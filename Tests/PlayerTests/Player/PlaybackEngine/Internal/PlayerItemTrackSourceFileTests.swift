import Foundation
@testable import Player
import Testing

// MARK: - Constants

private enum Constants {
	static let uuid = "uuid"
	static let trackId = "12345"
	static let sourceFileId = UUID(uuidString: "A0EEBC99-9C0B-4EF8-BB6D-6BB9BD380A11")!
	static let reportedSourceFileId = "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11"
}

// MARK: - PlayerItemTrackSourceFileTests

@Suite(.serialized)
final class PlayerItemTrackSourceFileTests {
	private let monitor = PlayerItemMonitorMock()
	private let playerEventSender = PlayerEventSenderMock()
	private let player = PlayerMock()
	private var timestamp: UInt64 = 1

	init() {
		let timeProvider = TimeProvider.mock(timestamp: { self.timestamp })
		let uuidProvider = UUIDProvider(uuidString: { Constants.uuid })
		PlayerWorld = PlayerWorldClient.mock(timeProvider: timeProvider, uuidProvider: uuidProvider)
	}

	@Test
	func test_streamingPlay_eventsCarryTypeAndSourceFileId() {
		let mediaProduct = TrackSourceFileMediaProduct(sourceFileId: Constants.sourceFileId, trackId: Constants.trackId)

		play(mediaProduct, playbackSource: .INTERNET)

		let streamingSessionStart = playerEventSender.streamingMetricsEvents.first as? StreamingSessionStart
		#expect(streamingSessionStart?.sessionProductType == "TRACK_SOURCE_FILE")
		#expect(streamingSessionStart?.sessionProductId == Constants.trackId)
		#expect(streamingSessionStart?.sessionSourceFileId == Constants.reportedSourceFileId)

		let playbackStatistics = playerEventSender.streamingMetricsEvents.compactMap { $0 as? PlaybackStatistics }
		#expect(playbackStatistics.count == 1)
		#expect(playbackStatistics.first?.productType == "TRACK_SOURCE_FILE")
		#expect(playbackStatistics.first?.actualProductId == Constants.trackId)
		#expect(playbackStatistics.first?.sourceFileId == Constants.reportedSourceFileId)

		#expect(playerEventSender.playLogEvents.count == 1)
		#expect(playerEventSender.playLogEvents.first?.productType == "TRACK_SOURCE_FILE")
		#expect(playerEventSender.playLogEvents.first?.requestedProductId == Constants.trackId)
		#expect(playerEventSender.playLogEvents.first?.actualProductId == Constants.trackId)
		#expect(playerEventSender.playLogEvents.first?.sourceFileId == Constants.reportedSourceFileId)
	}

	@Test
	func test_streamingPlay_trackEventsHaveNoSourceFileId() {
		play(MediaProduct.mock(productType: .TRACK, productId: Constants.trackId), playbackSource: .INTERNET)

		let streamingSessionStart = playerEventSender.streamingMetricsEvents.first as? StreamingSessionStart
		#expect(streamingSessionStart?.sessionSourceFileId == nil)
		let playbackStatistics = playerEventSender.streamingMetricsEvents.compactMap { $0 as? PlaybackStatistics }
		#expect(playbackStatistics.first?.sourceFileId == nil)
		#expect(playerEventSender.playLogEvents.first?.sourceFileId == nil)
	}

	// MARK: - Payloads

	@Test
	func test_payloads_omitSourceFileIdWhenNil() throws {
		#expect(try jsonKeys(of: PlayLogEvent.mock()).contains("sourceFileId") == false)
		#expect(try jsonKeys(of: StreamingSessionStart.mock()).contains("sessionSourceFileId") == false)
		#expect(try jsonKeys(of: PlaybackStatistics.mock()).contains("sourceFileId") == false)
	}

	@Test
	func test_payloads_includeSourceFileIdWhenSet() throws {
		let playLog = try jsonObject(of: PlayLogEvent.mock(
			productType: .TRACK_SOURCE_FILE,
			sourceFileId: Constants.reportedSourceFileId
		))
		#expect(playLog["productType"] as? String == "TRACK_SOURCE_FILE")
		#expect(playLog["sourceFileId"] as? String == Constants.reportedSourceFileId)

		let streamingSessionStart = try jsonObject(of: StreamingSessionStart.mock(
			sessionProductType: .TRACK_SOURCE_FILE,
			sessionSourceFileId: Constants.reportedSourceFileId
		))
		#expect(streamingSessionStart["sessionProductType"] as? String == "TRACK_SOURCE_FILE")
		#expect(streamingSessionStart["sessionSourceFileId"] as? String == Constants.reportedSourceFileId)

		let playbackStatistics = try jsonObject(of: PlaybackStatistics.mock(
			productType: ProductType.TRACK_SOURCE_FILE.rawValue,
			sourceFileId: Constants.reportedSourceFileId
		))
		#expect(playbackStatistics["productType"] as? String == "TRACK_SOURCE_FILE")
		#expect(playbackStatistics["sourceFileId"] as? String == Constants.reportedSourceFileId)
	}
}

private extension PlayerItemTrackSourceFileTests {
	/// Drives an item through load, play and completion, then emits its events, like `PlayerItemTests` does.
	func play(_ mediaProduct: MediaProduct, playbackSource: PlaybackSource) {
		var playerItem: PlayerItem? = PlayerItem.mock(
			mediaProduct: mediaProduct,
			playerItemMonitor: monitor,
			playerEventSender: playerEventSender,
			timestamp: timestamp
		)

		let asset = AssetMock(with: player, loudnessNormalizationConfiguration: LoudnessNormalizationConfiguration.mock())
		playerItem?.set(asset)
		playerItem?.set(Metadata.mock(productId: mediaProduct.productId, playbackSource: playbackSource))

		timestamp = 2
		playerItem?.loaded(asset: asset, with: 2)
		playerItem?.play(timestamp: 2)
		playerItem?.playing(asset: asset)

		timestamp = 5
		asset.assetPosition = 4
		playerItem?.completed(asset: asset)
		playerItem?.emitEvents()
		playerItem = nil

		RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
	}

	func jsonObject(of value: some Encodable) throws -> [String: Any] {
		try #require(JSONSerialization.jsonObject(with: JSONEncoder().encode(value)) as? [String: Any])
	}

	func jsonKeys(of value: some Encodable) throws -> Set<String> {
		try Set(jsonObject(of: value).keys)
	}
}
