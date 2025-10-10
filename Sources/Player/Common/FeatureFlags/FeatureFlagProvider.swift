public struct FeatureFlagProvider {
	public var shouldUseEventProducer: () -> Bool
	public var isContentCachingEnabled: () -> Bool
	public var shouldPauseAndPlayAroundSeek: () -> Bool
	public var shouldNotPerformActionAtItemEnd: () -> Bool
	public var shouldUseImprovedDRMHandling: () -> Bool
	public var shouldUseNewPlaybackEndpoints: () -> Bool

	public init(
		shouldUseEventProducer: @escaping () -> Bool,
		isContentCachingEnabled: @escaping () -> Bool,
		shouldPauseAndPlayAroundSeek: @escaping () -> Bool,
		shouldNotPerformActionAtItemEnd: @escaping () -> Bool,
		shouldUseImprovedDRMHandling: @escaping () -> Bool,
		shouldUseNewPlaybackEndpoints: @escaping () -> Bool
	) {
		self.shouldUseEventProducer = shouldUseEventProducer
		self.isContentCachingEnabled = isContentCachingEnabled
		self.shouldPauseAndPlayAroundSeek = shouldPauseAndPlayAroundSeek
		self.shouldNotPerformActionAtItemEnd = shouldNotPerformActionAtItemEnd
		self.shouldUseImprovedDRMHandling = shouldUseImprovedDRMHandling
		self.shouldUseNewPlaybackEndpoints = shouldUseNewPlaybackEndpoints
	}
}
