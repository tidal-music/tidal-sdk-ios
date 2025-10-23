import Foundation

public extension FeatureFlagProvider {
	static let standard = FeatureFlagProvider(
		shouldUseEventProducer: { false },
		isContentCachingEnabled: { true },
		shouldPauseAndPlayAroundSeek: { false },
		shouldNotPerformActionAtItemEnd: { false },
		shouldUseImprovedDRMHandling: { false },
		shouldUseNewPlaybackEndpoints: { false },
		shouldSupportABRPlayback: { false }
	)
}
