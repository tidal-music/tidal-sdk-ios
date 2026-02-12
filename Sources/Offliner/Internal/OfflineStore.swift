import Foundation
import GRDB
import TidalAPI

final class OfflineStore {
	private let databaseQueue: DatabaseQueue

	static func url() throws -> URL {
		let appSupportURLs = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
		guard let appSupportDirectory = appSupportURLs.first else {
			throw FileStorageError.noApplicationSupportDirectory
		}
		let directory = appSupportDirectory.appendingPathComponent("Offliner", isDirectory: true)
		try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
		return directory.appendingPathComponent("offline.sqlite")
	}

	init(_ databaseQueue: DatabaseQueue) {
		self.databaseQueue = databaseQueue
	}

	func storeMediaItem(
		task: StoreItemTask,
		mediaURL: URL,
		licenseURL: URL?,
		artworkURL: URL
	) throws {
		let metadataJson = try task.metadata.serialize()

		let mediaBookmark = try mediaURL.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil)
		let licenseBookmark = try licenseURL?.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil)
		let artworkBookmark = try artworkURL.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil)

		var replacedBookmarks: [Data] = []

		try databaseQueue.inTransaction { database in
			let existingRow = try Row.fetchOne(
				database,
				sql: """
					SELECT media_bookmark, license_bookmark, artwork_bookmark
					FROM offline_item
					WHERE resource_type = ? AND resource_id = ?
					""",
				arguments: [task.resourceType, task.resourceId]
			)

			if let existingRow {
				replacedBookmarks = ["media_bookmark", "license_bookmark", "artwork_bookmark"]
					.compactMap { existingRow[$0] }
			}

			try database.execute(
				sql: """
					INSERT INTO offline_item \
					(id, resource_type, resource_id, metadata, media_bookmark, license_bookmark, artwork_bookmark)
					VALUES (?, ?, ?, ?, ?, ?, ?)
					ON CONFLICT (resource_type, resource_id) DO UPDATE SET
						id = excluded.id,
						metadata = excluded.metadata,
						media_bookmark = excluded.media_bookmark,
						license_bookmark = excluded.license_bookmark,
						artwork_bookmark = excluded.artwork_bookmark
					""",
				arguments: [
					task.member, task.resourceType, task.resourceId, metadataJson,
					mediaBookmark, licenseBookmark, artworkBookmark
				]
			)

			try database.execute(
				sql: """
					INSERT INTO offline_item_relationship (collection, member, volume, position)
					VALUES (?, ?, ?, ?)
					ON CONFLICT (collection, volume, position) DO UPDATE SET
						member = excluded.member
					""",
				arguments: [task.collection, task.member, task.volume, task.position]
			)

			return .commit
		}

		for bookmarkData in replacedBookmarks {
			try? FileStorage.delete(bookmark: bookmarkData)
		}
	}

	func storeCollection(task: StoreCollectionTask, artworkURL: URL) throws {
		let metadataJson = try task.metadata.serialize()
		let artworkBookmark = try artworkURL.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil)

		var replacedArtworkBookmark: Data?

		try databaseQueue.inTransaction { database in
			let existingRow = try Row.fetchOne(
				database,
				sql: """
					SELECT artwork_bookmark
					FROM offline_item
					WHERE resource_type = ? AND resource_id = ?
					""",
				arguments: [task.resourceType, task.resourceId]
			)

			if let existingRow {
				replacedArtworkBookmark = existingRow["artwork_bookmark"]
			}

			try database.execute(
				sql: """
					INSERT INTO offline_item \
					(id, resource_type, resource_id, metadata, media_bookmark, license_bookmark, artwork_bookmark)
					VALUES (?, ?, ?, ?, NULL, NULL, ?)
					ON CONFLICT (resource_type, resource_id) DO UPDATE SET
						id = excluded.id,
						metadata = excluded.metadata,
						artwork_bookmark = excluded.artwork_bookmark
					""",
				arguments: [task.collection, task.resourceType, task.resourceId, metadataJson, artworkBookmark]
			)

			return .commit
		}

		if let replacedArtworkBookmark {
			try? FileStorage.delete(bookmark: replacedArtworkBookmark)
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
					SELECT id, resource_type, resource_id, metadata, media_bookmark, license_bookmark, artwork_bookmark
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
				mediaURL: try resolveAndUpdateBookmark(row, column: "media_bookmark", database),
				licenseURL: try resolveAndUpdateBookmarkIfPresent(row, column: "license_bookmark", database),
				artworkURL: try resolveAndUpdateBookmarkIfPresent(row, column: "artwork_bookmark", database)
			)
		}
	}

	func getCollection(collectionType: OfflineCollectionType, resourceId: String) throws -> OfflineCollection? {
		try databaseQueue.write { database in
			let row = try Row.fetchOne(
				database,
				sql: """
					SELECT id, resource_type, resource_id, metadata, artwork_bookmark
					FROM offline_item
					WHERE resource_type = ? AND resource_id = ?
					""",
				arguments: [collectionType.rawValue, resourceId]
			)

			guard let row else { return nil }

			let collectionType = OfflineCollectionType(rawValue: row["resource_type"])!

			return OfflineCollection(
				id: row["resource_id"],
				metadata: try OfflineCollection.Metadata.deserialize(collectionType: collectionType, json: row["metadata"]),
				artworkURL: try resolveAndUpdateBookmarkIfPresent(row, column: "artwork_bookmark", database)
			)
		}
	}

	func getMediaItems(mediaType: OfflineMediaItemType) throws -> [OfflineMediaItem] {
		try databaseQueue.write { database in
			let rows = try Row.fetchAll(
				database,
				sql: """
					SELECT id, resource_type, resource_id, metadata, media_bookmark, license_bookmark, artwork_bookmark
					FROM offline_item
					WHERE resource_type = ?
					ORDER BY created_at DESC
					""",
				arguments: [mediaType.rawValue]
			)

			return try rows.map { row in
				let mediaType = OfflineMediaItemType(rawValue: row["resource_type"])!

				return OfflineMediaItem(
					id: row["resource_id"],
					metadata: try OfflineMediaItem.Metadata.deserialize(mediaType: mediaType, json: row["metadata"]),
					mediaURL: try resolveAndUpdateBookmark(row, column: "media_bookmark", database),
					licenseURL: try resolveAndUpdateBookmarkIfPresent(row, column: "license_bookmark", database),
					artworkURL: try resolveAndUpdateBookmarkIfPresent(row, column: "artwork_bookmark", database)
				)
			}
		}
	}

	func getCollections(collectionType: OfflineCollectionType) throws -> [OfflineCollection] {
		try databaseQueue.write { database in
			let rows = try Row.fetchAll(
				database,
				sql: """
					SELECT id, resource_type, resource_id, metadata, artwork_bookmark
					FROM offline_item
					WHERE resource_type = ?
					ORDER BY created_at DESC
					""",
				arguments: [collectionType.rawValue]
			)

			return try rows.map { row in
				let collectionType = OfflineCollectionType(rawValue: row["resource_type"])!

				return OfflineCollection(
					id: row["resource_id"],
					metadata: try OfflineCollection.Metadata.deserialize(collectionType: collectionType, json: row["metadata"]),
					artworkURL: try resolveAndUpdateBookmarkIfPresent(row, column: "artwork_bookmark", database)
				)
			}
		}
	}

	func getCollectionItems(collectionType: OfflineCollectionType, resourceId: String) throws -> [OfflineCollectionItem] {
		try databaseQueue.write { database in
			let rows = try Row.fetchAll(
				database,
				sql: """
					SELECT i.id, i.resource_type, i.resource_id, i.metadata, i.media_bookmark, i.license_bookmark, i.artwork_bookmark,
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
						id: row["resource_id"],
						metadata: try OfflineMediaItem.Metadata.deserialize(mediaType: mediaType, json: row["metadata"]),
						mediaURL: try resolveAndUpdateBookmark(row, column: "media_bookmark", database),
						licenseURL: try resolveAndUpdateBookmarkIfPresent(row, column: "license_bookmark", database),
						artworkURL: try resolveAndUpdateBookmarkIfPresent(row, column: "artwork_bookmark", database)
					),
					volume: row["volume"],
					position: row["position"]
				)
			}
		}
	}
}

// MARK: - Task Extensions

extension StoreItemTask {
	var resourceId: String {
		switch metadata {
		case .track(let metadata): return metadata.track.id
		case .video(let metadata): return metadata.video.id
		}
	}

	var resourceType: String {
		switch metadata {
		case .track: return OfflineMediaItemType.tracks.rawValue
		case .video: return OfflineMediaItemType.videos.rawValue
		}
	}
}

private extension StoreCollectionTask {
	var resourceId: String {
		switch metadata {
		case .album(let metadata): return metadata.album.id
		case .playlist(let metadata): return metadata.playlist.id
		}
	}

	var resourceType: String {
		switch metadata {
		case .album: return OfflineCollectionType.albums.rawValue
		case .playlist: return OfflineCollectionType.playlists.rawValue
		}
	}
}

// MARK: - OfflineMediaItem.Metadata Serialization

private extension OfflineMediaItem.Metadata {
	func serialize() throws -> String {
		let encoder = JSONEncoder()

		switch self {
		case .track(let metadata):
			let data = try encoder.encode(metadata)
			return String(data: data, encoding: .utf8)!
		case .video(let metadata):
			let data = try encoder.encode(metadata)
			return String(data: data, encoding: .utf8)!
		}
	}

	static func deserialize(mediaType: OfflineMediaItemType, json: String) throws -> OfflineMediaItem.Metadata {
		let decoder = JSONDecoder()
		let data = json.data(using: .utf8)!

		switch mediaType {
		case .tracks:
			return .track(try decoder.decode(OfflineMediaItem.TrackMetadata.self, from: data))
		case .videos:
			return .video(try decoder.decode(OfflineMediaItem.VideoMetadata.self, from: data))
		}
	}
}

// MARK: - OfflineCollection.Metadata Serialization

private extension OfflineCollection.Metadata {
	func serialize() throws -> String {
		let encoder = JSONEncoder()

		switch self {
		case .album(let metadata):
			let data = try encoder.encode(metadata)
			return String(data: data, encoding: .utf8)!
		case .playlist(let metadata):
			let data = try encoder.encode(metadata)
			return String(data: data, encoding: .utf8)!
		}
	}

	static func deserialize(collectionType: OfflineCollectionType, json: String) throws -> OfflineCollection.Metadata {
		let decoder = JSONDecoder()
		let data = json.data(using: .utf8)!

		switch collectionType {
		case .albums:
			return .album(try decoder.decode(OfflineCollection.AlbumMetadata.self, from: data))
		case .playlists:
			return .playlist(try decoder.decode(OfflineCollection.PlaylistMetadata.self, from: data))
		}
	}
}

// MARK: - OfflineStore Helpers

private extension OfflineStore {
	private func resolveAndUpdateBookmark(_ row: Row, column: String, _ database: GRDB.Database) throws -> URL {
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

	private func resolveAndUpdateBookmarkIfPresent(_ row: Row, column: String, _ database: GRDB.Database) throws -> URL? {
		guard row[column] != nil else {
			return nil
		}

		return try resolveAndUpdateBookmark(row, column: column, database)
	}
}
