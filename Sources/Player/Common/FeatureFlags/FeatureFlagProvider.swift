public struct FeatureFlagProvider {
	public var shouldUseEventProducer: () -> Bool
	public var isContentCachingEnabled: () -> Bool
	public var shouldPauseAndPlayAroundSeek: () -> Bool
	public var shouldNotPerformActionAtItemEnd: () -> Bool

	public init(
		shouldUseEventProducer: @escaping () -> Bool,
		isContentCachingEnabled: @escaping () -> Bool,
		shouldPauseAndPlayAroundSeek: @escaping () -> Bool,
		shouldNotPerformActionAtItemEnd: @escaping () -> Bool
	) {
		self.shouldUseEventProducer = shouldUseEventProducer
		self.isContentCachingEnabled = isContentCachingEnabled
		self.shouldPauseAndPlayAroundSeek = shouldPauseAndPlayAroundSeek
		self.shouldNotPerformActionAtItemEnd = shouldNotPerformActionAtItemEnd
	}
}
