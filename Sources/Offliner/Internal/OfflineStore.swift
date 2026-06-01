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
			replacedBookmarks = try collectBookmarks(resourceType: result.resourceType, resourceId: result.resourceId, database: database)

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
						position,
						added_at)
					VALUES (?, ?, ?, ?, ?, ?, ?)
					ON CONFLICT (collection_resource_type, collection_resource_id, volume, position) DO UPDATE SET
						member_resource_type = excluded.member_resource_type,
						member_resource_id = excluded.member_resource_id,
						added_at = COALESCE(excluded.added_at, offline_item_relationship.added_at)
					""",
				arguments: [
					result.collectionResourceType,
					result.collectionResourceId,
					result.resourceType,
					result.resourceId,
					result.volume,
					result.position,
					encodeRelationshipAddedAt(result.addedAt)]
			)

			return .commit
		}

		deleteFiles(for: replacedBookmarks)
	}

	func storeCollection(_ result: StoreCollectionTaskResult) throws {
		let catalogMetadataJson = try result.catalogMetadata.serialize()
		let artworkBookmark = try result.artworkURL?.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil)

		var replacedBookmarks: [Data] = []

		try databaseQueue.inTransaction { database in
			replacedBookmarks = try collectBookmarks(resourceType: result.resourceType.rawValue, resourceId: result.resourceId, database: database)

			try database.execute(
				sql: """
					INSERT INTO offline_item \
					(resource_type, resource_id, catalog_metadata, artwork_bookmark)
					VALUES (?, ?, ?, ?)
					ON CONFLICT (resource_type, resource_id) DO UPDATE SET
						catalog_metadata = excluded.catalog_metadata,
						artwork_bookmark = excluded.artwork_bookmark
					""",
				arguments: [result.resourceType.rawValue, result.resourceId, catalogMetadataJson, artworkBookmark]
			)

			return .commit
		}

		deleteFiles(for: replacedBookmarks)
	}

	func deleteCollection(resourceType: String, resourceId: String) throws {
		var bookmarksToDelete: [Data] = []

		try databaseQueue.inTransaction { database in
			bookmarksToDelete = try collectBookmarks(resourceType: resourceType, resourceId: resourceId, database: database)

			try database.execute(
				sql: "DELETE FROM offline_item_relationship WHERE collection_resource_type = ? AND collection_resource_id = ?",
				arguments: [resourceType, resourceId]
			)

			try database.execute(
				sql: "DELETE FROM offline_item WHERE resource_type = ? AND resource_id = ?",
				arguments: [resourceType, resourceId]
			)

			return .commit
		}

		deleteFiles(for: bookmarksToDelete)
	}

	func deleteMediaItem(
		resourceType: String,
		resourceId: String,
		fromCollection collectionType: String,
		collectionId: String
	) throws {
		var bookmarksToDelete: [Data] = []

		try databaseQueue.inTransaction { database in
			try database.execute(
				sql: """
					DELETE FROM offline_item_relationship
					WHERE collection_resource_type = ? AND collection_resource_id = ?
					  AND member_resource_type = ? AND member_resource_id = ?
					""",
				arguments: [collectionType, collectionId, resourceType, resourceId]
			)

			let hasRelationships = try Bool.fetchOne(
				database,
				sql: "SELECT EXISTS(SELECT 1 FROM offline_item_relationship WHERE member_resource_type = ? AND member_resource_id = ?)",
				arguments: [resourceType, resourceId]
			) ?? false

			if !hasRelationships {
				bookmarksToDelete = try collectBookmarks(resourceType: resourceType, resourceId: resourceId, database: database)

				try database.execute(
					sql: "DELETE FROM offline_item WHERE resource_type = ? AND resource_id = ?",
					arguments: [resourceType, resourceId]
				)
			}

			return .commit
		}

		deleteFiles(for: bookmarksToDelete)
	}

	func getCollection(collectionType: OfflineCollectionType, resourceId: String) async throws -> OfflineCollection? {
		try await databaseQueue.write { [self] database in
			let row = try Row.fetchOne(
				database,
				sql: """
					SELECT resource_type, resource_id, catalog_metadata, artwork_bookmark, created_at
					FROM offline_item
					WHERE resource_type = ? AND resource_id = ?
					""",
				arguments: [collectionType.rawValue, resourceId]
			)

			guard let row else { return nil }

			let collectionType = OfflineCollectionType(rawValue: row["resource_type"])!

			return OfflineCollection(
				catalogMetadata: try OfflineCollection.Metadata.deserialize(collectionType: collectionType, json: row["catalog_metadata"]),
				artworkURL: try? resolveAndUpdateBookmarkIfPresent(row, column: "artwork_bookmark", database),
				addedAt: row["created_at"]
			)
		}
	}

	func getMediaItem(mediaType: OfflineMediaItemType, resourceId: String) async throws -> OfflineMediaItem? {
		try await databaseQueue.write { [self] database in
			let row = try Row.fetchOne(
				database,
				sql: """
					SELECT resource_type, resource_id, catalog_metadata, playback_metadata, media_bookmark, license_bookmark, artwork_bookmark
					FROM offline_item
					WHERE resource_type = ? AND resource_id = ?
					""",
				arguments: [mediaType.rawValue, resourceId]
			)

			return try row.map { try OfflineMediaItem(from: $0, store: self, database: database) }
		}
	}

	func getMediaItems(mediaType: OfflineMediaItemType) async throws -> ([OfflineMediaItem], [FailedOfflineItem]) {
		try await databaseQueue.write { [self] database in
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

			var items: [OfflineMediaItem] = []
			var failures: [FailedOfflineItem] = []

			for row in rows {
				do {
					items.append(try OfflineMediaItem(from: row, store: self, database: database))
				} catch {
					FailedOfflineItem(from: row).map { failures.append($0) }
				}
			}

			return (items, failures)
		}
	}

	func getCollections(collectionType: OfflineCollectionType) async throws -> [OfflineCollection] {
		try await databaseQueue.write { [self] database in
			let rows = try Row.fetchAll(
				database,
				sql: """
					SELECT resource_type, resource_id, catalog_metadata, artwork_bookmark, created_at
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
					artworkURL: try? resolveAndUpdateBookmarkIfPresent(row, column: "artwork_bookmark", database),
					addedAt: row["created_at"]
				)
			}
		}
	}

	func countCollectionItems(collectionType: OfflineCollectionType, resourceId: String) async throws -> Int {
		try await databaseQueue.read { database in
			let count = try Int.fetchOne(
				database,
				sql: """
					SELECT COUNT(*)
					FROM offline_item_relationship
					WHERE collection_resource_type = ? AND collection_resource_id = ?
					  AND (member_resource_type != collection_resource_type OR member_resource_id != collection_resource_id)
					""",
				arguments: [collectionType.rawValue, resourceId]
			)
			return count ?? 0
		}
	}

	func getCollectionItems(
		collectionType: OfflineCollectionType,
		resourceId: String,
		limit: Int,
		sort: OfflineCollectionItemSort? = nil,
		after cursor: Int64? = nil
	) async throws -> (OfflineCollectionItemsPage, [FailedOfflineItem]) {
		let query = CollectionItemsQuery(sort: sort)

		let (items, failures) = try await databaseQueue.write { [self] database -> ([OfflineCollectionItem], [FailedOfflineItem]) in
			let rows = try Row.fetchAll(
				database,
				sql: query.sql,
				arguments: [collectionType.rawValue, resourceId, cursor, cursor, limit]
			)

			var items: [OfflineCollectionItem] = []
			var failures: [FailedOfflineItem] = []

			for row in rows {
				do {
					items.append(try makeCollectionItem(from: row, database: database))
				} catch {
					FailedOfflineItem(from: row).map { failures.append($0) }
				}
			}

			return (items, failures)
		}

		let nextCursor = items.last?.cursor
		return (OfflineCollectionItemsPage(items: items, cursor: nextCursor), failures)
	}

	func getAudioFormatOfCollection(
		collectionType: OfflineCollectionType,
		resourceId: String
	) async throws -> AudioFormat? {
		try await databaseQueue.read { database in
			let row = try Row.fetchOne(
				database,
				sql: """
					SELECT i.playback_metadata
					FROM offline_item_relationship r
					JOIN offline_item i ON r.member_resource_type = i.resource_type AND r.member_resource_id = i.resource_id
					WHERE r.collection_resource_type = ? AND r.collection_resource_id = ?
					  AND r.member_resource_type = ?
					ORDER BY r.volume, r.position
					LIMIT 1
					""",
					arguments: [collectionType.rawValue, resourceId, OfflineMediaItemType.tracks.rawValue]
			)

			guard let row else { return nil }

			let playbackMetadataJson: String? = row["playback_metadata"]
			let playbackMetadata = try playbackMetadataJson.map { try OfflineMediaItem.PlaybackMetadata.deserialize($0) }
			return playbackMetadata?.format
		}
	}

	func getCollectionDuration(
		collectionType: OfflineCollectionType,
		resourceId: String
	) async throws -> Int {
		try await databaseQueue.read { database in
			let duration = try Int.fetchOne(
				database,
				sql: """
					SELECT COALESCE(SUM(json_extract(i.catalog_metadata, '$.duration')), 0)
					FROM offline_item_relationship r
					JOIN offline_item i ON r.member_resource_type = i.resource_type AND r.member_resource_id = i.resource_id
					WHERE r.collection_resource_type = ? AND r.collection_resource_id = ?
					  AND (r.member_resource_type != r.collection_resource_type OR r.member_resource_id != r.collection_resource_id)
					""",
				arguments: [collectionType.rawValue, resourceId]
			)
			return duration ?? 0
		}
	}

	private func collectBookmarks(resourceType: String, resourceId: String, database: GRDB.Database) throws -> [Data] {
		let row = try Row.fetchOne(
			database,
			sql: "SELECT media_bookmark, license_bookmark, artwork_bookmark FROM offline_item WHERE resource_type = ? AND resource_id = ?",
			arguments: [resourceType, resourceId]
		)
		return ["media_bookmark", "license_bookmark", "artwork_bookmark"].compactMap { row?[$0] as Data? }
	}

	private func deleteFiles(for bookmarks: [Data]) {
		for bookmarkData in bookmarks {
			try? FileStorage.delete(bookmark: bookmarkData)
		}
	}

	private func makeCollectionItem(from row: Row, database: GRDB.Database) throws -> OfflineCollectionItem {
		OfflineCollectionItem(
			item: try OfflineMediaItem(from: row, store: self, database: database),
			volume: row["volume"],
			position: row["position"],
			addedAt: decodeRelationshipAddedAt(row["relationship_added_at"]),
			cursor: row["relationship_id"]
		)
	}
}

private func encodeRelationshipAddedAt(_ date: Date?) -> String? {
	guard let date else { return nil }
	let formatter = ISO8601DateFormatter()
	formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
	return formatter.string(from: date)
}

private func decodeRelationshipAddedAt(_ string: String?) -> Date? {
	guard let string else { return nil }

	let formatter = ISO8601DateFormatter()
	formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
	if let date = formatter.date(from: string) {
		return date
	}

	formatter.formatOptions = [.withInternetDateTime]
	return formatter.date(from: string)
}

// MARK: - Collection Items Query

private struct CollectionItemsQuery {
	let sql: String

	init(sort: OfflineCollectionItemSort?) {
		let sortKeys = Self.sortKeys(for: sort)
		let orderBy = sortKeys
			.map { "collection_items.\($0.column) \($0.direction.sql)" }
			.joined(separator: ", ")
		let cursorPredicate = Self.cursorPredicate(for: sortKeys)

		sql = """
		WITH collection_items AS (
			SELECT r.id AS relationship_id,
			       i.resource_type, i.resource_id, i.catalog_metadata, i.playback_metadata,
			       i.media_bookmark, i.license_bookmark, i.artwork_bookmark,
			       r.volume, r.position, r.added_at AS relationship_added_at,
			       CASE
			         WHEN r.added_at IS NULL THEN 1
			         ELSE 0
			       END AS date_added_missing_sort_value,
			       r.added_at AS date_added_sort_value,
			       LOWER(COALESCE(json_extract(i.catalog_metadata, '$.title'), '')) AS title_sort_value,
			       CASE
			         WHEN COALESCE(json_extract(i.catalog_metadata, '$.albumTitle'), '') = '' THEN 1
			         ELSE 0
			       END AS album_missing_sort_value,
			       LOWER(COALESCE(json_extract(i.catalog_metadata, '$.albumTitle'), '')) AS album_sort_value,
			       CASE
			         WHEN COALESCE(json_extract(i.catalog_metadata, '$.artists[0]'), '') = '' THEN 1
			         ELSE 0
			       END AS artist_missing_sort_value,
			       LOWER(COALESCE(json_extract(i.catalog_metadata, '$.artists[0]'), '')) AS artist_sort_value
			FROM offline_item_relationship r
			JOIN offline_item i ON r.member_resource_type = i.resource_type AND r.member_resource_id = i.resource_id
			WHERE r.collection_resource_type = ? AND r.collection_resource_id = ?
			  AND (r.member_resource_type != r.collection_resource_type OR r.member_resource_id != r.collection_resource_id)
		),
		cursor_item AS (
			SELECT *
			FROM collection_items
			WHERE relationship_id = ?
		)
		SELECT resource_type, resource_id, catalog_metadata, playback_metadata,
		       media_bookmark, license_bookmark, artwork_bookmark,
		       volume, position, relationship_added_at, relationship_id
		FROM collection_items
		WHERE ? IS NULL
		   OR (
			EXISTS (SELECT 1 FROM cursor_item)
			AND (\(cursorPredicate))
		   )
		ORDER BY \(orderBy)
		LIMIT ?
		"""
	}

	private static func sortKeys(for sort: OfflineCollectionItemSort?) -> [CollectionItemSortKey] {
		guard let sort else {
			return [
				CollectionItemSortKey(column: "volume", direction: .ascending),
				CollectionItemSortKey(column: "position", direction: .ascending),
				CollectionItemSortKey(column: "relationship_id", direction: .ascending),
			]
		}

		switch sort {
		case .dateAdded(let direction):
			return [
				CollectionItemSortKey(column: "date_added_missing_sort_value", direction: .ascending),
				CollectionItemSortKey(column: "date_added_sort_value", direction: direction, nullable: true),
				CollectionItemSortKey(column: "volume", direction: .ascending),
				CollectionItemSortKey(column: "position", direction: .ascending),
				CollectionItemSortKey(column: "relationship_id", direction: .ascending),
			]

		case .title(let direction):
			return [
				CollectionItemSortKey(column: "title_sort_value", direction: direction),
				CollectionItemSortKey(column: "volume", direction: .ascending),
				CollectionItemSortKey(column: "position", direction: .ascending),
				CollectionItemSortKey(column: "relationship_id", direction: .ascending),
			]

		case .album(let direction):
			return [
				CollectionItemSortKey(column: "album_missing_sort_value", direction: .ascending),
				CollectionItemSortKey(column: "album_sort_value", direction: direction),
				CollectionItemSortKey(column: "volume", direction: .ascending),
				CollectionItemSortKey(column: "position", direction: .ascending),
				CollectionItemSortKey(column: "relationship_id", direction: .ascending),
			]

		case .artist(let direction):
			return [
				CollectionItemSortKey(column: "artist_missing_sort_value", direction: .ascending),
				CollectionItemSortKey(column: "artist_sort_value", direction: direction),
				CollectionItemSortKey(column: "volume", direction: .ascending),
				CollectionItemSortKey(column: "position", direction: .ascending),
				CollectionItemSortKey(column: "relationship_id", direction: .ascending),
			]
		}
	}

	private static func cursorPredicate(for sortKeys: [CollectionItemSortKey]) -> String {
		sortKeys.indices
			.map { index in
				let previousKeys = sortKeys.prefix(index)
				let equalities = previousKeys.map { key in
					key.equalityExpression
				}
				let key = sortKeys[index]
				let comparison = "collection_items.\(key.column) \(key.direction.cursorComparator) (SELECT \(key.column) FROM cursor_item)"
				return "(\((equalities + [comparison]).joined(separator: " AND ")))"
			}
			.joined(separator: " OR ")
	}
}

private struct CollectionItemSortKey {
	let column: String
	let direction: OfflineCollectionItemSortDirection
	let nullable: Bool

	init(column: String, direction: OfflineCollectionItemSortDirection, nullable: Bool = false) {
		self.column = column
		self.direction = direction
		self.nullable = nullable
	}

	var equalityExpression: String {
		let lhs = "collection_items.\(column)"
		let rhs = "(SELECT \(column) FROM cursor_item)"
		if nullable {
			return "(\(lhs) = \(rhs) OR (\(lhs) IS NULL AND \(rhs) IS NULL))"
		}
		return "\(lhs) = \(rhs)"
	}
}

private extension OfflineCollectionItemSortDirection {
	var sql: String {
		switch self {
		case .ascending: "ASC"
		case .descending: "DESC"
		}
	}

	var cursorComparator: String {
		switch self {
		case .ascending: ">"
		case .descending: "<"
		}
	}
}

// MARK: - FailedOfflineItem

struct FailedOfflineItem {
	let mediaType: OfflineMediaItemType
	let resourceId: String

	init?(from row: Row) {
		let resourceType: String = row["resource_type"]
		guard let mediaType = OfflineMediaItemType(rawValue: resourceType) else {
			return nil
		}
		self.mediaType = mediaType
		self.resourceId = row["resource_id"]
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
	let addedAt: Date?
	let mediaURL: URL
	let licenseURL: URL?
	let artworkURL: URL?
}

struct StoreCollectionTaskResult {
	let resourceType: OfflineCollectionType
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
		case .userCollectionTracks(let id):
			let data = try encoder.encode(["id": id])
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
		case .userCollectionTracks:
			let container = try decoder.decode([String: String].self, from: data)
			return .userCollectionTracks(id: container["id"]!)
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

extension OfflineStore {
	func resolveAndUpdateBookmark(_ row: Row, column: String, _ database: GRDB.Database) throws -> URL {
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

	func resolveAndUpdateBookmarkIfPresent(_ row: Row, column: String, _ database: GRDB.Database) throws -> URL? {
		guard row[column] != nil else {
			return nil
		}

		return try resolveAndUpdateBookmark(row, column: column, database)
	}
}

// MARK: - OfflineMediaItem from Row

private extension OfflineMediaItem {
	init(from row: Row, store: OfflineStore, database: GRDB.Database) throws {
		let mediaType = OfflineMediaItemType(rawValue: row["resource_type"])!
		let playbackMetadataJson: String? = row["playback_metadata"]

		self.init(
			catalogMetadata: try Metadata.deserialize(mediaType: mediaType, json: row["catalog_metadata"]),
			playbackMetadata: try playbackMetadataJson.map { try PlaybackMetadata.deserialize($0) },
			mediaURL: try store.resolveAndUpdateBookmark(row, column: "media_bookmark", database),
			licenseURL: try store.resolveAndUpdateBookmarkIfPresent(row, column: "license_bookmark", database),
			artworkURL: try? store.resolveAndUpdateBookmarkIfPresent(row, column: "artwork_bookmark", database)
		)
	}
}
