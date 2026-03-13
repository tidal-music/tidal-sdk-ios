import Foundation

private enum Constants {
	static let defaultVolume: Float = 1
}

// MARK: - CrossfadingPlayerWrapper

final class CrossfadingPlayerWrapper: GenericMediaPlayer {
	private let cachePath: URL
	private let featureFlagProvider: FeatureFlagProvider
	var crossfadeDuration: Double = 0
	fileprivate var currentPlayer: AVQueuePlayerWrapper
	fileprivate var nextPlayer: AVQueuePlayerWrapper

	private var playerDelegateA: PlayerDelegate!
	private var playerDelegateB: PlayerDelegate!

	fileprivate var isCrossfading = false

	fileprivate var delegates = PlayerMonitoringDelegates()

	// swiftlint:disable identifier_name
	var shouldVerifyItWasPlayingBeforeInterruption: Bool { false }
	var shouldSwitchStateOnSkipToNext: Bool { false }
	// swiftlint:enable identifier_name

	init(cachePath: URL, featureFlagProvider: FeatureFlagProvider) {
		self.cachePath = cachePath
		self.featureFlagProvider = featureFlagProvider

		currentPlayer = AVQueuePlayerWrapper(cachePath: cachePath, featureFlagProvider: featureFlagProvider)
		nextPlayer = AVQueuePlayerWrapper(cachePath: cachePath, featureFlagProvider: featureFlagProvider)

		currentPlayer.externalVolumeControl = true
		nextPlayer.externalVolumeControl = true

		playerDelegateA = PlayerDelegate(owner: self, player: currentPlayer)
		playerDelegateB = PlayerDelegate(owner: self, player: nextPlayer)

		currentPlayer.addMonitoringDelegate(monitoringDelegate: playerDelegateA)
		nextPlayer.addMonitoringDelegate(monitoringDelegate: playerDelegateB)

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
		return currentPlayer.canPlay(
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
		let target = currentPlayer.player.currentItem == nil ? currentPlayer : nextPlayer
		return await target.load(
			url,
			cacheKey: cacheKey,
			loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
			and: licenseLoader
		)
	}

	func unload(asset: Asset) {
		if asset.player === nextPlayer {
			cancelCrossfade()
			nextPlayer.unload(asset: asset)
			return
		}
		cancelCrossfade()
		currentPlayer.unload(asset: asset)
	}

	func play() {
		currentPlayer.play()
		if isCrossfading {
			nextPlayer.play()
		}
	}

	func pause() {
		currentPlayer.pause()
		if isCrossfading {
			nextPlayer.pause()
		}
	}

	func seek(to time: Double) {
		cancelCrossfade()
		currentPlayer.seek(to: time)
	}

	func unload() {
		cancelCrossfade()
		currentPlayer.unload()
		nextPlayer.unload()
		delegates.removeAll()
	}

	func reset() {
		cancelCrossfade()
		currentPlayer.reset()
		nextPlayer.reset()
		delegates.removeAll()
	}

	func updateVolume(loudnessNormalizer: LoudnessNormalizer?) {
		if !isCrossfading {
			currentPlayer.updateVolume(loudnessNormalizer: loudnessNormalizer)
		}
	}

	func addMonitoringDelegate(monitoringDelegate: PlayerMonitoringDelegate) {
		delegates.add(delegate: monitoringDelegate)
	}
}

// MARK: - Crossfade Logic

extension CrossfadingPlayerWrapper {
	fileprivate func setupProgressCallback() {
		currentPlayer.onPlaybackProgress = { [weak self] position, duration in
			self?.handlePlaybackProgress(position: position, duration: duration)
		}
	}

	fileprivate func handlePlaybackProgress(position: Double, duration: Double) {
		let crossfadeStart = max(0, duration - crossfadeDuration)
		guard position >= crossfadeStart else {
			return
		}

		if !isCrossfading {
			guard nextPlayer.player.currentItem != nil else {
				return
			}
			isCrossfading = true
			nextPlayer.player.volume = 0
			nextPlayer.play()
		}

		let elapsed = position - crossfadeStart
		let progress = min(Float(elapsed / crossfadeDuration), 1.0)

		currentPlayer.player.volume = normalizedVolume(for: currentPlayer) * (1.0 - progress)
		nextPlayer.player.volume = normalizedVolume(for: nextPlayer) * progress
	}

	fileprivate func handleCurrentCompleted(asset: Asset?) {
		isCrossfading = false
		delegates.completed(asset: asset)

		let temp = currentPlayer
		currentPlayer = nextPlayer
		nextPlayer = temp

		currentPlayer.player.volume = normalizedVolume(for: currentPlayer)
		setupProgressCallback()

		nextPlayer.reset()
		let nextDelegate = delegateForPlayer(nextPlayer)
		if let nextDelegate {
			nextPlayer.addMonitoringDelegate(monitoringDelegate: nextDelegate)
		}

		if currentPlayer.player.timeControlStatus == .playing {
			delegates.playing(asset: currentPlayer.currentAsset)
		}
	}

	fileprivate func cancelCrossfade() {
		guard isCrossfading else {
			return
		}
		isCrossfading = false
		nextPlayer.pause()
		nextPlayer.player.volume = 0
		currentPlayer.player.volume = normalizedVolume(for: currentPlayer)
	}

	fileprivate func normalizedVolume(for player: AVQueuePlayerWrapper) -> Float {
		player.currentAsset?.getLoudnessNormalizationConfiguration().getLoudnessNormalizer()?
			.getScaleFactor() ?? Constants.defaultVolume
	}

	private func delegateForPlayer(_ player: AVQueuePlayerWrapper) -> PlayerDelegate? {
		if playerDelegateA.player === player {
			return playerDelegateA
		}
		if playerDelegateB.player === player {
			return playerDelegateB
		}
		return nil
	}
}

// MARK: - PlayerDelegate

private final class PlayerDelegate: PlayerMonitoringDelegate {
	private weak var owner: CrossfadingPlayerWrapper?
	let player: AVQueuePlayerWrapper

	private var isCurrent: Bool {
		owner?.currentPlayer === player
	}

	init(owner: CrossfadingPlayerWrapper, player: AVQueuePlayerWrapper) {
		self.owner = owner
		self.player = player
	}

	func loaded(asset: Asset?, with duration: Double) {
		guard let owner else { return }
		owner.delegates.loaded(asset: asset, with: duration)
	}

	func playing(asset: Asset?) {
		guard let owner, isCurrent, !owner.isCrossfading else { return }
		player.player.volume = owner.normalizedVolume(for: player)
		owner.delegates.playing(asset: asset)
	}

	func paused(asset: Asset?) {
		guard let owner, isCurrent else { return }
		owner.delegates.paused(asset: asset)
	}

	func seeking(in asset: Asset?) {
		guard let owner, isCurrent else { return }
		owner.delegates.seeking(in: asset)
	}

	func stall(in asset: Asset?) {
		guard let owner, isCurrent else { return }
		owner.delegates.stall(in: asset)
	}

	func waiting(for asset: Asset?) {
		guard let owner, isCurrent else { return }
		owner.delegates.waiting(for: asset)
	}

	func downloaded(asset: Asset?) {
		guard let owner, isCurrent else { return }
		owner.delegates.downloaded(asset: asset)
	}

	func completed(asset: Asset?) {
		guard let owner else { return }
		if isCurrent {
			owner.handleCurrentCompleted(asset: asset)
		} else {
			owner.delegates.completed(asset: asset)
		}
	}

	func failed(asset: Asset?, with error: Error) {
		guard let owner else { return }
		if !isCurrent {
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
