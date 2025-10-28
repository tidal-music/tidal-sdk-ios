import AVFoundation
import Foundation
import MediaPlayer

// MARK: - Constants

// swiftlint:disable file_length

private enum Constants {
	static let defaultVolume: Float = 1
}

// MARK: - AVQueuePlayerWrapper

final class AVQueuePlayerWrapper: GenericMediaPlayer {
	private let featureFlagProvider: FeatureFlagProvider

	private let queue: OperationQueue
	private let assetFactory: AVURLAssetFactory

	@Atomic private var player: AVQueuePlayer
	private var playerMonitor: AVPlayerMonitor?
	private var isSeeking = false

	private let contentKeyDelegateQueue: DispatchQueue = DispatchQueue(label: "com.tidal.player.contentkeydelegate.queue")
	private let playbackTimeProgressQueue: DispatchQueue = DispatchQueue(label: "com.tidal.player.playbacktimeprogress.queue")

	private var playerItemMonitors: [AVPlayerItem: AVPlayerItemMonitor] = [AVPlayerItem: AVPlayerItemMonitor]()
	private var playerItemAssets: [AVPlayerItem: AVPlayerAsset] = [AVPlayerItem: AVPlayerAsset]()
	private var delegates: PlayerMonitoringDelegates = PlayerMonitoringDelegates()

	// MARK: - Convenience properties

	private var isContentCachingEnabled: Bool {
		featureFlagProvider.isContentCachingEnabled()
	}

	private var shouldPauseAndPlayAroundSeek: Bool {
		featureFlagProvider.shouldPauseAndPlayAroundSeek()
	}

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
		self.featureFlagProvider = featureFlagProvider

		queue = OperationQueue()
		queue.maxConcurrentOperationCount = 1
		queue.qualityOfService = .userInitiated

		assetFactory = AVURLAssetFactory()
		player = AVQueuePlayerWrapper.createPlayer(featureFlagProvider: featureFlagProvider)

		preparePlayer()
		preparePlayerCache()
	}

	func canPlay(
		productType: ProductType,
		codec: AudioCodec?,
		mediaType: String?,
		isOfflined: Bool
	) -> Bool {
		if productType == .VIDEO {
			return true
		}

		if case let .UC(url) = productType, url.isFileURL {
			return true
		}

		guard let codec else {
			return false
		}
		// Because we need to support items downloaded with both the legacy and the new OfflineEngine
		// We can't just add .FLAC to the 'supportedCodecs' array, and we need to depend on the mediaType
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
				let key = self.isContentCachingEnabled ? cacheKey : nil

				var urlAsset: AVURLAsset
				var cacheState = self.assetFactory.get(with: key)
				switch cacheState {
				case .none:
					urlAsset = AVURLAsset(url: url, options: [
						AVURLAssetPreferPreciseDurationAndTimingKey: url.isFileURL,
					])
				case let .some(state):
					switch state.status {
					case .notCached:
						urlAsset = AVURLAsset(url: url)
					case let .cached(cachedURL):
						urlAsset = AVURLAsset(url: cachedURL)
						if !urlAsset.isPlayableOffline {
							self.assetFactory.delete(state.key)
							cacheState = AssetCacheState(key: state.key, status: .notCached)
							urlAsset = AVURLAsset(url: url)
						}
					}
				}

				let asset = self.load(
					cacheState,
					urlAsset,
					loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
					and: licenseLoader as? AVContentKeySessionDelegate,
					AVPlayerAsset.self
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

			if let key = asset.cacheState?.key {
				self.assetFactory.cancel(with: key)
			}

			self.unload(playerItem: playerItem)

			if playerItem === self.player.currentItem {
				// If we are unloading the item that is playing
				// And there are no more assets loaded we do a reset
				guard let (nextPlayerItem, _) = self.playerItemAssets.first else {
					self.internalReset()
					return
				}
				self.enqueue(playerItem: nextPlayerItem)
				self.player.advanceToNextItem()
			} else {
				if !self.player.canInsert(playerItem, after: nil) {
					self.player.remove(playerItem)
				}
				if self.playerItemAssets.isEmpty {
					self.internalReset()
				}
			}
		}
	}

	func play() {
		queue.dispatch {
			if self.player.items().isEmpty {
				PlayerWorld.logger?.log(loggable: PlayerLoggable.playWithoutQueuedItems)
			}
			self.player.play()
		}
	}

	func pause() {
		queue.dispatch {
			self.player.pause()
		}
	}

	func seek(to time: Double) {
		queue.dispatch {
			guard let currentItem = self.player.currentItem, let asset = self.playerItemAssets[currentItem] else {
				return
			}

			self.delegates.seeking(in: asset)

			if self.shouldPauseAndPlayAroundSeek {
				if self.player.timeControlStatus == .playing {
					self.isSeeking = true
					await self.player.pause()
				}

				let completed = await self.player.seek(to: time)
				self.isSeeking = false
				await self.player.play()

				guard completed, currentItem == self.player.currentItem else {
					return
				}

				asset.setAssetPosition(currentItem)
			} else {
				let completed = await self.player.seek(to: time)
				guard completed, currentItem == self.player.currentItem, self.player.timeControlStatus == .playing else {
					return
				}

				asset.setAssetPosition(currentItem)
				self.delegates.playing(asset: asset)
			}
		}
	}

	func unload() {
		queue.cancelAllOperations()

		playerMonitor = nil
		delegates.removeAll()
		playerItemMonitors.removeAll()
		playerItemAssets.removeAll()

		assetFactory.reset()

		player.pause()
		player.removeAllItems()
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
			self.player.volume = loudnessNormalizer?.getScaleFactor() ?? 1.0
		}
	}

	func addMonitoringDelegate(monitoringDelegate: PlayerMonitoringDelegate) {
		queue.dispatch {
			self.delegates.add(delegate: monitoringDelegate)
		}
	}
}


// MARK: UCMediaPlayer

extension AVQueuePlayerWrapper: UCMediaPlayer {
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
					nil,
					urlAsset,
					loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
					and: nil,
					AVPlayerAsset.self
				)

				continuation.resume(returning: asset)
			}
		}
	}
}

// MARK: VideoPlayer

extension AVQueuePlayerWrapper: VideoPlayer {
	func renderVideo(in view: AVPlayerLayer) {
		queue.dispatch {
			guard self.player.currentItem != nil else {
				return
			}

			DispatchQueue.main.async {
				view.player = self.player
			}
		}
	}
}

private extension AVQueuePlayerWrapper {
	static func createPlayer(featureFlagProvider: FeatureFlagProvider) -> AVQueuePlayer {
		let player = AVQueuePlayer()
		player.automaticallyWaitsToMinimizeStalling = true
		player.actionAtItemEnd = if featureFlagProvider.shouldNotPerformActionAtItemEnd() {
			.none
		} else {
			.advance
		}
		player.allowsExternalPlayback = false
		return player
	}

	static func createPlayerItem(_ asset: AVURLAsset) -> AVPlayerItem {
		let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: [#keyPath(AVAsset.duration)])
		playerItem.preferredForwardBufferDuration = 0 // Framework decides
		//playerItem.variantPreferences = .scalabilityToLosslessAudio
		return playerItem
	}

	func load(
		_ cacheState: AssetCacheState?,
		_ urlAsset: AVURLAsset,
		loudnessNormalizationConfiguration: LoudnessNormalizationConfiguration,
		and contentKeySessionDelegate: AVContentKeySessionDelegate?,
		_ type: AVPlayerAsset.Type
	) -> AVPlayerAsset {
		let contentKeySession = contentKeySessionDelegate.map { delegate -> AVContentKeySession in
			let session = AVContentKeySession(keySystem: .fairPlayStreaming)
			session.setDelegate(delegate, queue: contentKeyDelegateQueue)
			session.addContentKeyRecipient(urlAsset)

			return session
		}

		let asset = type.init(
			with: self,
			loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
			contentKeySession,
			and: contentKeySessionDelegate
		)

		asset.setCacheState(cacheState)

		let playerItem = AVQueuePlayerWrapper.createPlayerItem(urlAsset)
		register(playerItem: playerItem, for: asset)

		// Items in the AVPlayer queue are not downloaded in advance
		// This way the next item in the queue can be downloaded in advance.
		if cacheState == nil {
			enqueue(playerItem: playerItem)
		} else if let state = cacheState {
			switch state.status {
			case .notCached:
				assetFactory.cacheAsset(urlAsset, for: state.key)
				if player.items().isEmpty {
					enqueue(playerItem: playerItem)
				}
			case .cached:
				enqueue(playerItem: playerItem)
			}
		}

		return asset
	}

	func monitor(_ playerItem: AVPlayerItem, asset: AVPlayerAsset) {
		playerItemMonitors[playerItem] = AVPlayerItemMonitor(
			playerItem,
			queue: queue,
			onFailure: failed,
			onStall: stalled,
			onCompletelyDownloaded: downloaded,
			onReadyToPlayToPlay: loaded,
			onItemPlayedToEnd: playedToEnd
		) { [weak self] item, newQuality in
			guard let self else {
				return
			}

			guard let asset = self.playerItemAssets[item] else {
				return
			}

			self.delegates.audioQualityChanged(asset: asset, to: newQuality)
		}
	}

	func preparePlayer() {
		playerMonitor = AVPlayerMonitor(
			player,
			playbackTimeProgressQueue,
			onIsPlaying: playing,
			onIsPaused: paused,
			onFailure: failed,
			onItemChanged: playerItemChanged,
			onWaitingToPlay: waiting,
			onPlaybackProgress: playbackProgressed
		)
	}

	func preparePlayerCache() {
		assetFactory.delegate = self
		if !isContentCachingEnabled {
			assetFactory.clearCache()
		}
	}

	func unload(playerItem: AVPlayerItem) {
		playerItemMonitors.removeValue(forKey: playerItem)
		playerItemAssets.removeValue(forKey: playerItem)
	}

	func register(playerItem: AVPlayerItem, for asset: AVPlayerAsset) {
		playerItemAssets[playerItem] = asset
		monitor(playerItem, asset: asset)
	}

	func enqueue(playerItem: AVPlayerItem) {
		if player.canInsert(playerItem, after: nil) {
			player.insert(playerItem, after: nil)
		}
	}

	func readPlaybackMetadata(playerItem: AVPlayerItem, asset: AVPlayerAsset) {
		// Metadata extraction is now handled by AVPlayerItemABRMonitor for quality detection
		delegates.playbackMetadataLoaded(asset: asset)
	}

	func internalReset() {
		playerMonitor = nil
		playerItemMonitors.removeAll()
		playerItemAssets.removeAll()

		assetFactory.reset()

		player.pause()
		player.removeAllItems()

		player = AVQueuePlayerWrapper.createPlayer(featureFlagProvider: featureFlagProvider)
		preparePlayer()
	}
}

// MARK: AVPlayer Monitoring

private extension AVQueuePlayerWrapper {
	func loaded(playerItem: AVPlayerItem) {
		queue.dispatch {
			guard let asset = self.playerItemAssets[playerItem] else {
				return
			}

			self.readPlaybackMetadata(playerItem: playerItem, asset: asset)

			self.delegates.loaded(asset: asset, with: CMTimeGetSeconds(playerItem.duration))
		}
	}

	func playing(playerItem: AVPlayerItem) {
		queue.dispatch {
			guard let asset = self.playerItemAssets[playerItem] else {
				return
			}

			self.player.allowsExternalPlayback = playerItem.tracks.contains(where: { $0.assetTrack?.mediaType == .video })

			let volume: Float = asset.getLoudnessNormalizationConfiguration().getLoudnessNormalizer()?
				.getScaleFactor() ?? Constants.defaultVolume

			self.player.volume = volume

			self.delegates.playing(asset: asset)
		}
	}

	func paused(playerItem: AVPlayerItem) {
		guard !isSeeking else {
			return
		}
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

			self.delegates.failed(asset: asset, with: AVQueuePlayerWrapper.convertError(error: error, playerItem: playerItem))
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

	func playerItemChanged(oldPlayerItem: AVPlayerItem) {
		queue.dispatch {
			self.playerItemMonitors.removeValue(forKey: oldPlayerItem)
			let asset = self.playerItemAssets.removeValue(forKey: oldPlayerItem)

			// AVPlayer has moved to the next item in its queue
			if let currentPlayerItem = self.player.currentItem {
				self.delegates.completed(asset: asset)
				if self.player.timeControlStatus == .playing {
					self.playing(playerItem: currentPlayerItem)
				}
			} else {
				// AVPlayer had no other item in the queue (We might still be downloading the next one)`
				PlayerWorld.logger?.log(loggable: PlayerLoggable.itemChangedWithoutQueuedItems)
				if let (nextPlayerItem, _) = self.playerItemAssets.first {
					self.enqueue(playerItem: nextPlayerItem)
				} else {
					self.internalReset()
				}
				self.delegates.completed(asset: asset)
			}
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


	func playedToEnd(playerItem: AVPlayerItem) {
		if featureFlagProvider.shouldNotPerformActionAtItemEnd() {
			player.remove(playerItem)
		}
	}
}

// MARK: AssetFactoryDelegate

extension AVQueuePlayerWrapper: AssetFactoryDelegate {
	func assetFinishedDownloading(_ urlAsset: AVURLAsset, to location: URL, for cacheKey: String) {
		queue.dispatch {
			guard
				let (oldPlayerItem, asset) = self.playerItemAssets.first(where: { $0.value.cacheState?.key == cacheKey }),
				self.player.canInsert(oldPlayerItem, after: nil)
			else {
				return
			}

			self.unload(playerItem: oldPlayerItem)

			let cacheState = AssetCacheState(key: cacheKey, status: .cached(cachedURL: location))
			asset.setCacheState(cacheState)

			let cachedPlayerItem = AVQueuePlayerWrapper.createPlayerItem(urlAsset)
			self.register(playerItem: cachedPlayerItem, for: asset)

			self.enqueue(playerItem: cachedPlayerItem)
		}
	}
}

// MARK: AVQueuePlayerWrapper Error Helpers

private extension AVQueuePlayerWrapper {
	static func convertError(error: Error?, playerItem: AVPlayerItem) -> PlayerInternalError {
		guard let error else {
			return PlayerInternalError(
				errorId: .PERetryable,
				errorType: .avPlayerOtherError,
				code: Int.max,
				description: "Playback failed, but no error describing the failure was present"
			)
		}

		let description = "Error: {\(error)}, Error log: {\(errorLog(playerItem: playerItem))}"

		if let mediaError = mediaError(error, with: description) {
			return mediaError
		}

		if let networkError = networkError(error, with: description) {
			return networkError
		}

		return PlayerInternalError(
			errorId: .PERetryable,
			errorType: .avPlayerOtherError,
			code: (error as NSError).code,
			description: description
		)
	}

	static func mediaError(_ error: Error, with description: String) -> PlayerInternalError? {
		let nserror = error as NSError

		// If it's the error related to the media services being reset, we create a specific internal error instead of a generic one.
		// This is because the media services being reset is a recoverable error that should be handled differently.
		if nserror.domain == ErrorConstants.avfoundationErrorDomain,
		   nserror.code == ErrorConstants.averrorMediaServicesWereResetErrorCode
		{
			return PlayerInternalError(
				errorId: .PERetryable,
				errorType: .mediaServicesWereReset,
				code: nserror.code,
				description: description
			)
		} else {
			return (error as? AVError).map {
				PlayerInternalError(
					errorId: .PERetryable,
					errorType: .avPlayerAvError,
					code: $0.code.rawValue,
					description: description
				)
			}
		}
	}

	static func networkError(_ error: Error, with description: String) -> PlayerInternalError? {
		if let error = error as? URLError {
			switch error.code {
			case .timedOut, .networkConnectionLost, .notConnectedToInternet:
				return PlayerInternalError(
					errorId: .PENetwork,
					errorType: .avPlayerUrlError,
					code: error.code.rawValue,
					description: description
				)
			default:
				return PlayerInternalError(
					errorId: .PERetryable,
					errorType: .avPlayerUrlError,
					code: error.code.rawValue,
					description: description
				)
			}
		}

		// The case below has been observed when AVPlayer times out while loading data.
		let error = error as NSError
		if error.domain == "CoreMediaErrorDomain", error.code == -12889 {
			return PlayerInternalError(
				errorId: .PENetwork,
				errorType: .avPlayerOtherError,
				code: error.code,
				description: description
			)
		}

		return nil
	}

	static func errorLog(playerItem: AVPlayerItem) -> String {
		guard let log = playerItem.errorLog() else {
			return "empty"
		}

		let events = "Log Events: " + log.events.description

		guard let data = log.extendedLogData(),
		      let logString = NSString(data: data, encoding: log.extendedLogDataStringEncoding)
		else {
			return "empty / \(events)"
		}

		return "\(logString as String) / \(events)"
	}
}

// swiftlint:enable file_length
