import Auth
import Foundation
@testable import Player

extension PlayerEngine {
	static func mock(
		queue: OperationQueue = OperationQueueMock(),
		httpClient: HttpClient = HttpClient(),
		accessTokenProvider: AccessTokenProvider,
		credentialsProvider: CredentialsProvider = CredentialsProviderMock(),
		fairplayLicenseFetcher: FairPlayLicenseFetcher = FairPlayLicenseFetcher.mock(),
		djProducer: DJProducer = DJProducer(
			httpClient: HttpClient(),
			with: AuthTokenProviderMock(),
			credentialsProvider: CredentialsProviderMock(),
			featureFlagProvider: .mock
		),
		configuration: Configuration = Configuration.mock(),
		playerEventSender: PlayerEventSender = PlayerEventSenderMock(),
		networkMonitor: NetworkMonitor = NetworkMonitorMock(),
		storage: Storage = StorageMock(),
		playerLoader: PlayerLoader = PlayerLoaderMock(),
		featureFlagProvider: FeatureFlagProvider = .mock,
		notificationsHandler: NotificationsHandler? = NotificationsHandler(
			listener: PlayerListenerMock(),
			queue: DispatchQueue(label: "com.tidal.queue.for.testing")
		)
	) -> PlayerEngine {
		PlayerEngine(
			with: queue,
			httpClient,
			accessTokenProvider,
			credentialsProvider,
			fairplayLicenseFetcher,
			djProducer,
			configuration,
			playerEventSender,
			networkMonitor,
			storage,
			playerLoader,
			featureFlagProvider,
			notificationsHandler
		)
	}
}
