import Auth
import EventProducer
import Foundation
@testable import Player

final class PlayerEventSenderMock: PlayerEventSender {
	var streamingMetricsEvents = [any StreamingMetricsEvent]()
	var playLogEvents = [PlayLogEvent]()
	var offlinePlays = [OfflinePlay]()
	var writtenEvents = [AnyObject]()

	override init(
		configuration: Configuration = Configuration.mock(),
		httpClient: HttpClient = HttpClient.mock(),
		credentialsProvider: CredentialsProvider = CredentialsProviderMock(),
		dataWriter: DataWriterProtocol = DataWriterMock(),
		featureFlagProvider: FeatureFlagProvider = .mock,
		eventSender: EventSender = EventSenderMock(),
		userClientIdSupplier: (() -> Int)? = nil
	) {
		super.init(
			configuration: configuration,
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			dataWriter: dataWriter,
			featureFlagProvider: featureFlagProvider,
			eventSender: eventSender,
			userClientIdSupplier: userClientIdSupplier
		)
	}

	func reset() {
		streamingMetricsEvents.removeAll()
		playLogEvents.removeAll()
		offlinePlays.removeAll()
	}

	override func send(_ event: any StreamingMetricsEvent, extras: PlayerEvent.Extras? = nil) {
		streamingMetricsEvents.append(event)
	}

	override func send(_ event: PlayLogEvent, extras: PlayerEvent.Extras?) {
		playLogEvents.append(event)
	}

	override func send(_ offlinePlay: OfflinePlay) {
		offlinePlays.append(offlinePlay)
	}

	override func writeEvent<T: Codable & Equatable>(event: LegacyEvent<T>) {
		writtenEvents.append(event)
	}
}
