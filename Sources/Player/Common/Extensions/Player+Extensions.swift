import Foundation

extension Player {
	static func mainPlayerType(
		_ featureFlagProvider: FeatureFlagProvider
	) -> (GenericMediaPlayer & LiveMediaPlayer & UCMediaPlayer & VideoPlayer).Type {
		if featureFlagProvider.shouldUseImprovedCaching() {
			AVQueuePlayerWrapper.self
		} else {
			AVQueuePlayerWrapperLegacy.self
		}
	}
}
