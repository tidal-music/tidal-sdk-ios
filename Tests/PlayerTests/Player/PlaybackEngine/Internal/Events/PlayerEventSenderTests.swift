import Auth
import EventProducer
@testable import Player
import XCTest

// MARK: - Constants

// swiftlint:disable file_length

private enum Constants {
	static let token = "token"

	static let successfulAuthResult: AuthResult = AuthResult.success(Credentials.mock(userId: "userId", token: token))
	static let successfulAuthResultNoUserId: AuthResult = AuthResult.success(Credentials.mock(token: token))
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
	private var accessTokenProvider: AuthTokenProviderMock!
	private var credentialsProvider: CredentialsProviderMock!
	private var dataWriter: DataWriterMock!
	private var playerEventSender: PlayerEventSender!
	private var featureFlagProvider: FeatureFlagProvider!
	private var eventSender: EventSenderMock!

	private var user: User!
	private var client: Client {
		Client(
			token: configuration.clientToken,
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

		var deviceInfoProvider = DeviceInfoProvider.mock
		deviceInfoProvider.deviceType = { _ in
			self.deviceType
		}

		PlayerWorld = PlayerWorldClient.mock(
			deviceInfoProvider: deviceInfoProvider,
			timeProvider: timeProvider,
			uuidProvider: uuidProvider
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

		accessTokenProvider = AuthTokenProviderMock()
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
			accessTokenProvider: accessTokenProvider,
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

	func test_send_StreamingMetricsEvent_with_StreamingSessionStart() {
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		let streamingSessionStart = StreamingSessionStart.mock()
		playerEventSender.send(streamingSessionStart)

		optimizedWait {
			!eventSender.sentEvents.isEmpty
		}
		assertStreamingMetricsEvent(
			name: StreamingMetricNames.streamingSessionStart,
			group: EventGroup.streamingMetrics,
			payload: streamingSessionStart
		)
	}

	func test_send_StreamingMetricsEvent_with_StreamingSessionStart_legacy() {
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		let streamingSessionStart = StreamingSessionStart.mock()
		playerEventSender.send(streamingSessionStart)

		optimizedWait {
			!eventSender.sentEvents.isEmpty
		}
		assertStreamingMetricsEvent(
			name: StreamingMetricNames.streamingSessionStart,
			group: EventGroup.streamingMetrics,
			payload: streamingSessionStart
		)
	}

	func test_send_StreamingMetricsEvent_with_StreamingSessionStart_legacy2() {
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

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
		assertLegacyStreamingMetricsEvent(event: streamingSessionStart, expectedDecodedEvent: expectedDecodedEvent)
	}

	func test_send_StreamingMetricsEvent_with_StreamingSessionStart_legacy3() {
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

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
		assertLegacyStreamingMetricsEvent(event: streamingSessionStart, expectedDecodedEvent: expectedDecodedEvent)
	}

	// MARK: StreamingSessionEnd

	func test_send_StreamingMetricsEvent_with_StreamingSessionEnd_legacy() {
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
		assertLegacyStreamingMetricsEvent(event: streamingSessionEnd, expectedDecodedEvent: expectedDecodedEvent)
	}

	func test_send_StreamingMetricsEvent_with_StreamingSessionEnd() {
		let streamingSessionEnd = StreamingSessionEnd.mock()
		playerEventSender.send(streamingSessionEnd)

		optimizedWait {
			!eventSender.sentEvents.isEmpty
		}
		assertStreamingMetricsEvent(
			name: StreamingMetricNames.streamingSessionEnd,
			group: EventGroup.streamingMetrics,
			payload: streamingSessionEnd
		)
	}

	// MARK: DownloadStatistics

	func test_send_StreamingMetricsEvent_with_DownloadStatistics() {
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		let downloadStatistics = DownloadStatistics.mock()
		playerEventSender.send(downloadStatistics)

		optimizedWait {
			!eventSender.sentEvents.isEmpty
		}
		assertStreamingMetricsEvent(
			name: StreamingMetricNames.downloadStatistics,
			group: EventGroup.streamingMetrics,
			payload: downloadStatistics
		)
	}

	func test_send_StreamingMetricsEvent_with_DownloadStatistics_legacy() {
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		let downloadStatistics = DownloadStatistics.mock()
		playerEventSender.send(downloadStatistics)

		optimizedWait {
			!eventSender.sentEvents.isEmpty
		}
		assertStreamingMetricsEvent(
			name: StreamingMetricNames.downloadStatistics,
			group: EventGroup.streamingMetrics,
			payload: downloadStatistics
		)
	}

	func test_send_StreamingMetricsEvent_with_DownloadStatistics_legacy2() {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

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
		assertLegacyStreamingMetricsEvent(event: downloadStatistics, expectedDecodedEvent: expectedDecodedEvent)
	}

	func test_send_StreamingMetricsEvent_with_DownloadStatistics_legacy3() {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

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
		assertLegacyStreamingMetricsEvent(event: downloadStatistics, expectedDecodedEvent: expectedDecodedEvent)
	}

	// MARK: DrmLicenseFetch

	func test_send_StreamingMetricsEvent_with_DrmLicenseFetch_legacy() {
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
		assertLegacyStreamingMetricsEvent(event: drmLicenseFetch, expectedDecodedEvent: expectedDecodedEvent)
	}

	func test_send_StreamingMetricsEvent_with_DrmLicenseFetch() {
		let drmLicenseFetch = DrmLicenseFetch.mock()
		playerEventSender.send(drmLicenseFetch)

		optimizedWait {
			!eventSender.sentEvents.isEmpty
		}
		assertStreamingMetricsEvent(
			name: StreamingMetricNames.drmLicenseFetch,
			group: EventGroup.streamingMetrics,
			payload: drmLicenseFetch
		)
	}

	// MARK: PlaybackInfoFetch

	func test_send_StreamingMetricsEvent_with_PlaybackInfoFetch_legacy() {
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
		assertLegacyStreamingMetricsEvent(event: playbackInfoFetch, expectedDecodedEvent: expectedDecodedEvent)
	}

	func test_send_StreamingMetricsEvent_with_PlaybackInfoFetch() {
		let playbackInfoFetch = PlaybackInfoFetch.mock()
		playerEventSender.send(playbackInfoFetch)

		optimizedWait {
			!eventSender.sentEvents.isEmpty
		}
		assertStreamingMetricsEvent(
			name: StreamingMetricNames.playbackInfoFetch,
			group: EventGroup.streamingMetrics,
			payload: playbackInfoFetch
		)
	}

	// MARK: PlaybackStatistics

	func test_send_StreamingMetricsEvent_with_PlaybackStatistics_legacy() {
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
		assertLegacyStreamingMetricsEvent(event: playbackStatistics, expectedDecodedEvent: expectedDecodedEvent)
	}

	func test_send_StreamingMetricsEvent_with_PlaybackStatistics() {
		let playbackStatistics = PlaybackStatistics.mock()
		playerEventSender.send(playbackStatistics)

		optimizedWait {
			!eventSender.sentEvents.isEmpty
		}
		assertStreamingMetricsEvent(
			name: StreamingMetricNames.playbackStatistics,
			group: EventGroup.streamingMetrics,
			payload: playbackStatistics
		)
	}

	// MARK: - PlayLogEvent

	func test_send_PlayLogEvent() {
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false
		assertPlayLogEvent()
	}

	func test_send_PlayLogEvent_legacy() {
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true
		assertPlayLogEvent()
	}

	func test_send_PlayLogEvent_legacy2() {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		assertLegacyPlayLogEvent()
	}

	func test_send_PlayLogEvent_legacy3() {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		assertLegacyPlayLogEvent()
	}

	func test_send_PlayLogEvent_with_tablet_deviceType_legacy() {
		deviceType = DeviceInfoProvider.Constants.deviceTypeTablet
		shouldUseEventProducer = false

		assertLegacyPlayLogEvent()
	}

	func test_send_PlayLogEvent_with_tablet_deviceType() {
		deviceType = DeviceInfoProvider.Constants.deviceTypeTablet

		assertPlayLogEvent()
	}

	func test_send_PlayLogEvent_with_embedded_deviceType_legacy() {
		deviceType = DeviceInfoProvider.Constants.deviceTypeEmbedded
		shouldUseEventProducer = false

		assertLegacyPlayLogEvent()
	}

	func test_send_PlayLogEvent_with_embedded_deviceType() {
		deviceType = DeviceInfoProvider.Constants.deviceTypeEmbedded

		assertPlayLogEvent()
	}

	// MARK: - ProgressEvent

	func test_send_ProgressEvent_legacy() {
		shouldUseEventProducer = false

		let progressEvent = ProgressEvent.mock()
		playerEventSender.send(progressEvent)

		optimizedWait(until: {
			!dataWriter.dataList.isEmpty
		})

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

	func test_send_ProgressEvent() {
		let progressEvent = ProgressEvent.mock()
		playerEventSender.send(progressEvent)

		optimizedWait {
			!eventSender.sentEvents.isEmpty
		}

		let name = EventNames.progress
		let group = EventGroup.playback
		let consentCategory = ConsentCategory.necessary
		assertEvent(name: name, group: group, consentCategory: consentCategory, playerEvent: progressEvent)
	}

	// MARK: - OfflinePlay

	func test_send_OfflinePlay() {
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		let offlinePlay = OfflinePlay.mock()
		playerEventSender.send(offlinePlay)

		optimizedWait(until: {
			!dataWriter.dataList.isEmpty
		})

		let eventData = dataWriter.dataList[0]
		let expectedDecodedEvent = offlinePlay

		assertLegacyEvent(expectedDecodedEvent: expectedDecodedEvent, from: eventData)
	}

	func test_send_OfflinePlay_legacy() {
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = true

		let offlinePlay = OfflinePlay.mock()
		playerEventSender.send(offlinePlay)

		optimizedWait(until: {
			!dataWriter.dataList.isEmpty
		})

		let eventData = dataWriter.dataList[0]
		let expectedDecodedEvent = offlinePlay

		assertLegacyEvent(expectedDecodedEvent: expectedDecodedEvent, from: eventData)
	}

	// MARK: - updateUserConfiguration()

	func test_updateUserConfiguration_legacy() {
		shouldUseEventProducer = false
		PlayerWorld.developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		// Test with any event since all should take into consideration the user configuration change.
		test_send_StreamingMetricsEvent_with_StreamingSessionStart_legacy3()

		// Change user configuration
		let userConfiguration = UserConfiguration.mock(userId: 100, userClientId: 200)
		updateUser(with: userConfiguration)
		playerEventSender.updateUserConfiguration(userConfiguration: userConfiguration)

		// The only difference now is the user (with updated user configuration)
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
		assertLegacyStreamingMetricsEvent(index: 1, event: streamingSessionStart, expectedDecodedEvent: expectedDecodedEvent)
	}

	// MARK: Credentials testing

	func test_send_event_whenUserIsNotAuthenticated_legacy() {
		shouldUseEventProducer = false

		// User is not authenticated (one is missing: access token or user id)
		credentialsProvider.injectedAuthResult = Constants.successfulAuthResultNoUserId

		let streamingSessionStart = StreamingSessionStart.mock()
		assertLegacyStreamingMetricsEventWasNotSent(event: streamingSessionStart)
	}

	func test_send_event_whenUserIsNotLoggedIn_legacy() {
		shouldUseEventProducer = false

		// User is not authenticated (getting credentials failed)
		credentialsProvider.injectedAuthResult = Constants.failedAuthResult

		let streamingSessionStart = StreamingSessionStart.mock()
		assertLegacyStreamingMetricsEventWasNotSent(event: streamingSessionStart)
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
	) {
		playerEventSender.send(event)

		optimizedWait(until: {
			dataWriter.dataList.count >= (index + 1)
		})

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

	func assertLegacyStreamingMetricsEventWasNotSent(event: any StreamingMetricsEvent) {
		playerEventSender.send(event)

		optimizedWait(until: {
			dataWriter.dataList.isEmpty
		})

		let expectation = expectation(description: "\(event.self) should have been sent to DataWriter")
		_ = XCTWaiter.wait(for: [expectation], timeout: 0.1)

		XCTAssertTrue(dataWriter.dataList.isEmpty)
	}

	func assertLegacyPlayLogEvent() {
		let playLogEvent = PlayLogEvent.mock()
		playerEventSender.send(playLogEvent)

		optimizedWait(until: {
			!dataWriter.dataList.isEmpty
		})

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

	func assertPlayLogEvent() {
		let playLogEvent = PlayLogEvent.mock()
		playerEventSender.send(playLogEvent)

		optimizedWait {
			!eventSender.sentEvents.isEmpty
		}

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
		optimizedWait {
			!eventSender.sentEvents.isEmpty
		}

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
			accessToken: "Bearer \(Constants.token)",
			clientId: userConfiguration.userClientId
		)
	}
}
