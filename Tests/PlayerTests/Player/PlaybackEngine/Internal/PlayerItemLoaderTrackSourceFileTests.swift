import Foundation
@testable import Player
import Testing

// MARK: - Constants

private enum Constants {
	static let trackId = "12345"
	static let sourceFileId = UUID(uuidString: "A0EEBC99-9C0B-4EF8-BB6D-6BB9BD380A11")!
}

// MARK: - PlayerItemLoaderTrackSourceFileTests

@Suite(.serialized)
final class PlayerItemLoaderTrackSourceFileTests {
	private let offlineItemProvider = OfflineItemProviderSpy()
	private let offlineStorage = OfflineStorageSpy()
	private let playerLoader = PlayerLoaderMock()
	private var requestedSourceFileIds = [String]()

	init() {
		PlayerWorld = PlayerWorldClient.mock()
	}

	private var playerItemLoader: PlayerItemLoader {
		let playbackInfoFetcher = PlaybackInfoFetcher.mock(trackSourceFileManifestFetch: { sourceFileId, formats, adaptive in
			self.requestedSourceFileIds.append(sourceFileId)
			return try await PlaybackInfoFetcher.mockTrackSourceFileManifestFetch(sourceFileId, formats, adaptive)
		})

		return PlayerItemLoader(
			with: offlineStorage,
			{ true },
			offlineItemProvider,
			playbackInfoFetcher,
			Configuration.mock(),
			and: playerLoader
		)
	}

	@Test
	func test_load_sourceFile_skipsAllOfflineSourcesAndStreams() async throws {
		let mediaProduct = TrackSourceFileMediaProduct(sourceFileId: Constants.sourceFileId, trackId: Constants.trackId)
		let playerItem = PlayerItem.mock(mediaProduct: mediaProduct, playerItemMonitor: PlayerItemMonitorMock())

		try await playerItemLoader.load(playerItem)

		#expect(offlineItemProvider.requests.isEmpty)
		#expect(offlineStorage.requestedKeys.isEmpty)
		#expect(playerLoader.loadOfflinePlaybackItems.isEmpty)
		#expect(playerLoader.loadPlayableStorageItems.isEmpty)
		#expect(requestedSourceFileIds == ["a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11"])
		#expect(playerLoader.loadPlaybackInfos.map(\.productType) == [.TRACK_SOURCE_FILE])
		#expect(playerLoader.loadPlaybackInfos.map(\.productId) == [Constants.trackId])
		#expect(playerItem.metadata?.playbackSource == .INTERNET)
	}

	@Test
	func test_load_track_usesOfflineItemOfSameProductId() async throws {
		let mediaProduct = MediaProduct.mock(productType: .TRACK, productId: Constants.trackId)
		let playerItem = PlayerItem.mock(mediaProduct: mediaProduct, playerItemMonitor: PlayerItemMonitorMock())

		try await playerItemLoader.load(playerItem)

		#expect(offlineItemProvider.requests.map(\.productId) == [Constants.trackId])
		#expect(playerLoader.loadOfflinePlaybackItems.count == 1)
		#expect(playerLoader.loadPlaybackInfos.isEmpty)
		#expect(requestedSourceFileIds.isEmpty)
	}
}

// MARK: - OfflineItemProviderSpy

/// Has an offline item for every product, so any lookup made for a source file would hijack its playback.
private final class OfflineItemProviderSpy: OfflineItemProvider {
	private(set) var requests = [(productType: ProductType, productId: String)]()

	func get(productType: ProductType, productId: String) async -> OfflinePlaybackItem? {
		requests.append((productType, productId))
		return OfflinePlaybackItem(
			mediaURL: URL(fileURLWithPath: "/offline/\(productId)"),
			licenseURL: nil,
			format: nil,
			albumReplayGain: nil,
			albumPeakAmplitude: nil,
			productType: productType
		)
	}
}

// MARK: - OfflineStorageSpy

private final class OfflineStorageSpy: OfflineStorage {
	private(set) var requestedKeys = [String]()

	func save(_ entry: OfflineEntry) throws {}

	func get(key: String) throws -> OfflineEntry? {
		requestedKeys.append(key)
		return nil
	}

	func delete(key: String) throws {}

	func getAll() throws -> [OfflineEntry] { [] }

	func clear() throws {}

	func totalSize() throws -> Int { 0 }
}
