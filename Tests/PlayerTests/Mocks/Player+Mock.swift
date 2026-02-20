import Auth
import Foundation
@testable import Player

extension PlayerEngine {
	static func mock(
		queue: OperationQueue = OperationQueueMock(),
		httpClient: HttpClient = HttpClient(),
		credentialsProvider: CredentialsProvider = CredentialsProviderMock(),
		fairplayLicenseFetcher: FairPlayLicenseFetcher = FairPlayLicenseFetcher.mock(),
		configuration: Configuration = Configuration.mock(),
		playerEventSender: PlayerEventSender = PlayerEventSenderMock(),
		networkMonitor: NetworkMonitor = NetworkMonitorMock(),
		storage: OfflineStorage = OfflineStorageMock(),
		playerLoader: PlayerLoader = PlayerLoaderMock(),
		featureFlagProvider: FeatureFlagProvider = .mock,
		notificationsHandler: NotificationsHandler? = .mock(queue: DispatchQueue(label: "com.tidal.queue.for.testing"))
	) -> PlayerEngine {
		PlayerEngine(
			with: queue,
			httpClient,
			credentialsProvider,
			fairplayLicenseFetcher,
			configuration,
			playerEventSender,
			networkMonitor,
			storage,
			nil,
			nil,
			playerLoader,
			featureFlagProvider,
			notificationsHandler
		)
	}
}
