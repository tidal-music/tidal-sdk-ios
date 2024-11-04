extension DevelopmentFeatureFlagProvider {
	static let live = DevelopmentFeatureFlagProvider(
		shouldReadAndVerifyPlaybackMetadata: false,
		shouldCheckExpiryAndRevalidateOfflineItems: false
	)
}
