import Foundation

extension Player {
	static func mainPlayerType(_ featureFlagProvider: FeatureFlagProvider) -> GenericMediaPlayer.Type {
		if featureFlagProvider.shouldUseImprovedCaching() {
			AVQueuePlayerWrapperLegacy.self
		} else {
			AVQueuePlayerWrapperLegacy.self
		}
	}
}
