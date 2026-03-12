import AVFoundation
import Foundation
import MediaPlayer

// MARK: - Constants

// swiftlint:disable file_length

private enum Constants {
	static let defaultVolume: Float = 1
	static let crossfadeDuration: Double = 10
	static let crossfadeTimerInterval: Double = 0.05
}

// MARK: - DualAVPlayerWrapper

final class DualAVPlayerWrapper: GenericMediaPlayer {
	private let featureFlagProvider: FeatureFlagProvider

	private let queue: OperationQueue

	private var playerA: AVPlayer
	private var playerB: AVPlayer
	private var playerMonitorA: AVPlayerMonitor?
	private var playerMonitorB: AVPlayerMonitor?
	private var isSeeking = false

	/// Tracks which player is currently the "active" one (playing the current track).
	private var isPlayerAActive = true
	private var activePlayer: AVPlayer { isPlayerAActive ? playerA : playerB }
	private var nextPlayer: AVPlayer { isPlayerAActive ? playerB : playerA }

	private let contentKeyDelegateQueue = DispatchQueue(label: "com.tidal.player.dual.contentkeydelegate.queue")
	private let playbackTimeProgressQueueA = DispatchQueue(label: "com.tidal.player.dual.playbacktimeprogress.a.queue")
	private let playbackTimeProgressQueueB = DispatchQueue(label: "com.tidal.player.dual.playbacktimeprogress.b.queue")

	private var playerItemMonitors: [AVPlayerItem: AVPlayerItemMonitor] = [:]
	private var playerItemAssets: [AVPlayerItem: AVPlayerAsset] = [:]
	private var delegates: PlayerMonitoringDelegates = PlayerMonitoringDelegates()

	/// Maps each AVPlayerItem to the AVPlayer instance that owns it.
	private var playerItemOwners: [AVPlayerItem: AVPlayer] = [:]

	// MARK: - Crossfade state

	private var crossfadeTimeObserver: Any?
	private var crossfadeTimer: Timer?
	private var isCrossfading = false

	// MARK: - Convenience properties

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

		playerA = DualAVPlayerWrapper.createPlayer()
		playerB = DualAVPlayerWrapper.createPlayer()

		preparePlayerA()
		preparePlayerB()
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

			let owningPlayer = self.playerItemOwners[playerItem]
			self.unloadPlayerItem(playerItem)

			if owningPlayer == self.activePlayer, playerItem == self.activePlayer.currentItem {
				self.cancelCrossfade()
				guard let (nextPlayerItem, _) = self.playerItemAssets.first else {
					self.internalReset()
					return
				}
				let owner = self.playerItemOwners[nextPlayerItem]
				if owner == self.nextPlayer {
					self.swapPlayers()
				}
			}
		}
	}

	func play() {
		queue.dispatch {
			self.activePlayer.play()
			if self.isCrossfading {
				self.nextPlayer.play()
			}
		}
	}

	func pause() {
		queue.dispatch {
			self.activePlayer.pause()
			if self.isCrossfading {
				self.nextPlayer.pause()
			}
		}
	}

	func seek(to time: Double) {
		queue.dispatch {
			guard let currentItem = self.activePlayer.currentItem, let asset = self.playerItemAssets[currentItem] else {
				return
			}

			self.delegates.seeking(in: asset)

			if self.shouldPauseAndPlayAroundSeek {
				if self.activePlayer.timeControlStatus == .playing {
					self.isSeeking = true
					await self.activePlayer.pause()
				}

				let completed = await self.activePlayer.seek(to: time)
				self.isSeeking = false
				await self.activePlayer.play()

				guard completed, currentItem == self.activePlayer.currentItem else {
					return
				}

				asset.setAssetPosition(currentItem)
			} else {
				let completed = await self.activePlayer.seek(to: time)
				guard completed, currentItem == self.activePlayer.currentItem,
				      self.activePlayer.timeControlStatus == .playing
				else {
					return
				}

				asset.setAssetPosition(currentItem)
				self.delegates.playing(asset: asset)
			}
		}
	}

	func unload() {
		queue.cancelAllOperations()
		queue.dispatch {
			self.cancelCrossfade()
			self.playerMonitorA = nil
			self.playerMonitorB = nil
			self.delegates.removeAll()
			self.playerItemMonitors.removeAll()
			self.playerItemAssets.removeAll()
			self.playerItemOwners.removeAll()

			self.playerA.pause()
			self.playerA.replaceCurrentItem(with: nil)
			self.playerB.pause()
			self.playerB.replaceCurrentItem(with: nil)
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
			self.activePlayer.volume = loudnessNormalizer?.getScaleFactor() ?? Constants.defaultVolume
		}
	}

	func addMonitoringDelegate(monitoringDelegate: PlayerMonitoringDelegate) {
		queue.dispatch {
			self.delegates.add(delegate: monitoringDelegate)
		}
	}
}

// MARK: UCMediaPlayer

extension DualAVPlayerWrapper: UCMediaPlayer {
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
					and: nil,
					AVPlayerAsset.self
				)

				continuation.resume(returning: asset)
			}
		}
	}
}

// MARK: VideoPlayer

extension DualAVPlayerWrapper: VideoPlayer {
	func renderVideo(in view: AVPlayerLayer) {
		queue.dispatch {
			guard self.activePlayer.currentItem != nil else {
				return
			}

			DispatchQueue.main.async {
				view.player = self.activePlayer
			}
		}
	}
}

// MARK: - Player creation & item management

private extension DualAVPlayerWrapper {
	static func createPlayer() -> AVPlayer {
		let player = AVPlayer()
		player.automaticallyWaitsToMinimizeStalling = true
		player.actionAtItemEnd = .none
		player.allowsExternalPlayback = false
		return player
	}

	static func createPlayerItem(_ asset: AVURLAsset) -> AVPlayerItem {
		let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: [#keyPath(AVAsset.duration)])
		playerItem.preferredForwardBufferDuration = 0
		playerItem.variantPreferences = .scalabilityToLosslessAudio
		playerItem.startsOnFirstEligibleVariant = true
		return playerItem
	}

	func load(
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

		let playerItem = DualAVPlayerWrapper.createPlayerItem(urlAsset)
		register(playerItem: playerItem, for: asset)

		let targetPlayer = targetPlayerForLoad()
		playerItemOwners[playerItem] = targetPlayer
		targetPlayer.replaceCurrentItem(with: playerItem)

		return asset
	}

	/// Determines which player should receive the next loaded item.
	/// If the active player has no item, use it. Otherwise, use the next player.
	func targetPlayerForLoad() -> AVPlayer {
		if activePlayer.currentItem == nil {
			return activePlayer
		}
		return nextPlayer
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

	func preparePlayerA() {
		playerMonitorA = AVPlayerMonitor(
			playerA,
			playbackTimeProgressQueueA,
			onIsPlaying: playing,
			onIsPaused: paused,
			onFailure: failed,
			onItemChanged: playerItemChanged,
			onWaitingToPlay: waiting,
			onPlaybackProgress: playbackProgressed
		)
	}

	func preparePlayerB() {
		playerMonitorB = AVPlayerMonitor(
			playerB,
			playbackTimeProgressQueueB,
			onIsPlaying: playing,
			onIsPaused: paused,
			onFailure: failed,
			onItemChanged: playerItemChanged,
			onWaitingToPlay: waiting,
			onPlaybackProgress: playbackProgressed
		)
	}

	func unloadPlayerItem(_ playerItem: AVPlayerItem) {
		playerItemMonitors.removeValue(forKey: playerItem)
		playerItemAssets.removeValue(forKey: playerItem)
		let owner = playerItemOwners.removeValue(forKey: playerItem)
		if owner?.currentItem == playerItem {
			owner?.replaceCurrentItem(with: nil)
		}
	}

	func register(playerItem: AVPlayerItem, for asset: AVPlayerAsset) {
		playerItemAssets[playerItem] = asset
		monitor(playerItem, asset: asset)
	}

	func readPlaybackMetadata(playerItem: AVPlayerItem, asset: AVPlayerAsset) {
		delegates.playbackMetadataLoaded(asset: asset)
	}

	func swapPlayers() {
		isPlayerAActive.toggle()
	}

	func internalReset() {
		cancelCrossfade()
		playerMonitorA = nil
		playerMonitorB = nil
		playerItemMonitors.removeAll()
		playerItemAssets.removeAll()
		playerItemOwners.removeAll()

		playerA.pause()
		playerA.replaceCurrentItem(with: nil)
		playerB.pause()
		playerB.replaceCurrentItem(with: nil)

		playerA = DualAVPlayerWrapper.createPlayer()
		playerB = DualAVPlayerWrapper.createPlayer()
		isPlayerAActive = true

		preparePlayerA()
		preparePlayerB()
	}
}

// MARK: - Crossfade logic

private extension DualAVPlayerWrapper {
	func setupCrossfadeObserver() {
		guard let currentItem = activePlayer.currentItem else {
			return
		}

		removeCrossfadeObserver()

		let duration = CMTimeGetSeconds(currentItem.duration)
		guard duration.isFinite, duration > Constants.crossfadeDuration else {
			return
		}

		let crossfadeStartTime = duration - Constants.crossfadeDuration
		let boundaryTime = CMTime(seconds: crossfadeStartTime, preferredTimescale: 600)
		crossfadeTimeObserver = activePlayer.addBoundaryTimeObserver(
			forTimes: [NSValue(time: boundaryTime)],
			queue: nil
		) { [weak self] in
			self?.beginCrossfade()
		}
	}

	func removeCrossfadeObserver() {
		if let observer = crossfadeTimeObserver {
			activePlayer.removeTimeObserver(observer)
			crossfadeTimeObserver = nil
		}
	}

	func beginCrossfade() {
		queue.dispatch {
			guard !self.isCrossfading else {
				return
			}

			guard self.nextPlayer.currentItem != nil else {
				return
			}

			self.isCrossfading = true
			self.nextPlayer.volume = 0
			self.nextPlayer.play()

			let startTime = CACurrentMediaTime()
			let fadeDuration = Constants.crossfadeDuration

			self.crossfadeTimer?.invalidate()
			self.crossfadeTimer = Timer.scheduledTimer(withTimeInterval: Constants.crossfadeTimerInterval, repeats: true) {
				[weak self] timer in
				guard let self else {
					timer.invalidate()
					return
				}

				self.queue.dispatch {
					let elapsed = CACurrentMediaTime() - startTime
					let progress = min(Float(elapsed / fadeDuration), 1.0)

					self.activePlayer.volume = 1.0 - progress
					self.nextPlayer.volume = progress

					if progress >= 1.0 {
						timer.invalidate()
						self.crossfadeTimer = nil
					}
				}
			}
		}
	}

	func cancelCrossfade() {
		removeCrossfadeObserver()
		crossfadeTimer?.invalidate()
		crossfadeTimer = nil
		isCrossfading = false
		nextPlayer.pause()
		nextPlayer.volume = 0
		activePlayer.volume = Constants.defaultVolume
	}

	func completeCrossfade() {
		crossfadeTimer?.invalidate()
		crossfadeTimer = nil
		isCrossfading = false

		activePlayer.volume = Constants.defaultVolume
	}
}

// MARK: - AVPlayer Monitoring

private extension DualAVPlayerWrapper {
	func loaded(playerItem: AVPlayerItem) {
		queue.dispatch {
			guard let asset = self.playerItemAssets[playerItem] else {
				return
			}

			self.readPlaybackMetadata(playerItem: playerItem, asset: asset)
			self.delegates.loaded(asset: asset, with: CMTimeGetSeconds(playerItem.duration))

			if self.playerItemOwners[playerItem] == self.activePlayer {
				self.setupCrossfadeObserver()
			}
		}
	}

	func playing(playerItem: AVPlayerItem) {
		queue.dispatch {
			guard let asset = self.playerItemAssets[playerItem] else {
				return
			}

			let owner = self.playerItemOwners[playerItem]

			// Only report playing delegate for the active player's item,
			// or for the next player's item after the crossfade completes (handled in playerItemChanged).
			guard owner == self.activePlayer else {
				return
			}

			self.activePlayer.allowsExternalPlayback = playerItem.tracks.contains(where: {
				$0.assetTrack?.mediaType == .video
			})

			let volume: Float = asset.getLoudnessNormalizationConfiguration().getLoudnessNormalizer()?
				.getScaleFactor() ?? Constants.defaultVolume

			if !self.isCrossfading {
				self.activePlayer.volume = volume
			}

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

			let owner = self.playerItemOwners[playerItem]
			guard owner == self.activePlayer else {
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

			self.delegates.failed(asset: asset, with: DualAVPlayerWrapper.convertError(error: error, playerItem: playerItem))
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

			let owner = self.playerItemOwners[playerItem]
			guard owner == self.activePlayer else {
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

			let owner = self.playerItemOwners[playerItem]
			guard owner == self.activePlayer else {
				return
			}

			self.delegates.waiting(for: asset)
		}
	}

	func playerItemChanged(oldPlayerItem: AVPlayerItem) {
		queue.dispatch {
			self.playerItemMonitors.removeValue(forKey: oldPlayerItem)
			let asset = self.playerItemAssets.removeValue(forKey: oldPlayerItem)
			let owner = self.playerItemOwners.removeValue(forKey: oldPlayerItem)

			guard owner == self.activePlayer else {
				return
			}

			self.completeCrossfade()
			self.swapPlayers()

			self.delegates.completed(asset: asset)

			if let currentItem = self.activePlayer.currentItem {
				self.setupCrossfadeObserver()
				if self.activePlayer.timeControlStatus == .playing {
					self.playing(playerItem: currentItem)
				}
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
		queue.dispatch {
			let owner = self.playerItemOwners[playerItem]

			if owner == self.activePlayer {
				self.completeCrossfade()

				self.playerItemMonitors.removeValue(forKey: playerItem)
				let asset = self.playerItemAssets.removeValue(forKey: playerItem)
				self.playerItemOwners.removeValue(forKey: playerItem)
				self.activePlayer.replaceCurrentItem(with: nil)

				self.swapPlayers()
				self.delegates.completed(asset: asset)

				if let currentItem = self.activePlayer.currentItem {
					self.setupCrossfadeObserver()
					if self.activePlayer.timeControlStatus == .playing {
						self.playing(playerItem: currentItem)
					}
				}
			}
		}
	}
}

// MARK: - Error Helpers

private extension DualAVPlayerWrapper {
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
