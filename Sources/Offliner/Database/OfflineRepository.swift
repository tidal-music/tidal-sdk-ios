import Foundation
import GRDB

enum MediaType: String {
	case tracks
	case videos
}

enum CollectionType: String {
	case albums
	case playlists
}

struct OfflineMediaItem {
	let id: String
	let mediaType: MediaType
	let resourceId: String
	let metadata: String
	let mediaURL: URL
	let licenseURL: URL?
}

struct OfflineCollection {
	let id: String
	let collectionType: CollectionType
	let resourceId: String
	let metadata: String
}

struct OfflineCollectionItem {
	let item: OfflineMediaItem
	let volume: Int
	let position: Int
}

class OfflineRepository {
	private let dbQueue: DatabaseQueue

	init(dbQueue: DatabaseQueue) {
		self.dbQueue = dbQueue
	}

	func storeMediaItem(
		id: String,
		mediaType: MediaType,
		resourceId: String,
		metadata: String,
		mediaURL: URL,
		licenseURL: URL?,
		collection: String,
		volume: Int,
		position: Int
	) throws {
		let mediaBookmark = try mediaURL.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil)
		let licenseBookmark = try licenseURL?.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil)

		try dbQueue.inTransaction { db in
			try db.execute(
				sql: """
					INSERT INTO offline_item (id, resource_type, resource_id, metadata, media_bookmark, license_bookmark)
					VALUES (?, ?, ?, ?, ?, ?)
					""",
				arguments: [id, mediaType.rawValue, resourceId, metadata, mediaBookmark, licenseBookmark]
			)

			try db.execute(
				sql: """
					INSERT INTO offline_item_relationship (collection, member, volume, position)
					VALUES (?, ?, ?, ?)
					""",
				arguments: [collection, id, volume, position]
			)

			return .commit
		}
	}

	func storeCollection(
		id: String,
		collectionType: CollectionType,
		resourceId: String,
		metadata: String
	) throws {
		try dbQueue.write { db in
			try db.execute(
				sql: """
					INSERT INTO offline_item (id, resource_type, resource_id, metadata, media_bookmark, license_bookmark)
					VALUES (?, ?, ?, ?, NULL, NULL)
					""",
				arguments: [id, collectionType.rawValue, resourceId, metadata]
			)
		}
	}

	func deleteItem(id: String) throws {
		try dbQueue.inTransaction { db in
			try db.execute(
				sql: "DELETE FROM offline_item_relationship WHERE collection = ? OR member = ?",
				arguments: [id, id]
			)

			try db.execute(
				sql: "DELETE FROM offline_item WHERE id = ?",
				arguments: [id]
			)

			return .commit
		}
	}

	func getMediaItem(mediaType: MediaType, resourceId: String) throws -> OfflineMediaItem? {
		try dbQueue.write { db in
			let row = try Row.fetchOne(
				db,
				sql: """
					SELECT id, resource_type, resource_id, metadata, media_bookmark, license_bookmark
					FROM offline_item
					WHERE resource_type = ? AND resource_id = ?
					""",
				arguments: [mediaType.rawValue, resourceId]
			)

			guard let row else { return nil }

			return OfflineMediaItem(
				id: row["id"],
				mediaType: MediaType(rawValue: row["resource_type"])!,
				resourceId: row["resource_id"],
				metadata: row["metadata"],
				mediaURL: try resolveBookmark(row, column: "media_bookmark", db: db),
				licenseURL: try resolveBookmarkIfPresent(row, column: "license_bookmark", db: db)
			)
		}
	}

	func getCollection(collectionType: CollectionType, resourceId: String) throws -> OfflineCollection? {
		try dbQueue.read { db in
			let row = try Row.fetchOne(
				db,
				sql: """
					SELECT id, resource_type, resource_id, metadata
					FROM offline_item
					WHERE resource_type = ? AND resource_id = ?
					""",
				arguments: [collectionType.rawValue, resourceId]
			)

			guard let row else { return nil }

			return OfflineCollection(
				id: row["id"],
				collectionType: CollectionType(rawValue: row["resource_type"])!,
				resourceId: row["resource_id"],
				metadata: row["metadata"]
			)
		}
	}

	func getMediaItems(mediaType: MediaType) throws -> [OfflineMediaItem] {
		try dbQueue.write { db in
			let rows = try Row.fetchAll(
				db,
				sql: """
					SELECT id, resource_type, resource_id, metadata, media_bookmark, license_bookmark
					FROM offline_item
					WHERE resource_type = ?
					ORDER BY created_at DESC
					""",
				arguments: [mediaType.rawValue]
			)

			return try rows.map { row in
				OfflineMediaItem(
					id: row["id"],
					mediaType: MediaType(rawValue: row["resource_type"])!,
					resourceId: row["resource_id"],
					metadata: row["metadata"],
					mediaURL: try resolveBookmark(row, column: "media_bookmark", db: db),
					licenseURL: try resolveBookmarkIfPresent(row, column: "license_bookmark", db: db)
				)
			}
		}
	}

	func getCollections(collectionType: CollectionType) throws -> [OfflineCollection] {
		try dbQueue.read { db in
			let rows = try Row.fetchAll(
				db,
				sql: """
					SELECT id, resource_type, resource_id, metadata
					FROM offline_item
					WHERE resource_type = ?
					ORDER BY created_at DESC
					""",
				arguments: [collectionType.rawValue]
			)

			return rows.map { row in
				OfflineCollection(
					id: row["id"],
					collectionType: CollectionType(rawValue: row["resource_type"])!,
					resourceId: row["resource_id"],
					metadata: row["metadata"]
				)
			}
		}
	}

	func getCollectionItems(collectionType: CollectionType, resourceId: String) throws -> [OfflineCollectionItem] {
		try dbQueue.write { db in
			let rows = try Row.fetchAll(
				db,
				sql: """
					SELECT i.id, i.resource_type, i.resource_id, i.metadata, i.media_bookmark, i.license_bookmark,
					       r.volume, r.position
					FROM offline_item i
					JOIN offline_item_relationship r ON r.member = i.id
					JOIN offline_item c ON r.collection = c.id
					WHERE c.resource_type = ? AND c.resource_id = ?
					ORDER BY r.volume, r.position
					""",
				arguments: [collectionType.rawValue, resourceId]
			)

			return try rows.map { row in
				OfflineCollectionItem(
					item: OfflineMediaItem(
						id: row["id"],
						mediaType: MediaType(rawValue: row["resource_type"])!,
						resourceId: row["resource_id"],
						metadata: row["metadata"],
						mediaURL: try resolveBookmark(row, column: "media_bookmark", db: db),
						licenseURL: try resolveBookmarkIfPresent(row, column: "license_bookmark", db: db)
					),
					volume: row["volume"],
					position: row["position"]
				)
			}
		}
	}
}

private extension OfflineRepository {
	private func resolveBookmark(_ row: Row, column: String, db: GRDB.Database) throws -> URL {
		let bookmarkData: Data = row[column]
		let itemId: String = row["id"]

		var isStale = false
		let url = try URL(
			resolvingBookmarkData: bookmarkData,
			options: [],
			relativeTo: nil,
			bookmarkDataIsStale: &isStale
		)

		if isStale {
			let updatedBookmark = try url.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil)
			try db.execute(
				sql: "UPDATE offline_item SET \(column) = ? WHERE id = ?",
				arguments: [updatedBookmark, itemId]
			)
		}

		return url
	}

	private func resolveBookmarkIfPresent(_ row: Row, column: String, db: GRDB.Database) throws -> URL? {
		guard row[column] != nil else {
			return nil
		}

		return try resolveBookmark(row, column: column, db: db)
	}
}
