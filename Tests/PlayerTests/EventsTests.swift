import Auth

// swiftlint:disable file_length force_cast type_body_length
import Foundation
@testable import Player
import XCTest

// MARK: - Constants

private enum Constants {
	static let error = NSError(domain: "mockDomain", code: 1, userInfo: nil)
	static let anErrorErrorMessage = "The operation couldn’t be completed. (PlayerTests.AnError error 1.)"
	static let mockErrorMessage = "The operation couldn’t be completed. (mock error 1.)"
	static let stallErrorMessage = "The operation couldn’t be completed. (Stall error 1.)"
	static let errorCode = "14:1"

	static let duration = Int(PlayerMock.duration) * 1000

	static let trackPlaybackInfo = TrackPlaybackInfo.mock()
	static let mediaProduct = MediaProduct.mock()
	static let mediaProduct2 = MediaProduct.mock(productId: "productId2")
	static let mediaProduct3 = MediaProduct.mock(productId: "productId3")

	static let networkType: NetworkType = .MOBILE
}

// MARK: - EventsTests

final class EventsTests: XCTestCase {
	private var timestamp: UInt64 = 1
	private var uuid = "uuid"

	private var configuration: Configuration!
	private var errorManager: ErrorManagerMock!
	private var urlSession: URLSession!
	private var httpClient: HttpClient!
	private var accessTokenProvider: AuthTokenProviderMock!
	private var credentialsProvider: CredentialsProviderMock!
	private var dataWriter: DataWriterMock!
	private var playerEventSender: PlayerEventSenderMock!

	private var listener: PlayerListenerMock!
	private var listenerQueue: DispatchQueue!

	private var notificationsHandler: NotificationsHandler!
	private var networkMonitor: NetworkMonitorMock!
	private var djProducer: DJProducer!
	private var playbackInfoFetcher: PlaybackInfoFetcher!
	private var fairplayLicenseFetcher: FairPlayLicenseFetcher!
	private var playerLoader: PlayerLoaderMock!
	private var playerEngine: PlayerEngine!
	private var player: PlayerMock!
	private var shouldUseEventProducer: Bool = false

	override func setUp() {
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
		networkMonitor = NetworkMonitorMock()
		networkMonitor.networkType = Constants.networkType

		PlayerWorld = PlayerWorldClient.mock(timeProvider: timeProvider, uuidProvider: uuidProvider)

		var featureFlagProvider = FeatureFlagProvider.mock
		featureFlagProvider.shouldUseEventProducer = {
			self.shouldUseEventProducer
		}

		// Set up EventSender
		configuration = Configuration.mock()

		let sessionConfiguration = URLSessionConfiguration.default
		sessionConfiguration.protocolClasses = [JsonEncodedResponseURLProtocol.self]
		urlSession = URLSession(configuration: sessionConfiguration)
		errorManager = ErrorManagerMock()
		httpClient = HttpClient.mock(
			urlSession: urlSession,
			responseErrorManager: errorManager,
			networkErrorManager: errorManager,
			timeoutErrorManager: errorManager
		)

		accessTokenProvider = AuthTokenProviderMock()
		credentialsProvider = CredentialsProviderMock()
		dataWriter = DataWriterMock()

		playerEventSender = PlayerEventSenderMock(
			configuration: configuration,
			httpClient: httpClient,
			accessTokenProvider: accessTokenProvider,
			credentialsProvider: credentialsProvider,
			dataWriter: dataWriter,
			featureFlagProvider: featureFlagProvider
		)

		// Set up Player

		listener = PlayerListenerMock()
		listenerQueue = DispatchQueue(label: "com.tidal.queue.for.testing")
		notificationsHandler = NotificationsHandler(listener: listener, queue: listenerQueue)

		djProducer = DJProducer(
			httpClient: httpClient,
			with: accessTokenProvider,
			credentialsProvider: credentialsProvider,
			featureFlagProvider: featureFlagProvider
		)

		playbackInfoFetcher = PlaybackInfoFetcher(
			with: configuration,
			httpClient,
			accessTokenProvider,
			credentialsProvider,
			networkMonitor,
			and: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)

		fairplayLicenseFetcher = FairPlayLicenseFetcher(
			with: httpClient,
			accessTokenProvider,
			credentialsProvider: credentialsProvider,
			and: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)
		playerLoader = PlayerLoaderMock(with: configuration, and: fairplayLicenseFetcher)

		playerEngine = PlayerEngine.mock(
			queue: OperationQueueMock(),
			httpClient: httpClient,
			accessTokenProvider: accessTokenProvider,
			credentialsProvider: credentialsProvider,
			fairplayLicenseFetcher: fairplayLicenseFetcher,
			djProducer: djProducer,
			playerEventSender: playerEventSender,
			networkMonitor: networkMonitor,
			playerLoader: playerLoader,
			featureFlagProvider: featureFlagProvider,
			notificationsHandler: notificationsHandler
		)

		player = playerLoader.player

		credentialsProvider.injectSuccessfulUserLevelCredentials()
	}

	override func tearDown() {
		JsonEncodedResponseURLProtocol.reset()
		player.reset()
	}

	func testCsssCpbiAndCsseSentAfterSuccessfulLoadAndReset() {
		shouldUseEventProducer = true
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		JsonEncodedResponseURLProtocol.succeed(with: Constants.trackPlaybackInfo)

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 0)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 0)
		XCTAssertEqual(playerEventSender.progressEvents.count, 0)

		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp
		playerEngine.load(Constants.mediaProduct, timestamp: initialTimestamp)

		player.loaded()
		playerEngine.reset()

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 3)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 0)
		XCTAssertEqual(playerEventSender.progressEvents.count, 0)

		let actualStreamingSessionStartEvent = playerEventSender.streamingMetricsEvents[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(startReason: .EXPLICIT)
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = playerEventSender.streamingMetricsEvents[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			startTimestamp: initialTimestamp,
			endTimestamp: initialTimestamp,
			endReason: .COMPLETE
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)

		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[2] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: initialTimestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)
	}

	func testCsssCpbiAndCsseSentAfterSuccessfulLoadAndReset_legacy() {
		shouldUseEventProducer = true
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		JsonEncodedResponseURLProtocol.succeed(with: Constants.trackPlaybackInfo)

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 0)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 0)
		XCTAssertEqual(playerEventSender.progressEvents.count, 0)

		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp
		playerEngine.load(Constants.mediaProduct, timestamp: initialTimestamp)

		player.loaded()
		playerEngine.reset()

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 3)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 0)
		XCTAssertEqual(playerEventSender.progressEvents.count, 0)

		let actualStreamingSessionStartEvent = playerEventSender.streamingMetricsEvents[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(startReason: .EXPLICIT)
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = playerEventSender.streamingMetricsEvents[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			startTimestamp: initialTimestamp,
			endTimestamp: initialTimestamp,
			endReason: .COMPLETE
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)

		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[2] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: initialTimestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)
	}

	func testCsssCpbiAndCsseSentAfterSuccessfulLoadAndReset_legacy2() {
		assertCsssCpbiAndCsseSentAfterSuccessfulLoadAndReset_legacy(shouldSendEventsInDeinit: true)
	}

	func testCsssCpbiAndCsseSentAfterSuccessfulLoadAndReset_legacy3() {
		assertCsssCpbiAndCsseSentAfterSuccessfulLoadAndReset_legacy(shouldSendEventsInDeinit: false)
	}

	func assertCsssCpbiAndCsseSentAfterSuccessfulLoadAndReset_legacy(shouldSendEventsInDeinit: Bool) {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = shouldSendEventsInDeinit

		JsonEncodedResponseURLProtocol.succeed(with: Constants.trackPlaybackInfo)

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 0)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 0)
		XCTAssertEqual(playerEventSender.progressEvents.count, 0)

		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp

		let mediaProduct = Constants.mediaProduct
		playerEngine.load(mediaProduct, timestamp: initialTimestamp)

		player.loaded()
		playerEngine.reset()

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 3)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 0)
		XCTAssertEqual(playerEventSender.progressEvents.count, 0)

		let actualStreamingSessionStartEvent = playerEventSender.streamingMetricsEvents[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(startReason: .EXPLICIT)
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = playerEventSender.streamingMetricsEvents[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			startTimestamp: initialTimestamp,
			endTimestamp: initialTimestamp,
			endReason: .COMPLETE
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)

		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[2] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: initialTimestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)
	}

	func testCsssCpbiAndCsseSentAfterFailedLoad() {
		shouldUseEventProducer = true
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		JsonEncodedResponseURLProtocol.fail()

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 0)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 0)
		XCTAssertEqual(playerEventSender.progressEvents.count, 0)

		let initialTimestamp: UInt64 = 1
		playerEngine.load(Constants.mediaProduct, timestamp: initialTimestamp)

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 3)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 0)
		XCTAssertEqual(playerEventSender.progressEvents.count, 0)

		let actualStreamingSessionStartEvent = playerEventSender.streamingMetricsEvents[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(startReason: .EXPLICIT)
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = playerEventSender.streamingMetricsEvents[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			startTimestamp: initialTimestamp,
			endTimestamp: initialTimestamp,
			endReason: .ERROR,
			errorMessage: Constants.anErrorErrorMessage,
			errorCode: Constants.errorCode
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)

		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[2] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock()
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)
	}

	func testCsssCpbiAndCsseSentAfterFailedLoad_legacy() {
		shouldUseEventProducer = true
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		JsonEncodedResponseURLProtocol.fail()

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 0)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 0)
		XCTAssertEqual(playerEventSender.progressEvents.count, 0)

		let initialTimestamp: UInt64 = 1
		playerEngine.load(Constants.mediaProduct, timestamp: initialTimestamp)

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 3)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 0)
		XCTAssertEqual(playerEventSender.progressEvents.count, 0)

		let actualStreamingSessionStartEvent = playerEventSender.streamingMetricsEvents[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(startReason: .EXPLICIT)
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = playerEventSender.streamingMetricsEvents[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			startTimestamp: initialTimestamp,
			endTimestamp: initialTimestamp,
			endReason: .ERROR,
			errorMessage: Constants.anErrorErrorMessage,
			errorCode: Constants.errorCode
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)

		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[2] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock()
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)
	}

	func testCsssCpbiAndCsseSentAfterFailedLoad_legacy2() {
		assertCsssCpbiAndCsseSentAfterFailedLoad_legacy(shouldSendEventsInDeinit: true)
	}

	func testCsssCpbiAndCsseSentAfterFailedLoad_legacy3() {
		assertCsssCpbiAndCsseSentAfterFailedLoad_legacy(shouldSendEventsInDeinit: false)
	}

	func assertCsssCpbiAndCsseSentAfterFailedLoad_legacy(shouldSendEventsInDeinit: Bool) {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = shouldSendEventsInDeinit

		JsonEncodedResponseURLProtocol.fail()

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 0)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 0)
		XCTAssertEqual(playerEventSender.progressEvents.count, 0)

		let initialTimestamp: UInt64 = 1
		playerEngine.load(Constants.mediaProduct, timestamp: initialTimestamp)

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 3)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 0)
		XCTAssertEqual(playerEventSender.progressEvents.count, 0)

		let actualStreamingSessionStartEvent = playerEventSender.streamingMetricsEvents[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(startReason: .EXPLICIT)
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = playerEventSender.streamingMetricsEvents[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			startTimestamp: initialTimestamp,
			endTimestamp: initialTimestamp,
			endReason: .ERROR,
			errorMessage: Constants.anErrorErrorMessage,
			errorCode: Constants.errorCode
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)

		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[2] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock()
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)
	}

	func testCsssAndCpbiSentAfterSkipToNext() {
		shouldUseEventProducer = true
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp

		let mediaProduct1 = Constants.mediaProduct
		uuid = mediaProduct1.productId
		playerEngine.load(mediaProduct1, timestamp: initialTimestamp)
		player.loaded()

		player.downloaded()
		playerEventSender.reset()

		let nextTimestamp: UInt64 = 2
		timestamp = nextTimestamp
		let mediaProduct2 = Constants.mediaProduct2
		uuid = mediaProduct2.productId
		playerEngine.setNext(mediaProduct2, timestamp: nextTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 3
		playerEngine.play(timestamp: playTimestamp)
		player.playing()

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 2)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 0)
		XCTAssertEqual(playerEventSender.progressEvents.count, 0)

		let actualStreamingSessionStartEvent = playerEventSender.streamingMetricsEvents[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(
			streamingSessionId: mediaProduct2.productId,
			startReason: .IMPLICIT,
			timestamp: nextTimestamp,
			sessionProductId: mediaProduct2.productId
		)
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = playerEventSender.streamingMetricsEvents[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			streamingSessionId: mediaProduct2.productId,
			startTimestamp: nextTimestamp,
			endTimestamp: nextTimestamp,
			endReason: .COMPLETE
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)

		let skipToNextTimestamp: UInt64 = 4
		timestamp = skipToNextTimestamp
		playerEngine.skipToNext(timestamp: skipToNextTimestamp)

		let actualPlaybackStatistics = playerEventSender.streamingMetricsEvents[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			streamingSessionId: mediaProduct1.productId,
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: nextTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endReason: EndReason.OTHER.rawValue,
			endTimestamp: skipToNextTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		player.playing()
		player.completed()

		// Events of the second item
		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(
			streamingSessionId: mediaProduct1.productId,
			timestamp: timestamp
		)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlaybackStatistics2 = playerEventSender.streamingMetricsEvents[4] as! PlaybackStatistics
		let expectedPlaybackStatistics2 = PlaybackStatistics.mock(
			streamingSessionId: mediaProduct2.productId,
			idealStartTimestamp: skipToNextTimestamp,
			actualStartTimestamp: skipToNextTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endTimestamp: skipToNextTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics2, expectedEvent: expectedPlaybackStatistics2)

		let actualStreamingSessionEndEvent2 = playerEventSender.streamingMetricsEvents[5] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent2 = StreamingSessionEnd.mock(
			streamingSessionId: mediaProduct2.productId,
			timestamp: timestamp
		)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent2, expectedEvent: expectedStreamingSessionEndEvent2)
	}

	func testCsssAndCpbiSentAfterSkipToNext_legacy() {
		shouldUseEventProducer = true
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp

		let mediaProduct1 = Constants.mediaProduct
		uuid = mediaProduct1.productId
		playerEngine.load(mediaProduct1, timestamp: initialTimestamp)
		player.loaded()

		player.downloaded()
		playerEventSender.reset()

		let nextTimestamp: UInt64 = 2
		timestamp = nextTimestamp
		let mediaProduct2 = Constants.mediaProduct2
		uuid = mediaProduct2.productId
		playerEngine.setNext(mediaProduct2, timestamp: nextTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 3
		playerEngine.play(timestamp: playTimestamp)
		player.playing()

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 2)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 0)
		XCTAssertEqual(playerEventSender.progressEvents.count, 0)

		let actualStreamingSessionStartEvent = playerEventSender.streamingMetricsEvents[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(
			streamingSessionId: mediaProduct2.productId,
			startReason: .IMPLICIT,
			timestamp: nextTimestamp,
			sessionProductId: mediaProduct2.productId
		)
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = playerEventSender.streamingMetricsEvents[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			streamingSessionId: mediaProduct2.productId,
			startTimestamp: nextTimestamp,
			endTimestamp: nextTimestamp,
			endReason: .COMPLETE
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)

		let skipToNextTimestamp: UInt64 = 4
		timestamp = skipToNextTimestamp
		playerEngine.skipToNext(timestamp: skipToNextTimestamp)

		let actualPlaybackStatistics = playerEventSender.streamingMetricsEvents[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			streamingSessionId: mediaProduct1.productId,
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: nextTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endReason: EndReason.OTHER.rawValue,
			endTimestamp: skipToNextTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		player.playing()
		player.completed()

		// Events of the second item
		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(
			streamingSessionId: mediaProduct1.productId,
			timestamp: timestamp
		)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlaybackStatistics2 = playerEventSender.streamingMetricsEvents[4] as! PlaybackStatistics
		let expectedPlaybackStatistics2 = PlaybackStatistics.mock(
			streamingSessionId: mediaProduct2.productId,
			idealStartTimestamp: skipToNextTimestamp,
			actualStartTimestamp: skipToNextTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endTimestamp: skipToNextTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics2, expectedEvent: expectedPlaybackStatistics2)

		let actualStreamingSessionEndEvent2 = playerEventSender.streamingMetricsEvents[5] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent2 = StreamingSessionEnd.mock(
			streamingSessionId: mediaProduct2.productId,
			timestamp: timestamp
		)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent2, expectedEvent: expectedStreamingSessionEndEvent2)
	}

	func testCsssAndCpbiSentAfterSkipToNext_legacy2() {
		assertCsssAndCpbiSentAfterSkipToNext_legacy(shouldSendEventsInDeinit: true)
	}

	func testCsssAndCpbiSentAfterSkipToNext_legacy3() {
		assertCsssAndCpbiSentAfterSkipToNext_legacy(shouldSendEventsInDeinit: false)
	}

	func assertCsssAndCpbiSentAfterSkipToNext_legacy(shouldSendEventsInDeinit: Bool) {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = shouldSendEventsInDeinit

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp

		let mediaProduct1 = Constants.mediaProduct
		uuid = mediaProduct1.productId
		playerEngine.load(mediaProduct1, timestamp: initialTimestamp)
		player.loaded()

		player.downloaded()
		playerEventSender.reset()

		let nextTimestamp: UInt64 = 2
		timestamp = nextTimestamp
		let mediaProduct2 = Constants.mediaProduct2
		uuid = mediaProduct2.productId
		playerEngine.setNext(mediaProduct2, timestamp: nextTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 3
		playerEngine.play(timestamp: playTimestamp)
		player.playing()

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 2)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 0)
		XCTAssertEqual(playerEventSender.progressEvents.count, 0)

		let actualStreamingSessionStartEvent = playerEventSender.streamingMetricsEvents[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(
			streamingSessionId: mediaProduct2.productId,
			startReason: .IMPLICIT,
			timestamp: nextTimestamp,
			sessionProductId: mediaProduct2.productId
		)
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = playerEventSender.streamingMetricsEvents[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			streamingSessionId: mediaProduct2.productId,
			startTimestamp: nextTimestamp,
			endTimestamp: nextTimestamp,
			endReason: .COMPLETE
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)

		let skipToNextTimestamp: UInt64 = 4
		timestamp = skipToNextTimestamp
		playerEngine.skipToNext(timestamp: skipToNextTimestamp)

		let actualPlaybackStatistics = playerEventSender.streamingMetricsEvents[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			streamingSessionId: mediaProduct1.productId,
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: nextTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endReason: EndReason.OTHER.rawValue,
			endTimestamp: skipToNextTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		player.playing()
		player.completed()

		// Events of the second item
		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(
			streamingSessionId: mediaProduct1.productId,
			timestamp: timestamp
		)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlaybackStatistics2 = playerEventSender.streamingMetricsEvents[4] as! PlaybackStatistics
		let expectedPlaybackStatistics2 = PlaybackStatistics.mock(
			streamingSessionId: mediaProduct2.productId,
			idealStartTimestamp: skipToNextTimestamp,
			actualStartTimestamp: skipToNextTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endTimestamp: skipToNextTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics2, expectedEvent: expectedPlaybackStatistics2)

		let actualStreamingSessionEndEvent2 = playerEventSender.streamingMetricsEvents[5] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent2 = StreamingSessionEnd.mock(
			streamingSessionId: mediaProduct2.productId,
			timestamp: timestamp
		)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent2, expectedEvent: expectedStreamingSessionEndEvent2)
	}

	func testCsssAndCpbiSentAfterSuccessfulLoadOfNext() {
		shouldUseEventProducer = true
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		JsonEncodedResponseURLProtocol.succeed(with: Constants.trackPlaybackInfo)

		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp
		playerEngine.load(Constants.mediaProduct, timestamp: initialTimestamp)
		player.loaded()

		player.downloaded()
		playerEventSender.reset()

		let nextTimestamp: UInt64 = 2
		timestamp = nextTimestamp
		playerEngine.setNext(Constants.mediaProduct, timestamp: nextTimestamp)
		player.loaded()

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 2)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 0)
		XCTAssertEqual(playerEventSender.progressEvents.count, 0)

		let actualStreamingSessionStartEvent = playerEventSender.streamingMetricsEvents[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(startReason: .IMPLICIT, timestamp: nextTimestamp)
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = playerEventSender.streamingMetricsEvents[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			startTimestamp: nextTimestamp,
			endTimestamp: nextTimestamp,
			endReason: .COMPLETE
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)
	}

	func testCsssAndCpbiSentAfterSuccessfulLoadOfNext_legacy() {
		shouldUseEventProducer = true
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		JsonEncodedResponseURLProtocol.succeed(with: Constants.trackPlaybackInfo)

		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp
		playerEngine.load(Constants.mediaProduct, timestamp: initialTimestamp)
		player.loaded()

		player.downloaded()
		playerEventSender.reset()

		let nextTimestamp: UInt64 = 2
		timestamp = nextTimestamp
		playerEngine.setNext(Constants.mediaProduct, timestamp: nextTimestamp)
		player.loaded()

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 2)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 0)
		XCTAssertEqual(playerEventSender.progressEvents.count, 0)

		let actualStreamingSessionStartEvent = playerEventSender.streamingMetricsEvents[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(startReason: .IMPLICIT, timestamp: nextTimestamp)
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = playerEventSender.streamingMetricsEvents[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			startTimestamp: nextTimestamp,
			endTimestamp: nextTimestamp,
			endReason: .COMPLETE
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)
	}

	func testCsssAndCpbiSentAfterSuccessfulLoadOfNext_legacy2() {
		assertCsssAndCpbiSentAfterSuccessfulLoadOfNext_legacy(shouldSendEventsInDeinit: true)
	}

	func testCsssAndCpbiSentAfterSuccessfulLoadOfNext_legacy3() {
		assertCsssAndCpbiSentAfterSuccessfulLoadOfNext_legacy(shouldSendEventsInDeinit: false)
	}

	func assertCsssAndCpbiSentAfterSuccessfulLoadOfNext_legacy(shouldSendEventsInDeinit: Bool) {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = shouldSendEventsInDeinit

		JsonEncodedResponseURLProtocol.succeed(with: Constants.trackPlaybackInfo)

		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp
		playerEngine.load(Constants.mediaProduct, timestamp: initialTimestamp)
		player.loaded()

		player.downloaded()
		playerEventSender.reset()

		let nextTimestamp: UInt64 = 2
		timestamp = nextTimestamp
		playerEngine.setNext(Constants.mediaProduct, timestamp: nextTimestamp)
		player.loaded()

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 2)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 0)
		XCTAssertEqual(playerEventSender.progressEvents.count, 0)

		let actualStreamingSessionStartEvent = playerEventSender.streamingMetricsEvents[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(startReason: .IMPLICIT, timestamp: nextTimestamp)
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = playerEventSender.streamingMetricsEvents[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			startTimestamp: nextTimestamp,
			endTimestamp: nextTimestamp,
			endReason: .COMPLETE
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)
	}

	func testCsssAndCpbiSentAfterNextIsReplaced() {
		shouldUseEventProducer = true
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		JsonEncodedResponseURLProtocol.succeed(with: Constants.trackPlaybackInfo)

		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp

		let mediaProduct1 = Constants.mediaProduct
		uuid = mediaProduct1.productId
		playerEngine.load(mediaProduct1, timestamp: initialTimestamp)
		player.loaded()

		player.downloaded()

		let mediaProduct2 = Constants.mediaProduct2
		uuid = mediaProduct2.productId
		playerEngine.setNext(mediaProduct2, timestamp: 2)
		player.loaded()

		let nextTimestamp: UInt64 = 3
		timestamp = nextTimestamp

		let mediaProduct3 = Constants.mediaProduct3
		uuid = mediaProduct3.productId
		playerEngine.setNext(mediaProduct3, timestamp: nextTimestamp)
		player.loaded()

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 7)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 0)
		XCTAssertEqual(playerEventSender.progressEvents.count, 0)

		let actualStreamingSessionStartEvent = playerEventSender.streamingMetricsEvents[5] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(
			streamingSessionId: mediaProduct3.productId,
			startReason: .IMPLICIT,
			timestamp: nextTimestamp,
			sessionProductId: mediaProduct3.productId
		)
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = playerEventSender.streamingMetricsEvents[6] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			streamingSessionId: mediaProduct3.productId,
			startTimestamp: nextTimestamp,
			endTimestamp: nextTimestamp,
			endReason: .COMPLETE
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)
	}

	func testCsssAndCpbiSentAfterNextIsReplaced_legacy() {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		JsonEncodedResponseURLProtocol.succeed(with: Constants.trackPlaybackInfo)

		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp
		playerEngine.load(Constants.mediaProduct, timestamp: initialTimestamp)
		player.loaded()

		player.downloaded()

		playerEngine.setNext(Constants.mediaProduct, timestamp: 2)
		player.loaded()

		let nextTimestamp: UInt64 = 3
		timestamp = nextTimestamp

		playerEngine.setNext(Constants.mediaProduct, timestamp: nextTimestamp)
		player.loaded()

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 7)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 0)
		XCTAssertEqual(playerEventSender.progressEvents.count, 0)

		let actualStreamingSessionStartEvent = playerEventSender.streamingMetricsEvents[5] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(startReason: .IMPLICIT, timestamp: nextTimestamp)
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = playerEventSender.streamingMetricsEvents[6] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			startTimestamp: nextTimestamp,
			endTimestamp: nextTimestamp,
			endReason: .COMPLETE
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)
	}

	func testCsssAndCpbiSentAfterNextIsReplaced_legacy2() {
		assertCsssAndCpbiSentAfterNextIsReplaced_legacy(shouldSendEventsInDeinit: true)
	}

	func testCsssAndCpbiSentAfterNextIsReplaced_legacy3() {
		assertCsssAndCpbiSentAfterNextIsReplaced_legacy(shouldSendEventsInDeinit: false)
	}

	func assertCsssAndCpbiSentAfterNextIsReplaced_legacy(shouldSendEventsInDeinit: Bool) {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = shouldSendEventsInDeinit

		JsonEncodedResponseURLProtocol.succeed(with: Constants.trackPlaybackInfo)

		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp

		let mediaProduct1 = Constants.mediaProduct
		uuid = mediaProduct1.productId
		playerEngine.load(mediaProduct1, timestamp: initialTimestamp)
		player.loaded()

		player.downloaded()

		let mediaProduct2 = Constants.mediaProduct2
		uuid = mediaProduct2.productId
		playerEngine.setNext(mediaProduct2, timestamp: 2)
		player.loaded()

		let nextTimestamp: UInt64 = 3
		timestamp = nextTimestamp

		let mediaProduct3 = Constants.mediaProduct3
		uuid = mediaProduct3.productId
		playerEngine.setNext(mediaProduct3, timestamp: nextTimestamp)
		player.loaded()

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 7)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 0)
		XCTAssertEqual(playerEventSender.progressEvents.count, 0)

		let actualStreamingSessionStartEvent = playerEventSender.streamingMetricsEvents[5] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(
			streamingSessionId: mediaProduct3.productId,
			startReason: .IMPLICIT,
			timestamp: nextTimestamp,
			sessionProductId: mediaProduct3.productId
		)
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = playerEventSender.streamingMetricsEvents[6] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			streamingSessionId: mediaProduct3.productId,
			startTimestamp: nextTimestamp,
			endTimestamp: nextTimestamp,
			endReason: .COMPLETE
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)
	}

	func testCsssAndCpbiSentAfterFailedLoadOfNext() {
		shouldUseEventProducer = true
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		JsonEncodedResponseURLProtocol.succeed(with: Constants.trackPlaybackInfo)

		playerEngine.load(Constants.mediaProduct, timestamp: 1)
		player.loaded()

		player.downloaded()
		playerEventSender.reset()

		JsonEncodedResponseURLProtocol.fail()

		let nextTimestamp: UInt64 = 2
		timestamp = nextTimestamp
		playerEngine.setNext(Constants.mediaProduct, timestamp: nextTimestamp)

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 2)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 0)
		XCTAssertEqual(playerEventSender.progressEvents.count, 0)

		let actualStreamingSessionStartEvent = playerEventSender.streamingMetricsEvents[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(startReason: .IMPLICIT, timestamp: nextTimestamp)
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = playerEventSender.streamingMetricsEvents[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			startTimestamp: nextTimestamp,
			endTimestamp: nextTimestamp,
			endReason: .ERROR,
			errorMessage: Constants.anErrorErrorMessage,
			errorCode: Constants.errorCode
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)
	}

	func testCsssAndCpbiSentAfterFailedLoadOfNext_legacy() {
		shouldUseEventProducer = true
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		JsonEncodedResponseURLProtocol.succeed(with: Constants.trackPlaybackInfo)

		playerEngine.load(Constants.mediaProduct, timestamp: 1)
		player.loaded()

		player.downloaded()
		playerEventSender.reset()

		JsonEncodedResponseURLProtocol.fail()

		let nextTimestamp: UInt64 = 2
		timestamp = nextTimestamp
		playerEngine.setNext(Constants.mediaProduct, timestamp: nextTimestamp)

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 2)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 0)
		XCTAssertEqual(playerEventSender.progressEvents.count, 0)

		let actualStreamingSessionStartEvent = playerEventSender.streamingMetricsEvents[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(startReason: .IMPLICIT, timestamp: nextTimestamp)
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = playerEventSender.streamingMetricsEvents[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			startTimestamp: nextTimestamp,
			endTimestamp: nextTimestamp,
			endReason: .ERROR,
			errorMessage: Constants.anErrorErrorMessage,
			errorCode: Constants.errorCode
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)
	}

	func testCsssAndCpbiSentAfterFailedLoadOfNext_legacy2() {
		assertCsssAndCpbiSentAfterFailedLoadOfNext_legacy(shouldSendEventsInDeinit: true)
	}

	func testCsssAndCpbiSentAfterFailedLoadOfNext_legacy3() {
		assertCsssAndCpbiSentAfterFailedLoadOfNext_legacy(shouldSendEventsInDeinit: false)
	}

	func assertCsssAndCpbiSentAfterFailedLoadOfNext_legacy(shouldSendEventsInDeinit: Bool) {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = shouldSendEventsInDeinit

		JsonEncodedResponseURLProtocol.succeed(with: Constants.trackPlaybackInfo)

		playerEngine.load(Constants.mediaProduct, timestamp: 1)
		player.loaded()

		player.downloaded()
		playerEventSender.reset()

		JsonEncodedResponseURLProtocol.fail()

		let nextTimestamp: UInt64 = 2
		timestamp = nextTimestamp
		playerEngine.setNext(Constants.mediaProduct, timestamp: nextTimestamp)

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 2)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 0)
		XCTAssertEqual(playerEventSender.progressEvents.count, 0)

		let actualStreamingSessionStartEvent = playerEventSender.streamingMetricsEvents[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(startReason: .IMPLICIT, timestamp: nextTimestamp)
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = playerEventSender.streamingMetricsEvents[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			startTimestamp: nextTimestamp,
			endTimestamp: nextTimestamp,
			endReason: .ERROR,
			errorMessage: Constants.anErrorErrorMessage,
			errorCode: Constants.errorCode
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)
	}

	func testPlayCurrentSucceeds() {
		shouldUseEventProducer = true
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let mediaProduct = Constants.mediaProduct
		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp
		playerEngine.load(mediaProduct, timestamp: initialTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 2
		timestamp = playTimestamp
		playerEngine.play(timestamp: playTimestamp)
		player.playing()

		let endTimestamp: UInt64 = 10
		let endAssetPosition: Double = 10
		timestamp = endTimestamp
		player.assetPosition = endAssetPosition
		player.completed()

		let events = playerEventSender.streamingMetricsEvents
		XCTAssertEqual(events.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualStreamingSessionStartEvent = events[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(startReason: .EXPLICIT)
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = events[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			startTimestamp: initialTimestamp,
			endTimestamp: initialTimestamp,
			endReason: .COMPLETE
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)

		let actualPlaybackStatistics = events[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: playTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endTimestamp: endTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = events[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: timestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			startTimestamp: playTimestamp,
			productType: mediaProduct.productType,
			requestedProductId: mediaProduct.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId,
			endTimestamp: endTimestamp,
			endAssetPosition: Double(endTimestamp)
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition,
			duration: Constants.duration,
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}

	func testPlayCurrentSucceeds_legacy() {
		shouldUseEventProducer = true
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let mediaProduct = Constants.mediaProduct
		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp
		playerEngine.load(mediaProduct, timestamp: initialTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 2
		timestamp = playTimestamp
		playerEngine.play(timestamp: playTimestamp)
		player.playing()

		let endTimestamp: UInt64 = 10
		let endAssetPosition: Double = 10
		timestamp = endTimestamp
		player.assetPosition = endAssetPosition
		player.completed()

		let events = playerEventSender.streamingMetricsEvents
		XCTAssertEqual(events.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualStreamingSessionStartEvent = events[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(startReason: .EXPLICIT)
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = events[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			startTimestamp: initialTimestamp,
			endTimestamp: initialTimestamp,
			endReason: .COMPLETE
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)

		let actualPlaybackStatistics = events[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: playTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endTimestamp: endTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = events[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: timestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			startTimestamp: playTimestamp,
			productType: mediaProduct.productType,
			requestedProductId: mediaProduct.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId,
			endTimestamp: endTimestamp,
			endAssetPosition: Double(endTimestamp)
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition,
			duration: Constants.duration,
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}

	func testPlayCurrentSucceeds_legacy2() {
		assertPlayCurrentSucceeds_legacy(shouldSendEventsInDeinit: true)
	}

	func testPlayCurrentSucceeds_legacy3() {
		assertPlayCurrentSucceeds_legacy(shouldSendEventsInDeinit: false)
	}

	func assertPlayCurrentSucceeds_legacy(shouldSendEventsInDeinit: Bool) {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = shouldSendEventsInDeinit

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let mediaProduct = Constants.mediaProduct
		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp
		playerEngine.load(mediaProduct, timestamp: initialTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 2
		timestamp = playTimestamp
		playerEngine.play(timestamp: playTimestamp)
		player.playing()

		let endTimestamp: UInt64 = 10
		let endAssetPosition: Double = 10
		timestamp = endTimestamp
		player.assetPosition = endAssetPosition
		player.completed()

		optimizedWait(until: {
			playerEventSender.streamingMetricsEvents.count == 4 &&
				playerEventSender.playLogEvents.count == 1 &&
				playerEventSender.progressEvents.count == 1
		})

		let events = playerEventSender.streamingMetricsEvents
		XCTAssertEqual(events.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualStreamingSessionStartEvent = events[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(startReason: .EXPLICIT)
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = events[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			startTimestamp: initialTimestamp,
			endTimestamp: initialTimestamp,
			endReason: .COMPLETE
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)

		let actualPlaybackStatistics = events[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: playTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endTimestamp: endTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = events[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: timestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			startTimestamp: playTimestamp,
			productType: mediaProduct.productType,
			requestedProductId: mediaProduct.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId,
			endTimestamp: endTimestamp,
			endAssetPosition: Double(endTimestamp)
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition,
			duration: Constants.duration,
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}

	///
	func testPlayCurrentSucceeds_withPreload() {
		shouldUseEventProducer = true
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let mediaProduct = Constants.mediaProduct
		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp
		playerEngine.load(mediaProduct, timestamp: 1, isPreload: true)

		player.loaded()

		let playTimestamp: UInt64 = 2
		timestamp = playTimestamp
		playerEngine.play(timestamp: 2)
		player.playing()

		let endTimestamp: UInt64 = 10
		let endAssetPosition: Double = 10
		timestamp = endTimestamp
		player.assetPosition = endAssetPosition
		player.completed()

		let events = playerEventSender.streamingMetricsEvents
		XCTAssertEqual(events.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualStreamingSessionStartEvent = events[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(startReason: .EXPLICIT, sessionTags: [.PRELOADED])
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = events[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			startTimestamp: initialTimestamp,
			endTimestamp: initialTimestamp,
			endReason: .COMPLETE
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)

		let actualPlaybackStatistics = events[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: playTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endTimestamp: endTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = events[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: timestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			startTimestamp: playTimestamp,
			productType: mediaProduct.productType,
			requestedProductId: mediaProduct.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId,
			endTimestamp: endTimestamp,
			endAssetPosition: Double(endTimestamp)
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition,
			duration: Constants.duration,
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}

	func testPlayCurrentSucceeds_withPreload_legacy() {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let mediaProduct = Constants.mediaProduct
		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp
		playerEngine.load(mediaProduct, timestamp: 1, isPreload: true)

		player.loaded()

		let playTimestamp: UInt64 = 2
		timestamp = playTimestamp
		playerEngine.play(timestamp: 2)
		player.playing()

		let endTimestamp: UInt64 = 10
		let endAssetPosition: Double = 10
		timestamp = endTimestamp
		player.assetPosition = endAssetPosition
		player.completed()

		optimizedWait {
			playerEventSender.streamingMetricsEvents.count == 4
		}

		let events = playerEventSender.streamingMetricsEvents
		XCTAssertEqual(events.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualStreamingSessionStartEvent = events[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(startReason: .EXPLICIT, sessionTags: [.PRELOADED])
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = events[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			startTimestamp: initialTimestamp,
			endTimestamp: initialTimestamp,
			endReason: .COMPLETE
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)

		let actualPlaybackStatistics = events[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: playTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endTimestamp: endTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = events[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: timestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			startTimestamp: playTimestamp,
			productType: mediaProduct.productType,
			requestedProductId: mediaProduct.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId,
			endTimestamp: endTimestamp,
			endAssetPosition: Double(endTimestamp)
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition,
			duration: Constants.duration,
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}

	func testPlayCurrentSucceeds_withPreload_legacy2() {
		assertPlayCurrentSucceeds_withPreload_legacy(shouldSendEventsInDeinit: true)
	}

	func testPlayCurrentSucceeds_withPreload_legacy3() {
		assertPlayCurrentSucceeds_withPreload_legacy(shouldSendEventsInDeinit: false)
	}

	func assertPlayCurrentSucceeds_withPreload_legacy(shouldSendEventsInDeinit: Bool) {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = shouldSendEventsInDeinit

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let mediaProduct = Constants.mediaProduct
		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp
		playerEngine.load(mediaProduct, timestamp: 1, isPreload: true)

		player.loaded()

		let playTimestamp: UInt64 = 2
		timestamp = playTimestamp
		playerEngine.play(timestamp: 2)
		player.playing()

		let endTimestamp: UInt64 = 10
		let endAssetPosition: Double = 10
		timestamp = endTimestamp
		player.assetPosition = endAssetPosition
		player.completed()

		let events = playerEventSender.streamingMetricsEvents
		XCTAssertEqual(events.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualStreamingSessionStartEvent = events[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(startReason: .EXPLICIT, sessionTags: [.PRELOADED])
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = events[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			startTimestamp: initialTimestamp,
			endTimestamp: initialTimestamp,
			endReason: .COMPLETE
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)

		let actualPlaybackStatistics = events[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: playTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endTimestamp: endTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = events[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: timestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			startTimestamp: playTimestamp,
			productType: mediaProduct.productType,
			requestedProductId: mediaProduct.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId,
			endTimestamp: endTimestamp,
			endAssetPosition: Double(endTimestamp)
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition,
			duration: Constants.duration,
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}

	func testPlayCurrentFails() {
		shouldUseEventProducer = true
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let mediaProduct = Constants.mediaProduct
		let initialTimestamp: UInt64 = 1
		playerEngine.load(mediaProduct, timestamp: initialTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 2
		playerEngine.play(timestamp: playTimestamp)
		player.playing()

		let endTimestamp: UInt64 = 5
		let endAssetPosition: Double = 5
		timestamp = endTimestamp
		player.assetPosition = endAssetPosition
		player.failed(with: Constants.error)

		let events = playerEventSender.streamingMetricsEvents
		XCTAssertEqual(events.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualStreamingSessionStartEvent = events[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(startReason: .EXPLICIT)
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = events[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			startTimestamp: initialTimestamp,
			endTimestamp: initialTimestamp,
			endReason: .COMPLETE
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)

		let actualPlaybackStatistics = events[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: initialTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endReason: EndReason.ERROR.rawValue,
			endTimestamp: endTimestamp,
			errorMessage: Constants.mockErrorMessage,
			errorCode: Constants.errorCode
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = events[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: timestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			startTimestamp: initialTimestamp,
			productType: mediaProduct.productType,
			requestedProductId: mediaProduct.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId,
			endTimestamp: endTimestamp,
			endAssetPosition: Double(endTimestamp)
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition,
			duration: Constants.duration,
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}

	func testPlayCurrentFails_legacy() {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let mediaProduct = Constants.mediaProduct
		let initialTimestamp: UInt64 = 1
		playerEngine.load(mediaProduct, timestamp: initialTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 2
		playerEngine.play(timestamp: playTimestamp)
		player.playing()

		let endTimestamp: UInt64 = 5
		let endAssetPosition: Double = 5
		timestamp = endTimestamp
		player.assetPosition = endAssetPosition
		player.failed(with: Constants.error)

		let events = playerEventSender.streamingMetricsEvents
		XCTAssertEqual(events.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualStreamingSessionStartEvent = events[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(startReason: .EXPLICIT)
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = events[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			startTimestamp: initialTimestamp,
			endTimestamp: initialTimestamp,
			endReason: .COMPLETE
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)

		let actualPlaybackStatistics = events[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: initialTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endReason: EndReason.ERROR.rawValue,
			endTimestamp: endTimestamp,
			errorMessage: Constants.mockErrorMessage,
			errorCode: Constants.errorCode
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = events[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: timestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			startTimestamp: initialTimestamp,
			productType: mediaProduct.productType,
			requestedProductId: mediaProduct.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId,
			endTimestamp: endTimestamp,
			endAssetPosition: Double(endTimestamp)
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition,
			duration: Constants.duration,
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}

	func testPlayCurrentFails_legacy2() {
		assertPlayCurrentFails_legacy(shouldSendEventsInDeinit: true)
	}

	func testPlayCurrentFails_legacy3() {
		assertPlayCurrentFails_legacy(shouldSendEventsInDeinit: false)
	}

	func assertPlayCurrentFails_legacy(shouldSendEventsInDeinit: Bool) {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = shouldSendEventsInDeinit

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let mediaProduct = Constants.mediaProduct
		let initialTimestamp: UInt64 = 1
		playerEngine.load(mediaProduct, timestamp: initialTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 2
		playerEngine.play(timestamp: playTimestamp)
		player.playing()

		let endTimestamp: UInt64 = 5
		let endAssetPosition: Double = 5
		timestamp = endTimestamp
		player.assetPosition = endAssetPosition
		player.failed(with: Constants.error)

		let events = playerEventSender.streamingMetricsEvents
		XCTAssertEqual(events.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualStreamingSessionStartEvent = events[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(startReason: .EXPLICIT)
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = events[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			startTimestamp: initialTimestamp,
			endTimestamp: initialTimestamp,
			endReason: .COMPLETE
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)

		let actualPlaybackStatistics = events[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: initialTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endReason: EndReason.ERROR.rawValue,
			endTimestamp: endTimestamp,
			errorMessage: Constants.mockErrorMessage,
			errorCode: Constants.errorCode
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = events[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: timestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			startTimestamp: initialTimestamp,
			productType: mediaProduct.productType,
			requestedProductId: mediaProduct.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId,
			endTimestamp: endTimestamp,
			endAssetPosition: Double(endTimestamp)
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition,
			duration: Constants.duration,
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}

	func testPlayCurrentReset() {
		shouldUseEventProducer = true
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let mediaProduct = Constants.mediaProduct
		let initialTimestamp: UInt64 = 1
		playerEngine.load(mediaProduct, timestamp: initialTimestamp)

		player.loaded()

		let playTimestamp: UInt64 = 2
		timestamp = playTimestamp
		playerEngine.play(timestamp: playTimestamp)
		player.playing()

		let endAssetPosition: Double = 5
		player.assetPosition = endAssetPosition

		// Set timestamp equal/higher than current media product, since events are sent afterwards, so to fake time has passed.
		let endTimestamp: UInt64 = 5
		timestamp = endTimestamp

		playerEngine.reset()

		let events = playerEventSender.streamingMetricsEvents
		XCTAssertEqual(events.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualStreamingSessionStartEvent = events[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(startReason: .EXPLICIT)
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = events[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			startTimestamp: initialTimestamp,
			endTimestamp: initialTimestamp,
			endReason: .COMPLETE
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)

		let actualPlaybackStatistics = events[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: playTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endReason: EndReason.OTHER.rawValue,
			endTimestamp: endTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = events[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: timestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			startTimestamp: playTimestamp,
			productType: mediaProduct.productType,
			requestedProductId: mediaProduct.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId,
			endTimestamp: endTimestamp,
			endAssetPosition: Double(endTimestamp)
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition,
			duration: Constants.duration,
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}

	func testPlayCurrentReset_legacy() {
		shouldUseEventProducer = true
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let mediaProduct = Constants.mediaProduct
		let initialTimestamp: UInt64 = 1
		playerEngine.load(mediaProduct, timestamp: initialTimestamp)

		player.loaded()

		let playTimestamp: UInt64 = 2
		timestamp = playTimestamp
		playerEngine.play(timestamp: playTimestamp)
		player.playing()

		let endAssetPosition: Double = 5
		player.assetPosition = endAssetPosition

		// Set timestamp equal/higher than current media product, since events are sent afterwards, so to fake time has passed.
		let endTimestamp: UInt64 = 5
		timestamp = endTimestamp

		playerEngine.reset()

		let events = playerEventSender.streamingMetricsEvents
		XCTAssertEqual(events.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualStreamingSessionStartEvent = events[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(startReason: .EXPLICIT)
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = events[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			startTimestamp: initialTimestamp,
			endTimestamp: initialTimestamp,
			endReason: .COMPLETE
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)

		let actualPlaybackStatistics = events[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: playTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endReason: EndReason.OTHER.rawValue,
			endTimestamp: endTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = events[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: timestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			startTimestamp: playTimestamp,
			productType: mediaProduct.productType,
			requestedProductId: mediaProduct.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId,
			endTimestamp: endTimestamp,
			endAssetPosition: Double(endTimestamp)
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition,
			duration: Constants.duration,
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}

	func testPlayCurrentReset_legacy2() {
		assertPlayCurrentReset_legacy(shouldSendEventsInDeinit: true)
	}

	func testPlayCurrentReset_legacy3() {
		assertPlayCurrentReset_legacy(shouldSendEventsInDeinit: false)
	}

	func assertPlayCurrentReset_legacy(shouldSendEventsInDeinit: Bool) {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = shouldSendEventsInDeinit

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let mediaProduct = Constants.mediaProduct
		let initialTimestamp: UInt64 = 1
		playerEngine.load(mediaProduct, timestamp: initialTimestamp)

		player.loaded()

		let playTimestamp: UInt64 = 2
		timestamp = playTimestamp
		playerEngine.play(timestamp: playTimestamp)
		player.playing()

		let endAssetPosition: Double = 5
		player.assetPosition = endAssetPosition

		// Set timestamp equal/higher than current media product, since events are sent afterwards, so to fake time has passed.
		let endTimestamp: UInt64 = 5
		timestamp = endTimestamp

		playerEngine.reset()

		let events = playerEventSender.streamingMetricsEvents
		XCTAssertEqual(events.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualStreamingSessionStartEvent = events[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(startReason: .EXPLICIT)
		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = events[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			startTimestamp: initialTimestamp,
			endTimestamp: initialTimestamp,
			endReason: .COMPLETE
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)

		let actualPlaybackStatistics = events[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: playTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endReason: EndReason.OTHER.rawValue,
			endTimestamp: endTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = events[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: timestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			startTimestamp: playTimestamp,
			productType: mediaProduct.productType,
			requestedProductId: mediaProduct.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId,
			endTimestamp: endTimestamp,
			endAssetPosition: Double(endTimestamp)
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition,
			duration: Constants.duration,
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}

	func testPlayCurrentAndNextSuccess() {
		shouldUseEventProducer = true
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp

		let mediaProduct1 = Constants.mediaProduct
		uuid = mediaProduct1.productId
		playerEngine.load(mediaProduct1, timestamp: initialTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 2
		playerEngine.play(timestamp: playTimestamp)
		player.playing()

		let nextTimestamp: UInt64 = 3
		timestamp = nextTimestamp
		let mediaProduct2 = Constants.mediaProduct2
		uuid = mediaProduct2.productId
		playerEngine.setNext(mediaProduct2, timestamp: nextTimestamp)
		player.downloaded()
		player.loaded()

		let endAssetPosition: Double = 10
		player.assetPosition = endAssetPosition
		player.completed()

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 6)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualPlaybackStatistics = playerEventSender.streamingMetricsEvents[4] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			streamingSessionId: mediaProduct1.productId,
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: initialTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endTimestamp: nextTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[5] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(
			streamingSessionId: mediaProduct1.productId,
			timestamp: timestamp
		)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			playbackSessionId: mediaProduct1.productId,
			startTimestamp: initialTimestamp,
			productType: mediaProduct1.productType,
			requestedProductId: mediaProduct1.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct1.progressSource?.sourceType,
			sourceId: mediaProduct1.progressSource?.sourceId,
			endTimestamp: nextTimestamp,
			endAssetPosition: endAssetPosition
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition,
			duration: Constants.duration,
			type: mediaProduct1.productType,
			sourceType: mediaProduct1.progressSource?.sourceType,
			sourceId: mediaProduct1.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)

		let endTimestamp: UInt64 = 5
		let endAssetPosition2: Double = 5
		timestamp = endTimestamp
		player.assetPosition = endAssetPosition2
		player.completed()

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 8)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 2)
		XCTAssertEqual(playerEventSender.progressEvents.count, 2)

		let actualPlaybackStatistics2 = playerEventSender.streamingMetricsEvents[6] as! PlaybackStatistics
		let expectedPlaybackStatistics2 = PlaybackStatistics.mock(
			streamingSessionId: mediaProduct2.productId,
			idealStartTimestamp: nextTimestamp,
			actualStartTimestamp: nextTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			startReason: .IMPLICIT,
			endTimestamp: endTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics2, expectedEvent: expectedPlaybackStatistics2)

		let actualStreamingSessionEndEvent2 = playerEventSender.streamingMetricsEvents[7] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent2 = StreamingSessionEnd.mock(
			streamingSessionId: mediaProduct2.productId,
			timestamp: timestamp
		)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent2, expectedEvent: expectedStreamingSessionEndEvent2)

		let actualPlayLog2 = playerEventSender.playLogEvents[1]
		let expectedPlayLog2 = PlayLogEvent.mock(
			playbackSessionId: mediaProduct2.productId,
			startTimestamp: nextTimestamp,
			productType: mediaProduct2.productType,
			requestedProductId: mediaProduct2.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct2.progressSource?.sourceType,
			sourceId: mediaProduct2.progressSource?.sourceId,
			endTimestamp: endTimestamp,
			endAssetPosition: endAssetPosition2
		)
		validatePlayLog(event: actualPlayLog2, expectedEvent: expectedPlayLog2)

		let assetPosition2 = Int(endAssetPosition2) * 1000
		let actualProgressEvent2 = playerEventSender.progressEvents[1]
		let expectedProgressEvent2 = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition2,
			duration: Constants.duration,
			type: mediaProduct2.productType,
			sourceType: mediaProduct2.progressSource?.sourceType,
			sourceId: mediaProduct2.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent2, expectedEvent: expectedProgressEvent2)
	}

	func testPlayCurrentAndNextSuccess_legacy() {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp

		let mediaProduct1 = Constants.mediaProduct
		uuid = mediaProduct1.productId
		playerEngine.load(mediaProduct1, timestamp: initialTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 2
		playerEngine.play(timestamp: playTimestamp)
		player.playing()

		let nextTimestamp: UInt64 = 3
		timestamp = nextTimestamp
		let mediaProduct2 = Constants.mediaProduct2
		uuid = mediaProduct2.productId
		playerEngine.setNext(mediaProduct2, timestamp: nextTimestamp)
		player.downloaded()
		player.loaded()

		let endAssetPosition: Double = 10
		player.assetPosition = endAssetPosition
		player.completed()

		optimizedWait(until: {
			playerEventSender.streamingMetricsEvents.count == 6 &&
				playerEventSender.playLogEvents.count == 1 &&
				playerEventSender.progressEvents.count == 1
		})

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 6)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualPlaybackStatistics = playerEventSender.streamingMetricsEvents[4] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			streamingSessionId: mediaProduct1.productId,
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: initialTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endTimestamp: nextTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[5] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(
			streamingSessionId: mediaProduct1.productId,
			timestamp: timestamp
		)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			playbackSessionId: mediaProduct1.productId,
			startTimestamp: initialTimestamp,
			productType: mediaProduct1.productType,
			requestedProductId: mediaProduct1.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct1.progressSource?.sourceType,
			sourceId: mediaProduct1.progressSource?.sourceId,
			endTimestamp: nextTimestamp,
			endAssetPosition: endAssetPosition
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition,
			duration: Constants.duration,
			type: mediaProduct1.productType,
			sourceType: mediaProduct1.progressSource?.sourceType,
			sourceId: mediaProduct1.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)

		let endTimestamp: UInt64 = 5
		let endAssetPosition2: Double = 5
		timestamp = endTimestamp
		player.assetPosition = endAssetPosition2
		player.completed()

		optimizedWait(until: {
			playerEventSender.streamingMetricsEvents.count == 8 &&
				playerEventSender.playLogEvents.count == 2 &&
				playerEventSender.progressEvents.count == 2
		})

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 8)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 2)
		XCTAssertEqual(playerEventSender.progressEvents.count, 2)

		let actualPlaybackStatistics2 = playerEventSender.streamingMetricsEvents[6] as! PlaybackStatistics
		let expectedPlaybackStatistics2 = PlaybackStatistics.mock(
			streamingSessionId: mediaProduct2.productId,
			idealStartTimestamp: nextTimestamp,
			actualStartTimestamp: nextTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			startReason: .IMPLICIT,
			endTimestamp: endTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics2, expectedEvent: expectedPlaybackStatistics2)

		let actualStreamingSessionEndEvent2 = playerEventSender.streamingMetricsEvents[7] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent2 = StreamingSessionEnd.mock(
			streamingSessionId: mediaProduct2.productId,
			timestamp: timestamp
		)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent2, expectedEvent: expectedStreamingSessionEndEvent2)

		let actualPlayLog2 = playerEventSender.playLogEvents[1]
		let expectedPlayLog2 = PlayLogEvent.mock(
			playbackSessionId: mediaProduct2.productId,
			startTimestamp: nextTimestamp,
			productType: mediaProduct2.productType,
			requestedProductId: mediaProduct2.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct2.progressSource?.sourceType,
			sourceId: mediaProduct2.progressSource?.sourceId,
			endTimestamp: endTimestamp,
			endAssetPosition: endAssetPosition2
		)
		validatePlayLog(event: actualPlayLog2, expectedEvent: expectedPlayLog2)

		let assetPosition2 = Int(endAssetPosition2) * 1000
		let actualProgressEvent2 = playerEventSender.progressEvents[1]
		let expectedProgressEvent2 = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition2,
			duration: Constants.duration,
			type: mediaProduct2.productType,
			sourceType: mediaProduct2.progressSource?.sourceType,
			sourceId: mediaProduct2.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent2, expectedEvent: expectedProgressEvent2)
	}

	func testPlayCurrentAndNextSuccess_legacy2() {
		assertPlayCurrentAndNextSuccess_legacy(shouldSendEventsInDeinit: true)
	}

	func testPlayCurrentAndNextSuccess_legacy3() {
		assertPlayCurrentAndNextSuccess_legacy(shouldSendEventsInDeinit: false)
	}

	func assertPlayCurrentAndNextSuccess_legacy(shouldSendEventsInDeinit: Bool) {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = shouldSendEventsInDeinit

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp

		let mediaProduct1 = Constants.mediaProduct
		uuid = mediaProduct1.productId
		playerEngine.load(mediaProduct1, timestamp: initialTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 2
		playerEngine.play(timestamp: playTimestamp)
		player.playing()

		let nextTimestamp: UInt64 = 3
		timestamp = nextTimestamp
		let mediaProduct2 = Constants.mediaProduct2
		uuid = mediaProduct2.productId
		playerEngine.setNext(mediaProduct2, timestamp: nextTimestamp)
		player.downloaded()
		player.loaded()

		let endAssetPosition: Double = 10
		player.assetPosition = endAssetPosition
		player.completed()

		optimizedWait(until: {
			playerEventSender.streamingMetricsEvents.count == 6 &&
				playerEventSender.playLogEvents.count == 1 &&
				playerEventSender.progressEvents.count == 1
		})

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 6)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualPlaybackStatistics = playerEventSender.streamingMetricsEvents[4] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			streamingSessionId: mediaProduct1.productId,
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: initialTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endTimestamp: nextTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[5] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(
			streamingSessionId: mediaProduct1.productId,
			timestamp: timestamp
		)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			playbackSessionId: mediaProduct1.productId,
			startTimestamp: initialTimestamp,
			productType: mediaProduct1.productType,
			requestedProductId: mediaProduct1.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct1.progressSource?.sourceType,
			sourceId: mediaProduct1.progressSource?.sourceId,
			endTimestamp: nextTimestamp,
			endAssetPosition: endAssetPosition
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition,
			duration: Constants.duration,
			type: mediaProduct1.productType,
			sourceType: mediaProduct1.progressSource?.sourceType,
			sourceId: mediaProduct1.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)

		let endTimestamp: UInt64 = 5
		let endAssetPosition2: Double = 5
		timestamp = endTimestamp
		player.assetPosition = endAssetPosition2
		player.completed()

		optimizedWait(until: {
			playerEventSender.streamingMetricsEvents.count == 8 &&
				playerEventSender.playLogEvents.count == 2 &&
				playerEventSender.progressEvents.count == 2
		})

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 8)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 2)
		XCTAssertEqual(playerEventSender.progressEvents.count, 2)

		let actualPlaybackStatistics2 = playerEventSender.streamingMetricsEvents[6] as! PlaybackStatistics
		let expectedPlaybackStatistics2 = PlaybackStatistics.mock(
			streamingSessionId: mediaProduct2.productId,
			idealStartTimestamp: nextTimestamp,
			actualStartTimestamp: nextTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			startReason: .IMPLICIT,
			endTimestamp: endTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics2, expectedEvent: expectedPlaybackStatistics2)

		let actualStreamingSessionEndEvent2 = playerEventSender.streamingMetricsEvents[7] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent2 = StreamingSessionEnd.mock(
			streamingSessionId: mediaProduct2.productId,
			timestamp: timestamp
		)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent2, expectedEvent: expectedStreamingSessionEndEvent2)

		let actualPlayLog2 = playerEventSender.playLogEvents[1]
		let expectedPlayLog2 = PlayLogEvent.mock(
			playbackSessionId: mediaProduct2.productId,
			startTimestamp: nextTimestamp,
			productType: mediaProduct2.productType,
			requestedProductId: mediaProduct2.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct2.progressSource?.sourceType,
			sourceId: mediaProduct2.progressSource?.sourceId,
			endTimestamp: endTimestamp,
			endAssetPosition: endAssetPosition2
		)
		validatePlayLog(event: actualPlayLog2, expectedEvent: expectedPlayLog2)

		let assetPosition2 = Int(endAssetPosition2) * 1000
		let actualProgressEvent2 = playerEventSender.progressEvents[1]
		let expectedProgressEvent2 = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition2,
			duration: Constants.duration,
			type: mediaProduct2.productType,
			sourceType: mediaProduct2.progressSource?.sourceType,
			sourceId: mediaProduct2.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent2, expectedEvent: expectedProgressEvent2)
	}

	func testLoadFailsInPlayer() {
		shouldUseEventProducer = true
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp

		playerEngine.load(Constants.mediaProduct, timestamp: initialTimestamp)

		let endTimestamp: UInt64 = 2
		timestamp = endTimestamp
		player.failed(with: Constants.error)

		XCTAssertEqual(playerEngine.getState(), .NOT_PLAYING)
		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 0)
		XCTAssertEqual(playerEventSender.progressEvents.count, 0)

		let events = playerEventSender.streamingMetricsEvents

		let actualStreamingSessionStartEvent = events[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(startReason: .EXPLICIT)

		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = events[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			startTimestamp: initialTimestamp,
			endTimestamp: initialTimestamp,
			endReason: .COMPLETE
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)

		let actualPlaybackStatistics = events[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			actualProductId: "\(playbackInfo.trackId)",
			endReason: EndReason.ERROR.rawValue,
			endTimestamp: endTimestamp,
			errorMessage: Constants.mockErrorMessage,
			errorCode: Constants.errorCode
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = events[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: timestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)
	}

	func testLoadFailsInPlayer_legacy() {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp

		playerEngine.load(Constants.mediaProduct, timestamp: initialTimestamp)

		let endTimestamp: UInt64 = 2
		timestamp = endTimestamp
		player.failed(with: Constants.error)

		XCTAssertEqual(playerEngine.getState(), .NOT_PLAYING)
		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 0)
		XCTAssertEqual(playerEventSender.progressEvents.count, 0)

		let events = playerEventSender.streamingMetricsEvents

		let actualStreamingSessionStartEvent = events[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(startReason: .EXPLICIT)

		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = events[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			startTimestamp: initialTimestamp,
			endTimestamp: initialTimestamp,
			endReason: .COMPLETE
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)

		let actualPlaybackStatistics = events[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			actualProductId: "\(playbackInfo.trackId)",
			endReason: EndReason.ERROR.rawValue,
			endTimestamp: endTimestamp,
			errorMessage: Constants.mockErrorMessage,
			errorCode: Constants.errorCode
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = events[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: timestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)
	}

	func testLoadFailsInPlayer_legacy2() {
		assertLoadFailsInPlayer_legacy(shouldSendEventsInDeinit: true)
	}

	func testLoadFailsInPlayer_legacy3() {
		assertLoadFailsInPlayer_legacy(shouldSendEventsInDeinit: false)
	}

	func assertLoadFailsInPlayer_legacy(shouldSendEventsInDeinit: Bool) {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = shouldSendEventsInDeinit

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp

		playerEngine.load(Constants.mediaProduct, timestamp: initialTimestamp)

		let endTimestamp: UInt64 = 2
		timestamp = endTimestamp
		player.failed(with: Constants.error)

		XCTAssertEqual(playerEngine.getState(), .NOT_PLAYING)
		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 0)
		XCTAssertEqual(playerEventSender.progressEvents.count, 0)

		let events = playerEventSender.streamingMetricsEvents

		let actualStreamingSessionStartEvent = events[0] as! StreamingSessionStart
		let expectedStreamingSessionStartEvent = mockStreamingSessionStart(startReason: .EXPLICIT)

		validateStreamingSessionStart(event: actualStreamingSessionStartEvent, expectedEvent: expectedStreamingSessionStartEvent)

		let actualPlaybackInfoFetch = events[1] as! PlaybackInfoFetch
		let expectedPlaybackInfoFetch = PlaybackInfoFetch.mock(
			startTimestamp: initialTimestamp,
			endTimestamp: initialTimestamp,
			endReason: .COMPLETE
		)
		validatePlaybackInfoFetch(event: actualPlaybackInfoFetch, expectedEvent: expectedPlaybackInfoFetch)

		let actualPlaybackStatistics = events[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			actualProductId: "\(playbackInfo.trackId)",
			endReason: EndReason.ERROR.rawValue,
			endTimestamp: endTimestamp,
			errorMessage: Constants.mockErrorMessage,
			errorCode: Constants.errorCode
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = events[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: timestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)
	}

	func testPlayCurrentNextFailsBetweenPlaybackInfoAndCurrentComplete() {
		shouldUseEventProducer = true
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let initialTimestamp: UInt64 = 1

		let mediaProduct1 = Constants.mediaProduct
		uuid = mediaProduct1.productId
		playerEngine.load(mediaProduct1, timestamp: initialTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 2
		playerEngine.play(timestamp: playTimestamp)
		player.playing()

		let nextTimestamp: UInt64 = 3
		timestamp = nextTimestamp
		let mediaProduct2 = Constants.mediaProduct2
		uuid = mediaProduct2.productId
		playerEngine.setNext(mediaProduct2, timestamp: nextTimestamp)
		player.downloaded()
		player.loaded()

		let endAssetPosition: Double = 10
		player.assetPosition = endAssetPosition
		player.failed(asset: player.assets[1], with: Constants.error)

		let endTimestamp: UInt64 = 10
		timestamp = endTimestamp
		player.completed()

		XCTAssertEqual(playerEngine.getState(), .NOT_PLAYING)
		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 8)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualPlaybackStatistics = playerEventSender.streamingMetricsEvents[4] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			streamingSessionId: mediaProduct1.productId,
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: initialTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endTimestamp: endTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[5] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(
			streamingSessionId: mediaProduct1.productId,
			timestamp: endTimestamp
		)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlaybackStatistics2 = playerEventSender.streamingMetricsEvents[6] as! PlaybackStatistics
		let expectedPlaybackStatistics2 = PlaybackStatistics.mock(
			streamingSessionId: mediaProduct2.productId,
			actualProductId: "\(playbackInfo.trackId)",
			startReason: .IMPLICIT,
			endReason: EndReason.ERROR.rawValue,
			endTimestamp: nextTimestamp,
			errorMessage: Constants.mockErrorMessage,
			errorCode: Constants.errorCode
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics2, expectedEvent: expectedPlaybackStatistics2)

		let actualStreamingSessionEndEvent2 = playerEventSender.streamingMetricsEvents[7] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent2 = StreamingSessionEnd.mock(
			streamingSessionId: mediaProduct2.productId,
			timestamp: endTimestamp
		)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent2, expectedEvent: expectedStreamingSessionEndEvent2)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			playbackSessionId: mediaProduct1.productId,
			startTimestamp: initialTimestamp,
			productType: mediaProduct1.productType,
			requestedProductId: mediaProduct1.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct1.progressSource?.sourceType,
			sourceId: mediaProduct1.progressSource?.sourceId,
			endTimestamp: endTimestamp,
			endAssetPosition: endAssetPosition
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition,
			duration: Constants.duration,
			type: mediaProduct2.productType,
			sourceType: mediaProduct2.progressSource?.sourceType,
			sourceId: mediaProduct2.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}

	func testPlayCurrentNextFailsBetweenPlaybackInfoAndCurrentComplete_legacy() {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let initialTimestamp: UInt64 = 1
		let mediaProduct = Constants.mediaProduct
		playerEngine.load(mediaProduct, timestamp: initialTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 2
		playerEngine.play(timestamp: playTimestamp)
		player.playing()

		let nextTimestamp: UInt64 = 3
		timestamp = nextTimestamp
		playerEngine.setNext(Constants.mediaProduct, timestamp: nextTimestamp)
		player.downloaded()
		player.loaded()

		let endAssetPosition: Double = 10
		player.assetPosition = endAssetPosition
		player.failed(asset: player.assets[1], with: Constants.error)

		let endTimestamp: UInt64 = 10
		timestamp = endTimestamp
		player.completed()

		XCTAssertEqual(playerEngine.getState(), .NOT_PLAYING)
		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 8)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualPlaybackStatistics = playerEventSender.streamingMetricsEvents[4] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: initialTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endTimestamp: endTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[5] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: endTimestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlaybackStatistics2 = playerEventSender.streamingMetricsEvents[6] as! PlaybackStatistics
		let expectedPlaybackStatistics2 = PlaybackStatistics.mock(
			actualProductId: "\(playbackInfo.trackId)",
			startReason: .IMPLICIT,
			endReason: EndReason.ERROR.rawValue,
			endTimestamp: nextTimestamp,
			errorMessage: Constants.mockErrorMessage,
			errorCode: Constants.errorCode
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics2, expectedEvent: expectedPlaybackStatistics2)

		let actualStreamingSessionEndEvent2 = playerEventSender.streamingMetricsEvents[7] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent2 = StreamingSessionEnd.mock(timestamp: endTimestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent2, expectedEvent: expectedStreamingSessionEndEvent2)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			startTimestamp: initialTimestamp,
			productType: mediaProduct.productType,
			requestedProductId: mediaProduct.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId,
			endTimestamp: endTimestamp,
			endAssetPosition: endAssetPosition
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition,
			duration: Constants.duration,
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}

	func testPlayCurrentNextFailsBetweenPlaybackInfoAndCurrentComplete_legacy2() {
		assertPlayCurrentNextFailsBetweenPlaybackInfoAndCurrentComplete_legacy(shouldSendEventsInDeinit: true)
	}

	func testPlayCurrentNextFailsBetweenPlaybackInfoAndCurrentComplete_legacy3() {
		assertPlayCurrentNextFailsBetweenPlaybackInfoAndCurrentComplete_legacy(shouldSendEventsInDeinit: false)
	}

	func assertPlayCurrentNextFailsBetweenPlaybackInfoAndCurrentComplete_legacy(shouldSendEventsInDeinit: Bool) {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = shouldSendEventsInDeinit

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let initialTimestamp: UInt64 = 1

		let mediaProduct1 = Constants.mediaProduct
		uuid = mediaProduct1.productId
		playerEngine.load(mediaProduct1, timestamp: initialTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 2
		playerEngine.play(timestamp: playTimestamp)
		player.playing()

		let nextTimestamp: UInt64 = 3
		timestamp = nextTimestamp
		let mediaProduct2 = Constants.mediaProduct2
		uuid = mediaProduct2.productId
		playerEngine.setNext(mediaProduct2, timestamp: nextTimestamp)
		player.downloaded()
		player.loaded()

		let endAssetPosition: Double = 10
		player.assetPosition = endAssetPosition
		player.failed(asset: player.assets[1], with: Constants.error)

		let endTimestamp: UInt64 = 10
		timestamp = endTimestamp
		player.completed()

		XCTAssertEqual(playerEngine.getState(), .NOT_PLAYING)
		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 8)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualPlaybackStatistics = playerEventSender.streamingMetricsEvents[4] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			streamingSessionId: mediaProduct1.productId,
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: initialTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endTimestamp: endTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[5] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(
			streamingSessionId: mediaProduct1.productId,
			timestamp: endTimestamp
		)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlaybackStatistics2 = playerEventSender.streamingMetricsEvents[6] as! PlaybackStatistics
		let expectedPlaybackStatistics2 = PlaybackStatistics.mock(
			streamingSessionId: mediaProduct2.productId,
			actualProductId: "\(playbackInfo.trackId)",
			startReason: .IMPLICIT,
			endReason: EndReason.ERROR.rawValue,
			endTimestamp: nextTimestamp,
			errorMessage: Constants.mockErrorMessage,
			errorCode: Constants.errorCode
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics2, expectedEvent: expectedPlaybackStatistics2)

		let actualStreamingSessionEndEvent2 = playerEventSender.streamingMetricsEvents[7] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent2 = StreamingSessionEnd.mock(
			streamingSessionId: mediaProduct2.productId,
			timestamp: endTimestamp
		)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent2, expectedEvent: expectedStreamingSessionEndEvent2)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			playbackSessionId: mediaProduct1.productId,
			startTimestamp: initialTimestamp,
			productType: mediaProduct1.productType,
			requestedProductId: mediaProduct1.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct1.progressSource?.sourceType,
			sourceId: mediaProduct1.progressSource?.sourceId,
			endTimestamp: endTimestamp,
			endAssetPosition: endAssetPosition
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition,
			duration: Constants.duration,
			type: mediaProduct2.productType,
			sourceType: mediaProduct2.progressSource?.sourceType,
			sourceId: mediaProduct2.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}

	func testPlayingAndPausing() {
		shouldUseEventProducer = true
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let initialTimestamp: UInt64 = 1
		let mediaProduct = Constants.mediaProduct
		playerEngine.load(mediaProduct, timestamp: initialTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 2
		let assetPosition: Double = 2
		playerEngine.play(timestamp: playTimestamp)
		player.playing()

		player.assetPosition = assetPosition
		let firstPause = Action(actionType: .PLAYBACK_STOP, assetPosition: assetPosition, timestamp: initialTimestamp)
		playerEngine.pause()
		player.paused()

		let firstPlay = Action(actionType: .PLAYBACK_START, assetPosition: assetPosition, timestamp: initialTimestamp)
		playerEngine.play(timestamp: 3)
		player.playing()

		let endAssetPosition: Double = 6
		player.assetPosition = endAssetPosition
		let secondPause = Action(actionType: .PLAYBACK_STOP, assetPosition: endAssetPosition, timestamp: initialTimestamp)
		playerEngine.pause()
		player.paused()

		// Set timestamp equal/higher than current media product, since events are sent afterwards, so to fake time has passed.
		let endTimestamp: UInt64 = 5
		timestamp = endTimestamp

		playerEngine.reset()

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualPlaybackStatistics = playerEventSender.streamingMetricsEvents[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: initialTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endReason: EndReason.OTHER.rawValue,
			endTimestamp: endTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: endTimestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			startTimestamp: initialTimestamp,
			productType: mediaProduct.productType,
			requestedProductId: mediaProduct.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId,
			actions: [firstPause, firstPlay, secondPause],
			endTimestamp: endTimestamp,
			endAssetPosition: endAssetPosition
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition2 = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition2,
			duration: Constants.duration,
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}

	func testPlayingAndPausing_legacy() {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let initialTimestamp: UInt64 = 1
		let mediaProduct = Constants.mediaProduct
		playerEngine.load(mediaProduct, timestamp: initialTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 2
		let assetPosition: Double = 2
		playerEngine.play(timestamp: playTimestamp)
		player.playing()

		player.assetPosition = assetPosition
		let firstPause = Action(actionType: .PLAYBACK_STOP, assetPosition: assetPosition, timestamp: initialTimestamp)
		playerEngine.pause()
		player.paused()

		let firstPlay = Action(actionType: .PLAYBACK_START, assetPosition: assetPosition, timestamp: initialTimestamp)
		playerEngine.play(timestamp: 3)
		player.playing()

		let endAssetPosition: Double = 6
		player.assetPosition = endAssetPosition
		let secondPause = Action(actionType: .PLAYBACK_STOP, assetPosition: endAssetPosition, timestamp: initialTimestamp)
		playerEngine.pause()
		player.paused()

		// Set timestamp equal/higher than current media product, since events are sent afterwards, so to fake time has passed.
		let endTimestamp: UInt64 = 5
		timestamp = endTimestamp

		playerEngine.reset()

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualPlaybackStatistics = playerEventSender.streamingMetricsEvents[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: initialTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endReason: EndReason.OTHER.rawValue,
			endTimestamp: endTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: endTimestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			startTimestamp: initialTimestamp,
			productType: mediaProduct.productType,
			requestedProductId: mediaProduct.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId,
			actions: [firstPause, firstPlay, secondPause],
			endTimestamp: endTimestamp,
			endAssetPosition: endAssetPosition
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition2 = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition2,
			duration: Constants.duration,
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}

	func testPlayingAndPausing_legacy2() {
		assertPlayingAndPausing_legacy(shouldSendEventsInDeinit: true)
	}

	func testPlayingAndPausing_legacy3() {
		assertPlayingAndPausing_legacy(shouldSendEventsInDeinit: false)
	}

	func assertPlayingAndPausing_legacy(shouldSendEventsInDeinit: Bool) {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = shouldSendEventsInDeinit

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let initialTimestamp: UInt64 = 1
		let mediaProduct = Constants.mediaProduct
		playerEngine.load(mediaProduct, timestamp: initialTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 2
		let assetPosition: Double = 2
		playerEngine.play(timestamp: playTimestamp)
		player.playing()

		player.assetPosition = assetPosition
		let firstPause = Action(actionType: .PLAYBACK_STOP, assetPosition: assetPosition, timestamp: initialTimestamp)
		playerEngine.pause()
		player.paused()

		let firstPlay = Action(actionType: .PLAYBACK_START, assetPosition: assetPosition, timestamp: initialTimestamp)
		playerEngine.play(timestamp: 3)
		player.playing()

		let endAssetPosition: Double = 6
		player.assetPosition = endAssetPosition
		let secondPause = Action(actionType: .PLAYBACK_STOP, assetPosition: endAssetPosition, timestamp: initialTimestamp)
		playerEngine.pause()
		player.paused()

		// Set timestamp equal/higher than current media product, since events are sent afterwards, so to fake time has passed.
		let endTimestamp: UInt64 = 5
		timestamp = endTimestamp

		playerEngine.reset()

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualPlaybackStatistics = playerEventSender.streamingMetricsEvents[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: initialTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endReason: EndReason.OTHER.rawValue,
			endTimestamp: endTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: endTimestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			startTimestamp: initialTimestamp,
			productType: mediaProduct.productType,
			requestedProductId: mediaProduct.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId,
			actions: [firstPause, firstPlay, secondPause],
			endTimestamp: endTimestamp,
			endAssetPosition: endAssetPosition
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition2 = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition2,
			duration: Constants.duration,
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}

	func testPlayingAndStalling() {
		shouldUseEventProducer = true
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let mediaProduct = Constants.mediaProduct
		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp
		playerEngine.load(mediaProduct, timestamp: initialTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 2
		let assetPosition: Double = 2
		timestamp = playTimestamp
		playerEngine.play(timestamp: playTimestamp)
		player.playing()

		player.assetPosition = assetPosition

		let stallTimestamp: UInt64 = 3
		timestamp = stallTimestamp

		let firstStall = Stall(
			reason: .UNEXPECTED,
			assetPosition: assetPosition,
			startTimestamp: stallTimestamp,
			endTimestamp: stallTimestamp
		)
		let firstStop = Action(actionType: .PLAYBACK_STOP, assetPosition: assetPosition, timestamp: stallTimestamp)
		player.stalled()

		let firstStart = Action(actionType: .PLAYBACK_START, assetPosition: Double(playTimestamp), timestamp: stallTimestamp)
		player.playing()

		let stallTimestamp2: UInt64 = 4
		timestamp = stallTimestamp2

		let endAssetPosition: Double = 6
		player.assetPosition = endAssetPosition
		let secondStall = Stall(
			reason: .UNEXPECTED,
			assetPosition: 6,
			startTimestamp: stallTimestamp2,
			endTimestamp: stallTimestamp2
		)
		let secondStop = Action(actionType: .PLAYBACK_STOP, assetPosition: 6, timestamp: stallTimestamp2)
		player.stalled()

		player.failed(with: NSError(domain: "Stall", code: 1, userInfo: nil))

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualPlaybackStatistics = playerEventSender.streamingMetricsEvents[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: playTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			stalls: [firstStall, secondStall],
			endReason: EndReason.ERROR.rawValue,
			endTimestamp: timestamp,
			errorMessage: Constants.stallErrorMessage,
			errorCode: Constants.errorCode
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: timestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			startTimestamp: playTimestamp,
			productType: mediaProduct.productType,
			requestedProductId: mediaProduct.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId,
			actions: [firstStop, firstStart, secondStop],
			endTimestamp: stallTimestamp2,
			endAssetPosition: endAssetPosition
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition2 = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition2,
			duration: Constants.duration,
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}

	func testPlayingAndStalling_legacy() {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let mediaProduct = Constants.mediaProduct
		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp
		playerEngine.load(mediaProduct, timestamp: initialTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 2
		let assetPosition: Double = 2
		timestamp = playTimestamp
		playerEngine.play(timestamp: playTimestamp)
		player.playing()

		player.assetPosition = assetPosition

		let stallTimestamp: UInt64 = 3
		timestamp = stallTimestamp

		let firstStall = Stall(
			reason: .UNEXPECTED,
			assetPosition: assetPosition,
			startTimestamp: stallTimestamp,
			endTimestamp: stallTimestamp
		)
		let firstStop = Action(actionType: .PLAYBACK_STOP, assetPosition: assetPosition, timestamp: stallTimestamp)
		player.stalled()

		let firstStart = Action(actionType: .PLAYBACK_START, assetPosition: Double(playTimestamp), timestamp: stallTimestamp)
		player.playing()

		let stallTimestamp2: UInt64 = 4
		timestamp = stallTimestamp2

		let endAssetPosition: Double = 6
		player.assetPosition = endAssetPosition
		let secondStall = Stall(reason: .UNEXPECTED, assetPosition: 6, startTimestamp: stallTimestamp2, endTimestamp: stallTimestamp2)
		let secondStop = Action(actionType: .PLAYBACK_STOP, assetPosition: 6, timestamp: stallTimestamp2)
		player.stalled()

		player.failed(with: NSError(domain: "Stall", code: 1, userInfo: nil))

		optimizedWait {
			playerEventSender.streamingMetricsEvents.count == 4
		}

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualPlaybackStatistics = playerEventSender.streamingMetricsEvents[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: playTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			stalls: [firstStall, secondStall],
			endReason: EndReason.ERROR.rawValue,
			endTimestamp: timestamp,
			errorMessage: Constants.stallErrorMessage,
			errorCode: Constants.errorCode
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: timestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			startTimestamp: playTimestamp,
			productType: mediaProduct.productType,
			requestedProductId: mediaProduct.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId,
			actions: [firstStop, firstStart, secondStop],
			endTimestamp: stallTimestamp2,
			endAssetPosition: endAssetPosition
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition2 = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition2,
			duration: Constants.duration,
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}

	func testPlayingAndStalling_legacy2() {
		testPlayingAndStalling_legacy(shouldSendEventsInDeinit: true)
	}

	func testPlayingAndStalling_legacy3() {
		testPlayingAndStalling_legacy(shouldSendEventsInDeinit: false)
	}

	func testPlayingAndStalling_legacy(shouldSendEventsInDeinit: Bool) {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let mediaProduct = Constants.mediaProduct
		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp
		playerEngine.load(mediaProduct, timestamp: initialTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 2
		let assetPosition: Double = 2
		timestamp = playTimestamp
		playerEngine.play(timestamp: playTimestamp)
		player.playing()

		player.assetPosition = assetPosition

		let stallTimestamp: UInt64 = 3
		timestamp = stallTimestamp

		let firstStall = Stall(
			reason: .UNEXPECTED,
			assetPosition: assetPosition,
			startTimestamp: stallTimestamp,
			endTimestamp: stallTimestamp
		)
		let firstStop = Action(actionType: .PLAYBACK_STOP, assetPosition: assetPosition, timestamp: stallTimestamp)
		player.stalled()

		let firstStart = Action(actionType: .PLAYBACK_START, assetPosition: Double(playTimestamp), timestamp: stallTimestamp)
		player.playing()

		let stallTimestamp2: UInt64 = 4
		timestamp = stallTimestamp2

		let endAssetPosition: Double = 6
		player.assetPosition = endAssetPosition
		let secondStall = Stall(reason: .UNEXPECTED, assetPosition: 6, startTimestamp: stallTimestamp2, endTimestamp: stallTimestamp2)
		let secondStop = Action(actionType: .PLAYBACK_STOP, assetPosition: 6, timestamp: stallTimestamp2)
		player.stalled()

		player.failed(with: NSError(domain: "Stall", code: 1, userInfo: nil))

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualPlaybackStatistics = playerEventSender.streamingMetricsEvents[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: playTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			stalls: [firstStall, secondStall],
			endReason: EndReason.ERROR.rawValue,
			endTimestamp: timestamp,
			errorMessage: Constants.stallErrorMessage,
			errorCode: Constants.errorCode
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: timestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			startTimestamp: playTimestamp,
			productType: mediaProduct.productType,
			requestedProductId: mediaProduct.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId,
			actions: [firstStop, firstStart, secondStop],
			endTimestamp: stallTimestamp2,
			endAssetPosition: endAssetPosition
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition2 = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition2,
			duration: Constants.duration,
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}

	func testPlayingAndSeeking() {
		shouldUseEventProducer = true
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let initialTimestamp: UInt64 = 1
		let mediaProduct = Constants.mediaProduct
		playerEngine.load(mediaProduct, timestamp: initialTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 2
		timestamp = playTimestamp
		playerEngine.play(timestamp: playTimestamp)
		player.playing()

		player.assetPosition = Double(playTimestamp)

		playerEngine.seek(3)
		player.seeking()
		let firstStop = Action(actionType: .PLAYBACK_STOP, assetPosition: 2, timestamp: playTimestamp)
		player.assetPosition = 3

		player.playing()
		let firstStart = Action(actionType: .PLAYBACK_START, assetPosition: 3, timestamp: playTimestamp)
		player.assetPosition = 4

		playerEngine.seek(9)
		player.seeking()
		let secondStop = Action(actionType: .PLAYBACK_STOP, assetPosition: 4, timestamp: playTimestamp)
		player.assetPosition = 9

		player.playing()
		let secondStart = Action(actionType: .PLAYBACK_START, assetPosition: 9, timestamp: playTimestamp)
		let endAssetPosition = 9.5
		player.assetPosition = endAssetPosition

		// Set timestamp equal/higher than current media product, since events are sent afterwards, so to fake time has passed.
		let endTimestamp: UInt64 = 5
		timestamp = endTimestamp

		playerEngine.reset()

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualPlaybackStatistics = playerEventSender.streamingMetricsEvents[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: playTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endReason: EndReason.OTHER.rawValue,
			endTimestamp: endTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: timestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			startTimestamp: playTimestamp,
			productType: mediaProduct.productType,
			requestedProductId: mediaProduct.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId,
			actions: [firstStop, firstStart, secondStop, secondStart],
			endTimestamp: endTimestamp,
			endAssetPosition: endAssetPosition
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition,
			duration: Constants.duration,
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}

	func testPlayingAndSeeking_legacy() {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let initialTimestamp: UInt64 = 1
		let mediaProduct = Constants.mediaProduct
		playerEngine.load(mediaProduct, timestamp: initialTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 2
		timestamp = playTimestamp
		playerEngine.play(timestamp: playTimestamp)
		player.playing()

		player.assetPosition = Double(playTimestamp)

		playerEngine.seek(3)
		player.seeking()
		let firstStop = Action(actionType: .PLAYBACK_STOP, assetPosition: 2, timestamp: playTimestamp)
		player.assetPosition = 3

		player.playing()
		let firstStart = Action(actionType: .PLAYBACK_START, assetPosition: 3, timestamp: playTimestamp)
		player.assetPosition = 4

		playerEngine.seek(9)
		player.seeking()
		let secondStop = Action(actionType: .PLAYBACK_STOP, assetPosition: 4, timestamp: playTimestamp)
		player.assetPosition = 9

		player.playing()
		let secondStart = Action(actionType: .PLAYBACK_START, assetPosition: 9, timestamp: playTimestamp)
		let endAssetPosition = 9.5
		player.assetPosition = endAssetPosition

		// Set timestamp equal/higher than current media product, since events are sent afterwards, so to fake time has passed.
		let endTimestamp: UInt64 = 5
		timestamp = endTimestamp

		playerEngine.reset()

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualPlaybackStatistics = playerEventSender.streamingMetricsEvents[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: playTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endReason: EndReason.OTHER.rawValue,
			endTimestamp: endTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: timestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			startTimestamp: playTimestamp,
			productType: mediaProduct.productType,
			requestedProductId: mediaProduct.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId,
			actions: [firstStop, firstStart, secondStop, secondStart],
			endTimestamp: endTimestamp,
			endAssetPosition: endAssetPosition
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition,
			duration: Constants.duration,
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}

	func testPlayingAndSeeking_legacy2() {
		testPlayingAndSeeking_legacy(shouldSendEventsInDeinit: true)
	}

	func testPlayingAndSeeking_legacy3() {
		testPlayingAndSeeking_legacy(shouldSendEventsInDeinit: false)
	}

	func testPlayingAndSeeking_legacy(shouldSendEventsInDeinit: Bool) {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let initialTimestamp: UInt64 = 1
		let mediaProduct = Constants.mediaProduct
		playerEngine.load(mediaProduct, timestamp: initialTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 2
		timestamp = playTimestamp
		playerEngine.play(timestamp: playTimestamp)
		player.playing()

		player.assetPosition = Double(playTimestamp)

		playerEngine.seek(3)
		player.seeking()
		let firstStop = Action(actionType: .PLAYBACK_STOP, assetPosition: 2, timestamp: playTimestamp)
		player.assetPosition = 3

		player.playing()
		let firstStart = Action(actionType: .PLAYBACK_START, assetPosition: 3, timestamp: playTimestamp)
		player.assetPosition = 4

		playerEngine.seek(9)
		player.seeking()
		let secondStop = Action(actionType: .PLAYBACK_STOP, assetPosition: 4, timestamp: playTimestamp)
		player.assetPosition = 9

		player.playing()
		let secondStart = Action(actionType: .PLAYBACK_START, assetPosition: 9, timestamp: playTimestamp)
		let endAssetPosition = 9.5
		player.assetPosition = endAssetPosition

		// Set timestamp equal/higher than current media product, since events are sent afterwards, so to fake time has passed.
		let endTimestamp: UInt64 = 5
		timestamp = endTimestamp

		playerEngine.reset()

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualPlaybackStatistics = playerEventSender.streamingMetricsEvents[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: playTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			endReason: EndReason.OTHER.rawValue,
			endTimestamp: endTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: timestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			startTimestamp: playTimestamp,
			productType: mediaProduct.productType,
			requestedProductId: mediaProduct.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId,
			actions: [firstStop, firstStart, secondStop, secondStart],
			endTimestamp: endTimestamp,
			endAssetPosition: endAssetPosition
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition,
			duration: Constants.duration,
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}

	func testStallsDueToSeek() {
		shouldUseEventProducer = true
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp
		let mediaProduct = Constants.mediaProduct
		playerEngine.load(mediaProduct, timestamp: initialTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 2
		let playTimestampDouble: Double = 2
		timestamp = playTimestamp
		playerEngine.play(timestamp: playTimestamp)
		player.playing()
		player.assetPosition = playTimestampDouble

		let endTimestamp: UInt64 = 3
		let endTimestampDouble: Double = 3
		timestamp = endTimestamp
		playerEngine.seek(endTimestampDouble)
		player.seeking()
		player.stalled()
		let firstStop = Action(actionType: .PLAYBACK_STOP, assetPosition: playTimestampDouble, timestamp: endTimestamp)
		let firstStall = Stall(
			reason: .SEEK,
			assetPosition: playTimestampDouble,
			startTimestamp: endTimestamp,
			endTimestamp: endTimestamp
		)
		player.assetPosition = endTimestampDouble

		player.playing()
		let firstStart = Action(actionType: .PLAYBACK_START, assetPosition: endTimestampDouble, timestamp: endTimestamp)
		player.assetPosition = 4

		playerEngine.seek(9)
		player.seeking()
		player.stalled()
		let secondStop = Action(actionType: .PLAYBACK_STOP, assetPosition: 4, timestamp: endTimestamp)
		let secondStall = Stall(reason: .SEEK, assetPosition: 4, startTimestamp: endTimestamp, endTimestamp: endTimestamp)
		player.assetPosition = 9

		player.playing()
		let secondStart = Action(actionType: .PLAYBACK_START, assetPosition: 9, timestamp: endTimestamp)

		let endAssetPosition: Double = 10
		player.assetPosition = endAssetPosition
		player.completed()

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualPlaybackStatistics = playerEventSender.streamingMetricsEvents[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: playTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			stalls: [firstStall, secondStall],
			endTimestamp: endTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: timestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			startTimestamp: playTimestamp,
			productType: mediaProduct.productType,
			requestedProductId: mediaProduct.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId,
			actions: [firstStop, firstStart, secondStop, secondStart],
			endTimestamp: endTimestamp,
			endAssetPosition: endAssetPosition
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition,
			duration: Constants.duration,
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}

	func testStallsDueToSeek_legacy() {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp
		let mediaProduct = Constants.mediaProduct
		playerEngine.load(mediaProduct, timestamp: initialTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 2
		let playTimestampDouble: Double = 2
		timestamp = playTimestamp
		playerEngine.play(timestamp: playTimestamp)
		player.playing()
		player.assetPosition = playTimestampDouble

		let endTimestamp: UInt64 = 3
		let endTimestampDouble: Double = 3
		timestamp = endTimestamp
		playerEngine.seek(endTimestampDouble)
		player.seeking()
		player.stalled()
		let firstStop = Action(actionType: .PLAYBACK_STOP, assetPosition: playTimestampDouble, timestamp: endTimestamp)
		let firstStall = Stall(
			reason: .SEEK,
			assetPosition: playTimestampDouble,
			startTimestamp: endTimestamp,
			endTimestamp: endTimestamp
		)
		player.assetPosition = endTimestampDouble

		player.playing()
		let firstStart = Action(actionType: .PLAYBACK_START, assetPosition: endTimestampDouble, timestamp: endTimestamp)
		player.assetPosition = 4

		playerEngine.seek(9)
		player.seeking()
		player.stalled()
		let secondStop = Action(actionType: .PLAYBACK_STOP, assetPosition: 4, timestamp: endTimestamp)
		let secondStall = Stall(reason: .SEEK, assetPosition: 4, startTimestamp: endTimestamp, endTimestamp: endTimestamp)
		player.assetPosition = 9

		player.playing()
		let secondStart = Action(actionType: .PLAYBACK_START, assetPosition: 9, timestamp: endTimestamp)

		let endAssetPosition: Double = 10
		player.assetPosition = endAssetPosition
		player.completed()

		optimizedWait(until: {
			playerEventSender.streamingMetricsEvents.count == 4 &&
				playerEventSender.playLogEvents.count == 1 &&
				playerEventSender.progressEvents.count == 1
		})

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualPlaybackStatistics = playerEventSender.streamingMetricsEvents[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: playTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			stalls: [firstStall, secondStall],
			endTimestamp: endTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: timestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			startTimestamp: playTimestamp,
			productType: mediaProduct.productType,
			requestedProductId: mediaProduct.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId,
			actions: [firstStop, firstStart, secondStop, secondStart],
			endTimestamp: endTimestamp,
			endAssetPosition: endAssetPosition
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition,
			duration: Constants.duration,
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}

	func testStallsDueToSeek_legacy2() {
		assertStallsDueToSeek_legacy(shouldSendEventsInDeinit: true)
	}

	func testStallsDueToSeek_legacy3() {
		assertStallsDueToSeek_legacy(shouldSendEventsInDeinit: false)
	}

	func assertStallsDueToSeek_legacy(shouldSendEventsInDeinit: Bool) {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = shouldSendEventsInDeinit

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp
		let mediaProduct = Constants.mediaProduct
		playerEngine.load(mediaProduct, timestamp: initialTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 2
		let playTimestampDouble: Double = 2
		timestamp = playTimestamp
		playerEngine.play(timestamp: playTimestamp)
		player.playing()
		player.assetPosition = playTimestampDouble

		let endTimestamp: UInt64 = 3
		let endTimestampDouble: Double = 3
		timestamp = endTimestamp
		playerEngine.seek(endTimestampDouble)
		player.seeking()
		player.stalled()
		let firstStop = Action(actionType: .PLAYBACK_STOP, assetPosition: playTimestampDouble, timestamp: endTimestamp)
		let firstStall = Stall(
			reason: .SEEK,
			assetPosition: playTimestampDouble,
			startTimestamp: endTimestamp,
			endTimestamp: endTimestamp
		)
		player.assetPosition = endTimestampDouble

		player.playing()
		let firstStart = Action(actionType: .PLAYBACK_START, assetPosition: endTimestampDouble, timestamp: endTimestamp)
		player.assetPosition = 4

		playerEngine.seek(9)
		player.seeking()
		player.stalled()
		let secondStop = Action(actionType: .PLAYBACK_STOP, assetPosition: 4, timestamp: endTimestamp)
		let secondStall = Stall(reason: .SEEK, assetPosition: 4, startTimestamp: endTimestamp, endTimestamp: endTimestamp)
		player.assetPosition = 9

		player.playing()
		let secondStart = Action(actionType: .PLAYBACK_START, assetPosition: 9, timestamp: endTimestamp)

		let endAssetPosition: Double = 10
		player.assetPosition = endAssetPosition
		player.completed()

		optimizedWait(until: {
			playerEventSender.streamingMetricsEvents.count == 4 &&
				playerEventSender.playLogEvents.count == 1 &&
				playerEventSender.progressEvents.count == 1
		})

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		let actualPlaybackStatistics = playerEventSender.streamingMetricsEvents[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: playTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			stalls: [firstStall, secondStall],
			endTimestamp: endTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: timestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			startTimestamp: playTimestamp,
			productType: mediaProduct.productType,
			requestedProductId: mediaProduct.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId,
			actions: [firstStop, firstStart, secondStop, secondStart],
			endTimestamp: endTimestamp,
			endAssetPosition: endAssetPosition
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition,
			duration: Constants.duration,
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}

	func testStallAndAbortedSeeks() {
		shouldUseEventProducer = true
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp

		let mediaProduct = Constants.mediaProduct
		playerEngine.load(mediaProduct, timestamp: initialTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 2
		playerEngine.play(timestamp: playTimestamp)
		player.playing()
		player.assetPosition = 1

		player.stalled()
		let firstStall = Stall(
			reason: .UNEXPECTED,
			assetPosition: 1,
			startTimestamp: initialTimestamp,
			endTimestamp: initialTimestamp
		)
		let firstStop = Action(actionType: .PLAYBACK_STOP, assetPosition: 1, timestamp: initialTimestamp)

		player.playing()
		let firstStart = Action(actionType: .PLAYBACK_START, assetPosition: 1, timestamp: initialTimestamp)
		player.assetPosition = 2

		playerEngine.seek(3)
		player.seeking()
		let secondStop = Action(actionType: .PLAYBACK_STOP, assetPosition: 2, timestamp: initialTimestamp)

		playerEngine.seek(4)
		player.seeking()
		player.stalled()
		let secondStall = Stall(reason: .SEEK, assetPosition: 2, startTimestamp: initialTimestamp, endTimestamp: initialTimestamp)

		playerEngine.seek(5)
		player.seeking()
		player.assetPosition = 5
		player.playing()
		let secondStart = Action(actionType: .PLAYBACK_START, assetPosition: 5, timestamp: initialTimestamp)

		// Fire of unexpected playing event
		player.playing()

		player.assetPosition = 7

		// Set timestamp equal/higher than current media product, since events are sent afterwards, so to fake time has passed.
		let endTimestamp: UInt64 = 5
		timestamp = endTimestamp

		playerEngine.reset()

		listenerQueue.sync {}

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		listenerQueue.sync {}

		let actualPlaybackStatistics = playerEventSender.streamingMetricsEvents[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: initialTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			stalls: [firstStall, secondStall],
			endReason: EndReason.OTHER.rawValue,
			endTimestamp: endTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: timestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let endAssetPosition: Double = 7
		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			startTimestamp: initialTimestamp,
			productType: mediaProduct.productType,
			requestedProductId: mediaProduct.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId,
			actions: [firstStop, firstStart, secondStop, secondStart],
			endTimestamp: endTimestamp,
			endAssetPosition: endAssetPosition
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition,
			duration: Constants.duration,
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}

	func testStallAndAbortedSeeks_legacy() {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp

		let mediaProduct = Constants.mediaProduct
		playerEngine.load(mediaProduct, timestamp: initialTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 2
		playerEngine.play(timestamp: playTimestamp)
		player.playing()
		player.assetPosition = 1

		player.stalled()
		let firstStall = Stall(reason: .UNEXPECTED, assetPosition: 1, startTimestamp: initialTimestamp, endTimestamp: initialTimestamp)
		let firstStop = Action(actionType: .PLAYBACK_STOP, assetPosition: 1, timestamp: initialTimestamp)

		player.playing()
		let firstStart = Action(actionType: .PLAYBACK_START, assetPosition: 1, timestamp: initialTimestamp)
		player.assetPosition = 2

		playerEngine.seek(3)
		player.seeking()
		let secondStop = Action(actionType: .PLAYBACK_STOP, assetPosition: 2, timestamp: initialTimestamp)

		playerEngine.seek(4)
		player.seeking()
		player.stalled()
		let secondStall = Stall(reason: .SEEK, assetPosition: 2, startTimestamp: initialTimestamp, endTimestamp: initialTimestamp)

		playerEngine.seek(5)
		player.seeking()
		player.assetPosition = 5
		player.playing()
		let secondStart = Action(actionType: .PLAYBACK_START, assetPosition: 5, timestamp: initialTimestamp)

		// Fire of unexpected playing event
		player.playing()

		player.assetPosition = 7

		// Set timestamp equal/higher than current media product, since events are sent afterwards, so to fake time has passed.
		let endTimestamp: UInt64 = 5
		timestamp = endTimestamp

		playerEngine.reset()

		listenerQueue.sync {}

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		listenerQueue.sync {}

		let actualPlaybackStatistics = playerEventSender.streamingMetricsEvents[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: initialTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			stalls: [firstStall, secondStall],
			endReason: EndReason.OTHER.rawValue,
			endTimestamp: endTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: timestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let endAssetPosition: Double = 7
		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			startTimestamp: initialTimestamp,
			productType: mediaProduct.productType,
			requestedProductId: mediaProduct.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId,
			actions: [firstStop, firstStart, secondStop, secondStart],
			endTimestamp: endTimestamp,
			endAssetPosition: endAssetPosition
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition,
			duration: Constants.duration,
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}

	func testStallAndAbortedSeeks_legacy2() {
		assertStallAndAbortedSeeks_legacy(shouldSendEventsInDeinit: true)
	}

	func testStallAndAbortedSeeks_legacy3() {
		assertStallAndAbortedSeeks_legacy(shouldSendEventsInDeinit: false)
	}

	func assertStallAndAbortedSeeks_legacy(shouldSendEventsInDeinit: Bool) {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = shouldSendEventsInDeinit

		let playbackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: playbackInfo)

		let initialTimestamp: UInt64 = 1
		timestamp = initialTimestamp

		let mediaProduct = Constants.mediaProduct
		playerEngine.load(mediaProduct, timestamp: initialTimestamp)
		player.loaded()

		let playTimestamp: UInt64 = 2
		playerEngine.play(timestamp: playTimestamp)
		player.playing()
		player.assetPosition = 1

		player.stalled()
		let firstStall = Stall(reason: .UNEXPECTED, assetPosition: 1, startTimestamp: initialTimestamp, endTimestamp: initialTimestamp)
		let firstStop = Action(actionType: .PLAYBACK_STOP, assetPosition: 1, timestamp: initialTimestamp)

		player.playing()
		let firstStart = Action(actionType: .PLAYBACK_START, assetPosition: 1, timestamp: initialTimestamp)
		player.assetPosition = 2

		playerEngine.seek(3)
		player.seeking()
		let secondStop = Action(actionType: .PLAYBACK_STOP, assetPosition: 2, timestamp: initialTimestamp)

		playerEngine.seek(4)
		player.seeking()
		player.stalled()
		let secondStall = Stall(reason: .SEEK, assetPosition: 2, startTimestamp: initialTimestamp, endTimestamp: initialTimestamp)

		playerEngine.seek(5)
		player.seeking()
		player.assetPosition = 5
		player.playing()
		let secondStart = Action(actionType: .PLAYBACK_START, assetPosition: 5, timestamp: initialTimestamp)

		// Fire of unexpected playing event
		player.playing()

		player.assetPosition = 7

		// Set timestamp equal/higher than current media product, since events are sent afterwards, so to fake time has passed.
		let endTimestamp: UInt64 = 5
		timestamp = endTimestamp

		playerEngine.reset()

		listenerQueue.sync {}

		XCTAssertEqual(playerEventSender.streamingMetricsEvents.count, 4)
		XCTAssertEqual(playerEventSender.playLogEvents.count, 1)
		XCTAssertEqual(playerEventSender.progressEvents.count, 1)

		listenerQueue.sync {}

		let actualPlaybackStatistics = playerEventSender.streamingMetricsEvents[2] as! PlaybackStatistics
		let expectedPlaybackStatistics = PlaybackStatistics.mock(
			idealStartTimestamp: playTimestamp,
			actualStartTimestamp: initialTimestamp,
			actualProductId: "\(playbackInfo.trackId)",
			stalls: [firstStall, secondStall],
			endReason: EndReason.OTHER.rawValue,
			endTimestamp: endTimestamp
		)
		validatePlaybackStatistics(event: actualPlaybackStatistics, expectedEvent: expectedPlaybackStatistics)

		let actualStreamingSessionEndEvent = playerEventSender.streamingMetricsEvents[3] as! StreamingSessionEnd
		let expectedStreamingSessionEndEvent = StreamingSessionEnd.mock(timestamp: timestamp)
		validateStreamingSessionEnd(event: actualStreamingSessionEndEvent, expectedEvent: expectedStreamingSessionEndEvent)

		let endAssetPosition: Double = 7
		let actualPlayLog = playerEventSender.playLogEvents[0]
		let expectedPlayLog = PlayLogEvent.mock(
			startTimestamp: initialTimestamp,
			productType: mediaProduct.productType,
			requestedProductId: mediaProduct.productId,
			actualProductId: "\(playbackInfo.trackId)",
			actualQuality: AudioQuality.LOSSLESS.rawValue,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId,
			actions: [firstStop, firstStart, secondStop, secondStart],
			endTimestamp: endTimestamp,
			endAssetPosition: endAssetPosition
		)
		validatePlayLog(event: actualPlayLog, expectedEvent: expectedPlayLog)

		let assetPosition = Int(endAssetPosition * 1000)
		let actualProgressEvent = playerEventSender.progressEvents[0]
		let expectedProgressEvent = ProgressEvent.mock(
			id: "\(playbackInfo.trackId)",
			assetPosition: assetPosition,
			duration: Constants.duration,
			type: mediaProduct.productType,
			sourceType: mediaProduct.progressSource?.sourceType,
			sourceId: mediaProduct.progressSource?.sourceId
		)
		validateProgressEvent(event: actualProgressEvent, expectedEvent: expectedProgressEvent)
	}
}

// MARK: - Helpers

private extension EventsTests {
	func validateStreamingSessionStart(event: StreamingSessionStart, expectedEvent: StreamingSessionStart) {
		XCTAssertEqual(event, expectedEvent)
	}

	func validateStreamingSessionEnd(event: StreamingSessionEnd, expectedEvent: StreamingSessionEnd) {
		XCTAssertEqual(event, expectedEvent)
	}

	func validatePlaybackInfoFetch(event: PlaybackInfoFetch, expectedEvent: PlaybackInfoFetch) {
		XCTAssertEqual(event, expectedEvent)
	}

	func validatePlaybackStatistics(event: PlaybackStatistics, expectedEvent: PlaybackStatistics) {
		XCTAssertEqual(event, expectedEvent)
	}

	func validatePlayLog(event: PlayLogEvent, expectedEvent: PlayLogEvent) {
		XCTAssertEqual(event, expectedEvent)
	}

	func validateProgressEvent(event: ProgressEvent, expectedEvent: ProgressEvent) {
		XCTAssertEqual(event, expectedEvent)
	}
}

// MARK: - Mock

private extension EventsTests {
	func mockStreamingSessionStart(
		streamingSessionId: String = "uuid",
		startReason: StartReason,
		timestamp: UInt64 = 1,
		sessionProductId: String = "productId",
		sessionTags: [StreamingSessionStart.SessionTag]? = nil
	) -> StreamingSessionStart {
		StreamingSessionStart.mock(
			streamingSessionId: streamingSessionId,
			startReason: startReason,
			timestamp: timestamp,
			networkType: Constants.networkType,
			sessionProductId: sessionProductId,
			sessionTags: sessionTags
		)
	}
}

// swiftlint:enable force_cast type_body_length file_length
