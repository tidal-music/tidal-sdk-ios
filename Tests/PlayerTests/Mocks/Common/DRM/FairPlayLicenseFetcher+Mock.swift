import Auth
@testable import Player

extension FairPlayLicenseFetcher {
	static func mock(
		httpClient: HttpClient = HttpClient.mock(),
		credentialsProvider: CredentialsProvider = CredentialsProviderMock(),
		playerEventSender: PlayerEventSender = PlayerEventSenderMock(),
		featureFlagProvider: FeatureFlagProvider = .mock
	) -> FairPlayLicenseFetcher {
		FairPlayLicenseFetcher(
			with: httpClient,
			credentialsProvider: credentialsProvider,
			and: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)
	}
}
