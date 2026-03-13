import Foundation

public extension FeatureFlagProvider {
	static let standard = FeatureFlagProvider(
		shouldUseEventProducer: { false },
		shouldPauseAndPlayAroundSeek: { false },
		shouldNotPerformActionAtItemEnd: { false },
		shouldUseImprovedDRMHandling: { false },
		shouldUseNewPlaybackEndpoints: { false },
		shouldSupportABRPlayback: { false }
	)
}
