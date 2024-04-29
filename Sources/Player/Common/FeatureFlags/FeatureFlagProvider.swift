public struct FeatureFlagProvider {
	// swiftlint:disable:next identifier_name
	public var isStallWhenTransitionFromEndedToBufferingEnabled: () -> Bool
	public var shouldUseAuthModule: () -> Bool
	public var shouldUseEventProducer: () -> Bool

	public init(
		// swiftlint:disable:next identifier_name
		isStallWhenTransitionFromEndedToBufferingEnabled: @escaping () -> Bool,
		shouldUseAuthModule: @escaping () -> Bool,
		shouldUseEventProducer: @escaping () -> Bool
	) {
		self.isStallWhenTransitionFromEndedToBufferingEnabled = isStallWhenTransitionFromEndedToBufferingEnabled
		self.shouldUseAuthModule = shouldUseAuthModule
		self.shouldUseEventProducer = shouldUseEventProducer
	}
}
