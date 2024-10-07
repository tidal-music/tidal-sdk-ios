import AVFoundation

// swiftlint:disable file_length
import Foundation
import MediaPlayer

// MARK: - Constants

private enum Constants {
	static let defaultVolume: Float = 1
}

// MARK: - AVQueuePlayerWrapperLegacy

final class AVQueuePlayerWrapperLegacy: GenericMediaPlayer {
	private let featureFlagProvider: FeatureFlagProvider
	private let queue: OperationQueue
	private let contentKeyDelegateQueue: DispatchQueue
	private let playbackTimeProgressQueue: DispatchQueue

	private let assetFactory: AVURLAssetFactoryLegacy
	@Atomic private var player: AVQueuePlayer

	private var playerItemMonitors: [AVPlayerItem: AVPlayerItemMonitor]
	private var playerItemAssets: [AVPlayerItem: AVPlayerAssetLegacy]
	private var delegates: PlayerMonitoringDelegates

	private var playerMonitor: AVPlayerMonitor?
	private var isSeeking = false

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

		contentKeyDelegateQueue = DispatchQueue(label: "com.tidal.player.contentkeydelegate.queue")
		playbackTimeProgressQueue = DispatchQueue(label: "com.tidal.player.playbacktimeprogress.queue")

		assetFactory = AVURLAssetFactoryLegacy(with: queue)
		player = AVQueuePlayerWrapperLegacy.createPlayer()

		playerItemMonitors = [AVPlayerItem: AVPlayerItemMonitor]()
		playerItemAssets = [AVPlayerItem: AVPlayerAssetLegacy]()
		delegates = PlayerMonitoringDelegates()

		preparePlayer()
		preparePlayerCache()
	}

	func canPlay(
		productType: ProductType,
		codec: AudioCodec?,
		mediaType: String?,
		isOfflined: Bool
	) -> Bool {
		switch productType {
		case .VIDEO, .BROADCAST, .UC:
			return true
		case .TRACK:
			guard let codec else {
				return false
			}
			return supportedCodecs.contains(codec) || (codec == .FLAC && !isOfflined)
		}
	}

	func load(
		_ url: URL,
		cacheKey: String?,
		loudnessNormalizationConfiguration: LoudnessNormalizationConfiguration,
		and licenseLoader: LicenseLoader?
	) async -> Asset {
		await withCheckedContinuation { continuation in
			queue.dispatch {
				var cacheState: AssetCacheState?
				let urlAsset: AVURLAsset
				if let cacheKey, self.isContentCachingEnabled {
					if let cachedAsset = self.assetFactory.get(with: cacheKey) {
						cacheState = AssetCacheState(key: cacheKey, status: .cached(cachedURL: cachedAsset.url))
						urlAsset = cachedAsset
					} else {
						cacheState = AssetCacheState(key: cacheKey, status: .notCached)
						urlAsset = self.assetFactory.create(using: cacheKey, or: url)
					}
				} else {
					cacheState = nil
					urlAsset = AVURLAsset(url: url, options: [AVURLAssetPreferPreciseDurationAndTimingKey: url.isFileURL])
				}

				let asset = self.load(
					urlAsset,
					loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
					and: licenseLoader as? AVContentKeySessionDelegate,
					AVPlayerAssetLegacy.self
				)

				asset.setCacheState(cacheState)

				continuation.resume(returning: asset)
			}
		}
	}

	func unload(asset: Asset) {
		queue.dispatch {
			guard let playerItem = self.playerItemAssets.first(where: { _, a in a === asset })?.key else {
				return
			}

			self.unload(playerItem: playerItem)
		}
	}

	func play() {
		queue.dispatch {
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
			self.player.pause()

			self.playerItemMonitors.removeAll()
			self.playerItemAssets.removeAll()
			self.playerMonitor = nil
			self.delegates.removeAll()
			self.player = AVQueuePlayerWrapperLegacy.createPlayer()

			self.preparePlayer()

			self.assetFactory.reset()
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

// MARK: LiveMediaPlayer

extension AVQueuePlayerWrapperLegacy: LiveMediaPlayer {
	func loadLive(
		_ url: URL,
		with licenseLoader: LicenseLoader?
	) async -> Asset {
		await withCheckedContinuation { continuation in
			queue.dispatch {
				let urlAsset = AVURLAsset(url: url)

				// In Live, there's no loudness normalization.
				let loudnessNormalizationConfiguration = LoudnessNormalizationConfiguration(
					loudnessNormalizationMode: .NONE,
					loudnessNormalizer: nil
				)

				let asset = self.load(
					urlAsset,
					loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
					and: licenseLoader as? AVContentKeySessionDelegate,
					LiveAVPlayerAssetLegacy.self
				)

				continuation.resume(returning: asset)
			}
		}
	}
}

// MARK: UCMediaPlayer

extension AVQueuePlayerWrapperLegacy: UCMediaPlayer {
	func loadUC(
		_ url: URL,
		loudnessNormalizationConfiguration: LoudnessNormalizationConfiguration,
		headers: [String: String]
	) async -> Asset {
		await withCheckedContinuation { continuation in
			queue.dispatch {
				var options = [
					AVURLAssetPreferPreciseDurationAndTimingKey: url.isFileURL,
					"AVURLAssetHTTPHeaderFieldsKey": headers,
				]

				if #available(iOS 17.0, macOS 14.0, *) {
					options[AVURLAssetOverrideMIMETypeKey] = "application/vnd.apple.mpegurl"
				}

				let urlAsset = AVURLAsset(
					url: url,
					options: options
				)

				let asset = self.load(
					urlAsset,
					loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
					and: nil,
					AVPlayerAssetLegacy.self
				)

				continuation.resume(returning: asset)
			}
		}
	}
}

// MARK: VideoPlayer

extension AVQueuePlayerWrapperLegacy: VideoPlayer {
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

private extension AVQueuePlayerWrapperLegacy {
	static func createPlayer() -> AVQueuePlayer {
		let player = AVQueuePlayer()
		player.automaticallyWaitsToMinimizeStalling = true
		player.actionAtItemEnd = .advance
		player.allowsExternalPlayback = false
		return player
	}

	static func createPlayerItem(_ asset: AVURLAsset) -> AVPlayerItem {
		let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: [#keyPath(AVAsset.duration)])
		playerItem.preferredForwardBufferDuration = 0 // Framework decides

		return playerItem
	}

	func load(
		_ urlAsset: AVURLAsset,
		loudnessNormalizationConfiguration: LoudnessNormalizationConfiguration,
		and contentKeySessionDelegate: AVContentKeySessionDelegate?,
		_ type: AVPlayerAssetLegacy.Type
	) -> AVPlayerAssetLegacy {
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

		let playerItem = AVQueuePlayerWrapperLegacy.createPlayerItem(urlAsset)
		monitor(playerItem)

		player.insert(playerItem, after: nil)
		playerItemAssets[playerItem] = asset

		return asset
	}

	func monitor(_ playerItem: AVPlayerItem) {
		playerItemMonitors[playerItem] = AVPlayerItemMonitor(
			playerItem,
			onFailure: failed,
			onStall: stalled,
			onCompletelyDownloaded: downloaded,
			onReadyToPlayToPlay: loaded,
			onDjSessionTransition: receivedDjSessionTransition
		)
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
		if !isContentCachingEnabled {
			assetFactory.clearCache()
		}
	}

	func unload(playerItem: AVPlayerItem) {
		playerItemMonitors.removeValue(forKey: playerItem)
		playerItemAssets.removeValue(forKey: playerItem)
		player.remove(playerItem)
	}

	func readPlaybackMetadata(_ playerItem: AVPlayerItem) async -> AssetPlaybackMetadata? {
		do {
			var formatDescriptions = [CMFormatDescription]()
			for track in playerItem.tracks {
				if let assetTrack = track.assetTrack {
					try await formatDescriptions.append(contentsOf: assetTrack.load(.formatDescriptions))
				}
			}

			guard !formatDescriptions.isEmpty else {
				return nil
			}

			let sampleRate: Float64? = Set(formatDescriptions).compactMap {
				$0.audioStreamBasicDescription?.mSampleRate
			}.sorted(by: { $0 > $1 }).first

			let bitdepthFlags = Set(formatDescriptions).compactMap {
				$0.audioStreamBasicDescription?.mFormatFlags
			}.sorted(by: { $0 > $1 }).first

			return AssetPlaybackMetadata(sampleRate: sampleRate, formatFlags: bitdepthFlags)
		} catch {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.legacyReadPlaybackMetadataFailed(error: error))
			return nil
		}
	}
}

private extension AVQueuePlayerWrapperLegacy {
	func loaded(playerItem: AVPlayerItem) {
		queue.dispatch {
			guard let asset = self.playerItemAssets[playerItem] else {
				return
			}

			self.delegates.loaded(asset: asset, with: CMTimeGetSeconds(playerItem.duration))
		}

		// In a separate context to not block player operation
		SafeTask {
			if let metadata = await self.readPlaybackMetadata(playerItem) {
				queue.dispatch {
					guard let asset = self.playerItemAssets[playerItem] else {
						return
					}
					asset.playbackMetadata = metadata
					self.delegates.playbackMetadataLoaded(asset: asset)
				}
			}
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

			self.delegates.failed(asset: asset, with: AVQueuePlayerWrapperLegacy.convertError(error: error, playerItem: playerItem))
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
			self.delegates.completed(asset: asset)

			guard let newPlayerItem = self.player.currentItem else {
				self.reset()
				return
			}

			if self.player.timeControlStatus == .playing {
				self.playing(playerItem: newPlayerItem)
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

	func receivedDjSessionTransition(playerItem: AVPlayerItem, transition: DJSessionTransition) {
		queue.dispatch {
			guard let asset = self.playerItemAssets[playerItem] else {
				return
			}

			self.delegates.djSessionTransition(asset: asset, transition: transition)
		}
	}
}

private extension AVQueuePlayerWrapperLegacy {
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
		(error as? AVError).map {
			PlayerInternalError(
				errorId: .PERetryable,
				errorType: .avPlayerAvError,
				code: $0.code.rawValue,
				description: description
			)
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
