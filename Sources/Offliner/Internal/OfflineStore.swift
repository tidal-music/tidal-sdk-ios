import Foundation
import GRDB

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

	func storeMediaItem(_ result: StoreItemTaskResult) throws {
		let catalogMetadataJson = try result.catalogMetadata.serialize()
		let playbackMetadataJson = try result.playbackMetadata?.serialize()

		let mediaBookmark = try result.mediaURL.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil)
		let licenseBookmark = try result.licenseURL?.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil)
		let artworkBookmark = try result.artworkURL?.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil)

		var replacedBookmarks: [Data] = []

		try databaseQueue.inTransaction { database in
			let existingRow = try Row.fetchOne(
				database,
				sql: """
					SELECT media_bookmark, license_bookmark, artwork_bookmark
					FROM offline_item
					WHERE resource_type = ? AND resource_id = ?
					""",
				arguments: [result.resourceType, result.resourceId]
			)

			if let existingRow {
				replacedBookmarks = ["media_bookmark", "license_bookmark", "artwork_bookmark"]
					.compactMap { existingRow[$0] }
			}

			try database.execute(
				sql: """
					INSERT INTO offline_item \
					(resource_type, resource_id, catalog_metadata, playback_metadata, media_bookmark, license_bookmark, artwork_bookmark)
					VALUES (?, ?, ?, ?, ?, ?, ?)
					ON CONFLICT (resource_type, resource_id) DO UPDATE SET
						catalog_metadata = excluded.catalog_metadata,
						playback_metadata = excluded.playback_metadata,
						media_bookmark = excluded.media_bookmark,
						license_bookmark = excluded.license_bookmark,
						artwork_bookmark = excluded.artwork_bookmark
					""",
				arguments: [
					result.resourceType,
					result.resourceId,
					catalogMetadataJson,
					playbackMetadataJson,
					mediaBookmark,
					licenseBookmark,
					artworkBookmark
				]
			)

			try database.execute(
				sql: """
					INSERT INTO offline_item_relationship (
						collection_resource_type,
						collection_resource_id,
						member_resource_type,
						member_resource_id,
						volume,
						position)
					VALUES (?, ?, ?, ?, ?, ?)
					ON CONFLICT (collection_resource_type, collection_resource_id, volume, position) DO UPDATE SET
						member_resource_type = excluded.member_resource_type,
						member_resource_id = excluded.member_resource_id
					""",
				arguments: [
					result.collectionResourceType,
					result.collectionResourceId,
					result.resourceType,
					result.resourceId,
					result.volume,
					result.position]
			)

			return .commit
		}

		for bookmarkData in replacedBookmarks {
			try? FileStorage.delete(bookmark: bookmarkData)
		}
	}

	func storeCollection(_ result: StoreCollectionTaskResult) throws {
		let catalogMetadataJson = try result.catalogMetadata.serialize()
		let artworkBookmark = try result.artworkURL?.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil)

		var replacedArtworkBookmark: Data?

		try databaseQueue.inTransaction { database in
			let existingRow = try Row.fetchOne(
				database,
				sql: """
					SELECT artwork_bookmark
					FROM offline_item
					WHERE resource_type = ? AND resource_id = ?
					""",
				arguments: [result.resourceType, result.resourceId]
			)

			if let existingRow {
				replacedArtworkBookmark = existingRow["artwork_bookmark"]
			}

			try database.execute(
				sql: """
					INSERT INTO offline_item \
					(resource_type, resource_id, catalog_metadata, artwork_bookmark)
					VALUES (?, ?, ?, ?)
					ON CONFLICT (resource_type, resource_id) DO UPDATE SET
						catalog_metadata = excluded.catalog_metadata,
						artwork_bookmark = excluded.artwork_bookmark
					""",
				arguments: [result.resourceType, result.resourceId, catalogMetadataJson, artworkBookmark]
			)

			return .commit
		}

		if let replacedArtworkBookmark {
			try? FileStorage.delete(bookmark: replacedArtworkBookmark)
		}
	}

	func deleteItem(resourceType: String, resourceId: String) throws {
		var bookmarksToDelete: [Data] = []

		try databaseQueue.inTransaction { database in
			let existingRow = try Row.fetchOne(
				database,
				sql: """
					SELECT media_bookmark, license_bookmark, artwork_bookmark
					FROM offline_item
					WHERE resource_type = ? AND resource_id = ?
					""",
				arguments: [resourceType, resourceId]
			)

			if let existingRow {
				bookmarksToDelete = ["media_bookmark", "license_bookmark", "artwork_bookmark"]
					.compactMap { existingRow[$0] }
			}

			try database.execute(
				sql: """
					DELETE FROM offline_item_relationship
					WHERE (collection_resource_type = ? AND collection_resource_id = ?)
					   OR (member_resource_type = ? AND member_resource_id = ?)
					""",
				arguments: [resourceType, resourceId, resourceType, resourceId]
			)

			try database.execute(
				sql: "DELETE FROM offline_item WHERE resource_type = ? AND resource_id = ?",
				arguments: [resourceType, resourceId]
			)

			return .commit
		}

		for bookmarkData in bookmarksToDelete {
			try? FileStorage.delete(bookmark: bookmarkData)
		}
	}

	func getMediaItem(mediaType: OfflineMediaItemType, resourceId: String) throws -> OfflineMediaItem? {
		try databaseQueue.write { database in
			let row = try Row.fetchOne(
				database,
				sql: """
					SELECT resource_type, resource_id, catalog_metadata, playback_metadata, media_bookmark, license_bookmark, artwork_bookmark
					FROM offline_item
					WHERE resource_type = ? AND resource_id = ?
					""",
				arguments: [mediaType.rawValue, resourceId]
			)

			guard let row else { return nil }

			let mediaType = OfflineMediaItemType(rawValue: row["resource_type"])!
			let playbackMetadataJson: String? = row["playback_metadata"]

			return OfflineMediaItem(
				catalogMetadata: try OfflineMediaItem.Metadata.deserialize(mediaType: mediaType, json: row["catalog_metadata"]),
				playbackMetadata: try playbackMetadataJson.map { try OfflineMediaItem.PlaybackMetadata.deserialize($0) },
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
					SELECT resource_type, resource_id, catalog_metadata, artwork_bookmark
					FROM offline_item
					WHERE resource_type = ? AND resource_id = ?
					""",
				arguments: [collectionType.rawValue, resourceId]
			)

			guard let row else { return nil }

			let collectionType = OfflineCollectionType(rawValue: row["resource_type"])!

			return OfflineCollection(
				catalogMetadata: try OfflineCollection.Metadata.deserialize(collectionType: collectionType, json: row["catalog_metadata"]),
				artworkURL: try resolveAndUpdateBookmarkIfPresent(row, column: "artwork_bookmark", database)
			)
		}
	}

	func getMediaItems(mediaType: OfflineMediaItemType) throws -> [OfflineMediaItem] {
		try databaseQueue.write { database in
			let rows = try Row.fetchAll(
				database,
				sql: """
					SELECT resource_type, resource_id, catalog_metadata, playback_metadata, media_bookmark, license_bookmark, artwork_bookmark
					FROM offline_item
					WHERE resource_type = ?
					ORDER BY created_at DESC
					""",
				arguments: [mediaType.rawValue]
			)

			return try rows.map { row in
				let mediaType = OfflineMediaItemType(rawValue: row["resource_type"])!
				let playbackMetadataJson: String? = row["playback_metadata"]

				return OfflineMediaItem(
					catalogMetadata: try OfflineMediaItem.Metadata.deserialize(mediaType: mediaType, json: row["catalog_metadata"]),
					playbackMetadata: try playbackMetadataJson.map { try OfflineMediaItem.PlaybackMetadata.deserialize($0) },
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
					SELECT resource_type, resource_id, catalog_metadata, artwork_bookmark
					FROM offline_item
					WHERE resource_type = ?
					ORDER BY created_at DESC
					""",
				arguments: [collectionType.rawValue]
			)

			return try rows.map { row in
				let collectionType = OfflineCollectionType(rawValue: row["resource_type"])!

				return OfflineCollection(
					catalogMetadata: try OfflineCollection.Metadata.deserialize(collectionType: collectionType, json: row["catalog_metadata"]),
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
					SELECT i.resource_type, i.resource_id, i.catalog_metadata, i.playback_metadata,
					       i.media_bookmark, i.license_bookmark, i.artwork_bookmark,
					       r.volume, r.position
					FROM offline_item_relationship r
					JOIN offline_item i ON r.member_resource_type = i.resource_type AND r.member_resource_id = i.resource_id
					WHERE r.collection_resource_type = ? AND r.collection_resource_id = ?
					ORDER BY r.volume, r.position
					""",
				arguments: [collectionType.rawValue, resourceId]
			)

			return try rows.map { row in
				let mediaType = OfflineMediaItemType(rawValue: row["resource_type"])!
				let playbackMetadataJson: String? = row["playback_metadata"]

				return OfflineCollectionItem(
					item: OfflineMediaItem(
						catalogMetadata: try OfflineMediaItem.Metadata.deserialize(mediaType: mediaType, json: row["catalog_metadata"]),
						playbackMetadata: try playbackMetadataJson.map { try OfflineMediaItem.PlaybackMetadata.deserialize($0) },
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

// MARK: - Result Types

struct StoreItemTaskResult {
	let resourceType: String
	let resourceId: String
	let catalogMetadata: OfflineMediaItem.Metadata
	let playbackMetadata: OfflineMediaItem.PlaybackMetadata?
	let collectionResourceType: String
	let collectionResourceId: String
	let volume: Int
	let position: Int
	let mediaURL: URL
	let licenseURL: URL?
	let artworkURL: URL?
}

struct StoreCollectionTaskResult {
	let resourceType: String
	let resourceId: String
	let catalogMetadata: OfflineCollection.Metadata
	let artworkURL: URL?
}

// MARK: - OfflineMediaItem.Metadata Serialization

extension OfflineMediaItem.Metadata {
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

extension OfflineCollection.Metadata {
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

// MARK: - PlaybackMetadata Serialization

private extension OfflineMediaItem.PlaybackMetadata {
	func serialize() throws -> String {
		let data = try JSONEncoder().encode(self)
		return String(data: data, encoding: .utf8)!
	}

	static func deserialize(_ json: String) throws -> OfflineMediaItem.PlaybackMetadata {
		let data = json.data(using: .utf8)!
		return try JSONDecoder().decode(OfflineMediaItem.PlaybackMetadata.self, from: data)
	}
}

// MARK: - OfflineStore Helpers

private extension OfflineStore {
	private func resolveAndUpdateBookmark(_ row: Row, column: String, _ database: GRDB.Database) throws -> URL {
		let bookmarkData: Data = row[column]
		let resourceType: String = row["resource_type"]
		let resourceId: String = row["resource_id"]

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
				sql: "UPDATE offline_item SET \(column) = ? WHERE resource_type = ? AND resource_id = ?",
				arguments: [updatedBookmark, resourceType, resourceId]
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
