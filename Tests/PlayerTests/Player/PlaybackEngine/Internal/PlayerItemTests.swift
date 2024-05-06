@testable import Player
import XCTest

// MARK: - Constants

private enum Constants {
	static let token = "token"
	static let deviceType = DeviceInfoProvider.Constants.deviceTypeMobile
	static let uuid = "uuid"
}

// MARK: - PlayerItemTests

// swiftlint:disable file_length
// swiftlint:disable:next type_body_length
final class PlayerItemTests: XCTestCase {
	private var monitor: PlayerItemMonitorMock!
	private var dataWriter: DataWriterMock!
	private var playerEventSender: PlayerEventSenderMock!
	private var player: PlayerMock!

	private let configuration: Configuration = .mock()
	private var user: User!
	private var client: Client {
		Client(
			token: configuration.clientToken,
			version: configuration.clientVersion,
			deviceType: Constants.deviceType
		)
	}

	private var timestamp: UInt64 = 1

	override func setUp() {
		// Set up time and uuid provider
		let timeProvider = TimeProvider.mock(
			timestamp: {
				self.timestamp
			}
		)
		let uuidProvider = UUIDProvider(
			uuidString: {
				Constants.uuid
			}
		)
		PlayerWorld = PlayerWorldClient.mock(timeProvider: timeProvider, uuidProvider: uuidProvider)

		monitor = PlayerItemMonitorMock()
		dataWriter = DataWriterMock()
		playerEventSender = PlayerEventSenderMock(dataWriter: dataWriter)
		player = PlayerMock()

		let userConfiguration = UserConfiguration.mock()
		user = User(
			id: userConfiguration.userId,
			accessToken: "Bearer \(Constants.token)",
			clientId: userConfiguration.userClientId
		)
	}

	// MARK: - init

	func test_init_sendsOnlyStreamingSessionStart_legacy() {
		// GIVEN
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		let mediaProduct = MediaProduct.mock()
		let playerItem = PlayerItem.mock(
			startReason: .EXPLICIT,
			mediaProduct: mediaProduct,
			networkType: .MOBILE,
			outputDevice: nil,
			sessionType: .PLAYBACK,
			playerItemMonitor: monitor,
			playerEventSender: playerEventSender,
			timestamp: timestamp,
			isPreload: false
		)

		// Needed to silence warning and keep playerItem in memory.
		withExtendedLifetime(playerItem) {}

		let streamingSessionStart = StreamingSessionStart.mock(
			streamingSessionId: Constants.uuid,
			startReason: .EXPLICIT,
			timestamp: timestamp,
			networkType: .MOBILE,
			outputDevice: nil,
			sessionType: .PLAYBACK,
			sessionProductType: mediaProduct.productType,
			sessionProductId: mediaProduct.productId,
			sessionTags: nil
		)

		// When the item has not been played, in deinit, we only send StreamingSessionStart.
		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 1)
		XCTAssertEqual(playerEventSender.streamingMetricsEvents.first as? StreamingSessionStart, streamingSessionStart)
	}

	func test_init_sendsOnlyStreamingSessionStart() {
		// GIVEN
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		let mediaProduct = MediaProduct.mock()
		_ = PlayerItem.mock(
			startReason: .EXPLICIT,
			mediaProduct: mediaProduct,
			networkType: .MOBILE,
			outputDevice: nil,
			sessionType: .PLAYBACK,
			playerItemMonitor: monitor,
			playerEventSender: playerEventSender,
			timestamp: timestamp,
			isPreload: false
		)

		let streamingSessionStart = StreamingSessionStart.mock(
			streamingSessionId: Constants.uuid,
			startReason: .EXPLICIT,
			timestamp: timestamp,
			networkType: .MOBILE,
			outputDevice: nil,
			sessionType: .PLAYBACK,
			sessionProductType: mediaProduct.productType,
			sessionProductId: mediaProduct.productId,
			sessionTags: nil
		)

		// When the item has not been played, in deinit, we only send StreamingSessionStart.
		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 1)
		XCTAssertEqual(playerEventSender.streamingMetricsEvents.first as? StreamingSessionStart, streamingSessionStart)
	}

	func test_init_and_deinit_withoutMetrics_sendsOnlyStreamingSessionStart_and_StreamingSessionEnd_legacy() {
		// GIVEN
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		let mediaProduct = MediaProduct.mock()
		var playerItem: PlayerItem? = PlayerItem.mock(
			startReason: .EXPLICIT,
			mediaProduct: mediaProduct,
			networkType: .MOBILE,
			outputDevice: nil,
			sessionType: .PLAYBACK,
			playerItemMonitor: monitor,
			playerEventSender: playerEventSender,
			timestamp: timestamp,
			isPreload: false
		)

		let streamingSessionStart = StreamingSessionStart.mock(
			streamingSessionId: Constants.uuid,
			startReason: .EXPLICIT,
			timestamp: timestamp,
			networkType: .MOBILE,
			outputDevice: nil,
			sessionType: .PLAYBACK,
			sessionProductType: mediaProduct.productType,
			sessionProductId: mediaProduct.productId,
			sessionTags: nil
		)

		let streamingSessionEnd = StreamingSessionEnd.mock(
			streamingSessionId: Constants.uuid,
			timestamp: timestamp
		)

		// Needed to silence warning about object not read
		withExtendedLifetime(playerItem) {}

		// This is needed in order to release the reference and cause deinit to be called so we can proceed with assertions.
		playerItem = nil

		// THEN
		let expectation = expectation(description: "Expect to receive events after PlayerItem deinit")
		_ = XCTWaiter.wait(for: [expectation], timeout: 0.1)

		// When the item has not been played, in deinit, we only send StreamingSessionStart and StreamingSessionEnd.
		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 2)
		XCTAssertEqual(playerEventSender.streamingMetricsEvents.first as? StreamingSessionStart, streamingSessionStart)
		XCTAssertEqual(playerEventSender.streamingMetricsEvents.last as? StreamingSessionEnd, streamingSessionEnd)
	}

	func test_init_and_deinit_withoutMetrics_sendsOnlyStreamingSessionStart_and_StreamingSessionEnd() {
		// GIVEN
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		let mediaProduct = MediaProduct.mock()
		var playerItem: PlayerItem? = PlayerItem.mock(
			startReason: .EXPLICIT,
			mediaProduct: mediaProduct,
			networkType: .MOBILE,
			outputDevice: nil,
			sessionType: .PLAYBACK,
			playerItemMonitor: monitor,
			playerEventSender: playerEventSender,
			timestamp: timestamp,
			isPreload: false
		)

		let streamingSessionStart = StreamingSessionStart.mock(
			streamingSessionId: Constants.uuid,
			startReason: .EXPLICIT,
			timestamp: timestamp,
			networkType: .MOBILE,
			outputDevice: nil,
			sessionType: .PLAYBACK,
			sessionProductType: mediaProduct.productType,
			sessionProductId: mediaProduct.productId,
			sessionTags: nil
		)

		let streamingSessionEnd = StreamingSessionEnd.mock(
			streamingSessionId: Constants.uuid,
			timestamp: timestamp
		)

		playerItem?.emitEvents()
		playerItem = nil

		// When the item has not been played, in deinit, we only send StreamingSessionStart and StreamingSessionEnd.
		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 2)
		XCTAssertEqual(playerEventSender.streamingMetricsEvents.first as? StreamingSessionStart, streamingSessionStart)
		XCTAssertEqual(playerEventSender.streamingMetricsEvents.last as? StreamingSessionEnd, streamingSessionEnd)
	}

	func test_usualStreamingPlayFlow_legacy() {
		// GIVEN
		let initialTimestamp = timestamp
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		let mediaProduct = MediaProduct.mock()
		let startReason: StartReason = .EXPLICIT
		var playerItem: PlayerItem? = PlayerItem.mock(
			startReason: startReason,
			mediaProduct: mediaProduct,
			networkType: .MOBILE,
			outputDevice: nil,
			sessionType: .PLAYBACK,
			playerItemMonitor: monitor,
			playerEventSender: playerEventSender,
			timestamp: timestamp,
			isPreload: false
		)

		// Have both metadata and asset set up
		let loudnessNormalizationConfiguration = LoudnessNormalizationConfiguration.mock()
		let asset = AssetMock(with: player, loudnessNormalizationConfiguration: loudnessNormalizationConfiguration)
		playerItem?.set(asset)

		let audioQuality = AudioQuality.LOSSLESS
		let metadata = Metadata.mock(productId: mediaProduct.productId, audioQuality: audioQuality)
		playerItem?.set(metadata)

		let startTimestamp: UInt64 = 2
		timestamp = startTimestamp

		// WHEN
		let duration: Double = 2
		playerItem?.loaded(asset: asset, with: duration)
		playerItem?.play(timestamp: startTimestamp)

		playerItem?.downloaded(asset: asset)

		playerItem?.playing(asset: asset)
		asset.assetPosition = 3

		let endTimestamp: UInt64 = 5
		timestamp = 5

		let endAssetPosition: Double = 4
		asset.assetPosition = endAssetPosition
		playerItem?.completed(asset: asset)

		// This is needed in order to release the reference and cause deinit to be called so we can proceed with assertions.
		playerItem = nil

		// THEN
		let expectation = expectation(description: "Expect to receive events after PlayerItem deinit")
		_ = XCTWaiter.wait(for: [expectation], timeout: 0.1)

		// Sent from the init: StreamingSessionStart, PlaybackStatistics, StreamingSessionEnd
		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 3)

		// StreamingSessionStart sent from init
		let streamingSessionStart = StreamingSessionStart.mock(
			streamingSessionId: Constants.uuid,
			startReason: startReason,
			timestamp: initialTimestamp,
			networkType: .MOBILE,
			outputDevice: nil,
			sessionProductId: mediaProduct.productId
		)
		XCTAssertEqual(playerEventSender.streamingMetricsEvents.first as? StreamingSessionStart, streamingSessionStart)

		// Sent in the deinit
		let playbackStatistics = PlaybackStatistics.mock(
			streamingSessionId: Constants.uuid,
			idealStartTimestamp: startTimestamp,
			actualStartTimestamp: startTimestamp,
			productType: mediaProduct.productType.rawValue,
			actualProductId: metadata.productId,
			actualStreamType: metadata.streamType.rawValue,
			actualAssetPresentation: metadata.assetPresentation.rawValue,
			actualAudioMode: metadata.audioMode?.rawValue,
			actualQuality: mediaProduct.productType.quality(given: metadata),
			startReason: startReason,
			endTimestamp: endTimestamp
		)
		XCTAssertEqual(playerEventSender.streamingMetricsEvents[1] as? PlaybackStatistics, playbackStatistics)

		let streamingSessionEnd = StreamingSessionEnd.mock(streamingSessionId: Constants.uuid, timestamp: endTimestamp)
		XCTAssertEqual(playerEventSender.streamingMetricsEvents[2] as? StreamingSessionEnd, streamingSessionEnd)

		let playLogEvent = PlayLogEvent.mock(
			playbackSessionId: Constants.uuid,
			startTimestamp: startTimestamp,
			requestedProductId: mediaProduct.productId,
			actualProductId: mediaProduct.productId,
			actualQuality: audioQuality.rawValue,
			endTimestamp: endTimestamp,
			endAssetPosition: endAssetPosition
		)
		XCTAssertEqual(playerEventSender.playLogEvents, [playLogEvent])

		let progressEvent = ProgressEvent.mock(
			id: mediaProduct.productId,
			assetPosition: Int(endAssetPosition * 1000),
			duration: Int(duration * 1000),
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		XCTAssertEqual(playerEventSender.progressEvents, [progressEvent])
	}

	func test_usualStreamingPlayFlow() {
		// GIVEN
		let initialTimestamp = timestamp
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		let mediaProduct = MediaProduct.mock()
		let startReason: StartReason = .EXPLICIT
		let playerItem: PlayerItem? = PlayerItem.mock(
			startReason: startReason,
			mediaProduct: mediaProduct,
			networkType: .MOBILE,
			outputDevice: nil,
			sessionType: .PLAYBACK,
			playerItemMonitor: monitor,
			playerEventSender: playerEventSender,
			timestamp: timestamp,
			isPreload: false
		)

		// Have both metadata and asset set up
		let loudnessNormalizationConfiguration = LoudnessNormalizationConfiguration.mock()
		let asset = AssetMock(with: player, loudnessNormalizationConfiguration: loudnessNormalizationConfiguration)
		playerItem?.set(asset)

		let audioQuality = AudioQuality.LOSSLESS
		let metadata = Metadata.mock(productId: mediaProduct.productId, audioQuality: audioQuality)
		playerItem?.set(metadata)

		let startTimestamp: UInt64 = 2
		timestamp = startTimestamp

		// WHEN
		let duration: Double = 2
		playerItem?.loaded(asset: asset, with: duration)
		playerItem?.play(timestamp: startTimestamp)

		playerItem?.downloaded(asset: asset)

		playerItem?.playing(asset: asset)
		asset.assetPosition = 3

		let endTimestamp: UInt64 = 5
		timestamp = 5

		let endAssetPosition: Double = 4
		asset.assetPosition = endAssetPosition
		playerItem?.completed(asset: asset)

		// Emit events
		playerItem?.emitEvents()

		// THEN
		let expectation = expectation(description: "Expect to receive events after PlayerItem deinit")
		_ = XCTWaiter.wait(for: [expectation], timeout: 0.1)

		// Sent from the init: StreamingSessionStart, PlaybackStatistics, StreamingSessionEnd
		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 3)

		// StreamingSessionStart sent from init
		let streamingSessionStart = StreamingSessionStart.mock(
			streamingSessionId: Constants.uuid,
			startReason: startReason,
			timestamp: initialTimestamp,
			networkType: .MOBILE,
			outputDevice: nil,
			sessionProductId: mediaProduct.productId
		)
		XCTAssertEqual(playerEventSender.streamingMetricsEvents.first as? StreamingSessionStart, streamingSessionStart)

		// Sent in the deinit
		let playbackStatistics = PlaybackStatistics.mock(
			streamingSessionId: Constants.uuid,
			idealStartTimestamp: startTimestamp,
			actualStartTimestamp: startTimestamp,
			productType: mediaProduct.productType.rawValue,
			actualProductId: metadata.productId,
			actualStreamType: metadata.streamType.rawValue,
			actualAssetPresentation: metadata.assetPresentation.rawValue,
			actualAudioMode: metadata.audioMode?.rawValue,
			actualQuality: mediaProduct.productType.quality(given: metadata),
			startReason: startReason,
			endTimestamp: endTimestamp
		)
		XCTAssertEqual(playerEventSender.streamingMetricsEvents[1] as? PlaybackStatistics, playbackStatistics)

		let streamingSessionEnd = StreamingSessionEnd.mock(streamingSessionId: Constants.uuid, timestamp: endTimestamp)
		XCTAssertEqual(playerEventSender.streamingMetricsEvents[2] as? StreamingSessionEnd, streamingSessionEnd)

		let playLogEvent = PlayLogEvent.mock(
			playbackSessionId: Constants.uuid,
			startTimestamp: startTimestamp,
			requestedProductId: mediaProduct.productId,
			actualProductId: mediaProduct.productId,
			actualQuality: audioQuality.rawValue,
			endTimestamp: endTimestamp,
			endAssetPosition: endAssetPosition
		)
		XCTAssertEqual(playerEventSender.playLogEvents, [playLogEvent])

		let progressEvent = ProgressEvent.mock(
			id: mediaProduct.productId,
			assetPosition: Int(endAssetPosition * 1000),
			duration: Int(duration * 1000),
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		XCTAssertEqual(playerEventSender.progressEvents, [progressEvent])
	}

	// MARK: - unload

	func test_unload_legacy() async throws {
		// GIVEN
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		let playerItem = PlayerItem.mock(
			startReason: .EXPLICIT,
			mediaProduct: .mock(),
			networkType: .MOBILE,
			outputDevice: nil,
			sessionType: .PLAYBACK,
			playerItemMonitor: monitor,
			playerEventSender: playerEventSender,
			timestamp: timestamp,
			isPreload: false
		)

		// Have both metadata and asset set up
		let loudnessNormalizationConfiguration = LoudnessNormalizationConfiguration.mock()
		let asset = AssetMock(with: player, loudnessNormalizationConfiguration: loudnessNormalizationConfiguration)
		playerItem.set(asset)

		let metadata = Metadata.mock()
		playerItem.set(metadata)

		// WHEN
		playerItem.unload()

		// THEN
		XCTAssertEqual(player.unloadedAssets as? [AssetMock], [asset])
		XCTAssertEqual(playerItem.metadata, nil)
		XCTAssertEqual(playerItem.asset, nil)
	}

	func test_unload() async throws {
		// GIVEN
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		let playerItem = PlayerItem.mock(
			startReason: .EXPLICIT,
			mediaProduct: .mock(),
			networkType: .MOBILE,
			outputDevice: nil,
			sessionType: .PLAYBACK,
			playerItemMonitor: monitor,
			playerEventSender: playerEventSender,
			timestamp: timestamp,
			isPreload: false
		)

		// Have both metadata and asset set up
		let loudnessNormalizationConfiguration = LoudnessNormalizationConfiguration.mock()
		let asset = AssetMock(with: player, loudnessNormalizationConfiguration: loudnessNormalizationConfiguration)
		playerItem.set(asset)

		let metadata = Metadata.mock()
		playerItem.set(metadata)

		// WHEN
		playerItem.unload()

		// THEN
		XCTAssertEqual(player.unloadedAssets as? [AssetMock], [asset])
		XCTAssertEqual(playerItem.metadata, nil)
		XCTAssertEqual(playerItem.asset, nil)
	}

	// MARK: - unloadFromPlayer

	func test_unloadFromPlayer_legacy() async throws {
		// GIVEN
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		let playerItem = PlayerItem.mock(
			startReason: .EXPLICIT,
			mediaProduct: .mock(),
			networkType: .MOBILE,
			outputDevice: nil,
			sessionType: .PLAYBACK,
			playerItemMonitor: monitor,
			playerEventSender: playerEventSender,
			timestamp: timestamp,
			isPreload: false
		)

		// Have both metadata and asset set up
		let loudnessNormalizationConfiguration = LoudnessNormalizationConfiguration.mock()
		let asset = AssetMock(with: player, loudnessNormalizationConfiguration: loudnessNormalizationConfiguration)
		playerItem.set(asset)

		let metadata = Metadata.mock()
		playerItem.set(metadata)

		// WHEN
		playerItem.unloadFromPlayer()

		// THEN
		XCTAssertEqual(player.unloadedAssets as? [AssetMock], [asset])

		// As opposed to unload(), we don't nullify metadata not asset
		XCTAssertEqual(playerItem.metadata, metadata)
		XCTAssertEqual(playerItem.asset, asset)
	}

	func test_unloadFromPlayer() async throws {
		// GIVEN
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		let playerItem = PlayerItem.mock(
			startReason: .EXPLICIT,
			mediaProduct: .mock(),
			networkType: .MOBILE,
			outputDevice: nil,
			sessionType: .PLAYBACK,
			playerItemMonitor: monitor,
			playerEventSender: playerEventSender,
			timestamp: timestamp,
			isPreload: false
		)

		// Have both metadata and asset set up
		let loudnessNormalizationConfiguration = LoudnessNormalizationConfiguration.mock()
		let asset = AssetMock(with: player, loudnessNormalizationConfiguration: loudnessNormalizationConfiguration)
		playerItem.set(asset)

		let metadata = Metadata.mock()
		playerItem.set(metadata)

		// WHEN
		playerItem.unloadFromPlayer()

		// THEN
		XCTAssertEqual(player.unloadedAssets as? [AssetMock], [asset])

		// As opposed to unload(), we don't nullify metadata not asset
		XCTAssertEqual(playerItem.metadata, metadata)
		XCTAssertEqual(playerItem.asset, asset)
	}

	// MARK: - play

	func test_play_legacy() {
		// GIVEN
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		let playerItem = PlayerItem.mock(
			startReason: .EXPLICIT,
			mediaProduct: .mock(),
			networkType: .MOBILE,
			outputDevice: nil,
			sessionType: .PLAYBACK,
			playerItemMonitor: monitor,
			playerEventSender: playerEventSender,
			timestamp: timestamp,
			isPreload: false
		)

		// Have both metadata and asset set up
		let loudnessNormalizationConfiguration = LoudnessNormalizationConfiguration.mock()
		let asset = AssetMock(with: player, loudnessNormalizationConfiguration: loudnessNormalizationConfiguration)
		playerItem.set(asset)

		let metadata = Metadata.mock()
		playerItem.set(metadata)

		// WHEN
		playerItem.play(timestamp: 2)

		// THEN
		XCTAssertEqual(player.playCallCount, 1)
	}

	func test_play() {
		// GIVEN
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		let playerItem = PlayerItem.mock(
			startReason: .EXPLICIT,
			mediaProduct: .mock(),
			networkType: .MOBILE,
			outputDevice: nil,
			sessionType: .PLAYBACK,
			playerItemMonitor: monitor,
			playerEventSender: playerEventSender,
			timestamp: timestamp,
			isPreload: false
		)

		// Have both metadata and asset set up
		let loudnessNormalizationConfiguration = LoudnessNormalizationConfiguration.mock()
		let asset = AssetMock(with: player, loudnessNormalizationConfiguration: loudnessNormalizationConfiguration)
		playerItem.set(asset)

		let metadata = Metadata.mock()
		playerItem.set(metadata)

		// WHEN
		playerItem.play(timestamp: 2)

		// THEN
		XCTAssertEqual(player.playCallCount, 1)
	}

	// MARK: - pause

	func test_pause_legacy() {
		// GIVEN
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		let playerItem = PlayerItem.mock(
			startReason: .EXPLICIT,
			mediaProduct: .mock(),
			networkType: .MOBILE,
			outputDevice: nil,
			sessionType: .PLAYBACK,
			playerItemMonitor: monitor,
			playerEventSender: playerEventSender,
			timestamp: timestamp,
			isPreload: false
		)

		// Have both metadata and asset set up
		let loudnessNormalizationConfiguration = LoudnessNormalizationConfiguration.mock()
		let asset = AssetMock(with: player, loudnessNormalizationConfiguration: loudnessNormalizationConfiguration)
		playerItem.set(asset)

		let metadata = Metadata.mock()
		playerItem.set(metadata)

		// WHEN
		playerItem.pause()

		// THEN
		XCTAssertEqual(player.pauseCallCount, 1)
	}

	func test_pause() {
		// GIVEN
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		let playerItem = PlayerItem.mock(
			startReason: .EXPLICIT,
			mediaProduct: .mock(),
			networkType: .MOBILE,
			outputDevice: nil,
			sessionType: .PLAYBACK,
			playerItemMonitor: monitor,
			playerEventSender: playerEventSender,
			timestamp: timestamp,
			isPreload: false
		)

		// Have both metadata and asset set up
		let loudnessNormalizationConfiguration = LoudnessNormalizationConfiguration.mock()
		let asset = AssetMock(with: player, loudnessNormalizationConfiguration: loudnessNormalizationConfiguration)
		playerItem.set(asset)

		let metadata = Metadata.mock()
		playerItem.set(metadata)

		// WHEN
		playerItem.pause()

		// THEN
		XCTAssertEqual(player.pauseCallCount, 1)
	}

	// MARK: - seek

	func test_seek_legacy() {
		// GIVEN
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		let playerItem = PlayerItem.mock(
			startReason: .EXPLICIT,
			mediaProduct: .mock(),
			networkType: .MOBILE,
			outputDevice: nil,
			sessionType: .PLAYBACK,
			playerItemMonitor: monitor,
			playerEventSender: playerEventSender,
			timestamp: timestamp,
			isPreload: false
		)

		// Have both metadata and asset set up
		let loudnessNormalizationConfiguration = LoudnessNormalizationConfiguration.mock()
		let asset = AssetMock(with: player, loudnessNormalizationConfiguration: loudnessNormalizationConfiguration)
		playerItem.set(asset)

		let metadata = Metadata.mock()
		playerItem.set(metadata)

		// WHEN
		playerItem.seek(to: 2)

		// THEN
		XCTAssertEqual(player.seekCallCount, 1)
	}

	func test_seek() {
		// GIVEN
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		let playerItem = PlayerItem.mock(
			startReason: .EXPLICIT,
			mediaProduct: .mock(),
			networkType: .MOBILE,
			outputDevice: nil,
			sessionType: .PLAYBACK,
			playerItemMonitor: monitor,
			playerEventSender: playerEventSender,
			timestamp: timestamp,
			isPreload: false
		)

		// Have both metadata and asset set up
		let loudnessNormalizationConfiguration = LoudnessNormalizationConfiguration.mock()
		let asset = AssetMock(with: player, loudnessNormalizationConfiguration: loudnessNormalizationConfiguration)
		playerItem.set(asset)

		let metadata = Metadata.mock()
		playerItem.set(metadata)

		// WHEN
		playerItem.seek(to: 2)

		// THEN
		XCTAssertEqual(player.seekCallCount, 1)
	}
}
