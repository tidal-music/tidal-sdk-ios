import Foundation

public extension FeatureFlagProvider {
	static let mock = FeatureFlagProvider(
		shouldUseEventProducer: { true },
		isContentCachingEnabled: { true },
		shouldSendEventsInDeinit: { true },
		shouldUseImprovedCaching: { false },
		shouldPauseAndPlayAroundSeek: { false },
		isOfflineEngineEnabled: { false }
	)
}
