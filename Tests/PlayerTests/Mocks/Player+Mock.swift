import Auth
import Foundation
@testable import Player

extension PlayerEngine {
	static func mock(
		queue: OperationQueue = OperationQueueMock(),
		httpClient: HttpClient = HttpClient(),
		credentialsProvider: CredentialsProvider = CredentialsProviderMock(),
		fairplayLicenseFetcher: FairPlayLicenseFetcher = FairPlayLicenseFetcher.mock(),
		djProducer: DJProducer = DJProducer(
			httpClient: HttpClient(),
			credentialsProvider: CredentialsProviderMock(),
			featureFlagProvider: .mock
		),
		configuration: Configuration = Configuration.mock(),
		playerEventSender: PlayerEventSender = PlayerEventSenderMock(),
		networkMonitor: NetworkMonitor = NetworkMonitorMock(),
		offlineStorage: OfflineStorage = OfflineStorageMock(),
		cacheStorage: CacheStorage? = CacheStorageMock(),
		playerLoader: PlayerLoader = PlayerLoaderMock(),
		featureFlagProvider: FeatureFlagProvider = .mock,
		notificationsHandler: NotificationsHandler? = .mock(queue: DispatchQueue(label: "com.tidal.queue.for.testing"))
	) -> PlayerEngine {
		PlayerEngine(
			with: queue,
			httpClient,
			credentialsProvider,
			fairplayLicenseFetcher,
			djProducer,
			configuration,
			playerEventSender,
			networkMonitor,
			offlineStorage,
			cacheStorage,
			nil,
			playerLoader,
			featureFlagProvider,
			notificationsHandler
		)
	}
}
