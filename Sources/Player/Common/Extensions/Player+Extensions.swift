import Foundation

extension Player {
	static func mainPlayerType(
		_ featureFlagProvider: FeatureFlagProvider,
		configuration: Configuration
	) -> MainPlayerType.Type {
		return DualAVPlayerWrapper.self
//		if configuration.isCrossfadeEnabled {
//			return DualAVPlayerWrapper.self
//		}
//		return AVQueuePlayerWrapper.self
	}
}
