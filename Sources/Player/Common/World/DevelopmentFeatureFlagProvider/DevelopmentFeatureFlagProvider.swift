import Foundation

/// Provider of feature flags used during development of new features.
struct DevelopmentFeatureFlagProvider {
	var shouldReadAndVerifyPlaybackMetadata: Bool
	var shouldCheckAndRevalidateOfflineItems: Bool
}
