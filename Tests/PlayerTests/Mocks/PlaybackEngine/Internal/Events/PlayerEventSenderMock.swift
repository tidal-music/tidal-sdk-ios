import Auth
import EventProducer
import Foundation
@testable import Player

final class PlayerEventSenderMock: PlayerEventSender {
	var streamingMetricsEvents = [any StreamingMetricsEvent]()
	var playLogEvents = [PlayLogEvent]()
	var progressEvents = [ProgressEvent]()
	var offlinePlays = [OfflinePlay]()
	var userConfigurations = [UserConfiguration]()
	var writtenEvents = [AnyObject]()

	override init(
		configuration: Configuration = Configuration.mock(),
		httpClient: HttpClient = HttpClient.mock(),
		credentialsProvider: CredentialsProvider = CredentialsProviderMock(),
		dataWriter: DataWriterProtocol = DataWriterMock(),
		featureFlagProvider: FeatureFlagProvider = .mock,
		eventSender: EventSender = EventSenderMock()
	) {
		super.init(
			configuration: configuration,
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			dataWriter: dataWriter,
			featureFlagProvider: featureFlagProvider,
			eventSender: eventSender
		)
	}

	func reset() {
		streamingMetricsEvents.removeAll()
		playLogEvents.removeAll()
		progressEvents.removeAll()
		offlinePlays.removeAll()
	}

	override func send(_ event: any StreamingMetricsEvent) {
		streamingMetricsEvents.append(event)
	}

	override func send(_ event: PlayLogEvent) {
		playLogEvents.append(event)
	}

	override func send(_ event: ProgressEvent) {
		progressEvents.append(event)
	}

	override func send(_ offlinePlay: OfflinePlay) {
		offlinePlays.append(offlinePlay)
	}

	override func updateUserConfiguration(userConfiguration: UserConfiguration) {
		userConfigurations.append(userConfiguration)
		super.updateUserConfiguration(userConfiguration: userConfiguration)
	}

	override func writeEvent<T: Codable & Equatable>(event: LegacyEvent<T>) {
		writtenEvents.append(event)
	}
}
