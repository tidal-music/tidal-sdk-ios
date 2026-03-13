import Foundation

private enum Constants {
	static let defaultVolume: Float = 1
}

// MARK: - CrossfadingPlayerWrapper

final class CrossfadingPlayerWrapper: GenericMediaPlayer {
	private let cachePath: URL
	private let featureFlagProvider: FeatureFlagProvider
	var crossfadeDuration: Double = 0
	fileprivate var activeWrapper: AVQueuePlayerWrapper
	fileprivate var incomingWrapper: AVQueuePlayerWrapper

	private var wrapperDelegateA: WrapperDelegate!
	private var wrapperDelegateB: WrapperDelegate!

	fileprivate var isCrossfading = false

	fileprivate var delegates = PlayerMonitoringDelegates()

	// swiftlint:disable identifier_name
	var shouldVerifyItWasPlayingBeforeInterruption: Bool { false }
	var shouldSwitchStateOnSkipToNext: Bool { false }
	// swiftlint:enable identifier_name

	init(cachePath: URL, featureFlagProvider: FeatureFlagProvider) {
		self.cachePath = cachePath
		self.featureFlagProvider = featureFlagProvider

		activeWrapper = AVQueuePlayerWrapper(cachePath: cachePath, featureFlagProvider: featureFlagProvider)
		incomingWrapper = AVQueuePlayerWrapper(cachePath: cachePath, featureFlagProvider: featureFlagProvider)

		activeWrapper.externalVolumeControl = true
		incomingWrapper.externalVolumeControl = true

		wrapperDelegateA = WrapperDelegate(owner: self, wrapper: activeWrapper)
		wrapperDelegateB = WrapperDelegate(owner: self, wrapper: incomingWrapper)

		activeWrapper.addMonitoringDelegate(monitoringDelegate: wrapperDelegateA)
		incomingWrapper.addMonitoringDelegate(monitoringDelegate: wrapperDelegateB)

		setupProgressCallback()
	}

	func canPlay(
		productType: ProductType,
		codec: AudioCodec?,
		mediaType: String?,
		isOfflined: Bool,
		crossfade: Bool
	) -> Bool {
		guard crossfade else {
			return false
		}
		if productType == .VIDEO {
			return false
		}
		if case .UC = productType {
			return false
		}
		return activeWrapper.canPlay(
			productType: productType,
			codec: codec,
			mediaType: mediaType,
			isOfflined: isOfflined,
			crossfade: false
		)
	}

	func load(
		_ url: URL,
		cacheKey: String?,
		loudnessNormalizationConfiguration: LoudnessNormalizationConfiguration,
		and licenseLoader: LicenseLoader?
	) async -> Asset {
		let targetWrapper = activeWrapper.player.currentItem == nil ? activeWrapper : incomingWrapper
		return await targetWrapper.load(
			url,
			cacheKey: cacheKey,
			loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
			and: licenseLoader
		)
	}

	func unload(asset: Asset) {
		if asset.player === incomingWrapper {
			cancelCrossfade()
			incomingWrapper.unload(asset: asset)
			return
		}
		cancelCrossfade()
		activeWrapper.unload(asset: asset)
	}

	func play() {
		activeWrapper.play()
		if isCrossfading {
			incomingWrapper.play()
		}
	}

	func pause() {
		activeWrapper.pause()
		if isCrossfading {
			incomingWrapper.pause()
		}
	}

	func seek(to time: Double) {
		cancelCrossfade()
		activeWrapper.seek(to: time)
	}

	func unload() {
		cancelCrossfade()
		activeWrapper.unload()
		incomingWrapper.unload()
		delegates.removeAll()
	}

	func reset() {
		cancelCrossfade()
		activeWrapper.reset()
		incomingWrapper.reset()
		delegates.removeAll()
	}

	func updateVolume(loudnessNormalizer: LoudnessNormalizer?) {
		if !isCrossfading {
			activeWrapper.updateVolume(loudnessNormalizer: loudnessNormalizer)
		}
	}

	func addMonitoringDelegate(monitoringDelegate: PlayerMonitoringDelegate) {
		delegates.add(delegate: monitoringDelegate)
	}
}

// MARK: - Crossfade Logic

extension CrossfadingPlayerWrapper {
	fileprivate func setupProgressCallback() {
		activeWrapper.onPlaybackProgress = { [weak self] position, duration in
			self?.handlePlaybackProgress(position: position, duration: duration)
		}
	}

	fileprivate func handlePlaybackProgress(position: Double, duration: Double) {
		let crossfadeStart = max(0, duration - crossfadeDuration)
		guard position >= crossfadeStart else {
			return
		}

		if !isCrossfading {
			guard incomingWrapper.player.currentItem != nil else {
				return
			}
			isCrossfading = true
			incomingWrapper.player.volume = 0
			incomingWrapper.play()
		}

		let elapsed = position - crossfadeStart
		let progress = min(Float(elapsed / crossfadeDuration), 1.0)

		activeWrapper.player.volume = normalizedVolume(for: activeWrapper) * (1.0 - progress)
		incomingWrapper.player.volume = normalizedVolume(for: incomingWrapper) * progress
	}

	fileprivate func handleActiveCompleted(asset: Asset?) {
		isCrossfading = false
		delegates.completed(asset: asset)

		let temp = activeWrapper
		activeWrapper = incomingWrapper
		incomingWrapper = temp

		activeWrapper.player.volume = normalizedVolume(for: activeWrapper)
		setupProgressCallback()

		incomingWrapper.reset()
		let incomingDelegate = delegateForWrapper(incomingWrapper)
		if let incomingDelegate {
			incomingWrapper.addMonitoringDelegate(monitoringDelegate: incomingDelegate)
		}

		if activeWrapper.player.timeControlStatus == .playing {
			delegates.playing(asset: activeWrapper.currentAsset)
		}
	}

	fileprivate func cancelCrossfade() {
		guard isCrossfading else {
			return
		}
		isCrossfading = false
		incomingWrapper.pause()
		incomingWrapper.player.volume = 0
		activeWrapper.player.volume = normalizedVolume(for: activeWrapper)
	}

	fileprivate func normalizedVolume(for wrapper: AVQueuePlayerWrapper) -> Float {
		wrapper.currentAsset?.getLoudnessNormalizationConfiguration().getLoudnessNormalizer()?
			.getScaleFactor() ?? Constants.defaultVolume
	}

	private func delegateForWrapper(_ wrapper: AVQueuePlayerWrapper) -> WrapperDelegate? {
		if wrapperDelegateA.wrapper === wrapper {
			return wrapperDelegateA
		}
		if wrapperDelegateB.wrapper === wrapper {
			return wrapperDelegateB
		}
		return nil
	}
}

// MARK: - WrapperDelegate

private final class WrapperDelegate: PlayerMonitoringDelegate {
	private weak var owner: CrossfadingPlayerWrapper?
	let wrapper: AVQueuePlayerWrapper

	private var isActive: Bool {
		owner?.activeWrapper === wrapper
	}

	init(owner: CrossfadingPlayerWrapper, wrapper: AVQueuePlayerWrapper) {
		self.owner = owner
		self.wrapper = wrapper
	}

	func loaded(asset: Asset?, with duration: Double) {
		guard let owner else { return }
		owner.delegates.loaded(asset: asset, with: duration)
	}

	func playing(asset: Asset?) {
		guard let owner, isActive, !owner.isCrossfading else { return }
		wrapper.player.volume = owner.normalizedVolume(for: wrapper)
		owner.delegates.playing(asset: asset)
	}

	func paused(asset: Asset?) {
		guard let owner, isActive else { return }
		owner.delegates.paused(asset: asset)
	}

	func seeking(in asset: Asset?) {
		guard let owner, isActive else { return }
		owner.delegates.seeking(in: asset)
	}

	func stall(in asset: Asset?) {
		guard let owner, isActive else { return }
		owner.delegates.stall(in: asset)
	}

	func waiting(for asset: Asset?) {
		guard let owner, isActive else { return }
		owner.delegates.waiting(for: asset)
	}

	func downloaded(asset: Asset?) {
		guard let owner, isActive else { return }
		owner.delegates.downloaded(asset: asset)
	}

	func completed(asset: Asset?) {
		guard let owner else { return }
		if isActive {
			owner.handleActiveCompleted(asset: asset)
		} else {
			owner.delegates.completed(asset: asset)
		}
	}

	func failed(asset: Asset?, with error: Error) {
		guard let owner else { return }
		if !isActive {
			owner.cancelCrossfade()
		}
		owner.delegates.failed(asset: asset, with: error)
	}

	func playbackMetadataLoaded(asset: Asset?) {
		guard let owner else { return }
		owner.delegates.playbackMetadataLoaded(asset: asset)
	}

	func playbackMetadataChanged(asset: Asset?, to metadata: AssetPlaybackMetadata) {
		guard let owner else { return }
		owner.delegates.playbackMetadataChanged(asset: asset, to: metadata)
	}
}
