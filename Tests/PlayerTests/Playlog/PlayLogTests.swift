import Auth
import CoreMedia
@testable import Player
import XCTest

// MARK: - Constants

private enum Constants {
	/// For these tests, we use 2 files which consist of silence.
	enum AudioFileName {
		static let short = "test_5sec"
		static let long = "test_1min"
	}

	enum PlayLogSource {
		static let short = Source(sourceType: "TEST_1", sourceId: "456")
		static let long = Source(sourceType: "TEST_2", sourceId: "789")
	}

	static let encoder = JSONEncoder()

	static let expectationExtraTime: TimeInterval = 2
	static let timerTimeInterval = 0.05
	static let expectationShortExtraTime: TimeInterval = 0.5
}

// MARK: - PlayLogTests

/// This set of tests actually uses the actual player to play tracks.
/// That is in order to simulate a more realistic scenario and make sure the metrics are correct and don't get broken by any
/// changes.
final class PlayLogTests: XCTestCase {
	private var playerEngine: PlayerEngine!
	private var playerEventSender: PlayerEventSenderMock!
	private var credentialsProvider: CredentialsProviderMock!
	private var timestamp: UInt64 = 1
	private var uuid = "uuid"

	lazy var shortAudioFile: AudioFile = {
		let url = PlayLogTestsHelper.url(from: Constants.AudioFileName.short)
		return AudioFile(
			name: Constants.AudioFileName.short,
			id: "1",
			mediaProduct: MediaProduct.mock(
				productType: .TRACK,
				productId: "1",
				progressSource: nil,
				playLogSource: Constants.PlayLogSource.short,
				productURL: url
			),
			url: url,
			duration: 5.055
		)
	}()

	lazy var longAudioFile: AudioFile = {
		let url = PlayLogTestsHelper.url(from: Constants.AudioFileName.long)
		return AudioFile(
			name: Constants.AudioFileName.long,
			id: "2",
			mediaProduct: MediaProduct.mock(
				productType: .TRACK,
				productId: "2",
				progressSource: nil,
				playLogSource: Constants.PlayLogSource.long,
				productURL: url
			),
			url: url,
			duration: 60.61
		)
	}()

	override func setUp() {
		var developmentFeatureFlagProvider = DevelopmentFeatureFlagProvider.mock
		developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		let timeProvider = TimeProvider.mock(
			timestamp: {
				self.timestamp
			}
		)
		let uuidProvider = UUIDProvider(
			uuidString: {
				self.uuid
			}
		)
		PlayerWorld = PlayerWorldClient.mock(
			timeProvider: timeProvider,
			uuidProvider: uuidProvider,
			developmentFeatureFlagProvider: developmentFeatureFlagProvider
		)

		let sessionConfiguration = URLSessionConfiguration.default
		sessionConfiguration.protocolClasses = [JsonEncodedResponseURLProtocol.self]
		let urlSession = URLSession(configuration: sessionConfiguration)
		let errorManager = ErrorManagerMock()
		let httpClient = HttpClient.mock(
			urlSession: urlSession,
			responseErrorManager: errorManager,
			networkErrorManager: errorManager,
			timeoutErrorManager: errorManager
		)

		let accessTokenProvider = AuthTokenProviderMock()
		credentialsProvider = CredentialsProviderMock()
		let dataWriter = DataWriterMock()
		let configuration = Configuration.mock()
		playerEventSender = PlayerEventSenderMock(
			configuration: configuration,
			httpClient: httpClient,
			accessTokenProvider: accessTokenProvider,
			dataWriter: dataWriter
		)

		let storage = Storage()
		let fairplayLicenseFetcher = FairPlayLicenseFetcher.mock()
		let networkMonitor = NetworkMonitorMock()

		let djProducer = DJProducer(
			httpClient: httpClient,
			with: accessTokenProvider,
			credentialsProvider: credentialsProvider,
			featureFlagProvider: .mock
		)

		let notificationsHandler = NotificationsHandler.mock()
		let featureFlagProvider = FeatureFlagProvider.mock

		let playerLoader = InternalPlayerLoader(
			with: configuration,
			and: fairplayLicenseFetcher,
			featureFlagProvider: featureFlagProvider,
			accessTokenProvider: accessTokenProvider,
			credentialsProvider: credentialsProvider,
			mainPlayer: AVQueuePlayerWrapper.self,
			externalPlayers: []
		)

		let operationQueue = OperationQueue()
		operationQueue.maxConcurrentOperationCount = 1
		operationQueue.qualityOfService = .userInitiated
		operationQueue.name = "com.tidal.player.testplayeroperationqueue"

		playerEngine = PlayerEngine.mock(
			queue: operationQueue,
			httpClient: httpClient,
			accessTokenProvider: accessTokenProvider,
			credentialsProvider: credentialsProvider,
			fairplayLicenseFetcher: fairplayLicenseFetcher,
			djProducer: djProducer,
			configuration: configuration,
			playerEventSender: playerEventSender,
			networkMonitor: networkMonitor,
			storage: storage,
			playerLoader: playerLoader,
			notificationsHandler: notificationsHandler
		)

		credentialsProvider.injectSuccessfulUserLevelCredentials()
	}
}

// MARK: - Tests

extension PlayLogTests {
	func test_play_media_till_end() {
		// GIVEN
		let audioFile = shortAudioFile
		setAudioFileResponseToURLProtocol(audioFile: audioFile)

		let mediaProduct = audioFile.mediaProduct

		// WHEN
		// First we load the media product and then proceed to play it.
		playerEngine.load(mediaProduct, timestamp: timestamp)
		playerEngine.play(timestamp: timestamp)

		// Now we wait the same amount of the duration of the track plus extra time
		let expectation = expectation(description: "Expecting audio file to have been played")
		_ = XCTWaiter.wait(for: [expectation], timeout: shortAudioFile.duration + Constants.expectationExtraTime)

		// THEN
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)

		let playLogEvent = playerEventSender.playLogEvents[0]
		let expectedPlayLogEvent = PlayLogEvent.mock(
			startAssetPosition: 0,
			requestedProductId: mediaProduct.productId,
			actualProductId: mediaProduct.productId,
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: Constants.PlayLogSource.short.sourceType,
			sourceId: Constants.PlayLogSource.short.sourceId,
			actions: [],
			endTimestamp: timestamp,
			endAssetPosition: audioFile.duration
		)
		assertPlayLogEvent(actualPlayLogEvent: playLogEvent, expectedPlayLogEvent: expectedPlayLogEvent)
	}

	func test_play_and_pause_in_the_middle_and_resume() {
		// GIVEN
		let audioFile = shortAudioFile
		setAudioFileResponseToURLProtocol(audioFile: audioFile)

		let mediaProduct = audioFile.mediaProduct

		// WHEN
		// First we load the media product and then proceed to play it.
		playerEngine.load(mediaProduct, timestamp: timestamp)
		playerEngine.play(timestamp: timestamp)

		optimizedWait {
			playerEngine.currentItem != nil
		}
		guard let currentItem = playerEngine.currentItem else {
			XCTFail("Expected for the currentItem to be set up!")
			return
		}

		// Wait for the track to reach 2 seconds
		let pauseAssetPosition: Double = 2
		wait(for: currentItem, toReach: pauseAssetPosition)

		playerEngine.pause()

		// Wait for the state to be changed to NOT_PLAYING
		waitForPlayerToPause()

		// Play again
		playerEngine.play(timestamp: timestamp)

		// THEN
		optimizedWait(timeout: audioFile.duration) {
			playerEventSender.playLogEvents.count == 1
		}

		let playLogEvent = playerEventSender.playLogEvents[0]
		let actions = [
			Action(actionType: .PLAYBACK_STOP, assetPosition: pauseAssetPosition, timestamp: timestamp),
			Action(actionType: .PLAYBACK_START, assetPosition: pauseAssetPosition, timestamp: timestamp),
		]
		let expectedPlayLogEvent = PlayLogEvent.mock(
			startAssetPosition: 0,
			requestedProductId: mediaProduct.productId,
			actualProductId: mediaProduct.productId,
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: Constants.PlayLogSource.short.sourceType,
			sourceId: Constants.PlayLogSource.short.sourceId,
			actions: actions,
			endTimestamp: timestamp,
			endAssetPosition: audioFile.duration
		)
		assertPlayLogEvent(actualPlayLogEvent: playLogEvent, expectedPlayLogEvent: expectedPlayLogEvent)
	}

	func test_play_and_seek_forward_and_resume() {
		// GIVEN
		let audioFile = shortAudioFile
		setAudioFileResponseToURLProtocol(audioFile: audioFile)

		let mediaProduct = audioFile.mediaProduct

		// WHEN
		// First we load the media product and then proceed to play it.
		playerEngine.load(mediaProduct, timestamp: timestamp)
		playerEngine.play(timestamp: timestamp)

		optimizedWait {
			playerEngine.currentItem != nil
		}
		guard let currentItem = playerEngine.currentItem else {
			XCTFail("Expected for the currentItem to be set up!")
			return
		}

		// Wait for the track to reach 2 seconds
		let pauseAssetPosition: Double = 2
		wait(for: currentItem, toReach: pauseAssetPosition)

		// Seek forward to 3 seconds
		let seekAssetPosition: Double = 3
		playerEngine.seek(seekAssetPosition)
		wait(for: currentItem, toReach: seekAssetPosition)

		// THEN
		optimizedWait(timeout: audioFile.duration) {
			playerEventSender.playLogEvents.count == 1
		}

		let playLogEvent = playerEventSender.playLogEvents[0]
		let actions = [
			Action(actionType: .PLAYBACK_STOP, assetPosition: pauseAssetPosition, timestamp: timestamp),
			Action(actionType: .PLAYBACK_START, assetPosition: seekAssetPosition, timestamp: timestamp),
		]
		let expectedPlayLogEvent = PlayLogEvent.mock(
			startAssetPosition: 0,
			requestedProductId: mediaProduct.productId,
			actualProductId: mediaProduct.productId,
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: Constants.PlayLogSource.short.sourceType,
			sourceId: Constants.PlayLogSource.short.sourceId,
			actions: actions,
			endTimestamp: timestamp,
			endAssetPosition: audioFile.duration
		)
		assertPlayLogEvent(actualPlayLogEvent: playLogEvent, expectedPlayLogEvent: expectedPlayLogEvent)
	}

	func test_play_and_seek_back_and_resume() {
		// GIVEN
		let audioFile = shortAudioFile
		setAudioFileResponseToURLProtocol(audioFile: audioFile)

		let mediaProduct = audioFile.mediaProduct

		// WHEN
		// First we load the media product and then proceed to play it.
		playerEngine.load(mediaProduct, timestamp: timestamp)
		playerEngine.play(timestamp: timestamp)

		optimizedWait {
			playerEngine.currentItem != nil
		}
		guard let currentItem = playerEngine.currentItem else {
			XCTFail("Expected for the currentItem to be set up!")
			return
		}

		// Wait for the track to reach 3 seconds
		let pauseAssetPosition: Double = 3
		wait(for: currentItem, toReach: pauseAssetPosition)

		// Seek back to 2 seconds
		let seekAssetPosition: Double = 2
		playerEngine.seek(seekAssetPosition)

		// THEN
		optimizedWait(timeout: audioFile.duration) {
			playerEventSender.playLogEvents.count == 1
		}

		let playLogEvent = playerEventSender.playLogEvents[0]
		let actions = [
			Action(actionType: .PLAYBACK_STOP, assetPosition: pauseAssetPosition, timestamp: timestamp),
			Action(actionType: .PLAYBACK_START, assetPosition: seekAssetPosition, timestamp: timestamp),
		]
		let expectedPlayLogEvent = PlayLogEvent.mock(
			startAssetPosition: 0,
			requestedProductId: mediaProduct.productId,
			actualProductId: mediaProduct.productId,
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: Constants.PlayLogSource.short.sourceType,
			sourceId: Constants.PlayLogSource.short.sourceId,
			actions: actions,
			endTimestamp: timestamp,
			endAssetPosition: audioFile.duration
		)
		assertPlayLogEvent(actualPlayLogEvent: playLogEvent, expectedPlayLogEvent: expectedPlayLogEvent)
	}

	func test_play_and_pause_and_seek_forward_and_resume() {
		// GIVEN
		let audioFile = shortAudioFile
		setAudioFileResponseToURLProtocol(audioFile: audioFile)

		let mediaProduct = audioFile.mediaProduct

		// WHEN
		// First we load the media product and then proceed to play it.
		playerEngine.load(mediaProduct, timestamp: timestamp)
		playerEngine.play(timestamp: timestamp)

		optimizedWait {
			playerEngine.currentItem != nil
		}
		guard let currentItem = playerEngine.currentItem else {
			XCTFail("Expected for the currentItem to be set up!")
			return
		}

		// Wait for the track to reach 2 seconds
		let pauseAssetPosition: Double = 2
		wait(for: currentItem, toReach: pauseAssetPosition)

		playerEngine.pause()

		// Wait for the state to be changed to NOT_PLAYING
		waitForPlayerToPause()

		// Seek forward to 3 seconds
		let seekAssetPosition: Double = 3
		playerEngine.seek(seekAssetPosition)

		playerEngine.play(timestamp: timestamp)

		// THEN
		optimizedWait(timeout: audioFile.duration) {
			playerEventSender.playLogEvents.count == 1
		}

		let playLogEvent = playerEventSender.playLogEvents[0]
		let actions = [
			Action(actionType: .PLAYBACK_STOP, assetPosition: pauseAssetPosition, timestamp: timestamp),
			Action(actionType: .PLAYBACK_START, assetPosition: seekAssetPosition, timestamp: timestamp),
		]
		let expectedPlayLogEvent = PlayLogEvent.mock(
			startAssetPosition: 0,
			requestedProductId: mediaProduct.productId,
			actualProductId: mediaProduct.productId,
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: Constants.PlayLogSource.short.sourceType,
			sourceId: Constants.PlayLogSource.short.sourceId,
			actions: actions,
			endTimestamp: timestamp,
			endAssetPosition: audioFile.duration
		)
		assertPlayLogEvent(actualPlayLogEvent: playLogEvent, expectedPlayLogEvent: expectedPlayLogEvent)
	}

	func test_play_and_pause_and_seek_back_and_resume() {
		// GIVEN
		let audioFile = shortAudioFile
		setAudioFileResponseToURLProtocol(audioFile: audioFile)

		let mediaProduct = audioFile.mediaProduct

		// WHEN
		// First we load the media product and then proceed to play it.
		playerEngine.load(mediaProduct, timestamp: timestamp)
		playerEngine.play(timestamp: timestamp)

		optimizedWait {
			playerEngine.currentItem != nil
		}
		guard let currentItem = playerEngine.currentItem else {
			XCTFail("Expected for the currentItem to be set up!")
			return
		}

		// Wait for the track to reach 3 seconds
		let pauseAssetPosition: Double = 3
		wait(for: currentItem, toReach: pauseAssetPosition)

		playerEngine.pause()

		// Wait for the state to be changed to NOT_PLAYING
		waitForPlayerToPause()

		// Seek back to 2 seconds
		let seekAssetPosition: Double = 2
		playerEngine.seek(seekAssetPosition)

		playerEngine.play(timestamp: timestamp)

		// THEN
		optimizedWait(timeout: audioFile.duration) {
			playerEventSender.playLogEvents.count == 1
		}

		let playLogEvent = playerEventSender.playLogEvents[0]
		let actions = [
			Action(actionType: .PLAYBACK_STOP, assetPosition: pauseAssetPosition, timestamp: timestamp),
			Action(actionType: .PLAYBACK_START, assetPosition: seekAssetPosition, timestamp: timestamp),
		]
		let expectedPlayLogEvent = PlayLogEvent.mock(
			startAssetPosition: 0,
			requestedProductId: mediaProduct.productId,
			actualProductId: mediaProduct.productId,
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: Constants.PlayLogSource.short.sourceType,
			sourceId: Constants.PlayLogSource.short.sourceId,
			actions: actions,
			endTimestamp: timestamp,
			endAssetPosition: audioFile.duration
		)
		assertPlayLogEvent(actualPlayLogEvent: playLogEvent, expectedPlayLogEvent: expectedPlayLogEvent)
	}

	func test_play_and_pause_and_resume_and_pause_and_resume() {
		// GIVEN
		let audioFile = shortAudioFile
		setAudioFileResponseToURLProtocol(audioFile: audioFile)

		let mediaProduct = audioFile.mediaProduct

		// WHEN
		// First we load the media product and then proceed to play it.
		playerEngine.load(mediaProduct, timestamp: timestamp)
		playerEngine.play(timestamp: timestamp)

		optimizedWait {
			playerEngine.currentItem != nil
		}
		guard let currentItem = playerEngine.currentItem else {
			XCTFail("Expected for the currentItem to be set up!")
			return
		}

		// Wait for the track to reach 2 seconds
		let pauseAssetPosition: Double = 2
		wait(for: currentItem, toReach: pauseAssetPosition)

		playerEngine.pause()

		// Wait for the state to be changed to NOT_PLAYING
		waitForPlayerToPause()

		// Play again
		playerEngine.play(timestamp: timestamp)

		// Wait for the track to reach 3 seconds
		let secondPauseAssetPosition: Double = 3
		wait(for: currentItem, toReach: secondPauseAssetPosition)

		playerEngine.pause()

		// Wait for the state to be changed to NOT_PLAYING
		waitForPlayerToPause()

		// Play again
		playerEngine.play(timestamp: timestamp)

		// THEN
		optimizedWait(timeout: audioFile.duration) {
			playerEventSender.playLogEvents.count == 1
		}

		let playLogEvent = playerEventSender.playLogEvents[0]
		let actions = [
			Action(actionType: .PLAYBACK_STOP, assetPosition: pauseAssetPosition, timestamp: timestamp),
			Action(actionType: .PLAYBACK_START, assetPosition: pauseAssetPosition, timestamp: timestamp),
			Action(actionType: .PLAYBACK_STOP, assetPosition: secondPauseAssetPosition, timestamp: timestamp),
			Action(actionType: .PLAYBACK_START, assetPosition: secondPauseAssetPosition, timestamp: timestamp),
		]
		let expectedPlayLogEvent = PlayLogEvent.mock(
			startAssetPosition: 0,
			requestedProductId: mediaProduct.productId,
			actualProductId: mediaProduct.productId,
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: Constants.PlayLogSource.short.sourceType,
			sourceId: Constants.PlayLogSource.short.sourceId,
			actions: actions,
			endTimestamp: timestamp,
			endAssetPosition: audioFile.duration
		)

		assertPlayLogEvent(actualPlayLogEvent: playLogEvent, expectedPlayLogEvent: expectedPlayLogEvent)
	}

	func test_play_and_seek_forward_and_seek_back_and_resume() {
		// GIVEN
		let audioFile = shortAudioFile
		setAudioFileResponseToURLProtocol(audioFile: audioFile)

		let mediaProduct = audioFile.mediaProduct

		// WHEN
		// First we load the media product and then proceed to play it.
		playerEngine.load(mediaProduct, timestamp: timestamp)
		playerEngine.play(timestamp: timestamp)

		optimizedWait {
			playerEngine.currentItem != nil
		}
		guard let currentItem = playerEngine.currentItem else {
			XCTFail("Expected for the currentItem to be set up!")
			return
		}

		// Wait for the track to reach 2 seconds
		let seekAssetPosition: Double = 2
		wait(for: currentItem, toReach: seekAssetPosition)

		// Seek forward to 3 seconds
		let seekForwardAssetPosition: Double = 3
		playerEngine.seek(seekForwardAssetPosition)
		wait(for: currentItem, toReach: seekForwardAssetPosition)

		// Seek back to 2 seconds
		let seekBackAssetPosition: Double = 2
		playerEngine.seek(seekBackAssetPosition)
		wait(for: currentItem, toReach: seekBackAssetPosition)

		// THEN
		optimizedWait(timeout: audioFile.duration) {
			playerEventSender.playLogEvents.count == 1
		}

		let playLogEvent = playerEventSender.playLogEvents[0]
		let actions = [
			Action(actionType: .PLAYBACK_STOP, assetPosition: seekAssetPosition, timestamp: timestamp),
			Action(actionType: .PLAYBACK_START, assetPosition: seekForwardAssetPosition, timestamp: timestamp),
			Action(actionType: .PLAYBACK_STOP, assetPosition: seekForwardAssetPosition, timestamp: timestamp),
			Action(actionType: .PLAYBACK_START, assetPosition: seekBackAssetPosition, timestamp: timestamp),
		]
		let expectedPlayLogEvent = PlayLogEvent.mock(
			startAssetPosition: 0,
			requestedProductId: mediaProduct.productId,
			actualProductId: mediaProduct.productId,
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: Constants.PlayLogSource.short.sourceType,
			sourceId: Constants.PlayLogSource.short.sourceId,
			actions: actions,
			endTimestamp: timestamp,
			endAssetPosition: audioFile.duration
		)
		assertPlayLogEvent(actualPlayLogEvent: playLogEvent, expectedPlayLogEvent: expectedPlayLogEvent)
	}

	func test_play_media_and_reset() {
		// GIVEN
		let audioFile = shortAudioFile
		setAudioFileResponseToURLProtocol(audioFile: audioFile)

		let mediaProduct = audioFile.mediaProduct

		// WHEN
		// First we load the media product and then proceed to play it.
		playerEngine.load(mediaProduct, timestamp: timestamp)
		playerEngine.play(timestamp: timestamp)

		optimizedWait {
			playerEngine.currentItem != nil
		}
		guard let currentItem = playerEngine.currentItem else {
			XCTFail("Expected for the currentItem to be set up!")
			return
		}

		// Wait for the track to reach 1 second
		let resetAssetPosition: Double = 1
		wait(for: currentItem, toReach: resetAssetPosition)

		playerEngine.reset()

		// THEN
		optimizedWait(timeout: audioFile.duration) {
			playerEventSender.playLogEvents.count == 1
		}

		let playLogEvent = playerEventSender.playLogEvents[0]
		let expectedPlayLogEvent = PlayLogEvent.mock(
			startAssetPosition: 0,
			requestedProductId: mediaProduct.productId,
			actualProductId: mediaProduct.productId,
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: Constants.PlayLogSource.short.sourceType,
			sourceId: Constants.PlayLogSource.short.sourceId,
			actions: [],
			endTimestamp: timestamp,
			endAssetPosition: resetAssetPosition
		)
		assertPlayLogEvent(actualPlayLogEvent: playLogEvent, expectedPlayLogEvent: expectedPlayLogEvent)
	}
}

// MARK: - Assertion Helpers

extension PlayLogTests {
	func assertPlayLogEvent(actualPlayLogEvent: PlayLogEvent, expectedPlayLogEvent: PlayLogEvent) {
		// We can't fully rely on the endAssetPosition or actions.assetPosition which can be different from the asset's total
		// duration due to different reasons, such as rounding errors from CMTime, buffering and decoding (maybe it buffered a tiny
		// bit more than the reported duration or there is some final decoding or processing that takes place at the end of the
		// track, which could account for the few extra milliseconds), frame rate, notification timing since it's dispatched async,
		// or some internal AVPlayer behavior. Because of that, we can't perform a easy comparison here. Therefore, we compare
		// specific properties which are more relevant and also set a short range for acceptable endAssetPosition (within 50
		// milliseconds).
		XCTAssertEqual(
			actualPlayLogEvent.startAssetPosition,
			expectedPlayLogEvent.startAssetPosition,
			"Expected startAssetPosition to be \(expectedPlayLogEvent.startAssetPosition) but got \(actualPlayLogEvent.startAssetPosition)"
		)
		XCTAssertEqual(
			actualPlayLogEvent.requestedProductId,
			expectedPlayLogEvent.requestedProductId,
			"Expected requestedProductId to be \(expectedPlayLogEvent.requestedProductId) but got \(actualPlayLogEvent.requestedProductId)"
		)
		XCTAssertEqual(
			actualPlayLogEvent.actualProductId,
			expectedPlayLogEvent.actualProductId,
			"Expected actualProductId to be \(expectedPlayLogEvent.actualProductId) but got \(actualPlayLogEvent.actualProductId)"
		)
		XCTAssertEqual(
			actualPlayLogEvent.actualQuality,
			expectedPlayLogEvent.actualQuality,
			"Expected actualQuality to be \(expectedPlayLogEvent.actualQuality) but got \(actualPlayLogEvent.actualQuality)"
		)
		XCTAssertEqual(
			actualPlayLogEvent.sourceType,
			expectedPlayLogEvent.sourceType,
			"Expected sourceType to be \(expectedPlayLogEvent.sourceType) but got \(actualPlayLogEvent.sourceType)"
		)
		XCTAssertEqual(
			actualPlayLogEvent.sourceId,
			expectedPlayLogEvent.sourceId,
			"Expected sourceId to be \(expectedPlayLogEvent.sourceId) but got \(actualPlayLogEvent.sourceId)"
		)
		XCTAssertEqual(
			actualPlayLogEvent.endTimestamp,
			expectedPlayLogEvent.endTimestamp,
			"Expected requestedProductId to be \(expectedPlayLogEvent.endTimestamp) but got \(actualPlayLogEvent.endTimestamp)"
		)

		XCTAssert(
			actualPlayLogEvent.actions.isEqual(to: expectedPlayLogEvent.actions),
			"Expected PlayLogEvents to have the same actions: expected \(expectedPlayLogEvent.actions) but got \(actualPlayLogEvent.actions)."
		)

		assertAssetPosition(
			expectedAssetPosition: expectedPlayLogEvent.endAssetPosition,
			actualAssetPosition: actualPlayLogEvent.endAssetPosition
		)
	}

	func assertAssetPosition(expectedAssetPosition: Double, actualAssetPosition: Double) {
		let isNegligible = PlayLogTestsHelper.isTimeDifferenceNegligible(
			assetPosition: expectedAssetPosition,
			anotherAssetPosition: actualAssetPosition
		)
		guard isNegligible else {
			XCTFail(
				"Expected to have only a negligible difference between actual (\(actualAssetPosition)) and expected assetPosition (\(expectedAssetPosition))."
			)
			return
		}
	}

	func wait(for playerItem: PlayerItem, toReach targetAssetPosition: Double) {
		let trackReachedAssetPositionExpectation =
			XCTestExpectation(description: "Expected for the track to reach \(targetAssetPosition) seconds")
		let timer = Timer.scheduledTimer(withTimeInterval: Constants.timerTimeInterval, repeats: true) { _ in
			if playerItem.assetPosition >= targetAssetPosition {
				trackReachedAssetPositionExpectation.fulfill()
			}
		}
		wait(for: [trackReachedAssetPositionExpectation], timeout: targetAssetPosition + Constants.expectationExtraTime)
		timer.invalidate()
	}

	func waitForPlayerToPause() {
		// Wait for the state to be changed to NOT_PLAYING
		let pauseTrackExpectation = XCTestExpectation(description: "Expected for the player's state to change to NOT_PLAYING")
		let timer = Timer.scheduledTimer(withTimeInterval: Constants.timerTimeInterval, repeats: true) { _ in
			if self.playerEngine.getState() == .NOT_PLAYING {
				pauseTrackExpectation.fulfill()
			}
		}
		wait(for: [pauseTrackExpectation], timeout: Constants.expectationShortExtraTime)
		timer.invalidate()
	}
}

// MARK: - Setup Helpers

private extension PlayLogTests {
	func setAudioFileResponseToURLProtocol(audioFile: AudioFile) {
		let mediaProduct = audioFile.mediaProduct

		guard let fileURLString = audioFile.url?.absoluteString else {
			XCTFail("Failed to get URL from the audioFile: \(audioFile.name)")
			return
		}
		let encodableEmuManifest = EncodableEmuManifest(urls: [fileURLString])

		do {
			let manifestData = try Constants.encoder.encode(encodableEmuManifest)
			let manifest: String = Data(manifestData).base64EncodedString()
			let trackPlaybackInfo = TrackPlaybackInfo.mock(
				trackId: Int(mediaProduct.productId)!,
				manifestHash: "manifestHash+\(audioFile.id)",
				manifest: manifest,
				albumReplayGain: 11,
				albumPeakAmplitude: 22,
				sampleRate: 33,
				bitDepth: 44
			)
			JsonEncodedResponseURLProtocol.succeed(with: trackPlaybackInfo)
		} catch {
			XCTFail("Failed to encode data: \(error)")
		}
	}
}
