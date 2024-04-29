import Auth
@testable import Player

extension FairPlayLicenseFetcher {
	static func mock(
		httpClient: HttpClient = HttpClient.mock(),
		accessTokenProvider: AccessTokenProvider = AuthTokenProviderMock(),
		credentialsProvider: CredentialsProvider = CredentialsProviderMock(),
		playerEventSender: PlayerEventSender = PlayerEventSenderMock(),
		featureFlagProvider: FeatureFlagProvider = .mock
	) -> FairPlayLicenseFetcher {
		FairPlayLicenseFetcher(
			with: httpClient,
			accessTokenProvider,
			credentialsProvider: credentialsProvider,
			and: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)
	}
}
