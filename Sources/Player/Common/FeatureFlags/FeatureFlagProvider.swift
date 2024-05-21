public struct FeatureFlagProvider {
	// swiftlint:disable:next identifier_name
	public var isStallWhenTransitionFromEndedToBufferingEnabled: () -> Bool
	public var shouldUseEventProducer: () -> Bool
	public var isContentCachingEnabled: () -> Bool

	public init(
		// swiftlint:disable:next identifier_name
		isStallWhenTransitionFromEndedToBufferingEnabled: @escaping () -> Bool,
		shouldUseEventProducer: @escaping () -> Bool,
		isContentCachingEnabled: @escaping () -> Bool
	) {
		self.isStallWhenTransitionFromEndedToBufferingEnabled = isStallWhenTransitionFromEndedToBufferingEnabled
		self.shouldUseEventProducer = shouldUseEventProducer
		self.isContentCachingEnabled = isContentCachingEnabled
	}
}
