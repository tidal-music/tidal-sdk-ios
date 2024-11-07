import Foundation

public extension FeatureFlagProvider {
	static let mock = FeatureFlagProvider(
		shouldUseEventProducer: { true },
		isContentCachingEnabled: { true },
		shouldUseImprovedCaching: { false },
		shouldPauseAndPlayAroundSeek: { false },
		shouldNotPerformActionAtItemEnd: { false }
	)
}
