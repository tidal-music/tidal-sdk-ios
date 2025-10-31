import Foundation

/// Provider of feature flags used during development of new features.
struct DevelopmentFeatureFlagProvider {
	var shouldCheckAndRevalidateOfflineItems: Bool
}
