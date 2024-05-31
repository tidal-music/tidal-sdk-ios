import Auth
import EventProducer
@testable import Player
import XCTest

// MARK: - Constants

// swiftlint:disable file_length

private enum Constants {
	static let token = "1234"
	static let tokenEncodedBase64 = "blabla.eyJjaWQiOjEyMzR9.blahblah"

	static let successfulAuthResult: AuthResult = AuthResult.success(Credentials.mock(userId: "userId", token: tokenEncodedBase64))
	static let successfulAuthResultNoUserId: AuthResult = AuthResult.success(Credentials.mock(token: tokenEncodedBase64))
	static let failedAuthResult: AuthResult = AuthResult<Credentials>.failure(TidalErrorMock(code: "81"))
}

// MARK: - PlayerEventSenderTests

final class PlayerEventSenderTests: XCTestCase {
	private let timestamp: UInt64 = 1
	private var uuid = "uuid"
	private var deviceType = DeviceInfoProvider.Constants.deviceTypeMobile
	private var shouldUseEventProducer = true

	private var configuration: Configuration!
	private var errorManager: ErrorManagerMock!
	private var httpClient: HttpClient!
	private var credentialsProvider: CredentialsProviderMock!
	private var dataWriter: DataWriterMock!
	private var playerEventSender: PlayerEventSender!
	private var featureFlagProvider: FeatureFlagProvider!
	private var eventSender: EventSenderMock!

	private var asyncSchedulerFactory: AsyncSchedulerFactorySpy = AsyncSchedulerFactorySpy()

	private var user: User!
	private var client: Client {
		Client(
			token: Constants.token,
			version: configuration.clientVersion,
			deviceType: deviceType
		)
	}

	private let encoder = JSONEncoder()
	private let decoder = JSONDecoder()

	override func setUp() {
		// Set up time and uuid provider
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
		let asyncSchedulerFactoryProvider = AsyncSchedulerFactoryProvider(
			newFactory: {
				self.asyncSchedulerFactory
			}
		)

		var deviceInfoProvider = DeviceInfoProvider.mock
		deviceInfoProvider.deviceType = { _ in
			self.deviceType
		}

		PlayerWorld = PlayerWorldClient.mock(
			deviceInfoProvider: deviceInfoProvider,
			timeProvider: timeProvider,
			uuidProvider: uuidProvider,
			asyncSchedulerFactoryProvider: asyncSchedulerFactoryProvider
		)

		// Set up EventSender
		configuration = Configuration.mock()

		let sessionConfiguration = URLSessionConfiguration.default
		sessionConfiguration.protocolClasses = [JsonEncodedResponseURLProtocol.self]
		let urlSession = URLSession(configuration: sessionConfiguration)
		errorManager = ErrorManagerMock()
		httpClient = HttpClient.mock(
			urlSession: urlSession,
			responseErrorManager: errorManager,
			networkErrorManager: errorManager,
			timeoutErrorManager: errorManager
		)

		credentialsProvider = CredentialsProviderMock()
		dataWriter = DataWriterMock()

		eventSender = EventSenderMock()
		featureFlagProvider = FeatureFlagProvider.mock
		featureFlagProvider.shouldUseEventProducer = {
			self.shouldUseEventProducer
		}
		playerEventSender = PlayerEventSender(
			configuration: configuration,
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			dataWriter: dataWriter,
			featureFlagProvider: featureFlagProvider,
			eventSender: eventSender
		)

		let userConfiguration = UserConfiguration.mock()
		playerEventSender.updateUserConfiguration(userConfiguration: userConfiguration)

		updateUser(with: userConfiguration)

		// Provide successful credentials by default. Where needed, we can give fail.
		// User is authenticated (access token + user id)
		credentialsProvider.injectedAuthResult = Constants.successfulAuthResult
	}
}

extension PlayerEventSenderTests {
	// MARK: - StreamingMetricsEvent

	// MARK: StreamingSessionStart

	func test_send_StreamingMetricsEvent_with_StreamingSessionStart_legacy() async {
		shouldUseEventProducer = false

		let streamingSessionStart = StreamingSessionStart.mock()
		let expectedDecodedEvent = LegacyEvent<StreamingSessionStart>(
			group: EventGroup.streamingMetrics.rawValue,
			name: StreamingMetricNames.streamingSessionStart,
			version: EventGroup.streamingMetrics.version,
			ts: timestamp,
			user: user,
			client: client,
			payload: streamingSessionStart
		)
		await assertLegacyStreamingMetricsEvent(event: streamingSessionStart, expectedDecodedEvent: expectedDecodedEvent)
	}

	func test_send_StreamingMetricsEvent_with_StreamingSessionStart() async {
		shouldUseEventProducer = true
		
		let streamingSessionStart = StreamingSessionStart.mock()
		playerEventSender.send(streamingSessionStart)

		await self.asyncSchedulerFactory.executeAll()

		assertStreamingMetricsEvent(
			name: StreamingMetricNames.streamingSessionStart,
			group: EventGroup.streamingMetrics,
			payload: streamingSessionStart
		)
	}

	// MARK: StreamingSessionEnd

	func test_send_StreamingMetricsEvent_with_StreamingSessionEnd_legacy() async {
		shouldUseEventProducer = false

		let streamingSessionEnd = StreamingSessionEnd.mock()
		let expectedDecodedEvent = LegacyEvent<StreamingSessionEnd>(
			group: EventGroup.streamingMetrics.rawValue,
			name: StreamingMetricNames.streamingSessionEnd,
			version: EventGroup.streamingMetrics.version,
			ts: timestamp,
			user: user,
			client: client,
			payload: streamingSessionEnd
		)
		await assertLegacyStreamingMetricsEvent(event: streamingSessionEnd, expectedDecodedEvent: expectedDecodedEvent)
	}

	func test_send_StreamingMetricsEvent_with_StreamingSessionEnd() async {
		shouldUseEventProducer = true
		
		let streamingSessionEnd = StreamingSessionEnd.mock()
		playerEventSender.send(streamingSessionEnd)

		await self.asyncSchedulerFactory.executeAll()

		assertStreamingMetricsEvent(
			name: StreamingMetricNames.streamingSessionEnd,
			group: EventGroup.streamingMetrics,
			payload: streamingSessionEnd
		)
	}

	// MARK: DownloadStatistics

	func test_send_StreamingMetricsEvent_with_DownloadStatistics_legacy() async {
		shouldUseEventProducer = false

		let downloadStatistics = DownloadStatistics.mock()
		let expectedDecodedEvent = LegacyEvent<DownloadStatistics>(
			group: EventGroup.streamingMetrics.rawValue,
			name: StreamingMetricNames.downloadStatistics,
			version: EventGroup.streamingMetrics.version,
			ts: timestamp,
			user: user,
			client: client,
			payload: downloadStatistics
		)
		await assertLegacyStreamingMetricsEvent(event: downloadStatistics, expectedDecodedEvent: expectedDecodedEvent)
	}
	
	func test_send_StreamingMetricsEvent_with_DownloadStatistics() async {
		shouldUseEventProducer = true
		
		let downloadStatistics = DownloadStatistics.mock()
		playerEventSender.send(downloadStatistics)

		await self.asyncSchedulerFactory.executeAll()

		assertStreamingMetricsEvent(
			name: StreamingMetricNames.downloadStatistics,
			group: EventGroup.streamingMetrics,
			payload: downloadStatistics
		)
	}

	// MARK: DrmLicenseFetch

	func test_send_StreamingMetricsEvent_with_DrmLicenseFetch_legacy() async {
		shouldUseEventProducer = false

		let drmLicenseFetch = DrmLicenseFetch.mock()
		let expectedDecodedEvent = LegacyEvent<DrmLicenseFetch>(
			group: EventGroup.streamingMetrics.rawValue,
			name: StreamingMetricNames.drmLicenseFetch,
			version: EventGroup.streamingMetrics.version,
			ts: timestamp,
			user: user,
			client: client,
			payload: drmLicenseFetch
		)
		await assertLegacyStreamingMetricsEvent(event: drmLicenseFetch, expectedDecodedEvent: expectedDecodedEvent)
	}

	func test_send_StreamingMetricsEvent_with_DrmLicenseFetch() async {
		shouldUseEventProducer = true
		
		let drmLicenseFetch = DrmLicenseFetch.mock()
		playerEventSender.send(drmLicenseFetch)

		await self.asyncSchedulerFactory.executeAll()

		assertStreamingMetricsEvent(
			name: StreamingMetricNames.drmLicenseFetch,
			group: EventGroup.streamingMetrics,
			payload: drmLicenseFetch
		)
	}

	// MARK: PlaybackInfoFetch

	func test_send_StreamingMetricsEvent_with_PlaybackInfoFetch_legacy() async {
		shouldUseEventProducer = false

		let playbackInfoFetch = PlaybackInfoFetch.mock()
		let expectedDecodedEvent = LegacyEvent<PlaybackInfoFetch>(
			group: EventGroup.streamingMetrics.rawValue,
			name: StreamingMetricNames.playbackInfoFetch,
			version: EventGroup.streamingMetrics.version,
			ts: timestamp,
			user: user,
			client: client,
			payload: playbackInfoFetch
		)
		await assertLegacyStreamingMetricsEvent(event: playbackInfoFetch, expectedDecodedEvent: expectedDecodedEvent)
	}

	func test_send_StreamingMetricsEvent_with_PlaybackInfoFetch() async {
		shouldUseEventProducer = true
		
		let playbackInfoFetch = PlaybackInfoFetch.mock()
		playerEventSender.send(playbackInfoFetch)

		await self.asyncSchedulerFactory.executeAll()
		
		assertStreamingMetricsEvent(
			name: StreamingMetricNames.playbackInfoFetch,
			group: EventGroup.streamingMetrics,
			payload: playbackInfoFetch
		)
	}

	// MARK: PlaybackStatistics

	func test_send_StreamingMetricsEvent_with_PlaybackStatistics_legacy() async {
		shouldUseEventProducer = false

		let playbackStatistics = PlaybackStatistics.mock()
		let expectedDecodedEvent = LegacyEvent<PlaybackStatistics>(
			group: EventGroup.streamingMetrics.rawValue,
			name: StreamingMetricNames.playbackStatistics,
			version: EventGroup.streamingMetrics.version,
			ts: timestamp,
			user: user,
			client: client,
			payload: playbackStatistics
		)
		await assertLegacyStreamingMetricsEvent(event: playbackStatistics, expectedDecodedEvent: expectedDecodedEvent)
	}

	func test_send_StreamingMetricsEvent_with_PlaybackStatistics() async {
		shouldUseEventProducer = true
		
		let playbackStatistics = PlaybackStatistics.mock()
		playerEventSender.send(playbackStatistics)
		
		await self.asyncSchedulerFactory.executeAll()
		
		assertStreamingMetricsEvent(
			name: StreamingMetricNames.playbackStatistics,
			group: EventGroup.streamingMetrics,
			payload: playbackStatistics
		)
	}

	// MARK: - PlayLogEvent

	func test_send_PlayLogEvent_legacy() async {
		shouldUseEventProducer = false
		await assertLegacyPlayLogEvent()
	}
	
	func test_send_PlayLogEvent() async {
		shouldUseEventProducer = true
		await assertPlayLogEvent()
	}

	func test_send_PlayLogEvent_with_tablet_deviceType_legacy() async {
		deviceType = DeviceInfoProvider.Constants.deviceTypeTablet
		shouldUseEventProducer = false
		await assertLegacyPlayLogEvent()
	}

	func test_send_PlayLogEvent_with_tablet_deviceType() async {
		deviceType = DeviceInfoProvider.Constants.deviceTypeTablet
		shouldUseEventProducer = true
		await assertPlayLogEvent()
	}

	func test_send_PlayLogEvent_with_embedded_deviceType_legacy() async {
		deviceType = DeviceInfoProvider.Constants.deviceTypeEmbedded
		shouldUseEventProducer = false
		await assertLegacyPlayLogEvent()
	}

	func test_send_PlayLogEvent_with_embedded_deviceType() async {
		deviceType = DeviceInfoProvider.Constants.deviceTypeEmbedded
		shouldUseEventProducer = true
		await assertPlayLogEvent()
	}

	// MARK: - ProgressEvent

	func test_send_ProgressEvent_legacy() async {
		shouldUseEventProducer = false

		let progressEvent = ProgressEvent.mock()
		playerEventSender.send(progressEvent)

		await self.asyncSchedulerFactory.executeAll()

		let eventData = dataWriter.dataList[0]
		let expectedDecodedEvent = LegacyEvent<ProgressEvent>(
			group: EventGroup.playback.rawValue,
			name: EventNames.progress,
			version: EventGroup.playback.version,
			ts: timestamp,
			user: user,
			client: client,
			payload: progressEvent
		)
		assertLegacyEvent(expectedDecodedEvent: expectedDecodedEvent, from: eventData)
	}

	func test_send_ProgressEvent() async {
		shouldUseEventProducer = true
		
		let progressEvent = ProgressEvent.mock()
		playerEventSender.send(progressEvent)

		await self.asyncSchedulerFactory.executeAll()

		let name = EventNames.progress
		let group = EventGroup.playback
		let consentCategory = ConsentCategory.necessary
		assertEvent(name: name, group: group, consentCategory: consentCategory, playerEvent: progressEvent)
	}

	// MARK: - OfflinePlay

	func test_send_OfflinePlay() async {
		let offlinePlay = OfflinePlay.mock()
		playerEventSender.send(offlinePlay)

		await self.asyncSchedulerFactory.executeAll()

		let eventData = dataWriter.dataList[0]
		let expectedDecodedEvent = offlinePlay
		assertLegacyEvent(expectedDecodedEvent: expectedDecodedEvent, from: eventData)
	}

	// MARK: - updateUserConfiguration()

	func test_updateUserConfiguration_legacy() async {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		var streamingSessionStart = StreamingSessionStart.mock()
		var expectedDecodedEvent = LegacyEvent<StreamingSessionStart>(
			group: EventGroup.streamingMetrics.rawValue,
			name: StreamingMetricNames.streamingSessionStart,
			version: EventGroup.streamingMetrics.version,
			ts: timestamp,
			user: user,
			client: client,
			payload: streamingSessionStart
		)
		await assertLegacyStreamingMetricsEvent(event: streamingSessionStart, expectedDecodedEvent: expectedDecodedEvent)

		// Change user configuration
		let userConfiguration = UserConfiguration.mock(userId: 100, userClientId: 200)
		updateUser(with: userConfiguration)
		playerEventSender.updateUserConfiguration(userConfiguration: userConfiguration)

		// The only difference now is the user (with updated user configuration)
		streamingSessionStart = StreamingSessionStart.mock()
		expectedDecodedEvent = LegacyEvent<StreamingSessionStart>(
			group: EventGroup.streamingMetrics.rawValue,
			name: StreamingMetricNames.streamingSessionStart,
			version: EventGroup.streamingMetrics.version,
			ts: timestamp,
			user: user,
			client: client,
			payload: streamingSessionStart
		)
		await assertLegacyStreamingMetricsEvent(index: 1, event: streamingSessionStart, expectedDecodedEvent: expectedDecodedEvent)
	}

	// MARK: Credentials testing

	func test_send_event_whenUserIsNotAuthenticated_legacy() async {
		shouldUseEventProducer = false

		// User is not authenticated (one is missing: access token or user id)
		credentialsProvider.injectedAuthResult = Constants.successfulAuthResultNoUserId

		let streamingSessionStart = StreamingSessionStart.mock()
		await assertLegacyStreamingMetricsEventWasNotSent(event: streamingSessionStart)
	}

	func test_send_event_whenUserIsNotLoggedIn_legacy() async {
		shouldUseEventProducer = false

		// User is not authenticated (getting credentials failed)
		credentialsProvider.injectedAuthResult = Constants.failedAuthResult

		let streamingSessionStart = StreamingSessionStart.mock()
		await assertLegacyStreamingMetricsEventWasNotSent(event: streamingSessionStart)
	}
}

// MARK: - Helper

private extension PlayerEventSenderTests {
	func assertLegacyEvent<T: Decodable & Equatable>(expectedDecodedEvent: T, from eventData: Data) {
		do {
			let decodedEvent = try decoder.decode(T.self, from: eventData)
			XCTAssertEqual(expectedDecodedEvent, decodedEvent)
		} catch {
			XCTFail("Fail to decode instance of \(T.self)")
		}

		XCTAssertEqual(dataWriter.urls.first?.lastPathComponent, uuid)
		XCTAssertEqual(dataWriter.optionsList.first, Data.WritingOptions.atomic)
	}

	func assertLegacyStreamingMetricsEvent<T: Decodable & Equatable>(
		index: Int = 0,
		event: any StreamingMetricsEvent,
		expectedDecodedEvent: T
	) async {
		playerEventSender.send(event)
		
		await self.asyncSchedulerFactory.executeAll()

		let eventData = dataWriter.dataList[index]
		assertLegacyEvent(expectedDecodedEvent: expectedDecodedEvent, from: eventData)
	}

	func assertStreamingMetricsEvent<T: Codable & Equatable>(
		name: String,
		group: EventGroup,
		payload: T
	) {
		assertEvent(name: name, group: group, consentCategory: .performance, playerEvent: payload)
	}

	func assertLegacyStreamingMetricsEventWasNotSent(event: any StreamingMetricsEvent) async {
		playerEventSender.send(event)

		await self.asyncSchedulerFactory.executeAll()

		XCTAssertTrue(dataWriter.dataList.isEmpty)
	}

	func assertLegacyPlayLogEvent() async {
		let playLogEvent = PlayLogEvent.mock()
		playerEventSender.send(playLogEvent)

		await self.asyncSchedulerFactory.executeAll()

		let eventData = dataWriter.dataList[0]
		let expectedDecodedEvent = LegacyEvent<PlayLogEvent>(
			group: EventGroup.playlog.rawValue,
			name: EventNames.playbackSession,
			version: EventGroup.playlog.version,
			ts: timestamp,
			user: user,
			client: client,
			payload: playLogEvent
		)
		assertLegacyEvent(expectedDecodedEvent: expectedDecodedEvent, from: eventData)
	}

	func assertPlayLogEvent() async {
		let playLogEvent = PlayLogEvent.mock()
		playerEventSender.send(playLogEvent)

		await self.asyncSchedulerFactory.executeAll()

		let name = EventNames.playbackSession
		let group = EventGroup.playlog
		let consentCategory = ConsentCategory.necessary
		assertEvent(name: name, group: group, consentCategory: consentCategory, playerEvent: playLogEvent)
	}

	func assertEvent<T: Codable & Equatable>(
		name: String,
		group: EventGroup,
		consentCategory: ConsentCategory,
		playerEvent: T
	) {
		let expectedEvent = PlayerEvent(
			group: group.rawValue,
			version: group.version,
			ts: timestamp,
			user: user,
			client: client,
			payload: playerEvent
		)

		guard let data = try? encoder.encode(expectedEvent), let payloadString = String(data: data, encoding: .utf8) else {
			XCTFail("Failed to encode event: \(expectedEvent)")
			return
		}

		let expectedEventSent = EventSenderMock.Event(
			name: name,
			consentCategory: consentCategory,
			headers: [:],
			payload: payloadString
		)

		guard let sentEvent = eventSender.sentEvents.first else {
			XCTFail("Failed to send event to EventSenderMock")
			return
		}

		// Since we don't guarantee the sorting keys in payload, we compare each property individually.
		// Payload is then decoded and asserted afterwards.
		XCTAssertEqual(expectedEventSent.name, sentEvent.name)
		XCTAssertEqual(expectedEventSent.consentCategory, sentEvent.consentCategory)
		XCTAssertEqual(expectedEventSent.headers, sentEvent.headers)

		let sendEventPayload = sentEvent.payload
		guard let sendEventPayloadData = sendEventPayload.data(using: .utf8) else {
			XCTFail("Failed to convert string to data: \(sendEventPayload)")
			return
		}

		do {
			let sentPlayerEvent = try decoder.decode(PlayerEvent<T>.self, from: sendEventPayloadData)
			let actualObject = sentPlayerEvent.payload
			XCTAssertEqual(playerEvent, actualObject)
		} catch {
			XCTFail("Failed to decode PlayerEvent of \(T.self): \(error)")
		}
	}

	func updateUser(with userConfiguration: UserConfiguration) {
		user = User(
			id: userConfiguration.userId,
			accessToken: "Bearer \(Constants.tokenEncodedBase64)",
			clientId: userConfiguration.userClientId
		)
	}
}
