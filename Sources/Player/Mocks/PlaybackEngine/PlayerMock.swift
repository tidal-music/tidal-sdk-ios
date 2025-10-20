import AVFoundation
import Foundation

// MARK: - PlayerMock

@_documentation(visibility: internal)
public final class PlayerMock: GenericMediaPlayer {
	// swiftlint:disable:next identifier_name
	public var shouldVerifyItWasPlayingBeforeInterruption: Bool { false }
	public var shouldSwitchStateOnSkipToNext: Bool { shouldSwitchStateOnSkipToNextFlag }

	var shouldSwitchStateOnSkipToNextFlag: Bool = false

	static let duration = 10.0

	private(set) var assets = [Asset]()
	var assetPosition: Double = 0 {
		didSet {
			assets.first?.assetPosition = assetPosition
		}
	}

	private var delegates = PlayerMonitoringDelegates()

	private(set) var loadCallCount = 0
	private(set) var loadLiveCallCount = 0
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

	public init() {}

	public init(cachePath: URL, featureFlagProvider: FeatureFlagProvider) {}

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

// MARK: LiveMediaPlayer

extension PlayerMock: LiveMediaPlayer {
	public func loadLive(_ url: URL, with licenseLoader: LicenseLoader?) async -> Asset {
		loadLiveCallCount += 1
		licenseLoaders.append(licenseLoader)
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

	func failed(asset: Asset?, with error: Error) {
		assets.removeAll { $0 === asset }
		delegates.failed(asset: asset, with: error)
	}
}
