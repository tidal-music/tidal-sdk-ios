@testable import Player

extension DevelopmentFeatureFlagProvider {
	static let mock: Self = DevelopmentFeatureFlagProvider(
		shouldReadAndVerifyPlaybackMetadata: false,
		shouldCheckAndRevalidateOfflineItems: false
	)
}
