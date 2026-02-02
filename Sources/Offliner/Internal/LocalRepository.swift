import Foundation
import GRDB
import TidalAPI

final class LocalRepository {
	private let databaseQueue: DatabaseQueue

	init(_ databaseQueue: DatabaseQueue) {
		self.databaseQueue = databaseQueue
	}

	func storeMediaItem(
		task: StoreItemTask,
		mediaURL: URL,
		licenseURL: URL?
	) throws {
		let (mediaType, metadataJson) = try task.metadata.serialize()

		let mediaBookmark = try mediaURL.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil)
		let licenseBookmark = try licenseURL?.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil)

		try databaseQueue.inTransaction { database in
			try database.execute(
				sql: """
					INSERT INTO offline_item (id, resource_type, resource_id, metadata, media_bookmark, license_bookmark)
					VALUES (?, ?, ?, ?, ?, ?)
					""",
				arguments: [task.id, mediaType.rawValue, task.metadata.resourceId, metadataJson, mediaBookmark, licenseBookmark]
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
		let (collectionType, metadataJson) = try task.metadata.serialize()

		try databaseQueue.write { database in
			try database.execute(
				sql: """
					INSERT INTO offline_item (id, resource_type, resource_id, metadata, media_bookmark, license_bookmark)
					VALUES (?, ?, ?, ?, NULL, NULL)
					""",
				arguments: [task.id, collectionType.rawValue, task.metadata.resourceId, metadataJson]
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

	func getMediaItem(mediaType: OfflineMediaItemType, resourceId: String) throws -> OfflineMediaItem? {
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

			let mediaType = OfflineMediaItemType(rawValue: row["resource_type"])!

			return OfflineMediaItem(
				id: row["id"],
				metadata: try OfflineMediaItem.Metadata.deserialize(mediaType: mediaType, json: row["metadata"]),
				mediaURL: try resolveBookmark(row, column: "media_bookmark", database),
				licenseURL: try resolveBookmarkIfPresent(row, column: "license_bookmark", database)
			)
		}
	}

	func getCollection(collectionType: OfflineCollectionType, resourceId: String) throws -> OfflineCollection? {
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

			let collectionType = OfflineCollectionType(rawValue: row["resource_type"])!

			return OfflineCollection(
				id: row["id"],
				metadata: try OfflineCollection.Metadata.deserialize(collectionType: collectionType, json: row["metadata"])
			)
		}
	}

	func getMediaItems(mediaType: OfflineMediaItemType) throws -> [OfflineMediaItem] {
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
				let mediaType = OfflineMediaItemType(rawValue: row["resource_type"])!

				return OfflineMediaItem(
					id: row["id"],
					metadata: try OfflineMediaItem.Metadata.deserialize(mediaType: mediaType, json: row["metadata"]),
					mediaURL: try resolveBookmark(row, column: "media_bookmark", database),
					licenseURL: try resolveBookmarkIfPresent(row, column: "license_bookmark", database)
				)
			}
		}
	}

	func getCollections(collectionType: OfflineCollectionType) throws -> [OfflineCollection] {
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
				let collectionType = OfflineCollectionType(rawValue: row["resource_type"])!

				return OfflineCollection(
					id: row["id"],
					metadata: try OfflineCollection.Metadata.deserialize(collectionType: collectionType, json: row["metadata"])
				)
			}
		}
	}

	func getCollectionItems(collectionType: OfflineCollectionType, resourceId: String) throws -> [OfflineCollectionItem] {
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
				let mediaType = OfflineMediaItemType(rawValue: row["resource_type"])!

				return OfflineCollectionItem(
					item: OfflineMediaItem(
						id: row["id"],
						metadata: try OfflineMediaItem.Metadata.deserialize(mediaType: mediaType, json: row["metadata"]),
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

// MARK: - OfflineMediaItem.Metadata Serialization

private extension OfflineMediaItem.Metadata {
	var resourceId: String {
		switch self {
		case .track(let obj): return obj.id
		case .video(let obj): return obj.id
		}
	}

	func serialize() throws -> (OfflineMediaItemType, String) {
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

	static func deserialize(mediaType: OfflineMediaItemType, json: String) throws -> OfflineMediaItem.Metadata {
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

// MARK: - OfflineCollection.Metadata Serialization

private extension OfflineCollection.Metadata {
	var resourceId: String {
		switch self {
		case .album(let obj): return obj.id
		case .playlist(let obj): return obj.id
		}
	}

	func serialize() throws -> (OfflineCollectionType, String) {
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

	static func deserialize(collectionType: OfflineCollectionType, json: String) throws -> OfflineCollection.Metadata {
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

// MARK: - LocalRepository Helpers

private extension LocalRepository {
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
