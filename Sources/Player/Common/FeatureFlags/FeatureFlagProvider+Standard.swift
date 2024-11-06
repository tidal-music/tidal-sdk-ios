import Foundation

public extension FeatureFlagProvider {
	static let standard = FeatureFlagProvider(
		shouldUseEventProducer: { false },
		isContentCachingEnabled: { true },
		shouldUseImprovedCaching: { false },
		shouldPauseAndPlayAroundSeek: { false },
		shouldNotPerformActionAtItemEnd: { false }
	)
}
