extension DevelopmentFeatureFlagProvider {
	static let live = DevelopmentFeatureFlagProvider(
		shouldCheckAndRevalidateOfflineItems: false
	)
}
