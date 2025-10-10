import Foundation

extension Player {
	static func mainPlayerType(
		_ featureFlagProvider: FeatureFlagProvider
	) -> MainPlayerType.Type {
		AVQueuePlayerWrapper.self
	}
}
