import Foundation

public extension FeatureFlagProvider {
	static let standard = FeatureFlagProvider(
		isStallWhenTransitionFromEndedToBufferingEnabled: { true },
		shouldUseAuthModule: { true },
		shouldUseEventProducer: { false },
		isContentCachingEnabled: { true }
	)
}
