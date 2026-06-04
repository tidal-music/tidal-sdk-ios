import Auth
import EventProducer
import Foundation
@testable import Player
import Testing

// MARK: - Constants

// swiftlint:disable file_length

private enum Constants {
	static let token = "1234"
	static let tokenEncodedBase64 = "blabla.eyJjaWQiOjEyMzR9.blahblah"

	static let userId = 19
	static let successfulAuthResult: AuthResult = AuthResult.success(Credentials.mock(
		userId: String(userId),
		token: tokenEncodedBase64
	))
	static let successfulAuthResultNoUserId: AuthResult = AuthResult.success(Credentials.mock(token: tokenEncodedBase64))
	static let failedAuthResult: AuthResult = AuthResult<Credentials>.failure(TidalErrorMock(code: "81"))
	static let userClientId = 10
}

// MARK: - PlayerEventSenderTests

@Suite(.serialized)
final class PlayerEventSenderTests {
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

	init() {
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
			eventSender: eventSender,
			userClientIdSupplier: {
				Constants.userClientId
			}
		)

		user = User(
			id: Constants.userId,
			accessToken: "Bearer \(Constants.tokenEncodedBase64)",
			clientId: Constants.userClientId
		)

		// Provide successful credentials by default. Where needed, we can give fail.
		// User is authenticated (access token + user id)
		credentialsProvider.injectedAuthResult = Constants.successfulAuthResult
	}
}

extension PlayerEventSenderTests {
	// MARK: - StreamingMetricsEvent

	// MARK: StreamingSessionStart

	@Test
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
			payload: streamingSessionStart,
			extras: nil
		)
		await assertLegacyStreamingMetricsEvent(event: streamingSessionStart, expectedDecodedEvent: expectedDecodedEvent)
	}

	@Test
	func test_send_StreamingMetricsEvent_with_StreamingSessionStart() async {
		shouldUseEventProducer = true

		let streamingSessionStart = StreamingSessionStart.mock()
		playerEventSender.send(streamingSessionStart)

		await asyncSchedulerFactory.executeAll()

		assertStreamingMetricsEvent(
			name: StreamingMetricNames.streamingSessionStart,
			group: EventGroup.streamingMetrics,
			payload: streamingSessionStart
		)
	}

	// MARK: StreamingSessionEnd

	@Test
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
			payload: streamingSessionEnd,
			extras: nil
		)
		await assertLegacyStreamingMetricsEvent(event: streamingSessionEnd, expectedDecodedEvent: expectedDecodedEvent)
	}

	@Test
	func test_send_StreamingMetricsEvent_with_StreamingSessionEnd() async {
		shouldUseEventProducer = true

		let streamingSessionEnd = StreamingSessionEnd.mock()
		playerEventSender.send(streamingSessionEnd)

		await asyncSchedulerFactory.executeAll()

		assertStreamingMetricsEvent(
			name: StreamingMetricNames.streamingSessionEnd,
			group: EventGroup.streamingMetrics,
			payload: streamingSessionEnd
		)
	}

	// MARK: DownloadStatistics

	@Test
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
			payload: downloadStatistics,
			extras: nil
		)
		await assertLegacyStreamingMetricsEvent(event: downloadStatistics, expectedDecodedEvent: expectedDecodedEvent)
	}

	@Test
	func test_send_StreamingMetricsEvent_with_DownloadStatistics() async {
		shouldUseEventProducer = true

		let downloadStatistics = DownloadStatistics.mock()
		playerEventSender.send(downloadStatistics)

		await asyncSchedulerFactory.executeAll()

		assertStreamingMetricsEvent(
			name: StreamingMetricNames.downloadStatistics,
			group: EventGroup.streamingMetrics,
			payload: downloadStatistics
		)
	}

	// MARK: DrmLicenseFetch

	@Test
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
			payload: drmLicenseFetch,
			extras: nil
		)
		await assertLegacyStreamingMetricsEvent(event: drmLicenseFetch, expectedDecodedEvent: expectedDecodedEvent)
	}

	@Test
	func test_send_StreamingMetricsEvent_with_DrmLicenseFetch() async {
		shouldUseEventProducer = true

		let drmLicenseFetch = DrmLicenseFetch.mock()
		playerEventSender.send(drmLicenseFetch)

		await asyncSchedulerFactory.executeAll()

		assertStreamingMetricsEvent(
			name: StreamingMetricNames.drmLicenseFetch,
			group: EventGroup.streamingMetrics,
			payload: drmLicenseFetch
		)
	}

	// MARK: PlaybackInfoFetch

	@Test
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
			payload: playbackInfoFetch,
			extras: nil
		)
		await assertLegacyStreamingMetricsEvent(event: playbackInfoFetch, expectedDecodedEvent: expectedDecodedEvent)
	}

	@Test
	func test_send_StreamingMetricsEvent_with_PlaybackInfoFetch() async {
		shouldUseEventProducer = true

		let playbackInfoFetch = PlaybackInfoFetch.mock()
		playerEventSender.send(playbackInfoFetch)

		await asyncSchedulerFactory.executeAll()

		assertStreamingMetricsEvent(
			name: StreamingMetricNames.playbackInfoFetch,
			group: EventGroup.streamingMetrics,
			payload: playbackInfoFetch
		)
	}

	// MARK: PlaybackStatistics

	@Test
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
			payload: playbackStatistics,
			extras: nil
		)
		await assertLegacyStreamingMetricsEvent(event: playbackStatistics, expectedDecodedEvent: expectedDecodedEvent)
	}

	@Test
	func test_send_StreamingMetricsEvent_with_PlaybackStatistics() async {
		shouldUseEventProducer = true

		let playbackStatistics = PlaybackStatistics.mock()
		playerEventSender.send(playbackStatistics)

		await asyncSchedulerFactory.executeAll()

		assertStreamingMetricsEvent(
			name: StreamingMetricNames.playbackStatistics,
			group: EventGroup.streamingMetrics,
			payload: playbackStatistics
		)
	}

	// MARK: - PlayLogEvent

	@Test
	func test_send_PlayLogEvent_legacy() async {
		shouldUseEventProducer = false
		await assertLegacyPlayLogEvent()
	}

	@Test
	func test_send_PlayLogEvent() async {
		shouldUseEventProducer = true
		await assertPlayLogEvent()
	}

	@Test
	func test_send_PlayLogEvent_with_tablet_deviceType_legacy() async {
		deviceType = DeviceInfoProvider.Constants.deviceTypeTablet
		shouldUseEventProducer = false
		await assertLegacyPlayLogEvent()
	}

	@Test
	func test_send_PlayLogEvent_with_tablet_deviceType() async {
		deviceType = DeviceInfoProvider.Constants.deviceTypeTablet
		shouldUseEventProducer = true
		await assertPlayLogEvent()
	}

	@Test
	func test_send_PlayLogEvent_with_embedded_deviceType_legacy() async {
		deviceType = DeviceInfoProvider.Constants.deviceTypeEmbedded
		shouldUseEventProducer = false
		await assertLegacyPlayLogEvent()
	}

	@Test
	func test_send_PlayLogEvent_with_embedded_deviceType() async {
		deviceType = DeviceInfoProvider.Constants.deviceTypeEmbedded
		shouldUseEventProducer = true
		await assertPlayLogEvent()
	}

	// MARK: - OfflinePlay

	@Test
	func test_send_OfflinePlay() async {
		let offlinePlay = OfflinePlay.mock()
		playerEventSender.send(offlinePlay)

		await asyncSchedulerFactory.executeAll()

		let eventData = dataWriter.dataList[0]
		let expectedDecodedEvent = offlinePlay
		assertLegacyEvent(expectedDecodedEvent: expectedDecodedEvent, from: eventData)
	}

	// MARK: Credentials testing

	@Test
	func test_send_event_whenUserIsNotAuthenticated_legacy() async {
		shouldUseEventProducer = false

		// User is not authenticated (one is missing: access token or user id)
		credentialsProvider.injectedAuthResult = Constants.successfulAuthResultNoUserId

		let streamingSessionStart = StreamingSessionStart.mock()
		await assertLegacyStreamingMetricsEventWasNotSent(event: streamingSessionStart)
	}

	@Test
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
			#expect(expectedDecodedEvent == decodedEvent)
		} catch {
			Issue.record("Fail to decode instance of \(T.self)")
		}

		#expect(dataWriter.urls.first?.lastPathComponent == uuid)
		#expect(dataWriter.optionsList.first == Data.WritingOptions.atomic)
	}

	func assertLegacyStreamingMetricsEvent<T: Decodable & Equatable>(
		index: Int = 0,
		event: any StreamingMetricsEvent,
		expectedDecodedEvent: T
	) async {
		playerEventSender.send(event)

		await asyncSchedulerFactory.executeAll()

		let eventData = dataWriter.dataList[index]
		assertLegacyEvent(expectedDecodedEvent: expectedDecodedEvent, from: eventData)
	}

	func assertStreamingMetricsEvent<T: Codable & Equatable>(
		name: String,
		group: EventGroup,
		payload: T
	) {
		assertEvent(name: name, group: group, consentCategory: .performance, playerEvent: payload, extras: nil)
	}

	func assertLegacyStreamingMetricsEventWasNotSent(event: any StreamingMetricsEvent) async {
		playerEventSender.send(event)

		await asyncSchedulerFactory.executeAll()

		#expect(dataWriter.dataList.isEmpty)
	}

	func assertLegacyPlayLogEvent() async {
		let playLogEvent = PlayLogEvent.mock()
		let playLogEventExtras: PlayerEvent.Extras = .mock()
		playerEventSender.send(playLogEvent, extras: playLogEventExtras)

		await asyncSchedulerFactory.executeAll()

		let eventData = dataWriter.dataList[0]
		let expectedDecodedEvent = LegacyEvent<PlayLogEvent>(
			group: EventGroup.playlog.rawValue,
			name: EventNames.playbackSession,
			version: EventGroup.playlog.version,
			ts: timestamp,
			user: user,
			client: client,
			payload: playLogEvent,
			extras: playLogEventExtras
		)
		assertLegacyEvent(expectedDecodedEvent: expectedDecodedEvent, from: eventData)
	}

	func assertPlayLogEvent() async {
		let playLogEvent = PlayLogEvent.mock()
		let playLogEventExtras: PlayerEvent.Extras = .mock()
		playerEventSender.send(playLogEvent, extras: playLogEventExtras)

		await asyncSchedulerFactory.executeAll()

		let name = EventNames.playbackSession
		let group = EventGroup.playlog
		let consentCategory = ConsentCategory.necessary
		assertEvent(name: name, group: group, consentCategory: consentCategory, playerEvent: playLogEvent, extras: playLogEventExtras)
	}

	func assertEvent<T: Codable & Equatable>(
		name: String,
		group: EventGroup,
		consentCategory: ConsentCategory,
		playerEvent: T,
		extras: PlayerEvent.Extras?
	) {
		let expectedEvent = PlayerEvent(
			group: group.rawValue,
			version: group.version,
			ts: timestamp,
			user: user,
			client: client,
			payload: playerEvent,
			extras: extras
		)

		guard let data = try? encoder.encode(expectedEvent), let payloadString = String(data: data, encoding: .utf8) else {
			Issue.record("Failed to encode event: \(expectedEvent)")
			return
		}

		let expectedEventSent = EventSenderMock.Event(
			name: name,
			consentCategory: consentCategory,
			headers: [:],
			payload: payloadString
		)

		guard let sentEvent = eventSender.sentEvents.first else {
			Issue.record("Failed to send event to EventSenderMock")
			return
		}

		// Since we don't guarantee the sorting keys in payload, we compare each property individually.
		// Payload is then decoded and asserted afterwards.
		#expect(expectedEventSent.name == sentEvent.name)
		#expect(expectedEventSent.consentCategory == sentEvent.consentCategory)
		#expect(expectedEventSent.headers == sentEvent.headers)

		let sendEventPayload = sentEvent.payload
		guard let sendEventPayloadData = sendEventPayload.data(using: .utf8) else {
			Issue.record("Failed to convert string to data: \(sendEventPayload)")
			return
		}

		do {
			let sentPlayerEvent = try decoder.decode(PlayerEvent<T>.self, from: sendEventPayloadData)
			let actualObject = sentPlayerEvent.payload
			#expect(playerEvent == actualObject)
		} catch {
			Issue.record("Failed to decode PlayerEvent of \(T.self): \(error)")
		}
	}
}
