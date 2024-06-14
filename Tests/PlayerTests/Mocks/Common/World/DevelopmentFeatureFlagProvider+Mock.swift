@testable import Player

extension DevelopmentFeatureFlagProvider {
	static let mock: Self = DevelopmentFeatureFlagProvider(
		isOffliningEnabled: false,
		shouldReadAndVerifyPlaybackMetadata: false
	)
}
