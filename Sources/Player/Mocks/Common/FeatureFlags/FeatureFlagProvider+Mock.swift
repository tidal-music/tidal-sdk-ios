import Foundation

public extension FeatureFlagProvider {
	static let mock = FeatureFlagProvider(
		shouldUseEventProducer: { true },
		isContentCachingEnabled: { true },
		shouldPauseAndPlayAroundSeek: { false },
		shouldNotPerformActionAtItemEnd: { false }
	)
}
