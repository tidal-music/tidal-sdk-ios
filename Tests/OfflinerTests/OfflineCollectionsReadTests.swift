@testable import Offliner
import GRDB
import XCTest

final class OfflineCollectionsReadTests: OfflinerTestCase {
	private var backend: StubOfflineApiClient!
	private var offliner: Offliner!

	override func setUp() {
		super.setUp()
		backend = StubOfflineApiClient()
		offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)
	}

	func testYieldsLocalThenCompleteMergedRead() async throws {
		try insertAlbumRow(id: "album-1")
		try insertAlbumRow(id: "album-2")
		backend.pendingCollectionsPages = [
			(collections: [.mock(catalogMetadata: .album(.mock(id: "album-2")), state: .pending)], cursor: "next"),
			(collections: [.mock(catalogMetadata: .album(.mock(id: "album-3")), state: .pending)], cursor: nil),
		]

		let (reads, error) = await collect(offliner.offlineCollections(collectionType: .albums))

		XCTAssertNil(error)
		XCTAssertEqual(reads.map(\.isComplete), [false, true])
		XCTAssertEqual(Set(reads[0].collections.map(\.catalogMetadata.id)), ["album-1", "album-2"])
		XCTAssertTrue(reads[0].collections.allSatisfy { $0.state == .stored })

		let complete = reads[1].collections
		XCTAssertEqual(complete.count, 3)
		XCTAssertEqual(complete.first { $0.catalogMetadata.id == "album-1" }?.state, .stored)
		XCTAssertEqual(complete.first { $0.catalogMetadata.id == "album-2" }?.state, .pending)
		XCTAssertEqual(complete.first { $0.catalogMetadata.id == "album-3" }?.state, .pending)
	}

	func testLocalReadFailureThrowsWithoutYielding() async throws {
		try insertAlbumRow(id: "album-1")
		try await lastDatabaseQueue.write { try $0.execute(sql: "ALTER TABLE offline_item RENAME TO offline_item_moved") }

		let (reads, error) = await collect(offliner.offlineCollections(collectionType: .albums))

		XCTAssertTrue(reads.isEmpty)
		XCTAssertNotNil(error)
		XCTAssertEqual(backend.pendingCollectionsCallCount, 0)
	}

	func testFailedInventoryPageThrowsAfterLocalRead() async throws {
		try insertAlbumRow(id: "album-1")
		backend.pendingCollectionsPages = [
			(collections: [.mock(catalogMetadata: .album(.mock(id: "album-2")), state: .pending)], cursor: "next"),
			(collections: [.mock(catalogMetadata: .album(.mock(id: "album-3")), state: .pending)], cursor: nil),
		]
		backend.pendingCollectionsFailingCall = 2

		let (reads, error) = await collect(offliner.offlineCollections(collectionType: .albums))

		XCTAssertEqual(reads.map(\.isComplete), [false])
		XCTAssertEqual(reads.first?.collections.map(\.catalogMetadata.id), ["album-1"])
		XCTAssertEqual((error as? URLError)?.code, .timedOut)
	}

	func testFailedFirstInventoryPageThrows() async throws {
		backend.pendingCollectionsFailingCall = 1

		let (reads, error) = await collect(offliner.offlineCollections(collectionType: .albums))

		XCTAssertEqual(reads.map(\.isComplete), [false])
		XCTAssertNotNil(error)
	}

	func testUnreadableRowIsSkipped() async throws {
		try insertAlbumRow(id: "album-1")
		try insertAlbumRow(id: "album-corrupt", catalogMetadata: "{not json")
		try insertAlbumRow(id: "album-2")

		let (reads, error) = await collect(offliner.offlineCollections(collectionType: .albums))

		XCTAssertNil(error)
		XCTAssertEqual(reads.map(\.isComplete), [false, true])
		XCTAssertEqual(Set(reads[1].collections.map(\.catalogMetadata.id)), ["album-1", "album-2"])
	}

	func testExistingStreamAlsoSkipsUnreadableRow() async throws {
		try insertAlbumRow(id: "album-1")
		try insertAlbumRow(id: "album-corrupt", catalogMetadata: "{not json")

		var emissions: [Set<OfflineCollection>] = []
		for await collections in offliner.getOfflineCollections(collectionType: .albums) {
			emissions.append(collections)
		}

		XCTAssertEqual(emissions.first?.map(\.catalogMetadata.id), ["album-1"])
	}

	func testUserCollectionTracksRowWithoutIdIsSkipped() async throws {
		try insertRow(resourceType: "userCollectionTracks", resourceId: "me", catalogMetadata: "{}")

		let (reads, error) = await collect(offliner.offlineCollections(collectionType: .userCollectionTracks))

		XCTAssertNil(error)
		XCTAssertEqual(reads.last?.collections.count, 0)
	}

	// MARK: - Helpers

	private func insertAlbumRow(id: String, catalogMetadata: String? = nil) throws {
		let metadata = catalogMetadata ?? #"{"id":"\#(id)","title":"Album \#(id)","artists":[],"explicit":false}"#
		try insertRow(resourceType: "albums", resourceId: id, catalogMetadata: metadata)
	}

	private func insertRow(resourceType: String, resourceId: String, catalogMetadata: String) throws {
		try lastDatabaseQueue.write { database in
			try database.execute(
				sql: "INSERT INTO offline_item (resource_type, resource_id, catalog_metadata) VALUES (?, ?, ?)",
				arguments: [resourceType, resourceId, catalogMetadata]
			)
		}
	}

	private func collect(
		_ stream: AsyncThrowingStream<OfflineCollectionsRead, Error>
	) async -> (reads: [OfflineCollectionsRead], error: Error?) {
		var reads: [OfflineCollectionsRead] = []
		do {
			for try await read in stream {
				reads.append(read)
			}
			return (reads, nil)
		} catch {
			return (reads, error)
		}
	}
}
