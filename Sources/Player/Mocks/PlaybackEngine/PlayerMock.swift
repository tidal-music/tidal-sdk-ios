import AVFoundation
import Foundation

// MARK: - PlayerMock

@_documentation(visibility: internal)
public final class PlayerMock: GenericMediaPlayer {
	// swiftlint:disable:next identifier_name
	public var shouldVerifyItWasPlayingBeforeInterruption: Bool { false }
	public var shouldSwitchStateOnSkipToNext: Bool { shouldSwitchStateOnSkipToNextFlag }

	var shouldSwitchStateOnSkipToNextFlag: Bool = false
	private let cacheManager: PlayerCacheManaging

	static let duration = 10.0

	private(set) var assets = [Asset]()
	var assetPosition: Double = 0 {
		didSet {
			assets.first?.assetPosition = assetPosition
		}
	}

	private var delegates = PlayerMonitoringDelegates()

	private(set) var loadCallCount = 0
	private(set) var loadUploadedCallCount = 0
	private(set) var unloadCallCount = 0
	private(set) var unloadedAssets = [Asset]()
	private(set) var playCallCount = 0
	private(set) var pauseCallCount = 0
	private(set) var seekCallCount = 0
	private(set) var updateVolumeCallCount = 0

	private(set) var loudnessNormalizers = [LoudnessNormalizer?]()
	private(set) var licenseLoaders = [LicenseLoader?]()

	var loudnessNormalizer = LoudnessNormalizer.mock()
	var loudnessNormalizationMode: LoudnessNormalizationMode = .ALBUM

	private final class NullPlayerCacheManager: PlayerCacheManaging {
		weak var delegate: PlayerCacheManagerDelegate?

		func prepareCache(isEnabled: Bool) {}

		func resolveAsset(for url: URL, cacheKey: String?) -> PlayerCacheResult {
			PlayerCacheResult(
				urlAsset: AVURLAsset(url: url),
				cacheState: cacheKey.map { AssetCacheState(key: $0, status: .notCached) }
			)
		}

		func startCachingIfNeeded(_ urlAsset: AVURLAsset, cacheState: AssetCacheState?) {}

		func cancelDownload(for cacheKey: String) {}

		func reset() {}
	}

	public convenience init() {
		self.init(
			cachePath: URL(fileURLWithPath: "/tmp"),
			cacheManager: NullPlayerCacheManager(),
			featureFlagProvider: .mock
		)
	}

	public init(cachePath: URL, cacheManager: PlayerCacheManaging, featureFlagProvider: FeatureFlagProvider) {
		self.cacheManager = cacheManager
	}

	public func canPlay(
		productType: PlayerProductType,
		codec: PlayerAudioCodec?,
		mediaType: String?,
		isOfflined: Bool
	) -> Bool {
		true
	}

	func load() -> Asset {
		loadCallCount += 1

		let loudnessNormalizationConfiguration = LoudnessNormalizationConfiguration(
			loudnessNormalizationMode: loudnessNormalizationMode,
			loudnessNormalizer: loudnessNormalizer
		)
		let asset = AssetMock(with: self, loudnessNormalizationConfiguration: loudnessNormalizationConfiguration)

		assets.append(asset)
		return asset
	}

	public func load(
		_ url: URL,
		cacheKey: String?,
		loudnessNormalizationConfiguration: LoudnessNormalizationConfiguration,
		and licenseLoader: LicenseLoader?
	) async -> Asset {
		loadCallCount += 1
		licenseLoaders.append(licenseLoader)
		let loudnessNormalizationConfiguration = LoudnessNormalizationConfiguration(
			loudnessNormalizationMode: loudnessNormalizationMode,
			loudnessNormalizer: loudnessNormalizer
		)
		let asset = AssetMock(with: self, loudnessNormalizationConfiguration: loudnessNormalizationConfiguration)

		assets.append(asset)
		return asset
	}

	public func unload(asset: Asset) {
		unloadCallCount += 1
		unloadedAssets.append(asset)

		assets = assets.filter { $0 !== asset }
	}

	public func play() {
		playCallCount += 1
	}

	public func pause() {
		pauseCallCount += 1
	}

	public func seek(to time: Double) {
		seekCallCount += 1
	}

	public func updateVolume(loudnessNormalizer: LoudnessNormalizer?) {
		loudnessNormalizers.append(loudnessNormalizer)
		updateVolumeCallCount += 1
	}

	public func addMonitoringDelegate(monitoringDelegate: PlayerMonitoringDelegate) {
		delegates.add(delegate: monitoringDelegate)
	}

	public func unload() {
		assetPosition = 0
		assets.removeAll()
	}

	public func reset() {
		assetPosition = 0
		assets.removeAll()
	}
}

// MARK: UCMediaPlayer

extension PlayerMock: UCMediaPlayer {
	public func loadUC(
		_ url: URL,
		loudnessNormalizationConfiguration: LoudnessNormalizationConfiguration,
		headers: [String: String]
	) async -> Asset {
		loadUploadedCallCount += 1
		let loudnessNormalizationConfiguration = LoudnessNormalizationConfiguration(
			loudnessNormalizationMode: loudnessNormalizationMode,
			loudnessNormalizer: loudnessNormalizer
		)
		let asset = AssetMock(with: self, loudnessNormalizationConfiguration: loudnessNormalizationConfiguration)

		assets.append(asset)
		return asset
	}
}

// MARK: VideoPlayer

extension PlayerMock: VideoPlayer {
	func renderVideo(in view: AVPlayerLayer) {}
}

extension PlayerMock {
	func loaded() {
		delegates.loaded(asset: assets.last, with: PlayerMock.duration)
	}

	func playing() {
		delegates.playing(asset: assets.first)
	}

	func playing(from assetPosition: Double) {
		self.assetPosition = assetPosition
		delegates.playing(asset: assets.first)
	}

	func paused() {
		delegates.paused(asset: assets.first)
	}

	func seeking() {
		delegates.seeking(in: assets.first)
	}

	func stalled() {
		delegates.stall(in: assets.first)
	}

	func completed() {
		let asset = assets.first
		assets.removeAll { $0 === asset }
		delegates.completed(asset: asset)

		if !assets.isEmpty {
			playing(from: 0)
		}
	}

	func downloaded() {
		delegates.downloaded(asset: assets.first)
	}

	func failed(with error: Error) {
		failed(asset: assets.first, with: error)
	}

	func audioQualityChanged(to quality: AudioQuality) {
		delegates.audioQualityChanged(asset: assets.first, to: quality)
	}

	func failed(asset: Asset?, with error: Error) {
		assets.removeAll { $0 === asset }
		delegates.failed(asset: asset, with: error)
	}
}
