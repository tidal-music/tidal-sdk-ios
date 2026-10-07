import Foundation
import GRDB
@testable import Player
import Testing

// MARK: - Constants

private enum Constants {
	static let trackId = "12345"
	static let sourceFileId = UUID(uuidString: "A0EEBC99-9C0B-4EF8-BB6D-6BB9BD380A11")!
}

// MARK: - OfflineEngineTrackSourceFileTests

/// A source file shares its productId with its track, so each engine entry point must refuse it rather than act on the
/// track's download or offline entry.
@Suite(.serialized)
final class OfflineEngineTrackSourceFileTests {
	private let downloader = DownloaderSpy()
	private let storage: GRDBOfflineStorage
	private let offlineEngine: OfflineEngine
	private let sourceFile = TrackSourceFileMediaProduct(sourceFileId: Constants.sourceFileId, trackId: Constants.trackId)

	init() throws {
		PlayerWorld = PlayerWorldClient.mock()
		let dbQueue = try DatabaseQueue()
		try GRDBOfflineStorage.initializeDatabase(dbQueue: dbQueue)
		storage = GRDBOfflineStorage(dbQueue: dbQueue)
		offlineEngine = OfflineEngine.mock(downloader: downloader, storage: storage)
	}

	@Test
	func test_offline_sourceFile_doesNotDownload() {
		#expect(offlineEngine.offline(mediaProduct: sourceFile) == false)
		#expect(downloader.downloadedProductIds.isEmpty)
	}

	@Test
	func test_offlineStateAndDelete_sourceFile_ignoreOfflinedTrack() throws {
		try storage.save(OfflineEntry.mock(
			productId: Constants.trackId,
			productType: .TRACK,
			URL: URL(fileURLWithPath: "/offline/\(Constants.trackId)")
		))
		let track = MediaProduct.mock(productType: .TRACK, productId: Constants.trackId)
		let trackState = offlineEngine.getOfflineState(mediaProduct: track)
		#expect(trackState != .NOT_OFFLINED)

		#expect(offlineEngine.getOfflineState(mediaProduct: sourceFile) == .NOT_OFFLINED)
		#expect(offlineEngine.deleteOffline(mediaProduct: sourceFile) == false)
		#expect(try storage.get(key: Constants.trackId) != nil)
		#expect(offlineEngine.getOfflineState(mediaProduct: track) == trackState)
	}
}

// MARK: - DownloaderSpy

private final class DownloaderSpy: Downloader {
	private(set) var downloadedProductIds = [String]()

	init() {
		super.init(
			playbackInfoFetcher: .mock(),
			fairPlayLicenseFetcher: .mock(),
			networkMonitor: NetworkMonitorMock(),
			featureFlagProvider: .mock
		)
	}

	override func download(mediaProduct: MediaProduct, sessionType: SessionType, outputDevice: String? = nil) {
		downloadedProductIds.append(mediaProduct.productId)
	}
}
