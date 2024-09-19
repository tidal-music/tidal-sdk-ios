public struct FeatureFlagProvider {
	public var shouldUseEventProducer: () -> Bool
	public var isContentCachingEnabled: () -> Bool
	public var shouldSendEventsInDeinit: () -> Bool
	public var shouldUseImprovedCaching: () -> Bool

	public init(
		shouldUseEventProducer: @escaping () -> Bool,
		isContentCachingEnabled: @escaping () -> Bool,
		shouldSendEventsInDeinit: @escaping () -> Bool,
		shouldUseImprovedCaching: @escaping () -> Bool
	) {
		self.shouldUseEventProducer = shouldUseEventProducer
		self.isContentCachingEnabled = isContentCachingEnabled
		self.shouldSendEventsInDeinit = shouldSendEventsInDeinit
		self.shouldUseImprovedCaching = shouldUseImprovedCaching
	}
}
