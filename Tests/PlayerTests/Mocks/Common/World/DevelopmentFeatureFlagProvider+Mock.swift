@testable import Player

extension DevelopmentFeatureFlagProvider {
	static let mock: Self = DevelopmentFeatureFlagProvider(
		shouldCheckAndRevalidateOfflineItems: false
	)
}
