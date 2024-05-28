import Foundation

public extension FeatureFlagProvider {
	static let mock = FeatureFlagProvider(
		isStallWhenTransitionFromEndedToBufferingEnabled: { true },
		shouldUseEventProducer: { true },
		isContentCachingEnabled: { true }
	)
}
