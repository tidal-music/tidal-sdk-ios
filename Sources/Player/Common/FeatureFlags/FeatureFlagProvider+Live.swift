import Foundation

public extension FeatureFlagProvider {
	static let live = FeatureFlagProvider(
		isStallWhenTransitionFromEndedToBufferingEnabled: {
			true
		},
		shouldUseAuthModule: {
			true
		},
		shouldUseEventProducer: {
			false
		}
	)
}
