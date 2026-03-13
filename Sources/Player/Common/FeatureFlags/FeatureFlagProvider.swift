public struct FeatureFlagProvider {
	public var shouldUseEventProducer: () -> Bool
	@available(*, deprecated, message: "Content caching has been removed. This flag is no longer used.")
	public var isContentCachingEnabled: () -> Bool
	/// Deprecated: No longer used in AVQueuePlayerWrapper. Kept for API compatibility.
	public var shouldPauseAndPlayAroundSeek: () -> Bool
	/// Deprecated: No longer used in AVQueuePlayerWrapper. Kept for API compatibility.
	public var shouldNotPerformActionAtItemEnd: () -> Bool
	public var shouldUseImprovedDRMHandling: () -> Bool
	public var shouldUseNewPlaybackEndpoints: () -> Bool
	public var shouldSupportABRPlayback: () -> Bool

	public init(
		shouldUseEventProducer: @escaping () -> Bool,
		isContentCachingEnabled: @escaping () -> Bool = { false },
		shouldPauseAndPlayAroundSeek: @escaping () -> Bool,
		shouldNotPerformActionAtItemEnd: @escaping () -> Bool,
		shouldUseImprovedDRMHandling: @escaping () -> Bool,
		shouldUseNewPlaybackEndpoints: @escaping () -> Bool,
		shouldSupportABRPlayback: @escaping () -> Bool
	) {
		self.shouldUseEventProducer = shouldUseEventProducer
		self.isContentCachingEnabled = isContentCachingEnabled
		self.shouldPauseAndPlayAroundSeek = shouldPauseAndPlayAroundSeek
		self.shouldNotPerformActionAtItemEnd = shouldNotPerformActionAtItemEnd
		self.shouldUseImprovedDRMHandling = shouldUseImprovedDRMHandling
		self.shouldUseNewPlaybackEndpoints = shouldUseNewPlaybackEndpoints
		self.shouldSupportABRPlayback = shouldSupportABRPlayback
	}
}
