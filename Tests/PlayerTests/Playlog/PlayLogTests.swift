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
	private var featureFlagProvider: FeatureFlagProvider!
	private var credentialsProvider: CredentialsProviderMock!
	private var httpClient: HttpClient!
	private var fairplayLicenseFetcher: FairPlayLicenseFetcher!
	private var djProducer: DJProducer!
	private var playerLoader: InternalPlayerLoader!
	private var storage: Storage!
	private var networkMonitor: NetworkMonitorMock!
	private var configuration: Configuration!
	private var notificationsHandler: NotificationsHandler!

	private var timestamp: UInt64 = 1
	private var uuid = "uuid"
	private var shouldSendEventsInDeinit: Bool = false

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
		featureFlagProvider = FeatureFlagProvider.mock
		featureFlagProvider.shouldSendEventsInDeinit = {
			self.shouldSendEventsInDeinit
		}

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
			uuidProvider: uuidProvider
		)

		credentialsProvider = CredentialsProviderMock()

		let sessionConfiguration = URLSessionConfiguration.default
		sessionConfiguration.protocolClasses = [JsonEncodedResponseURLProtocol.self]
		let urlSession = URLSession(configuration: sessionConfiguration)
		let errorManager = ErrorManagerMock()
		httpClient = HttpClient.mock(
			urlSession: urlSession,
			responseErrorManager: errorManager,
			networkErrorManager: errorManager,
			timeoutErrorManager: errorManager
		)

		let dataWriter = DataWriterMock()
		configuration = Configuration.mock()
		playerEventSender = PlayerEventSenderMock(
			configuration: configuration,
			httpClient: httpClient,
			dataWriter: dataWriter,
			featureFlagProvider: featureFlagProvider
		)

		storage = Storage()
		fairplayLicenseFetcher = FairPlayLicenseFetcher.mock(
			httpClient: HttpClient(using: urlSession),
			credentialsProvider: credentialsProvider,
			playerEventSender: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)

		networkMonitor = NetworkMonitorMock()

		let djProducerTimeoutPolicy = TimeoutPolicy.shortLived
		let djProducerSession = URLSession.new(with: djProducerTimeoutPolicy, name: "Player DJ Session")
		let djProducerHTTPClient = HttpClient(using: djProducerSession)

		djProducer = DJProducer(
			httpClient: djProducerHTTPClient,
			credentialsProvider: credentialsProvider,
			featureFlagProvider: .mock
		)

		notificationsHandler = NotificationsHandler.mock()

		setUpPlayerEngine()

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

		// Wait for the player engine state to be IDLE.
		waitForPlayerToBeInState(.IDLE)

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
			self.playerEngine.currentItem != nil
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
		waitForPlayerToBeInState(.NOT_PLAYING)

		// Play again
		playerEngine.play(timestamp: timestamp)

		let expectation = expectation(description: "Expecting audio file to have been played")
		_ = XCTWaiter.wait(for: [expectation], timeout: shortAudioFile.duration + Constants.expectationExtraTime)

		// Wait for the player engine state to be IDLE.
		waitForPlayerToBeInState(.IDLE)

		// THEN
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)

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
			self.playerEngine.currentItem != nil
		}
		guard let currentItem = playerEngine.currentItem else {
			XCTFail("Expected for the currentItem to be set up!")
			return
		}

		// Wait for the track to reach 2 seconds
		let seekTo3AssetPosition: Double = 2
		wait(for: currentItem, toReach: seekTo3AssetPosition)

		// Seek forward to 3 seconds
		let seekAssetPosition: Double = 3
		playerEngine.seek(seekAssetPosition)
		wait(for: currentItem, toReach: seekAssetPosition)

		// THEN
		waitForPlayerToBeInState(.IDLE, timeout: audioFile.duration - seekAssetPosition + Constants.expectationExtraTime)
		optimizedWait(timeout: audioFile.duration) {
			self.playerEventSender.playLogEvents.count == 1
		}

		let playLogEvent = playerEventSender.playLogEvents[0]
		let actions = [
			Action(actionType: .PLAYBACK_STOP, assetPosition: seekTo3AssetPosition, timestamp: timestamp),
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
			self.playerEngine.currentItem != nil
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
		wait(for: currentItem, toReach: seekAssetPosition)

		// THEN
		waitForPlayerToBeInState(.IDLE, timeout: audioFile.duration - seekAssetPosition + Constants.expectationExtraTime)
		optimizedWait(timeout: audioFile.duration) {
			self.playerEventSender.playLogEvents.count == 1
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
			self.playerEngine.currentItem != nil
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
		waitForPlayerToBeInState(.NOT_PLAYING)

		// Seek forward to 3 seconds
		let seekAssetPosition: Double = 3
		playerEngine.seek(seekAssetPosition)
		wait(for: currentItem, toReach: seekAssetPosition)

		playerEngine.play(timestamp: timestamp)

		// THEN
		waitForPlayerToBeInState(.IDLE, timeout: audioFile.duration - seekAssetPosition + Constants.expectationExtraTime)
		optimizedWait(timeout: audioFile.duration) {
			self.playerEventSender.playLogEvents.count == 1
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
			self.playerEngine.currentItem != nil
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
		waitForPlayerToBeInState(.NOT_PLAYING)

		// Seek back to 2 seconds
		let seekAssetPosition: Double = 2
		playerEngine.seek(seekAssetPosition)
		wait(for: currentItem, toReach: seekAssetPosition)

		playerEngine.play(timestamp: timestamp)

		// THEN
		waitForPlayerToBeInState(.IDLE, timeout: audioFile.duration - seekAssetPosition + Constants.expectationExtraTime)
		optimizedWait(timeout: audioFile.duration) {
			self.playerEventSender.playLogEvents.count == 1
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
			self.playerEngine.currentItem != nil
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
		waitForPlayerToBeInState(.NOT_PLAYING)

		// Play again
		playerEngine.play(timestamp: timestamp)

		// Wait for the track to reach 3 seconds
		let secondPauseAssetPosition: Double = 3
		wait(for: currentItem, toReach: secondPauseAssetPosition)

		playerEngine.pause()

		// Wait for the state to be changed to NOT_PLAYING
		waitForPlayerToBeInState(.NOT_PLAYING)

		// Play again
		playerEngine.play(timestamp: timestamp)

		// THEN
		waitForPlayerToBeInState(.IDLE, timeout: audioFile.duration + Constants.expectationExtraTime)
		optimizedWait(timeout: audioFile.duration) {
			self.playerEventSender.playLogEvents.count == 1
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
			self.playerEngine.currentItem != nil
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
		waitForPlayerToBeInState(.IDLE, timeout: audioFile.duration - seekBackAssetPosition + Constants.expectationExtraTime)
		optimizedWait(timeout: audioFile.duration) {
			self.playerEventSender.playLogEvents.count == 1
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

	func test_seek_forward_and_resume() {
		// GIVEN
		let audioFile = shortAudioFile
		setAudioFileResponseToURLProtocol(audioFile: audioFile)

		let mediaProduct = audioFile.mediaProduct

		// WHEN
		// First we load the media product and then proceed to seek forward and play it.
		playerEngine.load(mediaProduct, timestamp: timestamp)

		optimizedWait {
			self.playerEngine.currentItem != nil
		}
		guard let currentItem = playerEngine.currentItem else {
			XCTFail("Expected for the currentItem to be set up!")
			return
		}

		optimizedWait {
			currentItem.asset != nil
		}
		guard let asset = currentItem.asset else {
			XCTFail("Expected for the currentItem's asset to be set up!")
			return
		}

		// Seek forward to 2 seconds
		let seekAssetPosition: Double = 2
		playerEngine.seek(seekAssetPosition)
		wait(for: currentItem, toReach: seekAssetPosition)

		// seek is async so wait a tiny bit to make sure seek has completed before actually playing.
		optimizedWait(step: 0.05) {
			PlayLogTestsHelper.isTimeDifferenceNegligible(
				assetPosition: seekAssetPosition,
				anotherAssetPosition: asset.assetPosition
			)
		}
		assertAssetPosition(expectedAssetPosition: seekAssetPosition, actualAssetPosition: asset.assetPosition)
		playerEngine.play(timestamp: timestamp)

		// THEN
		waitForPlayerToBeInState(.IDLE, timeout: audioFile.duration + Constants.expectationExtraTime)
		optimizedWait(timeout: audioFile.duration) {
			self.playerEventSender.playLogEvents.count == 1
		}

		let playLogEvent = playerEventSender.playLogEvents[0]
		let expectedPlayLogEvent = PlayLogEvent.mock(
			startAssetPosition: seekAssetPosition,
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
			self.playerEngine.currentItem != nil
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
		waitForPlayerToBeInState(.IDLE)
		optimizedWait(timeout: audioFile.duration) {
			self.playerEventSender.playLogEvents.count == 1
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

	func test_load_and_setNext_and_play() {
		// GIVEN
		uuid = "uuid1"
		let audioFile1 = shortAudioFile
		setAudioFileResponseToURLProtocol(audioFile: audioFile1)

		let mediaProduct1 = audioFile1.mediaProduct

		// WHEN
		// First we load the first media product.
		playerEngine.load(mediaProduct1, timestamp: timestamp)

		optimizedWait {
			self.playerEngine.currentItem != nil
		}

		// Afterwards we load the second media product with setNext and finally play.
		uuid = "uuid2"
		let audioFile2 = longAudioFile
		setAudioFileResponseToURLProtocol(audioFile: audioFile2)
		let mediaProduct2 = audioFile2.mediaProduct

		playerEngine.setNext(mediaProduct2, timestamp: timestamp)
		optimizedWait {
			self.playerEngine.nextItem != nil
		}

		playerEngine.play(timestamp: timestamp)
		waitForPlayerToBeInState(.PLAYING)

		waitForPlayerToBeInState(.IDLE, timeout: shortAudioFile.duration + longAudioFile.duration + 5)

		// THEN
		waitForPlayerToBeInState(.IDLE, timeout: 5)
		optimizedWait {
			self.playerEventSender.playLogEvents.count == 2
		}
		XCTAssertEqual(playerEventSender.playLogEvents.count, 2)

		let playLogEvent1 = playerEventSender.playLogEvents[0]
		let expectedPlayLogEvent1 = PlayLogEvent.mock(
			startAssetPosition: 0,
			requestedProductId: mediaProduct1.productId,
			actualProductId: mediaProduct1.productId,
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: Constants.PlayLogSource.short.sourceType,
			sourceId: Constants.PlayLogSource.short.sourceId,
			actions: [],
			endTimestamp: timestamp,
			endAssetPosition: audioFile1.duration
		)
		assertPlayLogEvent(actualPlayLogEvent: playLogEvent1, expectedPlayLogEvent: expectedPlayLogEvent1)

		let playLogEvent2 = playerEventSender.playLogEvents[1]
		let expectedPlayLogEvent2 = PlayLogEvent.mock(
			startAssetPosition: 0,
			requestedProductId: mediaProduct2.productId,
			actualProductId: mediaProduct2.productId,
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: Constants.PlayLogSource.long.sourceType,
			sourceId: Constants.PlayLogSource.long.sourceId,
			actions: [],
			endTimestamp: timestamp,
			endAssetPosition: audioFile2.duration
		)
		assertPlayLogEvent(actualPlayLogEvent: playLogEvent2, expectedPlayLogEvent: expectedPlayLogEvent2)
	}

	func test_play_and_seek_forward_beyond_file_duration() {
		// GIVEN
		let audioFile = shortAudioFile
		setAudioFileResponseToURLProtocol(audioFile: audioFile)

		let mediaProduct = audioFile.mediaProduct

		// WHEN
		// First we load the media product and then proceed to play it.
		playerEngine.load(mediaProduct, timestamp: timestamp)
		playerEngine.play(timestamp: timestamp)

		optimizedWait {
			self.playerEngine.currentItem != nil
		}
		guard let currentItem = playerEngine.currentItem else {
			XCTFail("Expected for the currentItem to be set up!")
			return
		}

		// Wait for the track to reach 2 seconds
		let startSeekAssetPosition: Double = 2
		wait(for: currentItem, toReach: startSeekAssetPosition)

		// Seek forward to 10 seconds
		let seekAssetPosition: Double = 10
		playerEngine.seek(seekAssetPosition)

		// THEN
		optimizedWait(timeout: audioFile.duration) {
			self.playerEventSender.playLogEvents.count == 1
		}

		let playLogEvent = playerEventSender.playLogEvents[0]
		let actions = [
			Action(actionType: .PLAYBACK_STOP, assetPosition: startSeekAssetPosition, timestamp: timestamp),
			Action(actionType: .PLAYBACK_START, assetPosition: audioFile.duration, timestamp: timestamp),
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

	func test_load_and_setNext_and_play_and_seek_forward_beyond_file_duration_and_reset() {
		// GIVEN
		uuid = "uuid1"
		let audioFile1 = shortAudioFile
		setAudioFileResponseToURLProtocol(audioFile: audioFile1)

		let mediaProduct1 = audioFile1.mediaProduct

		// WHEN
		// First we load the first media product.
		playerEngine.load(mediaProduct1, timestamp: timestamp)

		optimizedWait {
			self.playerEngine.currentItem != nil
		}
		guard let currentItem = playerEngine.currentItem else {
			XCTFail("Expected for the currentItem to be set up!")
			return
		}

		// Afterwards we load the second media product and finally play.
		uuid = "uuid2"
		let audioFile2 = longAudioFile
		setAudioFileResponseToURLProtocol(audioFile: audioFile2)

		let mediaProduct2 = audioFile2.mediaProduct
		playerEngine.setNext(mediaProduct2, timestamp: timestamp)

		optimizedWait {
			self.playerEngine.nextItem != nil
		}

		playerEngine.play(timestamp: timestamp)

		// Wait for the track to reach 2 seconds
		let startSeekAssetPosition: Double = 2
		wait(for: currentItem, toReach: startSeekAssetPosition)

		// Seek forward to 10 seconds
		let seekAssetPosition: Double = 10
		playerEngine.seek(seekAssetPosition)

		// Wait until the previously next item is now the current item
		optimizedWait {
			self.playerEngine.nextItem == nil &&
				self.playerEngine.currentItem?.id == self.uuid
		}

		guard let nextCurrentItem = playerEngine.currentItem else {
			XCTFail("Expected for the currentItem to be set up!")
			return
		}

		// Wait for the track to reach 1 second
		let resetAssetPosition: Double = 1
		wait(for: nextCurrentItem, toReach: resetAssetPosition)

		playerEngine.reset()

		// THEN
		waitForPlayerToBeInState(.IDLE)
		optimizedWait {
			self.playerEventSender.playLogEvents.count == 2
		}
		XCTAssertEqual(playerEventSender.playLogEvents.count, 2)

		let playLogEvent1 = playerEventSender.playLogEvents[0]
		let actions1 = [
			Action(actionType: .PLAYBACK_STOP, assetPosition: startSeekAssetPosition, timestamp: timestamp),
			Action(actionType: .PLAYBACK_START, assetPosition: audioFile1.duration, timestamp: timestamp),
		]
		let expectedPlayLogEvent1 = PlayLogEvent.mock(
			startAssetPosition: 0,
			requestedProductId: mediaProduct1.productId,
			actualProductId: mediaProduct1.productId,
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: Constants.PlayLogSource.short.sourceType,
			sourceId: Constants.PlayLogSource.short.sourceId,
			actions: actions1,
			endTimestamp: timestamp,
			endAssetPosition: audioFile1.duration
		)
		assertPlayLogEvent(actualPlayLogEvent: playLogEvent1, expectedPlayLogEvent: expectedPlayLogEvent1)

		let playLogEvent2 = playerEventSender.playLogEvents[1]
		let expectedPlayLogEvent2 = PlayLogEvent.mock(
			startAssetPosition: 0,
			requestedProductId: mediaProduct2.productId,
			actualProductId: mediaProduct2.productId,
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: Constants.PlayLogSource.long.sourceType,
			sourceId: Constants.PlayLogSource.long.sourceId,
			actions: [],
			endTimestamp: timestamp,
			endAssetPosition: resetAssetPosition
		)
		assertPlayLogEvent(actualPlayLogEvent: playLogEvent2, expectedPlayLogEvent: expectedPlayLogEvent2)
	}

	func test_setNext_and_load_and_play_and_skipToNext() {
		// GIVEN
		uuid = "uuid2"
		let audioFile2 = longAudioFile
		setAudioFileResponseToURLProtocol(audioFile: audioFile2)
		let mediaProduct2 = audioFile2.mediaProduct

		// WHEN
		// setNext called before an initial load doesn't do anything
		playerEngine.setNext(mediaProduct2, timestamp: timestamp)

		uuid = "uuid1"
		let audioFile1 = shortAudioFile
		setAudioFileResponseToURLProtocol(audioFile: audioFile1)

		let mediaProduct1 = audioFile1.mediaProduct

		// Now actually load the first media product.
		playerEngine.load(mediaProduct1, timestamp: timestamp)

		optimizedWait {
			self.playerEngine.currentItem != nil
		}

		playerEngine.play(timestamp: timestamp)

		// skipToNext doesn't do anything since there's no nextItem
		playerEngine.skipToNext(timestamp: timestamp)

		// Now we wait the same amount of the duration of the track plus extra time
		let expectation = expectation(description: "Expecting audio file to have been played")
		_ = XCTWaiter.wait(
			for: [expectation],
			timeout: shortAudioFile.duration + Constants.expectationExtraTime
		)

		// THEN
		optimizedWait {
			self.playerEventSender.playLogEvents.count == 1
		}
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)

		let playLogEvent = playerEventSender.playLogEvents[0]
		let expectedPlayLogEvent = PlayLogEvent.mock(
			startAssetPosition: 0,
			requestedProductId: mediaProduct1.productId,
			actualProductId: mediaProduct1.productId,
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: Constants.PlayLogSource.short.sourceType,
			sourceId: Constants.PlayLogSource.short.sourceId,
			actions: [],
			endTimestamp: timestamp,
			endAssetPosition: audioFile1.duration
		)
		assertPlayLogEvent(actualPlayLogEvent: playLogEvent, expectedPlayLogEvent: expectedPlayLogEvent)
	}

	func test_load_and_play_and_setNext_and_skipToNext_and_reset() {
		// GIVEN
		uuid = "uuid1"
		let audioFile1 = shortAudioFile
		setAudioFileResponseToURLProtocol(audioFile: audioFile1)

		let mediaProduct1 = audioFile1.mediaProduct

		// WHEN
		// First we load the media product and then proceed to play it.
		playerEngine.load(mediaProduct1, timestamp: timestamp)
		playerEngine.play(timestamp: timestamp)

		optimizedWait {
			self.playerEngine.currentItem != nil
		}
		guard let currentItem = playerEngine.currentItem else {
			XCTFail("Expected for the currentItem to be set up!")
			return
		}

		// Afterwards we load the second media product with setNext.
		uuid = "uuid2"
		let audioFile2 = longAudioFile
		setAudioFileResponseToURLProtocol(audioFile: audioFile2)
		let mediaProduct2 = audioFile2.mediaProduct
		playerEngine.setNext(mediaProduct2, timestamp: timestamp)

		optimizedWait {
			self.playerEngine.nextItem != nil
		}

		// Wait for the track to reach 1 second
		let skipToNextAssetPosition: Double = 1
		wait(for: currentItem, toReach: skipToNextAssetPosition)

		playerEngine.skipToNext(timestamp: timestamp)

		// Wait until the previously next item is now the current item
		optimizedWait {
			self.playerEngine.currentItem?.id == self.uuid
		}
		guard let nextCurrentItem = playerEngine.currentItem else {
			XCTFail("Expected for the currentItem to be set up!")
			return
		}

		// Wait for the track to reach 1 second
		let resetAssetPosition: Double = 1
		wait(for: nextCurrentItem, toReach: resetAssetPosition)

		playerEngine.reset()

		// THEN
		waitForPlayerToBeInState(.IDLE)
		optimizedWait {
			self.playerEventSender.playLogEvents.count == 2
		}
		XCTAssertEqual(playerEventSender.playLogEvents.count, 2)

		let playLogEvent1 = playerEventSender.playLogEvents[0]
		let expectedPlayLogEvent1 = PlayLogEvent.mock(
			startAssetPosition: 0,
			requestedProductId: mediaProduct1.productId,
			actualProductId: mediaProduct1.productId,
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: Constants.PlayLogSource.short.sourceType,
			sourceId: Constants.PlayLogSource.short.sourceId,
			actions: [],
			endTimestamp: timestamp,
			endAssetPosition: skipToNextAssetPosition
		)
		assertPlayLogEvent(actualPlayLogEvent: playLogEvent1, expectedPlayLogEvent: expectedPlayLogEvent1)

		let playLogEvent2 = playerEventSender.playLogEvents[1]
		let expectedPlayLogEvent2 = PlayLogEvent.mock(
			startAssetPosition: 0,
			requestedProductId: mediaProduct2.productId,
			actualProductId: mediaProduct2.productId,
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: Constants.PlayLogSource.long.sourceType,
			sourceId: Constants.PlayLogSource.long.sourceId,
			actions: [],
			endTimestamp: timestamp,
			endAssetPosition: resetAssetPosition
		)
		assertPlayLogEvent(actualPlayLogEvent: playLogEvent2, expectedPlayLogEvent: expectedPlayLogEvent2)
	}

	func test_load_and_play_and_pause_and_seek_and_play_and_setNext_and_pause_and_play_and_skipToNext_and_seek_and_reset() {
		// GIVEN
		uuid = "uuid1"
		let audioFile1 = shortAudioFile
		setAudioFileResponseToURLProtocol(audioFile: audioFile1)

		let mediaProduct1 = audioFile1.mediaProduct

		// WHEN
		// First we load the media product and then proceed to play it.
		playerEngine.load(mediaProduct1, timestamp: timestamp)
		playerEngine.play(timestamp: timestamp)

		optimizedWait {
			self.playerEngine.currentItem != nil
		}
		waitForPlayerToBeInState(.PLAYING, timeout: 10)
		guard let currentItem = playerEngine.currentItem else {
			XCTFail("Expected for the currentItem to be set up!")
			return
		}

		// Wait for the track to reach 2 seconds
		let pauseAssetPosition: Double = 2
		wait(for: currentItem, toReach: pauseAssetPosition)

		playerEngine.pause()
		waitForPlayerToBeInState(.NOT_PLAYING)

		// Seek forward to 3 seconds
		let seekAssetPosition: Double = 3
		playerEngine.seek(seekAssetPosition)
		wait(for: currentItem, toReach: seekAssetPosition)

		playerEngine.play(timestamp: timestamp)

		// Afterwards we load the second media product with setNext.
		uuid = "uuid2"
		let audioFile2 = longAudioFile
		setAudioFileResponseToURLProtocol(audioFile: audioFile2)
		let mediaProduct2 = audioFile2.mediaProduct
		playerEngine.setNext(mediaProduct2, timestamp: timestamp)

		optimizedWait {
			self.playerEngine.nextItem != nil
		}

		playerEngine.pause()
		waitForPlayerToBeInState(.NOT_PLAYING, timeout: 5)

		playerEngine.play(timestamp: timestamp)

		// Wait for the track to reach 4 seconds
		let skipToNextAssetPosition: Double = 4
		wait(for: currentItem, toReach: skipToNextAssetPosition)
		playerEngine.skipToNext(timestamp: timestamp)

		// Wait until the previously next item is now the current item
		optimizedWait {
			self.playerEngine.currentItem?.id == self.uuid &&
				self.playerEngine.nextItem == nil
		}
		guard let nextCurrentItem = playerEngine.currentItem else {
			XCTFail("Expected for the currentItem to be set up!")
			return
		}

		// Seek forward to 58 seconds
		let seekAssetPosition2: Double = 58
		playerEngine.seek(seekAssetPosition2)
		wait(for: nextCurrentItem, toReach: seekAssetPosition2)

		// Wait for the track to reach 59 seconds
		let resetAssetPosition: Double = 59
		wait(for: nextCurrentItem, toReach: resetAssetPosition)

		playerEngine.reset()

		// THEN
		waitForPlayerToBeInState(.IDLE, timeout: 10)
		optimizedWait {
			self.playerEventSender.playLogEvents.count == 2
		}

		let playLogEvent1 = playerEventSender.playLogEvents[0]
		let actions1 = [
			Action(actionType: .PLAYBACK_STOP, assetPosition: pauseAssetPosition, timestamp: timestamp),
			Action(actionType: .PLAYBACK_START, assetPosition: seekAssetPosition, timestamp: timestamp),
			Action(actionType: .PLAYBACK_STOP, assetPosition: seekAssetPosition, timestamp: timestamp),
			Action(actionType: .PLAYBACK_START, assetPosition: seekAssetPosition, timestamp: timestamp),
		]
		let expectedPlayLogEvent1 = PlayLogEvent.mock(
			startAssetPosition: 0,
			requestedProductId: mediaProduct1.productId,
			actualProductId: mediaProduct1.productId,
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: Constants.PlayLogSource.short.sourceType,
			sourceId: Constants.PlayLogSource.short.sourceId,
			actions: actions1,
			endTimestamp: timestamp,
			endAssetPosition: skipToNextAssetPosition
		)
		assertPlayLogEvent(actualPlayLogEvent: playLogEvent1, expectedPlayLogEvent: expectedPlayLogEvent1)

		let playLogEvent2 = playerEventSender.playLogEvents[1]
		let actions2 = [
			Action(actionType: .PLAYBACK_STOP, assetPosition: 0, timestamp: timestamp),
			Action(actionType: .PLAYBACK_START, assetPosition: seekAssetPosition2, timestamp: timestamp),
		]
		let expectedPlayLogEvent2 = PlayLogEvent.mock(
			startAssetPosition: 0,
			requestedProductId: mediaProduct2.productId,
			actualProductId: mediaProduct2.productId,
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: Constants.PlayLogSource.long.sourceType,
			sourceId: Constants.PlayLogSource.long.sourceId,
			actions: actions2,
			endTimestamp: timestamp,
			endAssetPosition: resetAssetPosition
		)
		assertPlayLogEvent(actualPlayLogEvent: playLogEvent2, expectedPlayLogEvent: expectedPlayLogEvent2)
	}

	func test_load_and_play_and_resetPlayerEngine_and_setUpANewPlayerEngine_and_load_and_play_another_track_and_reset() {
		// GIVEN
		// First we load the media product and then proceed to play it.
		uuid = "uuid1"
		let shortAudioFile = shortAudioFile
		setAudioFileResponseToURLProtocol(audioFile: shortAudioFile)
		let mediaProduct1 = shortAudioFile.mediaProduct
		playerEngine.load(mediaProduct1, timestamp: timestamp)

		optimizedWait {
			self.playerEngine.currentItem != nil
		}
		guard let currentItem = playerEngine.currentItem else {
			XCTFail("Expected for the currentItem to be set up!")
			return
		}

		playerEngine.play(timestamp: timestamp)

		// Wait for the track to reach 2 seconds
		let loadSecondMediaProductAssetPosition: Double = 2
		wait(for: currentItem, toReach: loadSecondMediaProductAssetPosition)

		// Simulate Player.load() is called.
		// This is in order to simulate the following scenario: load and play a track, load and play another track.
		playerEngine.notificationsHandler = nil
		playerEngine.resetOrUnload()

		// Wait for the player engine state to be IDLE.
		waitForPlayerToBeInState(.IDLE)

		setUpPlayerEngine()

		// Now we load the second media product and then proceed to play it.
		uuid = "uuid2"
		let longAudioFile = longAudioFile
		setAudioFileResponseToURLProtocol(audioFile: longAudioFile)
		let mediaProduct2 = longAudioFile.mediaProduct
		playerEngine.load(mediaProduct2, timestamp: timestamp)

		optimizedWait {
			self.playerEngine.currentItem != nil
		}
		guard let nextCurrentItem = playerEngine.currentItem else {
			XCTFail("Expected for the currentItem to be set up!")
			return
		}

		playerEngine.play(timestamp: timestamp)

		// Wait for the track to reach 1 second
		let resetAssetPosition: Double = 1
		wait(for: nextCurrentItem, toReach: resetAssetPosition)

		playerEngine.reset()

		// THEN
		waitForPlayerToBeInState(.IDLE)
		optimizedWait {
			self.playerEventSender.playLogEvents.count == 2
		}

		let playLogEvent1 = playerEventSender.playLogEvents[0]
		let expectedPlayLogEvent1 = PlayLogEvent.mock(
			startAssetPosition: 0,
			requestedProductId: mediaProduct1.productId,
			actualProductId: mediaProduct1.productId,
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: Constants.PlayLogSource.short.sourceType,
			sourceId: Constants.PlayLogSource.short.sourceId,
			actions: [],
			endTimestamp: timestamp,
			endAssetPosition: loadSecondMediaProductAssetPosition
		)
		assertPlayLogEvent(actualPlayLogEvent: playLogEvent1, expectedPlayLogEvent: expectedPlayLogEvent1)

		let playLogEvent2 = playerEventSender.playLogEvents[1]
		let expectedPlayLogEvent2 = PlayLogEvent.mock(
			startAssetPosition: 0,
			requestedProductId: mediaProduct2.productId,
			actualProductId: mediaProduct2.productId,
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: Constants.PlayLogSource.long.sourceType,
			sourceId: Constants.PlayLogSource.long.sourceId,
			actions: [],
			endTimestamp: timestamp,
			endAssetPosition: resetAssetPosition
		)
		assertPlayLogEvent(actualPlayLogEvent: playLogEvent2, expectedPlayLogEvent: expectedPlayLogEvent2)
	}

	func test_load_and_play_and_resetPlayerEngine_and_setUpANewPlayerEngine_and_load_and_play_same_track_and_reset() {
		// GIVEN
		// First we load the media product and then proceed to play it.
		uuid = "uuid1"
		let shortAudioFile = shortAudioFile
		setAudioFileResponseToURLProtocol(audioFile: shortAudioFile)
		let mediaProduct1 = shortAudioFile.mediaProduct
		playerEngine.load(mediaProduct1, timestamp: timestamp)

		optimizedWait {
			self.playerEngine.currentItem != nil
		}
		guard let currentItem = playerEngine.currentItem else {
			XCTFail("Expected for the currentItem to be set up!")
			return
		}

		playerEngine.play(timestamp: timestamp)
		waitForPlayerToBeInState(.PLAYING)

		// Wait for the track to reach 2 seconds
		let loadSecondTimeAssetPosition: Double = 2
		wait(for: currentItem, toReach: loadSecondTimeAssetPosition)

		// Simulate Player.load() is called.
		// This is in order to simulate the following scenario: load and play a track, load and play another track.
		playerEngine.notificationsHandler = nil
		playerEngine.resetOrUnload()

		// Wait for the player engine state to be IDLE.
		waitForPlayerToBeInState(.IDLE)

		setUpPlayerEngine()

		// Now we load the same media product and then proceed to play it.
		let mediaProduct2 = shortAudioFile.mediaProduct
		playerEngine.load(mediaProduct2, timestamp: timestamp)

		optimizedWait {
			self.playerEngine.currentItem != nil
		}
		guard let nextCurrentItem = playerEngine.currentItem else {
			XCTFail("Expected for the currentItem to be set up!")
			return
		}

		playerEngine.play(timestamp: timestamp)
		waitForPlayerToBeInState(.PLAYING)

		// Wait for the track to reach 1 second
		let resetAssetPosition: Double = 1
		wait(for: nextCurrentItem, toReach: resetAssetPosition)

		playerEngine.reset()

		// THEN
		waitForPlayerToBeInState(.IDLE)
		optimizedWait {
			self.playerEventSender.playLogEvents.count == 2
		}

		let playLogEvent1 = playerEventSender.playLogEvents[0]
		let expectedPlayLogEvent1 = PlayLogEvent.mock(
			startAssetPosition: 0,
			requestedProductId: mediaProduct1.productId,
			actualProductId: mediaProduct1.productId,
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: Constants.PlayLogSource.short.sourceType,
			sourceId: Constants.PlayLogSource.short.sourceId,
			actions: [],
			endTimestamp: timestamp,
			endAssetPosition: loadSecondTimeAssetPosition
		)
		assertPlayLogEvent(actualPlayLogEvent: playLogEvent1, expectedPlayLogEvent: expectedPlayLogEvent1)

		let playLogEvent2 = playerEventSender.playLogEvents[1]
		let expectedPlayLogEvent2 = PlayLogEvent.mock(
			startAssetPosition: 0,
			requestedProductId: mediaProduct2.productId,
			actualProductId: mediaProduct2.productId,
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: Constants.PlayLogSource.short.sourceType,
			sourceId: Constants.PlayLogSource.short.sourceId,
			actions: [],
			endTimestamp: timestamp,
			endAssetPosition: resetAssetPosition
		)
		assertPlayLogEvent(actualPlayLogEvent: playLogEvent2, expectedPlayLogEvent: expectedPlayLogEvent2)
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
			"Expected sourceType to be \(String(describing: expectedPlayLogEvent.sourceType)) but got \(String(describing: actualPlayLogEvent.sourceType))"
		)
		XCTAssertEqual(
			actualPlayLogEvent.sourceId,
			expectedPlayLogEvent.sourceId,
			"Expected sourceId to be \(String(describing: expectedPlayLogEvent.sourceId)) but got \(String(describing: actualPlayLogEvent.sourceId))"
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
			XCTestExpectation(description: "Expected for the track to reach \(targetAssetPosition) second(s)")

		var timer: Timer?
		DispatchQueue.main.async {
			timer = Timer.scheduledTimer(withTimeInterval: Constants.timerTimeInterval, repeats: true) { timer in
				if playerItem.assetPosition >= targetAssetPosition {
					trackReachedAssetPositionExpectation.fulfill()
					timer.invalidate()
				}
			}
			RunLoop.main.add(timer!, forMode: .default)
		}

		wait(for: [trackReachedAssetPositionExpectation], timeout: targetAssetPosition + Constants.expectationExtraTime)
		timer?.invalidate()
	}

	func waitForPlayerToBeInState(_ state: State, timeout: TimeInterval = Constants.expectationExtraTime) {
		let pauseTrackExpectation = XCTestExpectation(description: "Expected for the player's state to change to \(state)")

		var timer: Timer?
		DispatchQueue.main.async {
			timer = Timer.scheduledTimer(withTimeInterval: Constants.timerTimeInterval, repeats: true) { timer in
				if self.playerEngine.getState() == state {
					pauseTrackExpectation.fulfill()
					timer.invalidate()
				}
			}
			RunLoop.main.add(timer!, forMode: .default)
		}

		wait(for: [pauseTrackExpectation], timeout: timeout)
		timer?.invalidate()
	}
}

// MARK: - Setup Helpers

private extension PlayLogTests {
	func setUpPlayerEngine() {
		playerLoader = InternalPlayerLoader(
			with: configuration,
			and: fairplayLicenseFetcher,
			featureFlagProvider: featureFlagProvider,
			credentialsProvider: credentialsProvider,
			mainPlayer: Player.mainPlayerType(featureFlagProvider),
			externalPlayers: []
		)

		let operationQueue = OperationQueue()
		operationQueue.maxConcurrentOperationCount = 1
		operationQueue.qualityOfService = .userInitiated
		operationQueue.name = "com.tidal.player.testplayeroperationqueue"

		playerEngine = PlayerEngine.mock(
			queue: operationQueue,
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			fairplayLicenseFetcher: fairplayLicenseFetcher,
			djProducer: djProducer,
			configuration: configuration,
			playerEventSender: playerEventSender,
			networkMonitor: networkMonitor,
			storage: storage,
			playerLoader: playerLoader,
			featureFlagProvider: featureFlagProvider,
			notificationsHandler: notificationsHandler
		)

		djProducer.delegate = playerEngine
	}

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
