@testable import Offliner
import XCTest

final class GetCollectionsStreamTests: OfflinerTestCase {
	func testGetOfflineCollectionEmitsLocalThenBackendPending() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(collectionType: .albums, resourceId: .identifier("album-123"))
		await offliner.run()
		await backend.waitForTasksToComplete()

		backend.pendingCollection = OfflineCollection.mock(
			catalogMetadata: .album(.mock(id: "album-123")),
			artworkURL: nil,
			state: .pending
		)

		var emissions: [OfflineCollection?] = []
		for await item in offliner.getOfflineCollection(collectionType: .albums, resourceId: .identifier("album-123")) {
			emissions.append(item)
		}

		XCTAssertEqual(emissions.count, 2)

		XCTAssertEqual(emissions[0]?.catalogMetadata.id, "album-123")
		XCTAssertEqual(emissions[0]?.state, .stored)

		XCTAssertEqual(emissions[1]?.catalogMetadata.id, "album-123")
		XCTAssertEqual(emissions[1]?.state, .pending)
	}

	func testGetOfflineCollectionsEmitsLocalThenBackendPending() async throws {
		let backend = StubOfflineApiClient()
		let offliner = createOffliner(
			offlineApiClient: backend,
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(collectionType: .albums, resourceId: .identifier("album-123"))
		await offliner.run()
		await backend.waitForTasksToComplete()

		let backendPending = OfflineCollection.mock(
			catalogMetadata: .album(.mock(id: "album-456")),
			artworkURL: nil,
			state: .pending
		)
		backend.pendingCollectionsPages = [(collections: [backendPending], cursor: nil)]

		var emissions: [Set<OfflineCollection>] = []
		for await page in offliner.getOfflineCollections(collectionType: .albums) {
			emissions.append(page)
		}

		XCTAssertEqual(emissions.count, 2)

		XCTAssertEqual(emissions[0].count, 1)
		let firstItem = try XCTUnwrap(emissions[0].first)
		XCTAssertEqual(firstItem.catalogMetadata.id, "album-123")
		XCTAssertEqual(firstItem.state, .stored)

		XCTAssertEqual(emissions[1].count, 2)
		let storedItem = try XCTUnwrap(emissions[1].first { $0.state == .stored })
		let pendingItem = try XCTUnwrap(emissions[1].first { $0.state == .pending })
		XCTAssertEqual(storedItem.catalogMetadata.id, "album-123")
		XCTAssertEqual(pendingItem.catalogMetadata.id, "album-456")
	}
}
