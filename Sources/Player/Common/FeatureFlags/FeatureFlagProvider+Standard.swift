import Foundation

public extension FeatureFlagProvider {
	static let standard = FeatureFlagProvider(
		shouldUseEventProducer: { false },
		isContentCachingEnabled: { true },
		shouldSendEventsInDeinit: { true },
		shouldUseImprovedCaching: { false },
		shouldPauseAndPlayAroundSeek: { false }
	)
}
