import AVFoundation
import Foundation
import MediaPlayer

// MARK: - Constants

private enum Constants {
	static let defaultVolume: Float = 1
}

// MARK: - AVPlayerWrapper

final class AVPlayerWrapper<Controller: PlaybackQueueController>: GenericMediaPlayer {
	private let queue: OperationQueue

	private var controller: Controller

	private let contentKeyDelegateQueue = DispatchQueue(label: "com.tidal.player.contentkeydelegate.queue")

	private var playerItemMonitors: [AVPlayerItem: AVPlayerItemMonitor] = [:]
	private var playerItemAssets: [AVPlayerItem: AVPlayerAsset] = [:]
	private var delegates: PlayerMonitoringDelegates = PlayerMonitoringDelegates()

	// MARK: - Convenience properties

	private let supportedCodecs: [PlayerAudioCodec] = [
		PlayerAudioCodec.AAC,
		PlayerAudioCodec.AAC_LC,
		PlayerAudioCodec.HE_AAC_V1,
		PlayerAudioCodec.EAC3,
		PlayerAudioCodec.ALAC,
		PlayerAudioCodec.MP3,
	]

	// swiftlint:disable identifier_name
	var shouldVerifyItWasPlayingBeforeInterruption: Bool { false }
	var shouldSwitchStateOnSkipToNext: Bool { false }
	// swiftlint:enable identifier_name

	// MARK: Initialization

	init(cachePath: URL, featureFlagProvider: FeatureFlagProvider) {
		queue = OperationQueue()
		queue.maxConcurrentOperationCount = 1
		queue.qualityOfService = .userInitiated

		controller = Controller()
		controller.setupMonitoring(
			callbacks: makeCallbacks(),
			normalizedVolumeProvider: { [weak self] player in
				guard let self, let currentItem = player.currentItem,
				      let asset = self.playerItemAssets[currentItem]
				else {
					return Constants.defaultVolume
				}
				return asset.getLoudnessNormalizationConfiguration().getLoudnessNormalizer()?
					.getScaleFactor() ?? Constants.defaultVolume
			}
		)
	}

	func canPlay(
		productType: ProductType,
		codec: AudioCodec?,
		mediaType: String?,
		isOfflined: Bool
	) -> Bool {
		if productType == .VIDEO {
			return controller.supportsVideo
		}

		if case let .UC(url) = productType {
			return controller.supportsUC && url.isFileURL
		}

		guard let codec else {
			return false
		}

		return supportedCodecs.contains(codec) || (codec == .FLAC && mediaType != MediaTypes.BTS)
	}

	func load(
		_ url: URL,
		cacheKey: String?,
		loudnessNormalizationConfiguration: LoudnessNormalizationConfiguration,
		and licenseLoader: LicenseLoader?
	) async -> Asset {
		await withCheckedContinuation { continuation in
			queue.dispatch {
				let urlAsset = AVURLAsset(url: url, options: [
					AVURLAssetPreferPreciseDurationAndTimingKey: url.isFileURL,
				])

				let asset = self.load(
					urlAsset,
					loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
					and: licenseLoader as? AVContentKeySessionDelegate
				)

				continuation.resume(returning: asset)
			}
		}
	}

	func unload(asset: Asset) {
		queue.dispatch {
			guard let (playerItem, _) = self.playerItemAssets.first(where: { _, a in a === asset }) else {
				return
			}

			let wasCurrentItem = playerItem === self.controller.activePlayer.currentItem

			self.playerItemMonitors.removeValue(forKey: playerItem)
			self.playerItemAssets.removeValue(forKey: playerItem)
			self.controller.removeItem(playerItem)

			if wasCurrentItem {
				guard let (nextPlayerItem, _) = self.playerItemAssets.first else {
					self.internalReset()
					return
				}
				self.controller.enqueue(nextPlayerItem)
				self.controller.advanceToNextItem()
			} else if self.playerItemAssets.isEmpty {
				self.internalReset()
			}
		}
	}

	func play() {
		queue.dispatch {
			self.controller.play()
		}
	}

	func pause() {
		queue.dispatch {
			self.controller.pause()
		}
	}

	func seek(to time: Double) {
		queue.dispatch {
			let player = self.controller.activePlayer
			guard let currentItem = player.currentItem, let asset = self.playerItemAssets[currentItem] else {
				return
			}

			self.delegates.seeking(in: asset)

			let completed = await player.seek(to: time)
			guard completed, currentItem == player.currentItem,
			      player.timeControlStatus == .playing
			else {
				return
			}

			asset.setAssetPosition(currentItem)
			self.delegates.playing(asset: asset)
		}
	}

	func unload() {
		queue.cancelAllOperations()
		queue.dispatch {
			self.delegates.removeAll()
			self.playerItemMonitors.removeAll()
			self.playerItemAssets.removeAll()
			self.controller.teardown()
		}
	}

	func reset() {
		queue.cancelAllOperations()
		queue.dispatch {
			self.delegates.removeAll()
			self.internalReset()
		}
	}

	func updateVolume(loudnessNormalizer: LoudnessNormalizer?) {
		queue.dispatch {
			self.controller.setVolume(loudnessNormalizer?.getScaleFactor() ?? Constants.defaultVolume)
		}
	}

	func addMonitoringDelegate(monitoringDelegate: PlayerMonitoringDelegate) {
		queue.dispatch {
			self.delegates.add(delegate: monitoringDelegate)
		}
	}
}

// MARK: UCMediaPlayer

extension AVPlayerWrapper: UCMediaPlayer {
	func loadUC(
		_ url: URL,
		loudnessNormalizationConfiguration: LoudnessNormalizationConfiguration,
		headers: [String: String]
	) async -> Asset {
		await withCheckedContinuation { continuation in
			queue.dispatch {
				var options: [String: Any] = [
					"AVURLAssetHTTPHeaderFieldsKey": headers,
				]

				if !url.isFileURL {
					if #available(iOS 17.0, macOS 14.0, *) {
						options[AVURLAssetOverrideMIMETypeKey] = "application/vnd.apple.mpegurl"
					}
				}

				let urlAsset = AVURLAsset(url: url, options: options)

				let asset = self.load(
					urlAsset,
					loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
					and: nil
				)

				continuation.resume(returning: asset)
			}
		}
	}
}

// MARK: VideoPlayer

extension AVPlayerWrapper: VideoPlayer {
	func renderVideo(in view: AVPlayerLayer) {
		queue.dispatch {
			let player = self.controller.activePlayer
			guard player.currentItem != nil else {
				return
			}

			DispatchQueue.main.async {
				view.player = player
			}
		}
	}
}

// MARK: - Asset loading & registration

private extension AVPlayerWrapper {
	func load(
		_ urlAsset: AVURLAsset,
		loudnessNormalizationConfiguration: LoudnessNormalizationConfiguration,
		and contentKeySessionDelegate: AVContentKeySessionDelegate?
	) -> AVPlayerAsset {
		let (asset, playerItem) = AVPlayerItemFactory.loadAsset(
			urlAsset,
			loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
			contentKeySessionDelegate: contentKeySessionDelegate,
			contentKeyDelegateQueue: contentKeyDelegateQueue,
			player: self
		)

		register(playerItem: playerItem, for: asset)
		controller.enqueue(playerItem)

		return asset
	}

	func register(playerItem: AVPlayerItem, for asset: AVPlayerAsset) {
		playerItemAssets[playerItem] = asset
		monitor(playerItem, asset: asset)
	}

	func monitor(_ playerItem: AVPlayerItem, asset: AVPlayerAsset) {
		playerItemMonitors[playerItem] = AVPlayerItemMonitor(
			playerItem,
			queue: queue,
			adaptiveQualities: asset.getAdaptiveAudioQualities(),
			onFailure: failed,
			onStall: stalled,
			onCompletelyDownloaded: downloaded,
			onReadyToPlayToPlay: loaded,
			onItemPlayedToEnd: playedToEnd,
			onPlaybackMetadataChanged: { [weak self] item, metadata in
				guard let self else {
					return
				}

				guard let asset = self.playerItemAssets[item] else {
					return
				}

				self.delegates.playbackMetadataChanged(asset: asset, to: metadata)
			}
		)
	}

	func internalReset() {
		playerItemMonitors.removeAll()
		playerItemAssets.removeAll()
		controller.reset()
	}
}

// MARK: - Monitoring Callbacks

private extension AVPlayerWrapper {
	func makeCallbacks() -> PlayerMonitorCallbacks {
		PlayerMonitorCallbacks(
			onIsPlaying: playing,
			onIsPaused: paused,
			onFailure: failed,
			onItemChanged: playerItemChanged,
			onWaitingToPlay: waiting,
			onPlaybackProgress: playbackProgressed
		)
	}

	func loaded(playerItem: AVPlayerItem) {
		queue.dispatch {
			guard let asset = self.playerItemAssets[playerItem] else {
				return
			}

			self.delegates.playbackMetadataLoaded(asset: asset)
			self.delegates.loaded(asset: asset, with: CMTimeGetSeconds(playerItem.duration))
		}
	}

	func playing(playerItem: AVPlayerItem) {
		queue.dispatch {
			guard let asset = self.playerItemAssets[playerItem] else {
				return
			}

			self.controller.activePlayer.allowsExternalPlayback = playerItem.tracks.contains(where: {
				$0.assetTrack?.mediaType == .video
			})

			let volume: Float = asset.getLoudnessNormalizationConfiguration().getLoudnessNormalizer()?
				.getScaleFactor() ?? Constants.defaultVolume
			self.controller.applyPlayingVolume(volume)

			self.delegates.playing(asset: asset)
		}
	}

	func paused(playerItem: AVPlayerItem) {
		queue.dispatch {
			guard let asset = self.playerItemAssets[playerItem] else {
				return
			}

			self.delegates.paused(asset: asset)
		}
	}

	func failed(playerItem: AVPlayerItem, with error: Error?) {
		queue.dispatch {
			guard let asset = self.playerItemAssets[playerItem] else {
				return
			}

			self.delegates.failed(asset: asset, with: AVPlayerErrorConverter.convertError(error: error, playerItem: playerItem))
		}
	}

	func downloaded(playerItem: AVPlayerItem) {
		queue.dispatch {
			guard let asset = self.playerItemAssets[playerItem] else {
				return
			}

			self.delegates.downloaded(asset: asset)
		}
	}

	func stalled(playerItem: AVPlayerItem) {
		queue.dispatch {
			guard let asset = self.playerItemAssets[playerItem] else {
				return
			}

			guard self.controller.isOnActivePlayer(playerItem) else {
				return
			}

			self.delegates.stall(in: asset)
		}
	}

	func waiting(playerItem: AVPlayerItem) {
		queue.dispatch {
			guard let asset = self.playerItemAssets[playerItem] else {
				return
			}

			self.delegates.waiting(for: asset)
		}
	}

	func playbackProgressed(in playerItem: AVPlayerItem) {
		queue.dispatch {
			guard let asset = self.playerItemAssets[playerItem] else {
				return
			}

			asset.setAssetPosition(playerItem)
		}
	}

	func playerItemChanged(oldPlayerItem: AVPlayerItem) {
		queue.dispatch {
			self.playerItemMonitors.removeValue(forKey: oldPlayerItem)
			let asset = self.playerItemAssets.removeValue(forKey: oldPlayerItem)

			if let currentPlayerItem = self.controller.activePlayer.currentItem {
				self.delegates.completed(asset: asset)
				if self.controller.activePlayer.timeControlStatus == .playing {
					self.playing(playerItem: currentPlayerItem)
				}
			} else {
				PlayerWorld.logger?.log(loggable: PlayerLoggable.itemChangedWithoutQueuedItems)
				if let (nextPlayerItem, _) = self.playerItemAssets.first {
					self.controller.enqueue(nextPlayerItem)
				} else {
					self.internalReset()
				}
				self.delegates.completed(asset: asset)
			}
		}
	}

	func playedToEnd(playerItem: AVPlayerItem) {
		queue.dispatch {
			self.playerItemMonitors.removeValue(forKey: playerItem)
			let asset = self.playerItemAssets.removeValue(forKey: playerItem)

			let result = self.controller.onPlayedToEnd(playerItem)

			if result.completed {
				self.delegates.completed(asset: asset)

				if result.shouldTriggerPlaying, let currentItem = self.controller.activePlayer.currentItem {
					self.playing(playerItem: currentItem)
				}
			}
		}
	}
}
