import Foundation

extension Player {
	static func mainPlayerType(
		_ featureFlagProvider: FeatureFlagProvider,
		configuration: Configuration
	) -> MainPlayerType.Type {
		if configuration.isCrossfadeEnabled {
			return AVPlayerWrapper<DualPlayerQueueController>.self
		}
		return AVPlayerWrapper<SingleQueueController>.self
	}
}
