extension DevelopmentFeatureFlagProvider {
	static let live = DevelopmentFeatureFlagProvider(
		shouldReadAndVerifyPlaybackMetadata: false,
		shouldCheckAndRevalidateOfflineItems: false
	)
}
