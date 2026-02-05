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
		backendClient: BackendClientProtocol,
		artworkDownloader: ArtworkDownloaderProtocol,
		mediaDownloader: MediaDownloaderProtocol
	) -> Offliner {
		let dbPath = tempDir.appendingPathComponent("test-\(UUID().uuidString).sqlite").path
		// swiftlint:disable:next force_try
		let databaseQueue = try! DatabaseQueue(path: dbPath)
		// swiftlint:disable:next force_try
		try! Migrations.run(databaseQueue)
		let offlineStore = OfflineStore(databaseQueue)

		return Offliner(
			backendClient: backendClient,
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader,
			mediaDownloader: mediaDownloader
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

		try await runTask
	}
}
