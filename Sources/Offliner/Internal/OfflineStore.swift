import Foundation
import GRDB

final class OfflineStore {
	private let databaseQueue: DatabaseQueue
	private let writeLock = NSLock()
	private var acceptsWrites = true

	static func searchKey(_ value: String) -> String {
		value.lowercased().folding(options: .diacriticInsensitive, locale: Locale(identifier: "en_US_POSIX"))
	}

	static let foldFunction = DatabaseFunction("FOLD", argumentCount: 1, pure: true) { values in
		guard let value = String.fromDatabaseValue(values[0]) else { return nil }
		return searchKey(value)
	}

	static func makeDatabaseQueue(path: String) throws -> DatabaseQueue {
		var configuration = GRDB.Configuration()
		configuration.prepareDatabase { database in
			database.add(function: foldFunction)
		}
		return try DatabaseQueue(path: path, configuration: configuration)
	}

	init(_ databaseQueue: DatabaseQueue) {
		self.databaseQueue = databaseQueue
	}

	func storeMediaItem(_ result: StoreItemTaskResult) throws {
		writeLock.lock()
		defer { writeLock.unlock() }
		try ensureAcceptsWritesLocked()
		let catalogMetadataJson = try result.catalogMetadata.serialize()
		let playbackMetadataJson = try result.playbackMetadata?.serialize()

		let mediaBookmark = try Self.makeBookmark(for: result.mediaURL)
		let licenseBookmark = try result.licenseURL.map { try Self.makeBookmark(for: $0) }
		let artworkBookmark = try result.artworkURL.map { try Self.makeBookmark(for: $0) }

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
						added_at,
						title_sort,
						album_sort,
						artist_sort)
					VALUES (?, ?, ?, ?, ?, ?, ?,
						LOWER(COALESCE(json_extract(?, '$.title'), '')),
						LOWER(COALESCE(json_extract(?, '$.albumTitle'), '')),
						LOWER(COALESCE((SELECT group_concat(value, ', ') FROM json_each(?, '$.artists')), '')))
					ON CONFLICT (collection_resource_type, collection_resource_id, volume, position) DO UPDATE SET
						member_resource_type = excluded.member_resource_type,
						member_resource_id = excluded.member_resource_id,
						added_at = COALESCE(excluded.added_at, offline_item_relationship.added_at),
						title_sort = excluded.title_sort,
						album_sort = excluded.album_sort,
						artist_sort = excluded.artist_sort
					""",
				arguments: [
					result.collectionResourceType,
					result.collectionResourceId,
					result.resourceType,
					result.resourceId,
					result.volume,
					result.position,
					encodeRelationshipAddedAt(result.addedAt),
					catalogMetadataJson,
					catalogMetadataJson,
					catalogMetadataJson]
			)

			return .commit
		}

		deleteFiles(for: replacedBookmarks)
	}

	func storeCollection(_ result: StoreCollectionTaskResult) throws {
		writeLock.lock()
		defer { writeLock.unlock() }
		try ensureAcceptsWritesLocked()
		let catalogMetadataJson = try result.catalogMetadata.serialize()
		let artworkBookmark = try result.artworkURL.map { try Self.makeBookmark(for: $0) }

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
		writeLock.lock()
		defer { writeLock.unlock() }
		try ensureAcceptsWritesLocked()
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
		writeLock.lock()
		defer { writeLock.unlock() }
		try ensureAcceptsWritesLocked()
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
		let row = try await databaseQueue.read { database in
			try Row.fetchOne(
				database,
				sql: """
					SELECT resource_type, resource_id, catalog_metadata, artwork_bookmark, created_at
					FROM offline_item
					WHERE resource_type = ? AND resource_id = ?
					""",
				arguments: [collectionType.rawValue, resourceId]
			)
		}

		guard let row else { return nil }

		let collectionType = OfflineCollectionType(rawValue: row["resource_type"])!

		var renewals: [BookmarkRenewal] = []
		let collection = OfflineCollection(
			catalogMetadata: try OfflineCollection.Metadata.deserialize(collectionType: collectionType, json: row["catalog_metadata"]),
			artworkURL: try? Self.resolveBookmarkIfPresent(row, column: "artwork_bookmark", renewals: &renewals),
			addedAt: row["created_at"]
		)
		try await storeRenewedBookmarks(renewals)

		return collection
	}

	func getMediaItem(mediaType: OfflineMediaItemType, resourceId: String) async throws -> OfflineMediaItem? {
		let row = try await databaseQueue.read { database in
			try Row.fetchOne(
				database,
				sql: """
					SELECT resource_type, resource_id, catalog_metadata, playback_metadata, artwork_bookmark
					FROM offline_item
					WHERE resource_type = ? AND resource_id = ?
					""",
				arguments: [mediaType.rawValue, resourceId]
			)
		}

		var renewals: [BookmarkRenewal] = []
		let item = try row.map { try OfflineMediaItem(from: $0, renewals: &renewals) }
		try await storeRenewedBookmarks(renewals)

		return item
	}

	func getPlaybackAsset(mediaType: OfflineMediaItemType, resourceId: String) async throws -> OfflinePlaybackAsset? {
		let row = try await databaseQueue.read { database in
			try Row.fetchOne(
				database,
				sql: """
					SELECT resource_type, resource_id, playback_metadata, media_bookmark, license_bookmark
					FROM offline_item
					WHERE resource_type = ? AND resource_id = ?
					""",
				arguments: [mediaType.rawValue, resourceId]
			)
		}

		guard let row else { return nil }

		let playbackMetadataJson: String? = row["playback_metadata"]

		var renewals: [BookmarkRenewal] = []
		let item = OfflinePlaybackAsset(
			playbackMetadata: try playbackMetadataJson.map { try OfflineMediaItem.PlaybackMetadata.deserialize($0) },
			mediaURL: try Self.resolveBookmark(row, column: "media_bookmark", renewals: &renewals),
			licenseURL: try Self.resolveBookmarkIfPresent(row, column: "license_bookmark", renewals: &renewals)
		)
		try await storeRenewedBookmarks(renewals)

		return item
	}

	func getMediaItems(mediaType: OfflineMediaItemType) async throws -> ([OfflineMediaItem], [FailedOfflineItem]) {
		let rows = try await databaseQueue.read { database in
			try Row.fetchAll(
				database,
				sql: """
					SELECT resource_type, resource_id, catalog_metadata, playback_metadata, artwork_bookmark
					FROM offline_item
					WHERE resource_type = ?
					ORDER BY created_at DESC
					""",
				arguments: [mediaType.rawValue]
			)
		}

		var items: [OfflineMediaItem] = []
		var failures: [FailedOfflineItem] = []
		var renewals: [BookmarkRenewal] = []

		for row in rows {
			do {
				items.append(try OfflineMediaItem(from: row, renewals: &renewals))
			} catch {
				FailedOfflineItem(from: row).map { failures.append($0) }
			}
		}

		try await storeRenewedBookmarks(renewals)

		return (items, failures)
	}

	func getCollections(collectionType: OfflineCollectionType) async throws -> [OfflineCollection] {
		let rows = try await databaseQueue.read { database in
			try Row.fetchAll(
				database,
				sql: """
					SELECT resource_type, resource_id, catalog_metadata, artwork_bookmark, created_at
					FROM offline_item
					WHERE resource_type = ?
					ORDER BY created_at DESC
					""",
				arguments: [collectionType.rawValue]
			)
		}

		var renewals: [BookmarkRenewal] = []
		let collections = try rows.map { row in
			let collectionType = OfflineCollectionType(rawValue: row["resource_type"])!

			return OfflineCollection(
				catalogMetadata: try OfflineCollection.Metadata.deserialize(collectionType: collectionType, json: row["catalog_metadata"]),
				artworkURL: try? Self.resolveBookmarkIfPresent(row, column: "artwork_bookmark", renewals: &renewals),
				addedAt: row["created_at"]
			)
		}
		try await storeRenewedBookmarks(renewals)

		return collections
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
		after cursor: String? = nil
	) async throws -> (OfflineCollectionItemsPage, [FailedOfflineItem]) {
		let parsedCursor = cursor.flatMap { Int64($0) }
		let cursorVolume = parsedCursor.map { Int($0 / 1_000_000) } ?? -1
		let cursorPosition = parsedCursor.map { Int($0 % 1_000_000) } ?? -1

		let rows = try await databaseQueue.read { database in
			try Row.fetchAll(
				database,
				sql: """
					SELECT i.resource_type, i.resource_id, i.catalog_metadata, i.playback_metadata,
					       i.artwork_bookmark,
					       r.volume, r.position, r.added_at AS relationship_added_at
					FROM offline_item_relationship r
					JOIN offline_item i ON r.member_resource_type = i.resource_type AND r.member_resource_id = i.resource_id
					WHERE r.collection_resource_type = ? AND r.collection_resource_id = ?
					  AND (r.volume > ? OR (r.volume = ? AND r.position > ?))
					  AND (r.member_resource_type != r.collection_resource_type OR r.member_resource_id != r.collection_resource_id)
					ORDER BY r.volume, r.position
					LIMIT ?
					""",
				arguments: [collectionType.rawValue, resourceId, cursorVolume, cursorVolume, cursorPosition, limit]
			)
		}

		let (items, failures, renewals) = collectItems(from: rows)
		try await storeRenewedBookmarks(renewals)

		let nextCursor = items.last.map { String(Int64($0.volume) * 1_000_000 + Int64($0.position)) }
		return (OfflineCollectionItemsPage(items: items, cursor: nextCursor), failures)
	}

	func getCollectionItemsOrderByTitle(
		collectionType: OfflineCollectionType,
		resourceId: String,
		direction: SortDirection,
		limit: Int,
		after cursor: String? = nil
	) async throws -> (OfflineCollectionItemsPage, [FailedOfflineItem]) {
		let comparator = direction.comparator
		let order = direction.order
		let parsedCursor = decodeSortCursor(cursor)
		let cursorPredicate = parsedCursor == nil ? "" : "AND (r.title_sort, r.id) \(comparator) (?, ?)"

		let rows = try await databaseQueue.read { database in
			try Row.fetchAll(
				database,
				sql: """
					SELECT i.resource_type, i.resource_id, i.catalog_metadata, i.playback_metadata,
					       i.artwork_bookmark,
					       r.volume, r.position, r.id AS relationship_id, r.added_at AS relationship_added_at,
					       r.title_sort AS sort_value
					FROM offline_item_relationship r
					JOIN offline_item i ON r.member_resource_type = i.resource_type AND r.member_resource_id = i.resource_id
					WHERE r.collection_resource_type = ? AND r.collection_resource_id = ?
					  AND (r.member_resource_type != r.collection_resource_type OR r.member_resource_id != r.collection_resource_id)
					  \(cursorPredicate)
					ORDER BY r.title_sort \(order), r.id \(order)
					LIMIT ?
					""",
				arguments: self.sortQueryArguments(
					collectionType: collectionType,
					resourceId: resourceId,
					cursor: parsedCursor,
					limit: limit
				)
			)
		}

		let (items, failures, renewals) = collectItems(from: rows)
		try await storeRenewedBookmarks(renewals)

		return (OfflineCollectionItemsPage(items: items, cursor: makeSortCursor(from: rows.last)), failures)
	}

	func getCollectionItemsOrderByAlbum(
		collectionType: OfflineCollectionType,
		resourceId: String,
		direction: SortDirection,
		limit: Int,
		after cursor: String? = nil
	) async throws -> (OfflineCollectionItemsPage, [FailedOfflineItem]) {
		let comparator = direction.comparator
		let order = direction.order
		let parsedCursor = decodeSortCursor(cursor)
		let cursorPredicate = parsedCursor == nil ? "" : "AND (r.album_sort, r.id) \(comparator) (?, ?)"

		let rows = try await databaseQueue.read { database in
			try Row.fetchAll(
				database,
				sql: """
					SELECT i.resource_type, i.resource_id, i.catalog_metadata, i.playback_metadata,
					       i.artwork_bookmark,
					       r.volume, r.position, r.id AS relationship_id, r.added_at AS relationship_added_at,
					       r.album_sort AS sort_value
					FROM offline_item_relationship r
					JOIN offline_item i ON r.member_resource_type = i.resource_type AND r.member_resource_id = i.resource_id
					WHERE r.collection_resource_type = ? AND r.collection_resource_id = ?
					  AND (r.member_resource_type != r.collection_resource_type OR r.member_resource_id != r.collection_resource_id)
					  \(cursorPredicate)
					ORDER BY r.album_sort \(order), r.id \(order)
					LIMIT ?
					""",
				arguments: self.sortQueryArguments(
					collectionType: collectionType,
					resourceId: resourceId,
					cursor: parsedCursor,
					limit: limit
				)
			)
		}

		let (items, failures, renewals) = collectItems(from: rows)
		try await storeRenewedBookmarks(renewals)

		return (OfflineCollectionItemsPage(items: items, cursor: makeSortCursor(from: rows.last)), failures)
	}

	func getCollectionItemsOrderByArtist(
		collectionType: OfflineCollectionType,
		resourceId: String,
		direction: SortDirection,
		limit: Int,
		after cursor: String? = nil
	) async throws -> (OfflineCollectionItemsPage, [FailedOfflineItem]) {
		let comparator = direction.comparator
		let order = direction.order
		let parsedCursor = decodeSortCursor(cursor)
		let cursorPredicate = parsedCursor == nil ? "" : "AND (r.artist_sort, r.id) \(comparator) (?, ?)"

		let rows = try await databaseQueue.read { database in
			try Row.fetchAll(
				database,
				sql: """
					SELECT i.resource_type, i.resource_id, i.catalog_metadata, i.playback_metadata,
					       i.artwork_bookmark,
					       r.volume, r.position, r.id AS relationship_id, r.added_at AS relationship_added_at,
					       r.artist_sort AS sort_value
					FROM offline_item_relationship r
					JOIN offline_item i ON r.member_resource_type = i.resource_type AND r.member_resource_id = i.resource_id
					WHERE r.collection_resource_type = ? AND r.collection_resource_id = ?
					  AND (r.member_resource_type != r.collection_resource_type OR r.member_resource_id != r.collection_resource_id)
					  \(cursorPredicate)
					ORDER BY r.artist_sort \(order), r.id \(order)
					LIMIT ?
					""",
				arguments: self.sortQueryArguments(
					collectionType: collectionType,
					resourceId: resourceId,
					cursor: parsedCursor,
					limit: limit
				)
			)
		}

		let (items, failures, renewals) = collectItems(from: rows)
		try await storeRenewedBookmarks(renewals)

		return (OfflineCollectionItemsPage(items: items, cursor: makeSortCursor(from: rows.last)), failures)
	}

	func getCollectionItemsOrderByDateAdded(
		collectionType: OfflineCollectionType,
		resourceId: String,
		direction: SortDirection,
		limit: Int,
		after cursor: String? = nil
	) async throws -> (OfflineCollectionItemsPage, [FailedOfflineItem]) {
		let comparator = direction.comparator
		let order = direction.order
		let parsedCursor = decodeSortCursor(cursor)
		let cursorPredicate = parsedCursor == nil ? "" : "AND (r.added_at_sort, r.id) \(comparator) (?, ?)"

		let rows = try await databaseQueue.read { database in
			try Row.fetchAll(
				database,
				sql: """
					SELECT i.resource_type, i.resource_id, i.catalog_metadata, i.playback_metadata,
					       i.artwork_bookmark,
					       r.volume, r.position, r.id AS relationship_id, r.added_at AS relationship_added_at,
					       r.added_at_sort AS sort_value
					FROM offline_item_relationship r
					JOIN offline_item i ON r.member_resource_type = i.resource_type AND r.member_resource_id = i.resource_id
					WHERE r.collection_resource_type = ? AND r.collection_resource_id = ?
					  AND (r.member_resource_type != r.collection_resource_type OR r.member_resource_id != r.collection_resource_id)
					  \(cursorPredicate)
					ORDER BY r.added_at_sort \(order), r.id \(order)
					LIMIT ?
					""",
				arguments: self.sortQueryArguments(
					collectionType: collectionType,
					resourceId: resourceId,
					cursor: parsedCursor,
					limit: limit
				)
			)
		}

		let (items, failures, renewals) = collectItems(from: rows)
		try await storeRenewedBookmarks(renewals)

		return (OfflineCollectionItemsPage(items: items, cursor: makeSortCursor(from: rows.last)), failures)
	}

	func searchCollectionItems(
		collectionType: OfflineCollectionType,
		resourceId: String,
		query: String,
		sort: OfflineCollectionItemSort?,
		limit: Int,
		after cursor: String?
	) async throws -> (OfflineCollectionSearchPage, [FailedOfflineItem]) {
		guard let pattern = likePattern(for: query) else {
			return (OfflineCollectionSearchPage(hits: [], cursor: nil), [])
		}

		let searchSort = SearchSort(sort)
		let (cursorPredicate, cursorArguments) = searchSort.cursorClause(for: cursor)

		var arguments: [DatabaseValueConvertible?] = [collectionType.rawValue, resourceId, pattern, pattern]
		arguments += cursorArguments
		arguments.append(limit)

		let rows = try await databaseQueue.read { database in
			try Row.fetchAll(
				database,
				sql: """
					SELECT i.resource_type, i.resource_id, i.catalog_metadata, i.playback_metadata,
					       i.artwork_bookmark,
					       r.volume, r.position, r.id AS relationship_id, r.added_at AS relationship_added_at
					       \(searchSort.sortColumnSelect)
					FROM offline_item_relationship r
					JOIN offline_item i
					  ON i.resource_type = r.member_resource_type AND i.resource_id = r.member_resource_id
					WHERE r.collection_resource_type = ? AND r.collection_resource_id = ?
					  AND (r.member_resource_type != r.collection_resource_type OR r.member_resource_id != r.collection_resource_id)
					  AND (FOLD(r.title_sort) LIKE ? ESCAPE '\\' OR FOLD(r.artist_sort) LIKE ? ESCAPE '\\')
					  \(cursorPredicate)
					ORDER BY \(searchSort.orderClause)
					LIMIT ?
					""",
				arguments: StatementArguments(arguments)
			)
		}

		var hits: [OfflineCollectionSearchHit] = []
		var failures: [FailedOfflineItem] = []
		var renewals: [BookmarkRenewal] = []

		for row in rows {
			do {
				let item = try makeCollectionItem(from: row, renewals: &renewals)
				hits.append(OfflineCollectionSearchHit(item: item, cursor: searchSort.rowCursor(row)))
			} catch {
				FailedOfflineItem(from: row).map { failures.append($0) }
			}
		}

		try await storeRenewedBookmarks(renewals)

		return (OfflineCollectionSearchPage(hits: hits, cursor: hits.last?.cursor), failures)
	}

	private func likePattern(for query: String) -> String? {
		let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
		guard !trimmed.isEmpty else { return nil }

		let escaped = Self.searchKey(trimmed)
			.replacingOccurrences(of: "\\", with: "\\\\")
			.replacingOccurrences(of: "%", with: "\\%")
			.replacingOccurrences(of: "_", with: "\\_")
		return "%\(escaped)%"
	}

	private func makeSortCursor(from row: Row?) -> String? {
		row.map { row -> String in
			let relationshipId: Int64 = row["relationship_id"]
			let sortValue: String = row["sort_value"] ?? ""
			return "\(relationshipId):\(sortValue)"
		}
	}

	private func decodeSortCursor(_ cursor: String?) -> (sortValue: String, relationshipId: Int64)? {
		guard let cursor, let separator = cursor.firstIndex(of: ":"), let relationshipId = Int64(cursor[..<separator]) else {
			return nil
		}
		return (String(cursor[cursor.index(after: separator)...]), relationshipId)
	}

	private func sortQueryArguments(
		collectionType: OfflineCollectionType,
		resourceId: String,
		cursor: (sortValue: String, relationshipId: Int64)?,
		limit: Int
	) -> StatementArguments {
		var values: [DatabaseValueConvertible?] = [collectionType.rawValue, resourceId]
		if let cursor {
			values.append(cursor.sortValue)
			values.append(cursor.relationshipId)
		}
		values.append(limit)
		return StatementArguments(values)
	}

	private func collectItems(
		from rows: [Row]
	) -> ([OfflineCollectionItem], [FailedOfflineItem], [BookmarkRenewal]) {
		var items: [OfflineCollectionItem] = []
		var failures: [FailedOfflineItem] = []
		var renewals: [BookmarkRenewal] = []

		for row in rows {
			do {
				items.append(try makeCollectionItem(from: row, renewals: &renewals))
			} catch {
				FailedOfflineItem(from: row).map { failures.append($0) }
			}
		}

		return (items, failures, renewals)
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

	func invalidateWrites() {
		writeLock.lock()
		acceptsWrites = false
		writeLock.unlock()
	}

	func allBookmarks() throws -> [Data] {
		try databaseQueue.read { database in
			let rows = try Row.fetchAll(database, sql: "SELECT media_bookmark, license_bookmark, artwork_bookmark FROM offline_item")
			return rows.flatMap { row in
				["media_bookmark", "license_bookmark", "artwork_bookmark"].compactMap { row[$0] as Data? }
			}
		}
	}

	private func ensureAcceptsWritesLocked() throws {
		guard acceptsWrites else { throw OfflinerLifecycleError.reset }
	}

	private func ensureAcceptsWrites() throws {
		writeLock.lock()
		defer { writeLock.unlock() }
		try ensureAcceptsWritesLocked()
	}

	private func deleteFiles(for bookmarks: [Data]) {
		for bookmarkData in bookmarks {
			try? FileStorage.delete(bookmark: bookmarkData)
		}
	}

	private func makeCollectionItem(from row: Row, renewals: inout [BookmarkRenewal]) throws -> OfflineCollectionItem {
		OfflineCollectionItem(
			item: try OfflineMediaItem(from: row, renewals: &renewals),
			volume: row["volume"],
			position: row["position"],
			addedAt: decodeRelationshipAddedAt(row["relationship_added_at"])
		)
	}
}

private extension SortDirection {
	var comparator: String {
		self == .ascending ? ">" : "<"
	}

	var order: String {
		self == .ascending ? "ASC" : "DESC"
	}
}

private enum SearchSort {
	case natural
	case keyed(column: String, direction: SortDirection)

	init(_ sort: OfflineCollectionItemSort?) {
		switch sort {
		case nil: self = .natural
		case .title(let direction): self = .keyed(column: "title_sort", direction: direction)
		case .album(let direction): self = .keyed(column: "album_sort", direction: direction)
		case .artist(let direction): self = .keyed(column: "artist_sort", direction: direction)
		case .dateAdded(let direction): self = .keyed(column: "added_at_sort", direction: direction)
		}
	}

	var orderClause: String {
		switch self {
		case .natural:
			return "r.volume, r.position"
		case .keyed(let column, let direction):
			return "r.\(column) \(direction.order), r.id \(direction.order)"
		}
	}

	var sortColumnSelect: String {
		switch self {
		case .natural:
			return ""
		case .keyed(let column, _):
			return ", r.\(column) AS sort_value"
		}
	}

	func cursorClause(for cursor: String?) -> (predicate: String, arguments: [DatabaseValueConvertible?]) {
		guard let cursor else { return ("", []) }

		switch self {
		case .natural:
			guard let value = Int64(cursor) else { return ("", []) }
			let volume = Int(value / 1_000_000)
			let position = Int(value % 1_000_000)
			return ("AND (r.volume > ? OR (r.volume = ? AND r.position > ?))", [volume, volume, position])
		case .keyed(let column, let direction):
			guard let separator = cursor.firstIndex(of: ":"), let relationshipId = Int64(cursor[..<separator]) else {
				return ("", [])
			}
			let sortValue = String(cursor[cursor.index(after: separator)...])
			return ("AND (r.\(column), r.id) \(direction.comparator) (?, ?)", [sortValue, relationshipId])
		}
	}

	func rowCursor(_ row: Row) -> String {
		switch self {
		case .natural:
			let volume: Int = row["volume"]
			let position: Int = row["position"]
			return String(Int64(volume) * 1_000_000 + Int64(position))
		case .keyed:
			let relationshipId: Int64 = row["relationship_id"]
			let sortValue: String = row["sort_value"] ?? ""
			return "\(relationshipId):\(sortValue)"
		}
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

// MARK: - BookmarkRenewal

struct BookmarkRenewal {
	let resourceType: String
	let resourceId: String
	let column: String
	let bookmark: Data
}

// MARK: - OfflineStore Helpers

extension OfflineStore {
	static func resolveBookmark(_ bookmarkData: Data) throws -> (url: URL, renewedBookmark: Data?) {
		let values = URL.resourceValues(forKeys: [.pathKey, .canonicalPathKey], fromBookmarkData: bookmarkData)
		if let path = values?.path ?? values?.canonicalPath, FileManager.default.fileExists(atPath: path) {
			return (URL(fileURLWithPath: path), nil)
		}

		var isStale = false
		let url = try URL(
			resolvingBookmarkData: bookmarkData,
			options: [],
			relativeTo: nil,
			bookmarkDataIsStale: &isStale
		)

		return (url, try? makeBookmark(for: url))
	}

	static func makeBookmark(for url: URL) throws -> Data {
		try url.bookmarkData(
			options: [],
			includingResourceValuesForKeys: [.pathKey, .canonicalPathKey],
			relativeTo: nil
		)
	}

	static func resolveBookmark(_ row: Row, column: String, renewals: inout [BookmarkRenewal]) throws -> URL {
		let bookmarkData: Data = row[column]
		let (url, renewedBookmark) = try resolveBookmark(bookmarkData)

		if let renewedBookmark {
			renewals.append(
				BookmarkRenewal(
					resourceType: row["resource_type"],
					resourceId: row["resource_id"],
					column: column,
					bookmark: renewedBookmark
				)
			)
		}

		return url
	}

	static func resolveBookmarkIfPresent(_ row: Row, column: String, renewals: inout [BookmarkRenewal]) throws -> URL? {
		guard row[column] != nil else {
			return nil
		}

		return try resolveBookmark(row, column: column, renewals: &renewals)
	}

	func storeRenewedBookmarks(_ renewals: [BookmarkRenewal]) async throws {
		guard !renewals.isEmpty else {
			return
		}
		try ensureAcceptsWrites()

		let chunkSize = 300

		try await databaseQueue.write { database in
			for (column, columnRenewals) in Dictionary(grouping: renewals, by: \.column) {
				for start in stride(from: 0, to: columnRenewals.count, by: chunkSize) {
					let chunk = columnRenewals[start ..< min(start + chunkSize, columnRenewals.count)]
					let values = Array(repeating: "(?, ?, ?)", count: chunk.count).joined(separator: ", ")
					let arguments = chunk.flatMap { [$0.resourceType, $0.resourceId, $0.bookmark] as [DatabaseValueConvertible?] }

					try database.execute(
						sql: """
							UPDATE offline_item
							SET \(column) = v.column3
							FROM (VALUES \(values)) AS v
							WHERE offline_item.resource_type = v.column1 AND offline_item.resource_id = v.column2
							""",
						arguments: StatementArguments(arguments)
					)
				}
			}
		}
	}
}

// MARK: - OfflineMediaItem from Row

private extension OfflineMediaItem {
	init(from row: Row, renewals: inout [BookmarkRenewal]) throws {
		let mediaType = OfflineMediaItemType(rawValue: row["resource_type"])!
		let playbackMetadataJson: String? = row["playback_metadata"]

		let catalogMetadata = try Metadata.deserialize(mediaType: mediaType, json: row["catalog_metadata"])
		let playbackMetadata = try playbackMetadataJson.map { try PlaybackMetadata.deserialize($0) }

		self.init(
			catalogMetadata: catalogMetadata,
			playbackMetadata: playbackMetadata,
			artworkURL: try? OfflineStore.resolveBookmarkIfPresent(row, column: "artwork_bookmark", renewals: &renewals)
		)
	}
}
