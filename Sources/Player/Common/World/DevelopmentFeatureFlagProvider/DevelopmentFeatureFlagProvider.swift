import Foundation

/// Provider of feature flags used during development of new features.
struct DevelopmentFeatureFlagProvider {
	var isOffliningEnabled: Bool
	/// Flag whether we should emit events on the `deinit`` of ``Player item``.
	var shouldSendEventsInDeinit: Bool
}
