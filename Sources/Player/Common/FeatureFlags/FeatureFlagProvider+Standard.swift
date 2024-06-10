import Foundation

public extension FeatureFlagProvider {
	static let standard = FeatureFlagProvider(
		isStallWhenTransitionFromEndedToBufferingEnabled: { true },
		shouldUseEventProducer: { false },
		isContentCachingEnabled: { true },
		shouldSendEventsInDeinit: { true },
		shouldUseImprovedCaching: { false }
	)
}
