@testable import Offliner
import GRDB
import XCTest

final class CollectionAddedAtTests: OfflinerTestCase {
	private var backend: StubOfflineApiClient!
	private var offliner: Offliner!
	private var store: OfflineStore!

	private let first = Date(timeIntervalSince1970: 1_767_225_600)
	private let second = Date(timeIntervalSince1970: 1_767_225_700)
	private let third = Date(timeIntervalSince1970: 1_767_225_800)

	override func setUp() {
		super.setUp()
		backend = StubOfflineApiClient()
		offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)
		store = OfflineStore(lastDatabaseQueue)
	}

	func testPendingToStoredKeepsAddedAtAndPosition() async throws {
		backend.pendingCollectionsPages = [(collections: [album("A", first), album("B", second), album("C", third)], cursor: nil)]
		let initial = try await completeRead()
		XCTAssertEqual(initial.map(\.catalogMetadata.id), ["C", "B", "A"])
		XCTAssertEqual(initial.map(\.state), [.pending, .pending, .pending])

		try storeAlbum("A")
		backend.pendingCollectionsPages = [(collections: [album("B", second), album("C", third)], cursor: nil)]
		let afterA = try await completeRead()
		XCTAssertEqual(afterA.map(\.catalogMetadata.id), ["C", "B", "A"])
		XCTAssertEqual(afterA.map(\.state), [.pending, .pending, .stored])
		XCTAssertEqual(afterA.map(\.addedAt), initial.map(\.addedAt))

		try storeAlbum("C")
		backend.pendingCollectionsPages = [(collections: [album("B", second)], cursor: nil)]
		let afterC = try await completeRead()
		XCTAssertEqual(afterC.map(\.catalogMetadata.id), ["C", "B", "A"])
		XCTAssertEqual(afterC.map(\.state), [.stored, .pending, .stored])
		XCTAssertEqual(afterC.map(\.addedAt), initial.map(\.addedAt))
	}

	func testFirstRecordedAddedAtWinsOverLaterInventoryValues() async throws {
		backend.pendingCollectionsPages = [(collections: [album("A", first)], cursor: nil)]
		_ = try await completeRead()

		backend.pendingCollectionsPages = [(collections: [album("A", third)], cursor: nil)]
		let read = try await completeRead()

		XCTAssertEqual(read.first?.addedAt, first)
	}

	func testPendingWithoutMetaReturnsTheSameAddedAtOnEveryRead() async throws {
		backend.pendingCollectionsOmitAddedAt = true

		backend.pendingCollectionsPages = [(collections: [album("A", first)], cursor: nil)]
		let firstRead = try await completeRead()
		try await Task.sleep(nanoseconds: 20_000_000)
		backend.pendingCollectionsPages = [(collections: [album("A", first)], cursor: nil)]
		let secondRead = try await completeRead()

		let addedAt = try XCTUnwrap(firstRead.first?.addedAt)
		XCTAssertNotEqual(addedAt, first)
		XCTAssertEqual(secondRead.first?.addedAt, addedAt)
	}

	func testPendingWithoutMetaUsesTheDownloadRequestTime() async throws {
		let before = Date()
		try await offliner.download(collectionType: .albums, resourceId: .identifier("A"))
		let after = Date()

		backend.pendingCollectionsOmitAddedAt = true
		backend.pendingCollectionsPages = [(collections: [album("A", first)], cursor: nil)]
		let read = try await completeRead()

		let addedAt = try XCTUnwrap(read.first?.addedAt)
		XCTAssertGreaterThanOrEqual(addedAt.timeIntervalSince1970, before.timeIntervalSince1970 - 0.001)
		XCTAssertLessThanOrEqual(addedAt.timeIntervalSince1970, after.timeIntervalSince1970 + 0.001)
	}

	func testStoredCollectionKeepsTheDownloadRequestTime() async throws {
		try await offliner.download(collectionType: .albums, resourceId: .identifier("A"))
		let recordedOptional = try await recordedAddedAt("A")
		let recorded = try XCTUnwrap(recordedOptional)

		await offliner.run()
		await backend.waitForTasksToComplete()

		let read = try await completeRead()
		XCTAssertEqual(read.map(\.catalogMetadata.id), ["A"])
		XCTAssertEqual(read.first?.state, .stored)
		XCTAssertEqual(read.first?.addedAt, recorded)
	}

	func testEqualAddedAtIsOrderedById() async throws {
		backend.pendingCollectionsPages = [(collections: [album("b", first), album("c", first), album("a", first)], cursor: nil)]
		try storeAlbum("d")
		try store.recordCollectionAddedAt(collectionType: .albums, resourceId: "e", addedAt: first)
		try storeAlbum("e")

		let read = try await completeRead()

		// "d" was stored now; the others share `first`, the stored "e" included.
		XCTAssertEqual(read.map(\.catalogMetadata.id), ["d", "a", "b", "c", "e"])
	}

	func testRemovalClearsAddedAt() async throws {
		try store.recordCollectionAddedAt(collectionType: .albums, resourceId: "A", addedAt: first)
		try storeAlbum("A")

		try store.deleteCollection(resourceType: "albums", resourceId: "A")

		let recorded = try await recordedAddedAt("A")
		XCTAssertNil(recorded)
	}

	func testMigrationBackfillsAddedAtFromCreatedAt() async throws {
		let databaseQueue = try OfflineStore.makeDatabaseQueue(path: tempDir.appendingPathComponent("legacy.sqlite").path)
		try Migrations.run(databaseQueue, upTo: "V000002_collection_item_sort_indexes")
		try await databaseQueue.write { database in
			try database.execute(
				sql: """
				INSERT INTO offline_item (resource_type, resource_id, catalog_metadata, created_at) VALUES
					('albums', 'old', '{"id":"old","title":"Old","artists":[],"explicit":false}', '2025-01-01 10:00:00'),
					('albums', 'new', '{"id":"new","title":"New","artists":[],"explicit":false}', '2025-06-01 10:00:00'),
					('tracks', 'track', '{}', '2025-06-01 10:00:00')
				"""
			)
		}

		try Migrations.run(databaseQueue)

		let collections = try await OfflineStore(databaseQueue).getCollections(collectionType: .albums)
		XCTAssertEqual(collections.map(\.catalogMetadata.id), ["new", "old"])
		XCTAssertEqual(collections.last?.addedAt, Date(timeIntervalSince1970: 1_735_725_600))
		let backfilled = try await databaseQueue.read { try Int.fetchOne($0, sql: "SELECT COUNT(*) FROM offline_collection_added_at") }
		XCTAssertEqual(backfilled, 2)
	}

	// MARK: - Helpers

	private func album(_ id: String, _ addedAt: Date) -> OfflineCollection {
		.mock(catalogMetadata: .album(.mock(id: id)), artworkURL: nil, state: .pending, addedAt: addedAt)
	}

	private func storeAlbum(_ id: String) throws {
		try store.storeCollection(StoreCollectionTaskResult(
			resourceType: .albums,
			resourceId: id,
			catalogMetadata: .album(.mock(id: id)),
			artworkURL: nil
		))
	}

	private func recordedAddedAt(_ id: String) async throws -> Date? {
		try await lastDatabaseQueue.read { database in
			try Date.fetchOne(
				database,
				sql: "SELECT added_at FROM offline_collection_added_at WHERE resource_type = 'albums' AND resource_id = ?",
				arguments: [id]
			)
		}
	}

	private func completeRead() async throws -> [OfflineCollection] {
		var complete: [OfflineCollection]?
		for try await read in offliner.offlineCollections(collectionType: .albums) where read.isComplete {
			complete = read.collections
		}
		return try XCTUnwrap(complete)
	}
}
