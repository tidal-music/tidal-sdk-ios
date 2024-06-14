extension DevelopmentFeatureFlagProvider {
	static let live = DevelopmentFeatureFlagProvider(
		isOffliningEnabled: false,
		shouldReadAndVerifyPlaybackMetadata: false
	)
}
