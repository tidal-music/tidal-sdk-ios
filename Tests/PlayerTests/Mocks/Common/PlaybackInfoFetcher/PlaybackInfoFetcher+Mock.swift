import Auth
@testable import Player

extension PlaybackInfoFetcher {
	static func mock(
		configuration: Configuration = Configuration.mock(),
		httpClient: HttpClient = HttpClient.mock(),
		credentialsProvider: CredentialsProvider = CredentialsProviderMock(),
		networkMonitor: NetworkMonitor = NetworkMonitorMock(),
		playerEventSender: PlayerEventSender = PlayerEventSenderMock(),
		featureFlagProvider: FeatureFlagProvider = .mock
	) -> PlaybackInfoFetcher {
		PlaybackInfoFetcher(
			with: configuration,
			httpClient,
			credentialsProvider,
			networkMonitor,
			and: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)
	}
}
