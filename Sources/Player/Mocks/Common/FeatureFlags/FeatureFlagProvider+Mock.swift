import Foundation

public extension FeatureFlagProvider {
	static let mock = FeatureFlagProvider(
		isStallWhenTransitionFromEndedToBufferingEnabled: { true },
		shouldUseAuthModule: { true },
		shouldUseEventProducer: { true },
		isContentCachingEnabled: { true }
	)
}
