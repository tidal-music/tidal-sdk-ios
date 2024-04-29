extension DevelopmentFeatureFlagProvider {
	static let live = DevelopmentFeatureFlagProvider(
		isOffliningEnabled: false,
		shouldSendEventsInDeinit: false
	)
}
