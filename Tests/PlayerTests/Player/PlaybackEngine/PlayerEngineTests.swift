import Auth
@testable import Player

// swiftlint:disable file_length
import XCTest

// MARK: - Constants

private enum Constants {
	static let initialTime: UInt64 = 1

	static let trackPlaybackInfo1 = TrackPlaybackInfo.mock(trackId: 1)
	static let mediaProduct1 = MediaProduct.mock(productId: "1")

	static let trackPlaybackInfo2 = TrackPlaybackInfo.mock(trackId: 2)
	static let mediaProduct2 = MediaProduct.mock(productId: "2")
}

// MARK: - PlayerEngineTests

final class PlayerEngineTests: XCTestCase {
	private var operationQueue: OperationQueueMock!
	private var urlSession: URLSession!
	private var httpClient: HttpClient!
	private var playerEventSender: PlayerEventSenderMock!
	private var listener: PlayerListenerMock!
	private var listenerQueue: DispatchQueue!
	private var notificationsHandler: NotificationsHandler!
	private var credentialsProvider: CredentialsProviderMock!
	private var featureFlagProvider: FeatureFlagProvider!
	private var storage: Storage!
	private var djProducer: DJProducer!
	private var fairplayLicenseFetcher: FairPlayLicenseFetcher!
	private var networkMonitor: NetworkMonitorMock!
	private var playbackInfoFetcher: PlaybackInfoFetcher!
	private var configuration: Configuration!

	private var playerEngine: PlayerEngine!
	private var timestamp: UInt64 = Constants.initialTime

	private var genericPlayer: PlayerMock!
	private var playerLoader: PlayerLoaderMock!

	/// Convenience asset which can be used in different tests
	private var asset: Asset {
		let loudnessNormalizationConfiguration = LoudnessNormalizationConfiguration.mock(loudnessNormalizationMode: .ALBUM)
		return Asset(with: genericPlayer, loudnessNormalizationConfiguration: loudnessNormalizationConfiguration)
	}

	override func setUp() {
		let timeProvider = TimeProvider.mock(
			timestamp: {
				self.timestamp
			}
		)
		PlayerWorld = PlayerWorldClient.mock(timeProvider: timeProvider)

		let operationQueue = OperationQueueMock()

		let sessionConfiguration = URLSessionConfiguration.default
		sessionConfiguration.protocolClasses = [JsonEncodedResponseURLProtocol.self]
		urlSession = URLSession(configuration: sessionConfiguration)

		httpClient = HttpClient(
			using: urlSession,
			responseErrorManager: ResponseErrorManager(backoffPolicy: BackoffPolicyMock()),
			networkErrorManager: NetworkErrorManager(backoffPolicy: BackoffPolicyMock()),
			timeoutErrorManager: TimeoutErrorManager(backoffPolicy: BackoffPolicyMock())
		)

		playerEventSender = PlayerEventSenderMock()
		listener = PlayerListenerMock()
		listenerQueue = DispatchQueue(label: "com.tidal.queue.for.testing")
		notificationsHandler = NotificationsHandler(listener: listener, queue: listenerQueue)
		credentialsProvider = CredentialsProviderMock()
		featureFlagProvider = FeatureFlagProvider.mock

		djProducer = DJProducer(
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			featureFlagProvider: featureFlagProvider
		)
		fairplayLicenseFetcher = FairPlayLicenseFetcher(
			with: HttpClient(using: urlSession),
			credentialsProvider: credentialsProvider,
			and: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)
		networkMonitor = NetworkMonitorMock()

		playbackInfoFetcher = PlaybackInfoFetcher(
			with: Configuration.mock(),
			httpClient,
			credentialsProvider,
			networkMonitor,
			and: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)
		configuration = Configuration.mock()

		playerLoader = PlayerLoaderMock()

		playerEngine = PlayerEngine.mock(
			queue: operationQueue,
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			fairplayLicenseFetcher: fairplayLicenseFetcher,
			djProducer: djProducer,
			configuration: configuration,
			playerEventSender: playerEventSender,
			networkMonitor: networkMonitor,
			playerLoader: playerLoader,
			notificationsHandler: notificationsHandler
		)

		credentialsProvider.injectSuccessfulUserLevelCredentials()

		genericPlayer = PlayerMock()
		playerLoader.player = genericPlayer
	}

	override func tearDown() {
		JsonEncodedResponseURLProtocol.reset()
	}
}

extension PlayerEngineTests {
	// MARK: - load

	func test_load() {
		// GIVEN
		let trackPlaybackInfo = Constants.trackPlaybackInfo1
		JsonEncodedResponseURLProtocol.succeed(with: trackPlaybackInfo)

		let mediaProduct = Constants.mediaProduct1

		// WHEN
		playerEngine.load(mediaProduct, timestamp: 1, isPreload: false)

		// THEN
		let expectedPlayerItem = playerItem(
			mediaProduct: mediaProduct,
			trackPlaybackInfo: trackPlaybackInfo,
			shouldSetMetadataAndAsset: true
		)

		assertItem(item: playerEngine.currentItem, expectedItem: expectedPlayerItem, shouldBeLoaded: true)
		assertItem(item: playerEngine.nextItem, expectedItem: nil, shouldBeLoaded: nil)
		XCTAssertEqual(playerEngine.getState(), .NOT_PLAYING)

		assertGenericPlayer(assets: [asset], playCount: 0, pauseCount: 0)
		assertPlayerLoader(trackPlaybackInfos: [trackPlaybackInfo])
	}

	func test_load_alreadyLoadedItem() {
		// GIVEN
		let trackPlaybackInfo = Constants.trackPlaybackInfo1
		JsonEncodedResponseURLProtocol.succeed(with: trackPlaybackInfo)

		let mediaProduct = Constants.mediaProduct1

		// WHEN
		playerEngine.load(mediaProduct, timestamp: 1, isPreload: false)

		// THEN
		let expectedPlayerItem = playerItem(
			mediaProduct: mediaProduct,
			trackPlaybackInfo: trackPlaybackInfo,
			shouldSetMetadataAndAsset: true
		)

		assertItem(item: playerEngine.currentItem, expectedItem: expectedPlayerItem, shouldBeLoaded: true)
		assertItem(item: playerEngine.nextItem, expectedItem: nil, shouldBeLoaded: nil)
		XCTAssertEqual(playerEngine.getState(), .NOT_PLAYING)

		assertGenericPlayer(assets: [asset], playCount: 0, pauseCount: 0)
		assertPlayerLoader(trackPlaybackInfos: [trackPlaybackInfo])
	}

	func test_load_and_pause() {
		// GIVEN
		let trackPlaybackInfo = Constants.trackPlaybackInfo1
		JsonEncodedResponseURLProtocol.succeed(with: trackPlaybackInfo)

		let mediaProduct = Constants.mediaProduct1

		// WHEN
		playerEngine.load(mediaProduct, timestamp: 1, isPreload: false)
		playerEngine.pause()

		// THEN
		let expectedPlayerItem = playerItem(
			mediaProduct: mediaProduct,
			trackPlaybackInfo: trackPlaybackInfo,
			shouldSetMetadataAndAsset: true
		)

		assertItem(item: playerEngine.currentItem, expectedItem: expectedPlayerItem, shouldBeLoaded: true)
		assertItem(item: playerEngine.nextItem, expectedItem: nil, shouldBeLoaded: nil)

		XCTAssertEqual(playerEngine.getState(), .NOT_PLAYING)

		assertGenericPlayer(assets: [asset], playCount: 0, pauseCount: 1)
		assertPlayerLoader(trackPlaybackInfos: [trackPlaybackInfo])
	}

	// MARK: - setNext

	func test_setNext() {
		// GIVEN
		let trackPlaybackInfo1 = Constants.trackPlaybackInfo1
		JsonEncodedResponseURLProtocol.succeed(with: trackPlaybackInfo1)

		let mediaProduct1 = Constants.mediaProduct1
		playerEngine.load(mediaProduct1, timestamp: 1, isPreload: false)

		let trackPlaybackInfo2 = Constants.trackPlaybackInfo2
		JsonEncodedResponseURLProtocol.succeed(with: trackPlaybackInfo2)

		let mediaProduct2 = Constants.mediaProduct2

		// WHEN
		playerEngine.setNext(mediaProduct2, timestamp: 5)

		// THEN
		let expectedPlayerItem1 = playerItem(
			mediaProduct: mediaProduct1,
			trackPlaybackInfo: trackPlaybackInfo1,
			shouldSetMetadataAndAsset: true
		)
		assertItem(item: playerEngine.currentItem, expectedItem: expectedPlayerItem1, shouldBeLoaded: true)

		let expectedPlayerItem2 = playerItem(
			mediaProduct: mediaProduct2,
			trackPlaybackInfo: trackPlaybackInfo2,
			shouldSetMetadataAndAsset: false
		)
		assertItem(item: playerEngine.nextItem, expectedItem: expectedPlayerItem2, shouldBeLoaded: false)

		XCTAssertEqual(playerEngine.getState(), .NOT_PLAYING)

		assertGenericPlayer(assets: [asset], playCount: 0, pauseCount: 0)
		assertPlayerLoader(trackPlaybackInfos: [trackPlaybackInfo1])
	}

	func test_setNext_whenIdle() {
		// GIVEN
		let mediaProduct1 = Constants.mediaProduct1

		// WHEN
		playerEngine.setNext(mediaProduct1, timestamp: 1)

		// THEN
		XCTAssertEqual(playerEngine.currentItem, nil)
		XCTAssertEqual(playerEngine.nextItem, nil)

		XCTAssertEqual(playerEngine.getState(), .IDLE)

		assertGenericPlayer(assets: [], playCount: 0, pauseCount: 0)
		assertPlayerLoader(trackPlaybackInfos: [])
	}

	func test_setNext_and_play() {
		// GIVEN
		let trackPlaybackInfo1 = Constants.trackPlaybackInfo1
		JsonEncodedResponseURLProtocol.succeed(with: trackPlaybackInfo1)

		let mediaProduct1 = Constants.mediaProduct1
		playerEngine.load(mediaProduct1, timestamp: 1, isPreload: false)

		let trackPlaybackInfo2 = Constants.trackPlaybackInfo2
		JsonEncodedResponseURLProtocol.succeed(with: trackPlaybackInfo2)

		let mediaProduct2 = Constants.mediaProduct2

		// WHEN
		playerEngine.setNext(mediaProduct2, timestamp: 5)

		// THEN
		XCTAssertEqual(playerEngine.getState(), .NOT_PLAYING)

		// Play it
		playerEngine.play(timestamp: 1)
		genericPlayer.playing()

		let expectedPlayerItem1 = playerItem(
			mediaProduct: mediaProduct1,
			trackPlaybackInfo: trackPlaybackInfo1,
			shouldSetMetadataAndAsset: true
		)
		assertItem(item: playerEngine.currentItem, expectedItem: expectedPlayerItem1, shouldBeLoaded: true)

		let expectedPlayerItem2 = playerItem(
			mediaProduct: mediaProduct2,
			trackPlaybackInfo: trackPlaybackInfo2,
			shouldSetMetadataAndAsset: false
		)
		assertItem(item: playerEngine.nextItem, expectedItem: expectedPlayerItem2, shouldBeLoaded: false)

		XCTAssertEqual(playerEngine.getState(), .PLAYING)

		assertGenericPlayer(assets: [asset], playCount: 1, pauseCount: 0)
		assertPlayerLoader(trackPlaybackInfos: [trackPlaybackInfo1])
	}

	// MARK: - skipToNext

	func test_skipToNext_when_nextWasSetUpAndNotLoaded() {
		// GIVEN
		// First, we perform the exact same changes as above.
		let trackPlaybackInfo1 = Constants.trackPlaybackInfo1
		JsonEncodedResponseURLProtocol.succeed(with: trackPlaybackInfo1)

		let mediaProduct1 = Constants.mediaProduct1
		playerEngine.load(mediaProduct1, timestamp: 1, isPreload: false)

		XCTAssertEqual(playerEngine.getState(), .NOT_PLAYING)

		// Play it
		playerEngine.play(timestamp: 1)
		genericPlayer.playing()

		XCTAssertEqual(playerEngine.getState(), .PLAYING)

		let trackPlaybackInfo2 = Constants.trackPlaybackInfo2
		JsonEncodedResponseURLProtocol.succeed(with: trackPlaybackInfo2)

		let mediaProduct2 = Constants.mediaProduct2
		playerEngine.setNext(mediaProduct2, timestamp: 5)

		let expectedPlayerItem1 = playerItem(
			mediaProduct: mediaProduct1,
			trackPlaybackInfo: trackPlaybackInfo1,
			shouldSetMetadataAndAsset: true
		)
		assertItem(item: playerEngine.currentItem, expectedItem: expectedPlayerItem1, shouldBeLoaded: true)

		let expectedPlayerItem2 = playerItem(
			mediaProduct: mediaProduct2,
			trackPlaybackInfo: trackPlaybackInfo2,
			shouldSetMetadataAndAsset: false
		)
		assertItem(item: playerEngine.nextItem, expectedItem: expectedPlayerItem2, shouldBeLoaded: false)

		// Finish loading of the currentItem
		genericPlayer.loaded()
		genericPlayer.playing()

		// WHEN
		// skipToNext() should unload the current one, set the previously next as current, and nextItem should become nil.
		playerEngine.skipToNext(timestamp: timestamp)

		// THEN
		let expectedPlayerItem2AfterLoaded = playerItem(
			mediaProduct: mediaProduct2,
			trackPlaybackInfo: trackPlaybackInfo2,
			shouldSetMetadataAndAsset: true
		)
		assertItem(item: playerEngine.currentItem, expectedItem: expectedPlayerItem2AfterLoaded, shouldBeLoaded: true)
		assertItem(item: playerEngine.nextItem, expectedItem: nil, shouldBeLoaded: nil)

		// Since nextItem is still not loaded, make sure it has changed from playing to stalled
		XCTAssertEqual(playerEngine.getState(), .STALLED)

		// One from play called above, one from loaded (play after load) and then from skipToNext
		assertGenericPlayer(assets: [asset], playCount: 3, pauseCount: 0)
		assertPlayerLoader(trackPlaybackInfos: [trackPlaybackInfo1, trackPlaybackInfo2])
	}

	func test_skipToNext_when_nextWasSetUpAndLoaded_and_shouldSwitchStateOnSkipToNextIsFalse() {
		// GIVEN
		// First, we perform the exact same changes as above.
		let trackPlaybackInfo1 = Constants.trackPlaybackInfo1
		JsonEncodedResponseURLProtocol.succeed(with: trackPlaybackInfo1)

		let mediaProduct1 = Constants.mediaProduct1
		playerEngine.load(mediaProduct1, timestamp: 1, isPreload: false)

		XCTAssertEqual(playerEngine.getState(), .NOT_PLAYING)

		// Play it
		playerEngine.play(timestamp: 1)
		genericPlayer.playing()

		let trackPlaybackInfo2 = Constants.trackPlaybackInfo2
		JsonEncodedResponseURLProtocol.succeed(with: trackPlaybackInfo2)

		let mediaProduct2 = Constants.mediaProduct2
		playerEngine.setNext(mediaProduct2, timestamp: 5)

		// Finish loading of the currentItem
		genericPlayer.loaded()

		XCTAssertEqual(playerEngine.getState(), .PLAYING)

		let expectedPlayerItem1 = playerItem(
			mediaProduct: mediaProduct1,
			trackPlaybackInfo: trackPlaybackInfo1,
			shouldSetMetadataAndAsset: true
		)
		assertItem(item: playerEngine.currentItem, expectedItem: expectedPlayerItem1, shouldBeLoaded: true)

		let expectedPlayerItem2 = playerItem(
			mediaProduct: mediaProduct2,
			trackPlaybackInfo: trackPlaybackInfo2,
			shouldSetMetadataAndAsset: false
		)
		assertItem(item: playerEngine.nextItem, expectedItem: expectedPlayerItem2, shouldBeLoaded: false)

		// currentItem has finished download, so it calls load of nextItem
		genericPlayer.downloaded()

		let expectedPlayerItem2AfterLoaded = playerItem(
			mediaProduct: mediaProduct2,
			trackPlaybackInfo: trackPlaybackInfo2,
			shouldSetMetadataAndAsset: true
		)
		assertItem(item: playerEngine.nextItem, expectedItem: expectedPlayerItem2AfterLoaded, shouldBeLoaded: true)

		// Make sure it's still playing
		XCTAssertEqual(playerEngine.getState(), .PLAYING)

		// WHEN
		// skipToNext() should unload the current one, set the previously next as current, and nextItem should become nil.
		playerEngine.skipToNext(timestamp: timestamp)

		// THEN
		assertItem(item: playerEngine.currentItem, expectedItem: expectedPlayerItem2AfterLoaded, shouldBeLoaded: true)
		assertItem(item: playerEngine.nextItem, expectedItem: nil, shouldBeLoaded: nil)

		// Make sure it's still playing after skipping to next item
		XCTAssertEqual(playerEngine.getState(), .PLAYING)

		// One from play called above, one from loaded (play after load) and then from skipToNext
		assertGenericPlayer(assets: [asset], playCount: 3, pauseCount: 0)
		assertPlayerLoader(trackPlaybackInfos: [trackPlaybackInfo1, trackPlaybackInfo2])
	}

	func test_skipToNext_when_nextWasSetUpAndLoaded_and_fails() {
		// GIVEN
		// First, we perform the exact same changes as above.
		let trackPlaybackInfo1 = Constants.trackPlaybackInfo1
		JsonEncodedResponseURLProtocol.succeed(with: trackPlaybackInfo1)

		let mediaProduct1 = Constants.mediaProduct1
		playerEngine.load(mediaProduct1, timestamp: 1, isPreload: false)

		XCTAssertEqual(playerEngine.getState(), .NOT_PLAYING)

		// Play it
		playerEngine.play(timestamp: 1)
		genericPlayer.playing()

		let trackPlaybackInfo2 = Constants.trackPlaybackInfo2
		JsonEncodedResponseURLProtocol.succeed(with: trackPlaybackInfo2)

		let mediaProduct2 = Constants.mediaProduct2
		playerEngine.setNext(mediaProduct2, timestamp: 5)

		// Finish loading of the currentItem
		genericPlayer.loaded()
		genericPlayer.playing()

		XCTAssertEqual(playerEngine.getState(), .PLAYING)

		let expectedPlayerItem1 = playerItem(
			mediaProduct: mediaProduct1,
			trackPlaybackInfo: trackPlaybackInfo1,
			shouldSetMetadataAndAsset: true
		)
		assertItem(item: playerEngine.currentItem, expectedItem: expectedPlayerItem1, shouldBeLoaded: true)

		let expectedPlayerItem2 = playerItem(
			mediaProduct: mediaProduct2,
			trackPlaybackInfo: trackPlaybackInfo2,
			shouldSetMetadataAndAsset: false
		)
		assertItem(item: playerEngine.nextItem, expectedItem: expectedPlayerItem2, shouldBeLoaded: false)

		// currentItem has finished download, so it calls load of nextItem
		genericPlayer.downloaded()
		let error = HttpError.httpServerError(statusCode: 1)
		genericPlayer.failed(with: error)

		// Listener is called with error
		XCTAssertEqual(listener.numErrors, 1)

		// The failure resets the player engine to not playing and nullifies everything
		XCTAssertEqual(playerEngine.getState(), .NOT_PLAYING)
		XCTAssertEqual(playerEngine.currentItem, nil)
		XCTAssertEqual(playerEngine.nextItem, nil)

		// WHEN
		// skipToNext() ends up resetting to idle since there's no current item
		playerEngine.skipToNext(timestamp: timestamp)

		// THEN
		// Make sure it's idle, and items remain nil
		XCTAssertEqual(playerEngine.getState(), .IDLE)
		XCTAssertEqual(playerEngine.currentItem, nil)
		XCTAssertEqual(playerEngine.nextItem, nil)

		// One from play called above and one from loaded (play after load). It doesn't call a third time because of the failure.
		assertGenericPlayer(assets: [], playCount: 2, pauseCount: 0)
		assertPlayerLoader(trackPlaybackInfos: [trackPlaybackInfo1, trackPlaybackInfo2])
	}

	func test_skipToNext_when_nextWasSetUpAndLoaded_and_shouldSwitchStateOnSkipToNextIsTrue() {
		// GIVEN
		// First, we perform the exact same changes as above.
		let trackPlaybackInfo1 = Constants.trackPlaybackInfo1
		JsonEncodedResponseURLProtocol.succeed(with: trackPlaybackInfo1)

		let mediaProduct1 = Constants.mediaProduct1
		playerEngine.load(mediaProduct1, timestamp: 1, isPreload: false)

		XCTAssertEqual(playerEngine.getState(), .NOT_PLAYING)

		// Set shouldSwitchStateOnSkipToNext to true since the default is false.
		genericPlayer.shouldSwitchStateOnSkipToNextFlag = true

		// Play it
		playerEngine.play(timestamp: 1)
		genericPlayer.playing()

		let trackPlaybackInfo2 = Constants.trackPlaybackInfo2
		JsonEncodedResponseURLProtocol.succeed(with: trackPlaybackInfo2)

		let mediaProduct2 = Constants.mediaProduct2
		playerEngine.setNext(mediaProduct2, timestamp: 5)

		// Finish loading of the currentItem
		genericPlayer.loaded()
		genericPlayer.playing()

		XCTAssertEqual(playerEngine.getState(), .PLAYING)

		let expectedPlayerItem1 = playerItem(
			mediaProduct: mediaProduct1,
			trackPlaybackInfo: trackPlaybackInfo1,
			shouldSetMetadataAndAsset: true
		)
		assertItem(item: playerEngine.currentItem, expectedItem: expectedPlayerItem1, shouldBeLoaded: true)

		let expectedPlayerItem2 = playerItem(
			mediaProduct: mediaProduct2,
			trackPlaybackInfo: trackPlaybackInfo2,
			shouldSetMetadataAndAsset: false
		)
		assertItem(item: playerEngine.nextItem, expectedItem: expectedPlayerItem2, shouldBeLoaded: false)

		// currentItem has finished download, so it calls load of nextItem
		genericPlayer.downloaded()

		let expectedPlayerItem2AfterLoaded = playerItem(
			mediaProduct: mediaProduct2,
			trackPlaybackInfo: trackPlaybackInfo2,
			shouldSetMetadataAndAsset: true
		)
		assertItem(item: playerEngine.nextItem, expectedItem: expectedPlayerItem2AfterLoaded, shouldBeLoaded: true)

		// Make sure it's still playing
		XCTAssertEqual(playerEngine.getState(), .PLAYING)

		// WHEN
		// skipToNext() should unload the current one, set the previously next as current, and nextItem should become nil.
		playerEngine.skipToNext(timestamp: timestamp)

		// THEN
		assertItem(item: playerEngine.currentItem, expectedItem: expectedPlayerItem2AfterLoaded, shouldBeLoaded: true)
		assertItem(item: playerEngine.nextItem, expectedItem: nil, shouldBeLoaded: nil)

		// Make sure it's stalled and not playing due to flag shouldSwitchStateOnSkipToNext being true.
		// The player engine should take care of moving to playing when ready.
		XCTAssertEqual(playerEngine.getState(), .STALLED)

		// One from play called above, one from loaded (play after load) and then from skipToNext
		assertGenericPlayer(assets: [asset], playCount: 3, pauseCount: 0)
		assertPlayerLoader(trackPlaybackInfos: [trackPlaybackInfo1, trackPlaybackInfo2])
	}

	func test_skipToNext_when_nextItemWasNotSetUp() {
		// GIVEN
		// First, we perform the exact same changes as above.
		let trackPlaybackInfo1 = Constants.trackPlaybackInfo1
		JsonEncodedResponseURLProtocol.succeed(with: trackPlaybackInfo1)

		let mediaProduct1 = Constants.mediaProduct1
		playerEngine.load(mediaProduct1, timestamp: 1, isPreload: false)

		XCTAssertEqual(playerEngine.getState(), .NOT_PLAYING)

		// Play it
		playerEngine.play(timestamp: 1)
		genericPlayer.playing()

		let trackPlaybackInfo2 = Constants.trackPlaybackInfo2
		JsonEncodedResponseURLProtocol.succeed(with: trackPlaybackInfo2)

		// Finish loading of the currentItem
		genericPlayer.loaded()
		genericPlayer.playing()

		XCTAssertEqual(playerEngine.getState(), .PLAYING)

		let expectedPlayerItem1 = playerItem(
			mediaProduct: mediaProduct1,
			trackPlaybackInfo: trackPlaybackInfo1,
			shouldSetMetadataAndAsset: true
		)
		assertItem(item: playerEngine.currentItem, expectedItem: expectedPlayerItem1, shouldBeLoaded: true)
		assertItem(item: playerEngine.nextItem, expectedItem: nil, shouldBeLoaded: nil)

		// Make sure it's still playing
		XCTAssertEqual(playerEngine.getState(), .PLAYING)

		// One from play called above and one from loaded (play after load).
		assertGenericPlayer(assets: [asset], playCount: 2, pauseCount: 0)

		// WHEN
		// skipToNext() should unload the current one, set the previously next as current, and nextItem should become nil.
		playerEngine.skipToNext(timestamp: timestamp)

		// Since setNext was not called, meaning there's no nextItem set up, then both currentItem and nextItem are nil, reset is
		// called, and set to IDLE state.
		assertItem(item: playerEngine.currentItem, expectedItem: nil, shouldBeLoaded: nil)
		assertItem(item: playerEngine.nextItem, expectedItem: nil, shouldBeLoaded: nil)
		XCTAssertEqual(playerEngine.getState(), .IDLE)

		// Same as above
		assertGenericPlayer(assets: [], playCount: 2, pauseCount: 0)
		assertPlayerLoader(trackPlaybackInfos: [trackPlaybackInfo1])
	}

	// MARK: - updateLoudnessNormalizationMode()

	func test_updateLoudnessNormalizationMode() {
		// GIVEN
		// First, load 2 items, so we have a currentItem and nextItem to be updated.
		let trackPlaybackInfo1 = Constants.trackPlaybackInfo1
		JsonEncodedResponseURLProtocol.succeed(with: trackPlaybackInfo1)

		let mediaProduct1 = Constants.mediaProduct1
		playerEngine.load(mediaProduct1, timestamp: 1, isPreload: false)

		XCTAssertEqual(playerEngine.getState(), .NOT_PLAYING)

		// Play it
		playerEngine.play(timestamp: 1)

		let trackPlaybackInfo2 = Constants.trackPlaybackInfo2
		JsonEncodedResponseURLProtocol.succeed(with: trackPlaybackInfo2)

		let mediaProduct2 = Constants.mediaProduct2
		playerEngine.setNext(mediaProduct2, timestamp: 5)

		// Finish loading of the currentItem
		genericPlayer.loaded()
		genericPlayer.playing()

		XCTAssertEqual(playerEngine.getState(), .PLAYING)

		let expectedPlayerItem1 = playerItem(
			mediaProduct: mediaProduct1,
			trackPlaybackInfo: trackPlaybackInfo1,
			shouldSetMetadataAndAsset: true
		)
		assertItem(item: playerEngine.currentItem, expectedItem: expectedPlayerItem1, shouldBeLoaded: true)

		XCTAssertEqual(playerEngine.currentItem, expectedPlayerItem1)
		XCTAssertEqual(playerEngine.currentItem?.isLoaded, true)

		let expectedPlayerItem2 = playerItem(
			mediaProduct: mediaProduct2,
			trackPlaybackInfo: trackPlaybackInfo2,
			shouldSetMetadataAndAsset: false
		)
		assertItem(item: playerEngine.nextItem, expectedItem: expectedPlayerItem2, shouldBeLoaded: false)

		// currentItem has finished download, so it calls load of nextItem
		genericPlayer.downloaded()

		let expectedPlayerItem2AfterLoaded = playerItem(
			mediaProduct: mediaProduct2,
			trackPlaybackInfo: trackPlaybackInfo2,
			shouldSetMetadataAndAsset: true
		)
		assertItem(item: playerEngine.nextItem, expectedItem: expectedPlayerItem2AfterLoaded, shouldBeLoaded: true)

		let currentItemAsset = genericPlayer.assets[0] as? AssetMock
		let nextItemAsset = genericPlayer.assets[1] as? AssetMock

		XCTAssertEqual(genericPlayer.assets, [currentItemAsset, nextItemAsset])

		// WHEN
		let preAmp = configuration.currentPreAmpValue
		let newMode = LoudnessNormalizationMode.NONE
		playerEngine.updateLoudnessNormalizationMode(newMode)

		// THEN
		XCTAssertEqual(currentItemAsset?.loudnessNormalizationModes, [.NONE])
		XCTAssertEqual(currentItemAsset?.preAmpValues, [preAmp])
		XCTAssertEqual(currentItemAsset?.updateVolumeCallCount, 1)

		XCTAssertEqual(nextItemAsset?.loudnessNormalizationModes, [.NONE])
		XCTAssertEqual(nextItemAsset?.preAmpValues, [preAmp])
		XCTAssertEqual(nextItemAsset?.updateVolumeCallCount, 0)
	}

	func test_configuration_didSet_calls_updateLoudnessNormalizationMode() {
		// GIVEN
		// First, load 2 items, so we have a currentItem and nextItem to be updated.
		let trackPlaybackInfo1 = Constants.trackPlaybackInfo1
		JsonEncodedResponseURLProtocol.succeed(with: trackPlaybackInfo1)

		let mediaProduct1 = Constants.mediaProduct1
		playerEngine.load(mediaProduct1, timestamp: 1, isPreload: false)

		XCTAssertEqual(playerEngine.getState(), .NOT_PLAYING)

		// Play it
		playerEngine.play(timestamp: 1)

		let trackPlaybackInfo2 = Constants.trackPlaybackInfo2
		JsonEncodedResponseURLProtocol.succeed(with: trackPlaybackInfo2)

		let mediaProduct2 = Constants.mediaProduct2
		playerEngine.setNext(mediaProduct2, timestamp: 5)

		// Finish loading of the currentItem
		genericPlayer.loaded()
		genericPlayer.playing()

		XCTAssertEqual(playerEngine.getState(), .PLAYING)

		let expectedPlayerItem1 = playerItem(
			mediaProduct: mediaProduct1,
			trackPlaybackInfo: trackPlaybackInfo1,
			shouldSetMetadataAndAsset: true
		)
		assertItem(item: playerEngine.currentItem, expectedItem: expectedPlayerItem1, shouldBeLoaded: true)

		XCTAssertEqual(playerEngine.currentItem, expectedPlayerItem1)
		XCTAssertEqual(playerEngine.currentItem?.isLoaded, true)

		let expectedPlayerItem2 = playerItem(
			mediaProduct: mediaProduct2,
			trackPlaybackInfo: trackPlaybackInfo2,
			shouldSetMetadataAndAsset: false
		)
		assertItem(item: playerEngine.nextItem, expectedItem: expectedPlayerItem2, shouldBeLoaded: false)

		// currentItem has finished download, so it calls load of nextItem
		genericPlayer.downloaded()

		let expectedPlayerItem2AfterLoaded = playerItem(
			mediaProduct: mediaProduct2,
			trackPlaybackInfo: trackPlaybackInfo2,
			shouldSetMetadataAndAsset: true
		)
		assertItem(item: playerEngine.nextItem, expectedItem: expectedPlayerItem2AfterLoaded, shouldBeLoaded: true)

		let currentItemAsset = genericPlayer.assets[0] as? AssetMock
		let nextItemAsset = genericPlayer.assets[1] as? AssetMock

		XCTAssertEqual(genericPlayer.assets, [currentItemAsset, nextItemAsset])

		// WHEN
		let preAmpValue: Float = 0.5
		configuration.loudnessNormalizationPreAmp = preAmpValue
		playerEngine.updateConfiguration(configuration)

		// THEN
		XCTAssertEqual(currentItemAsset?.loudnessNormalizationModes, [.ALBUM])
		XCTAssertEqual(currentItemAsset?.preAmpValues, [preAmpValue])
		XCTAssertEqual(currentItemAsset?.updateVolumeCallCount, 1)

		XCTAssertEqual(nextItemAsset?.loudnessNormalizationModes, [.ALBUM])
		XCTAssertEqual(nextItemAsset?.preAmpValues, [preAmpValue])
		XCTAssertEqual(nextItemAsset?.updateVolumeCallCount, 0)
	}

	// MARK: - reset

	func test_reset() {
		// GIVEN
		let trackPlaybackInfo1 = Constants.trackPlaybackInfo1
		JsonEncodedResponseURLProtocol.succeed(with: trackPlaybackInfo1)

		let mediaProduct1 = Constants.mediaProduct1
		playerEngine.load(mediaProduct1, timestamp: 1, isPreload: false)

		XCTAssertEqual(playerEngine.getState(), .NOT_PLAYING)

		// Play it
		playerEngine.play(timestamp: 1)
		genericPlayer.playing()

		let expectedPlayerItem = playerItem(
			mediaProduct: mediaProduct1,
			trackPlaybackInfo: trackPlaybackInfo1,
			shouldSetMetadataAndAsset: true
		)
		assertItem(item: playerEngine.currentItem, expectedItem: expectedPlayerItem, shouldBeLoaded: true)
		assertItem(item: playerEngine.nextItem, expectedItem: nil, shouldBeLoaded: nil)

		XCTAssertEqual(playerEngine.getState(), .PLAYING)
		assertGenericPlayer(assets: [asset], playCount: 1, pauseCount: 0)
		assertPlayerLoader(trackPlaybackInfos: [trackPlaybackInfo1])

		// WHEN
		playerEngine.reset()

		// THEN
		// Play and pause call counts remain the same, state becomes IDLE, player loader calls reset and items are removed and
		// nullified.
		assertGenericPlayer(assets: [], playCount: 1, pauseCount: 0)
		XCTAssertEqual(playerEngine.getState(), .IDLE)
		XCTAssertEqual(playerLoader.resetCallCount, 1)
		XCTAssertEqual(playerEngine.currentItem, nil)
		XCTAssertEqual(playerEngine.nextItem, nil)
	}
}

// MARK: - Assertion helpers

extension PlayerEngineTests {
	func assertGenericPlayer(assets: [Asset], playCount: Int, pauseCount: Int) {
		XCTAssertEqual(genericPlayer.assetPosition, 0)
		XCTAssertEqual(genericPlayer.assets, assets)
		XCTAssertEqual(genericPlayer.pauseCallCount, pauseCount)
		XCTAssertEqual(genericPlayer.playCallCount, playCount)
		XCTAssertEqual(genericPlayer.seekCallCount, 0)
		XCTAssertEqual(genericPlayer.updateVolumeCallCount, 0)
	}

	/// - Attention: If item is nil, then ``shouldBeLoaded`` should be nil.
	func assertItem(item: PlayerItem?, expectedItem: PlayerItem?, shouldBeLoaded: Bool?) {
		XCTAssertEqual(item, expectedItem)

		if let shouldBeLoaded {
			XCTAssertEqual(item?.isLoaded, shouldBeLoaded)
		}
	}

	func assertPlayerLoader(trackPlaybackInfos: [TrackPlaybackInfo]) {
		let expectedPlaybackInfos = trackPlaybackInfos.map { self.playbackInfo(from: $0) }
		XCTAssertEqual(playerLoader.loadStoredMediaProducts, [])
		XCTAssertEqual(playerLoader.loadPlayableStorageItems, [])
		XCTAssertEqual(playerLoader.loadPlaybackInfos, expectedPlaybackInfos)
	}
}

// MARK: - Mock helpers

extension PlayerEngineTests {
	func playbackInfo(from trackPlaybackInfo: TrackPlaybackInfo) -> PlaybackInfo {
		let playbackInfo = PlaybackInfo(
			productType: .TRACK,
			productId: String(trackPlaybackInfo.trackId),
			streamType: .ON_DEMAND,
			assetPresentation: trackPlaybackInfo.assetPresentation,
			audioMode: trackPlaybackInfo.audioMode,
			audioQuality: trackPlaybackInfo.audioQuality,
			audioCodec: nil,
			audioSampleRate: trackPlaybackInfo.sampleRate,
			audioBitDepth: trackPlaybackInfo.bitDepth,
			videoQuality: nil,
			streamingSessionId: trackPlaybackInfo.streamingSessionId,
			contentHash: trackPlaybackInfo.manifestHash,
			mediaType: trackPlaybackInfo.manifestMimeType,
			url: URL(string: "https://www.tidal.com")!, // from the manifest
			licenseSecurityToken: trackPlaybackInfo.licenseSecurityToken,
			albumReplayGain: trackPlaybackInfo.albumReplayGain,
			albumPeakAmplitude: trackPlaybackInfo.albumPeakAmplitude,
			trackReplayGain: trackPlaybackInfo.trackReplayGain,
			trackPeakAmplitude: trackPlaybackInfo.trackPeakAmplitude,
			offlineRevalidateAt: trackPlaybackInfo.offlineRevalidateAt,
			offlineValidUntil: trackPlaybackInfo.offlineValidUntil
		)
		return playbackInfo
	}

	func playerItem(
		mediaProduct: MediaProduct,
		trackPlaybackInfo: TrackPlaybackInfo,
		shouldSetMetadataAndAsset: Bool
	) -> PlayerItem {
		let expectedPlayerItem = PlayerItem.mock(
			mediaProduct: mediaProduct,
			playerItemMonitor: playerEngine,
			playerEventSender: playerEventSender,
			timestamp: 2,
			featureFlagProvider: featureFlagProvider
		)

		if shouldSetMetadataAndAsset {
			let metadata = Metadata.mockFromTrackPlaybackInfo(
				productId: mediaProduct.productId,
				trackPlaybackInfo: trackPlaybackInfo
			)
			expectedPlayerItem.set(metadata)
			expectedPlayerItem.set(asset)
		}

		return expectedPlayerItem
	}
}

// MARK: - PlayerItem + Equatable

extension PlayerItem: Equatable {
	public static func == (lhs: PlayerItem, rhs: PlayerItem) -> Bool {
		lhs.isLoaded == rhs.isLoaded &&
			lhs.isCompletelyDownloaded == rhs.isCompletelyDownloaded &&
			lhs.mediaProduct == rhs.mediaProduct &&
			lhs.assetPosition == rhs.assetPosition &&
			lhs.asset == rhs.asset &&
			lhs.id == rhs.id &&
			lhs.metadata == rhs.metadata
	}
}

// swiftlint:enable file_length
