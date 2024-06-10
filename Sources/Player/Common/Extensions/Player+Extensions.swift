import Foundation

extension Player {
	static func mainPlayerType(_ featureFlagProvider: FeatureFlagProvider) -> GenericMediaPlayer.Type {
		if featureFlagProvider.shouldUseImprovedCaching() {
			AVQueuePlayerWrapper.self
		} else {
			AVQueuePlayerWrapperLegacy.self
		}
	}
}
