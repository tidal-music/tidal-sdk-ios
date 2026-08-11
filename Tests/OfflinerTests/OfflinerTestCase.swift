@testable import Offliner
import GRDB
import XCTest

class OfflinerTestCase: XCTestCase {
	var tempDir: URL!
	var lastDatabaseQueue: DatabaseQueue!
	private var offliners: [Offliner] = []

	override func setUp() {
		super.setUp()
		tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
		try? FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
	}

	override func tearDown() async throws {
		for offliner in offliners {
			try? await offliner.reset()
		}
		offliners.removeAll()
		if let tempDir {
			try? FileManager.default.removeItem(at: tempDir)
		}
		try await super.tearDown()
	}

	func createOffliner(
		installationId: String = UUID().uuidString,
		offlineApiClient: OfflineApiClientProtocol,
		artworkDownloader: ArtworkDownloaderProtocol,
		mediaDownloader: MediaDownloaderProtocol,
		trackManifestFetcher: TrackManifestFetcherProtocol = SucceedingTrackManifestFetcher(),
		videoManifestFetcher: VideoManifestFetcherProtocol = SucceedingVideoManifestFetcher()
	) -> Offliner {
		// swiftlint:disable:next force_try
		let storage = try! OfflinerStorage(installationId: installationId, baseDirectory: tempDir)
		lastDatabaseQueue = storage.databaseQueue

		let offliner = Offliner(
			storage: storage,
			offlineApiClient: offlineApiClient,
			artworkDownloader: artworkDownloader,
			mediaDownloader: mediaDownloader,
			trackManifestFetcher: trackManifestFetcher,
			videoManifestFetcher: videoManifestFetcher
		)
		offliners.append(offliner)
		return offliner
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
