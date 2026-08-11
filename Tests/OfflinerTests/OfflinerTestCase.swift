@testable import Offliner
import GRDB
import XCTest

class OfflinerTestCase: XCTestCase {
	var tempDir: URL!
	var lastDatabaseQueue: DatabaseQueue!

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
		installationId: String = UUID().uuidString,
		offlineApiClient: OfflineApiClientProtocol,
		artworkDownloader: ArtworkDownloaderProtocol,
		mediaDownloader: MediaDownloaderProtocol,
		trackManifestFetcher: TrackManifestFetcherProtocol = SucceedingTrackManifestFetcher(),
		videoManifestFetcher: VideoManifestFetcherProtocol = SucceedingVideoManifestFetcher(),
		collectionDownloadStatePollInterval: UInt64 = 1_000_000_000
	) -> Offliner {
		// swiftlint:disable:next force_try
		let storage = try! OfflinerStorage(installationId: installationId, baseDirectory: tempDir)
		lastDatabaseQueue = storage.databaseQueue

		return Offliner(
			storage: storage,
			offlineApiClient: offlineApiClient,
			artworkDownloader: artworkDownloader,
			mediaDownloader: mediaDownloader,
			trackManifestFetcher: trackManifestFetcher,
			videoManifestFetcher: videoManifestFetcher,
			collectionDownloadStatePollInterval: collectionDownloadStatePollInterval
		)
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
