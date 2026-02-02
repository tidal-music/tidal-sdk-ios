import Foundation
import GRDB
import TidalAPI

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
	let item: ItemMetadata
	let mediaURL: URL
	let licenseURL: URL?
}

struct OfflineCollection {
	let id: String
	let collection: CollectionMetadata
}

struct OfflineCollectionItem {
	let item: OfflineMediaItem
	let volume: Int
	let position: Int
}

final class OfflineRepository {
	private let databaseQueue: DatabaseQueue

	init(_ databaseQueue: DatabaseQueue) {
		self.databaseQueue = databaseQueue
	}

	func storeMediaItem(
		task: StoreItemTask,
		mediaURL: URL,
		licenseURL: URL?
	) throws {
		let (mediaType, metadataJson) = try task.item.serialize()

		let mediaBookmark = try mediaURL.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil)
		let licenseBookmark = try licenseURL?.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil)

		try databaseQueue.inTransaction { database in
			try database.execute(
				sql: """
					INSERT INTO offline_item (id, resource_type, resource_id, metadata, media_bookmark, license_bookmark)
					VALUES (?, ?, ?, ?, ?, ?)
					""",
				arguments: [task.id, mediaType.rawValue, task.item.resourceId, metadataJson, mediaBookmark, licenseBookmark]
			)

			try database.execute(
				sql: """
					INSERT INTO offline_item_relationship (collection, member, volume, position)
					VALUES (?, ?, ?, ?)
					""",
				arguments: [task.collectionId, task.id, task.volume, task.index]
			)

			return .commit
		}
	}

	func storeCollection(task: StoreCollectionTask) throws {
		let (collectionType, metadataJson) = try task.collection.serialize()

		try databaseQueue.write { database in
			try database.execute(
				sql: """
					INSERT INTO offline_item (id, resource_type, resource_id, metadata, media_bookmark, license_bookmark)
					VALUES (?, ?, ?, ?, NULL, NULL)
					""",
				arguments: [task.id, collectionType.rawValue, task.collection.resourceId, metadataJson]
			)
		}
	}

	func deleteItem(id: String) throws {
		try databaseQueue.inTransaction { database in
			try database.execute(
				sql: "DELETE FROM offline_item_relationship WHERE collection = ? OR member = ?",
				arguments: [id, id]
			)

			try database.execute(
				sql: "DELETE FROM offline_item WHERE id = ?",
				arguments: [id]
			)

			return .commit
		}
	}

	func getMediaItem(mediaType: MediaType, resourceId: String) throws -> OfflineMediaItem? {
		try databaseQueue.write { database in
			let row = try Row.fetchOne(
				database,
				sql: """
					SELECT id, resource_type, resource_id, metadata, media_bookmark, license_bookmark
					FROM offline_item
					WHERE resource_type = ? AND resource_id = ?
					""",
				arguments: [mediaType.rawValue, resourceId]
			)

			guard let row else { return nil }

			let mediaType = MediaType(rawValue: row["resource_type"])!

			return OfflineMediaItem(
				id: row["id"],
				item: try ItemMetadata.deserialize(mediaType: mediaType, json: row["metadata"]),
				mediaURL: try resolveBookmark(row, column: "media_bookmark", database),
				licenseURL: try resolveBookmarkIfPresent(row, column: "license_bookmark", database)
			)
		}
	}

	func getCollection(collectionType: CollectionType, resourceId: String) throws -> OfflineCollection? {
		try databaseQueue.read { database in
			let row = try Row.fetchOne(
				database,
				sql: """
					SELECT id, resource_type, resource_id, metadata
					FROM offline_item
					WHERE resource_type = ? AND resource_id = ?
					""",
				arguments: [collectionType.rawValue, resourceId]
			)

			guard let row else { return nil }

			let collectionType = CollectionType(rawValue: row["resource_type"])!

			return OfflineCollection(
				id: row["id"],
				collection: try CollectionMetadata.deserialize(collectionType: collectionType, json: row["metadata"])
			)
		}
	}

	func getMediaItems(mediaType: MediaType) throws -> [OfflineMediaItem] {
		try databaseQueue.write { database in
			let rows = try Row.fetchAll(
				database,
				sql: """
					SELECT id, resource_type, resource_id, metadata, media_bookmark, license_bookmark
					FROM offline_item
					WHERE resource_type = ?
					ORDER BY created_at DESC
					""",
				arguments: [mediaType.rawValue]
			)

			return try rows.map { row in
				let mediaType = MediaType(rawValue: row["resource_type"])!

				return OfflineMediaItem(
					id: row["id"],
					item: try ItemMetadata.deserialize(mediaType: mediaType, json: row["metadata"]),
					mediaURL: try resolveBookmark(row, column: "media_bookmark", database),
					licenseURL: try resolveBookmarkIfPresent(row, column: "license_bookmark", database)
				)
			}
		}
	}

	func getCollections(collectionType: CollectionType) throws -> [OfflineCollection] {
		try databaseQueue.read { database in
			let rows = try Row.fetchAll(
				database,
				sql: """
					SELECT id, resource_type, resource_id, metadata
					FROM offline_item
					WHERE resource_type = ?
					ORDER BY created_at DESC
					""",
				arguments: [collectionType.rawValue]
			)

			return try rows.map { row in
				let collectionType = CollectionType(rawValue: row["resource_type"])!

				return OfflineCollection(
					id: row["id"],
					collection: try CollectionMetadata.deserialize(collectionType: collectionType, json: row["metadata"])
				)
			}
		}
	}

	func getCollectionItems(collectionType: CollectionType, resourceId: String) throws -> [OfflineCollectionItem] {
		try databaseQueue.write { database in
			let rows = try Row.fetchAll(
				database,
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
				let mediaType = MediaType(rawValue: row["resource_type"])!

				return OfflineCollectionItem(
					item: OfflineMediaItem(
						id: row["id"],
						item: try ItemMetadata.deserialize(mediaType: mediaType, json: row["metadata"]),
						mediaURL: try resolveBookmark(row, column: "media_bookmark", database),
						licenseURL: try resolveBookmarkIfPresent(row, column: "license_bookmark", database)
					),
					volume: row["volume"],
					position: row["position"]
				)
			}
		}
	}
}

// MARK: - ItemMetadata Serialization

private extension ItemMetadata {
	func serialize() throws -> (MediaType, String) {
		let encoder = JSONEncoder()

		switch self {
		case .track(let track):
			let data = try encoder.encode(track)
			let json = String(data: data, encoding: .utf8)!
			return (.tracks, json)
		case .video(let video):
			let data = try encoder.encode(video)
			let json = String(data: data, encoding: .utf8)!
			return (.videos, json)
		}
	}

	static func deserialize(mediaType: MediaType, json: String) throws -> ItemMetadata {
		let decoder = JSONDecoder()
		let data = json.data(using: .utf8)!

		switch mediaType {
		case .tracks:
			return .track(try decoder.decode(TracksResourceObject.self, from: data))
		case .videos:
			return .video(try decoder.decode(VideosResourceObject.self, from: data))
		}
	}
}

// MARK: - CollectionMetadata Serialization

private extension CollectionMetadata {
	func serialize() throws -> (CollectionType, String) {
		let encoder = JSONEncoder()

		switch self {
		case .album(let album):
			let data = try encoder.encode(album)
			let json = String(data: data, encoding: .utf8)!
			return (.albums, json)
		case .playlist(let playlist):
			let data = try encoder.encode(playlist)
			let json = String(data: data, encoding: .utf8)!
			return (.playlists, json)
		}
	}

	static func deserialize(collectionType: CollectionType, json: String) throws -> CollectionMetadata {
		let decoder = JSONDecoder()
		let data = json.data(using: .utf8)!

		switch collectionType {
		case .albums:
			return .album(try decoder.decode(AlbumsResourceObject.self, from: data))
		case .playlists:
			return .playlist(try decoder.decode(PlaylistsResourceObject.self, from: data))
		}
	}
}

// MARK: - OfflineRepository Helpers

private extension OfflineRepository {
	private func resolveBookmark(_ row: Row, column: String, _ database: GRDB.Database) throws -> URL {
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
			try database.execute(
				sql: "UPDATE offline_item SET \(column) = ? WHERE id = ?",
				arguments: [updatedBookmark, itemId]
			)
		}

		return url
	}

	private func resolveBookmarkIfPresent(_ row: Row, column: String, _ database: GRDB.Database) throws -> URL? {
		guard row[column] != nil else {
			return nil
		}

		return try resolveBookmark(row, column: column, database)
	}
}
