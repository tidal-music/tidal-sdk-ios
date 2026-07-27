@testable import Offliner
import GRDB
import XCTest

class OfflinerTestCase: XCTestCase {
	var tempDir: URL!

	override func setUp() {
		super.setUp()
		tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		try? FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
	}

	override func tearDown() {
		if let tempDir {
			try? FileManager.default.removeItem(at: tempDir)
		}
		super.tearDown()
	}

	func createOffliner(
		offlineApiClient: OfflineApiClientProtocol,
		artworkDownloader: ArtworkDownloaderProtocol,
		mediaDownloader: MediaDownloaderProtocol,
		trackManifestFetcher: TrackManifestFetcherProtocol = SucceedingTrackManifestFetcher(),
		videoManifestFetcher: VideoManifestFetcherProtocol = SucceedingVideoManifestFetcher(),
		collectionDownloadStatePollInterval: UInt64 = 1_000_000_000
	) -> Offliner {
		let dbPath = tempDir.appendingPathComponent("test-\(UUID().uuidString).sqlite").path
		// swiftlint:disable:next force_try
		let databaseQueue = try! DatabaseQueue(path: dbPath)
		// swiftlint:disable:next force_try
		try! Migrations.run(databaseQueue)
		let offlineStore = OfflineStore(databaseQueue)

		return Offliner(
			offlineApiClient: offlineApiClient,
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader,
			mediaDownloader: mediaDownloader,
			trackManifestFetcher: trackManifestFetcher,
			videoManifestFetcher: videoManifestFetcher,
			collectionDownloadStatePollInterval: collectionDownloadStatePollInterval
		)
	}

	/// Polls the local store until at least `target` media items of the given type are present, or the poll budget is
	/// exhausted. Used by tests that let the task runner drain in the background rather than observing the download stream.
	@discardableResult
	func waitForStoredMediaItems(
		_ offliner: Offliner,
		mediaType: OfflineMediaItemType,
		target: Int,
		maxPolls: Int = 300
	) async throws -> [OfflineMediaItem] {
		for _ in 0..<maxPolls {
			let items = try await offliner.getOfflineMediaItems(mediaType: mediaType)
			if items.count >= target {
				return items
			}
			try? await Task.sleep(nanoseconds: 10_000_000)
		}
		return try await offliner.getOfflineMediaItems(mediaType: mediaType)
	}

	func downloadAndWaitForCompletion(_ offliner: Offliner) async throws {
		let downloads = offliner.newDownloads
		async let runTask: () = offliner.run()

		for await download in downloads {
			let events = download.events
			await assertEventually(events) { event in
				if case .state(.completed) = event { return true }
				return false
			}
			break
		}

		await runTask
	}
}
