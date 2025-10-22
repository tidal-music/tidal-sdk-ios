import AVFoundation

// swiftlint:disable file_length
import Foundation

// MARK: - PlayerItemMonitor

protocol PlayerItemMonitor: AnyObject {
	func loaded(playerItem: PlayerItem)
	func playing(playerItem: PlayerItem)
	func paused(playerItem: PlayerItem)
	func stalled(playerItem: PlayerItem)
	func downloaded(playerItem: PlayerItem)
	func completed(playerItem: PlayerItem)
	func failed(playerItem: PlayerItem, with error: Error)
	func playbackMetadataLoaded(playerItem: PlayerItem)
}

// MARK: - PlayerItem

final class PlayerItem {
	let id: String
	let mediaProduct: MediaProduct

	private weak var playerItemMonitor: PlayerItemMonitor?
	private let playerEventSender: PlayerEventSender
	private let featureFlagProvider: FeatureFlagProvider
	private var playbackStartReason: StartReason

	@Atomic private var metrics: Metrics?
	@Atomic private var isDownloaded: Bool
	@Atomic private var shouldPlayWhenLoaded: Bool
	@Atomic private var seekTimeWhenLoaded: Double?
	@Atomic private var duration: Double?
	@Atomic private(set) var metadata: Metadata?
	@Atomic private(set) var asset: Asset?

	init(
		startReason: StartReason,
		mediaProduct: MediaProduct,
		networkType: NetworkType,
		outputDevice: String?,
		sessionType: SessionType,
		playerItemMonitor: PlayerItemMonitor,
		playerEventSender: PlayerEventSender,
		timestamp: UInt64,
		featureFlagProvider: FeatureFlagProvider,
		isPreload: Bool = false
	) {
		id = PlayerWorld.uuidProvider.uuidString()
		self.mediaProduct = mediaProduct
		self.playerItemMonitor = playerItemMonitor
		self.playerEventSender = playerEventSender
		self.featureFlagProvider = featureFlagProvider

		isDownloaded = false
		shouldPlayWhenLoaded = false
		playbackStartReason = startReason

		var sessionTags = [StreamingSessionStart.SessionTag]()
		if isPreload {
			sessionTags.append(StreamingSessionStart.SessionTag.PRELOADED)
		}
		if !featureFlagProvider.isContentCachingEnabled() {
			sessionTags.append(StreamingSessionStart.SessionTag.CACHING_DISABLED)
		}
		if featureFlagProvider.shouldUseImprovedDRMHandling() {
			sessionTags.append(StreamingSessionStart.SessionTag.IMPROVED_DRM)
		}
		if mediaProduct.extras?[MediaProduct.Extras.Constants.UploadsDictKey] != nil {
			sessionTags.append(StreamingSessionStart.SessionTag.UPLOAD)
		}
		
		playerEventSender.send(StreamingSessionStart(
			streamingSessionId: id,
			startReason: playbackStartReason,
			timestamp: timestamp,
			networkType: networkType,
			outputDevice: outputDevice,
			sessionType: sessionType,
			sessionProductType: mediaProduct.productType.rawValue,
			sessionProductId: mediaProduct.productId,
			sessionTags: sessionTags.isEmpty ? nil : sessionTags
		), extras: mediaProduct.extras)
	}

	func emitEvents() {
		emitStreamingMetrics()
		emitPlayLog()
		emitOfflinePlay()
	}

	func set(_ metadata: Metadata) {
		self.metadata = metadata
	}

	func set(_ asset: Asset) {
		self.asset = asset
		asset.player.addMonitoringDelegate(monitoringDelegate: self)

		if shouldPlayWhenLoaded {
			asset.player.play()
		}
	}

	func updatePlaybackStartReason(to actualPlaybackStartReason: StartReason) {
		playbackStartReason = actualPlaybackStartReason
	}

	/// - Important: This func should be called in order to not send extra metrics events
	/// (for items which have not been played, but used in memory for optimization reasons and internal functionality).
	/// See ``deinit``, where we emit all of them.
	func unload() {
		guard let asset else {
			return
		}

		asset.unload()
		metadata = nil
		self.asset = nil
	}

	/// Unloads asset from player.
	/// This func should be called when the item has been played and we do want to send all metrics.
	func unloadFromPlayer() {
		asset?.unload()
	}

	func play(timestamp: UInt64) {
		if metrics == nil {
			metrics = Metrics(idealStartTime: timestamp)
		}

		shouldPlayWhenLoaded = true
		asset?.player.play()
	}

	func pause() {
		asset?.player.pause()
	}

	func seek(to time: Double) {
		seekTimeWhenLoaded = time
		asset?.player.seek(to: time)
	}

	var isLoaded: Bool {
		asset != nil
	}

	var isCompletelyDownloaded: Bool {
		isDownloaded
	}

	var playbackContext: PlaybackContext? {
		guard let metadata, let duration else {
			return nil
		}

		let (bitDepth, sampleRate) = obtainPlaybackContextBitDepthAndSampleRate(
			pbiMetadata: metadata,
			playbackMetadata: asset?.playbackMetadata
		)

		let codec = metadata.audioCodec ?? AudioCodec(from: metadata.audioQuality, mode: metadata.audioMode)

		return PlaybackContext(
			productId: metadata.productId,
			streamType: metadata.streamType,
			assetPresentation: metadata.assetPresentation,
			audioMode: metadata.audioMode,
			audioQuality: metadata.audioQuality,
			audioCodec: codec?.displayName,
			audioSampleRate: sampleRate,
			audioBitDepth: bitDepth,
			audioBitRate: metadata.audioQuality?.toBitRate(),
			videoQuality: metadata.videoQuality,
			duration: duration,
			assetPosition: assetPosition,
			playbackSessionId: id
		)
	}

	var assetPosition: Double {
		asset?.getAssetPosition() ?? 0
	}
}

// MARK: PlayerMonitoringDelegate

extension PlayerItem: PlayerMonitoringDelegate {
	func loaded(asset: Asset?, with duration: Double) {
		guard asset === self.asset, self.duration == nil else {
			return
		}

		self.duration = duration

		// In addition to triggering a call to play when setting the asset, we also set call it here.
		// When using AirPlay, AVPlayer will not respect the call to play unless it's underlying player item
		// is ready to play. When AirPlay is disabled, it is not necessary that the underlying item is ready
		// for AVPlayer to respect the call to play().
		//
		// Ideally we would prefer not to call play when setting the asset, but external player does not provide
		// the duration of its asset until playback starts. Since it does not provide the duration
		// before playback has started, this function will not be called until it is playing. As a
		// result we cannot call play from this function for some external players.
		//
		// Reset the states after they are used to prevent an unexpected event triggering a seek.
		if shouldPlayWhenLoaded {
			asset?.player.play()
			shouldPlayWhenLoaded = false
		}

		if let seekTimeWhenLoaded {
			asset?.player.seek(to: seekTimeWhenLoaded)
			self.seekTimeWhenLoaded = nil
		}

		playerItemMonitor?.loaded(playerItem: self)
	}

	func playing(asset: Asset?) {
		guard let asset, asset === self.asset else {
			return
		}
		// Due to the periodic timer frequency in PlaybackTimeProgressMonitor, it's possible an item starts playing right after the
		// observer has just executed the on-progress block, meaning we might get an asset position which is not zero when we start
		// to play an item. In this case, we will force the asset position to be zero just for the metrics collection.
		let assetPosition = asset.getAssetPosition()
		if assetPosition > 0, assetPosition < PlaybackTimeProgressMonitorConstants.timeInterval {
			metrics?.recordProgress(at: 0)
		} else {
			metrics?.recordProgress(at: assetPosition)
		}

		playerItemMonitor?.playing(playerItem: self)
	}

	func paused(asset: Asset?) {
		guard let asset, asset === self.asset else {
			return
		}

		metrics?.recordPause(at: asset.getAssetPosition())
		playerItemMonitor?.paused(playerItem: self)
	}

	func seeking(in asset: Asset?) {
		guard let asset, asset === self.asset else {
			return
		}

		metrics?.recordSeek(at: asset.getAssetPosition())
	}

	func waiting(for asset: Asset?) {
		guard asset === self.asset else {
			return
		}

		playerItemMonitor?.stalled(playerItem: self)
	}

	func stall(in asset: Asset?) {
		guard let asset, asset === self.asset else {
			return
		}

		metrics?.recordStall(at: asset.getAssetPosition())
		playerItemMonitor?.stalled(playerItem: self)
	}

	func downloaded(asset: Asset?) {
		guard asset === self.asset else {
			return
		}

		isDownloaded = true
		playerItemMonitor?.downloaded(playerItem: self)
	}

	func completed(asset: Asset?) {
		guard let asset, asset === self.asset else {
			return
		}

		metrics?.recordEnd(endReason: .COMPLETE, assetPosition: asset.getAssetPosition())
		playerItemMonitor?.completed(playerItem: self)
	}

	func failed(asset: Asset?, with error: Error) {
		guard let asset, asset === self.asset else {
			return
		}

		if metrics == nil {
			metrics = Metrics()
		}

		metrics?.recordEnd(endReason: .ERROR, assetPosition: asset.getAssetPosition(), error: error)
		playerItemMonitor?.failed(playerItem: self, with: error)
	}

	func playbackMetadataLoaded(asset: Asset?) {
		guard asset === self.asset else {
			return
		}

		playerItemMonitor?.playbackMetadataLoaded(playerItem: self)
	}
}

// MARK: CustomStringConvertible

extension PlayerItem: CustomStringConvertible {
	var description: String { // swiftlint:disable:next line_length
		"PlayerItem(id: \"\(id)\", mediaProduct: \(mediaProduct), playerItemMonitor: \(String(describing: playerItemMonitor)), playerEventSender: \(playerEventSender), metrics: \(String(describing: metrics)), isDownloaded: \(isDownloaded), shouldPlayWhenLoaded: \(shouldPlayWhenLoaded), seekTimeWhenLoaded: \(String(describing: seekTimeWhenLoaded)), duration: \(String(describing: duration)), metadata: \(String(describing: metadata)), asset: \(String(describing: asset))"
	}
}

private extension PlayerItem {
	func obtainPlaybackContextBitDepthAndSampleRate(
		pbiMetadata: Metadata,
		playbackMetadata: AssetPlaybackMetadata?
	) -> (Int?, Int?) {
		// We will be using the backend data for now, same as the other platforms
		var bitDepth: Int? = pbiMetadata.audioBitDepth
		var sampleRate: Int? = pbiMetadata.audioSampleRate

		guard PlayerWorld.developmentFeatureFlagProvider.shouldReadAndVerifyPlaybackMetadata else {
			return (bitDepth, sampleRate)
		}

		if let metadataSampleRate = pbiMetadata.audioSampleRate,
		   let metadataBitDepth = pbiMetadata.audioBitDepth,
		   let playbackMetadata
		{
			// We have the data from both places to compare so we can assert on DEBUG to verify it's always the same.
			// With this info we can decide in the future if we should switch to the real data.
			assert(metadataBitDepth == playbackMetadata.bitDepth, "Bit-depth does not match!")
			assert(metadataSampleRate == playbackMetadata.sampleRate, "Sample rate does not match!")
		} else if let playbackMetadata {
			// This could happen in the cases were we are playing an offlined track without the metadata stored
			// or if the backend has not yet backfilled the data
			bitDepth = playbackMetadata.bitDepth
			sampleRate = playbackMetadata.sampleRate
		}

		return (bitDepth, sampleRate)
	}

	func emitStreamingMetrics() {
		let now = PlayerWorld.timeProvider.timestamp()

		defer {
			playerEventSender.send(StreamingSessionEnd(streamingSessionId: id, timestamp: now))
		}

		guard let metrics, let metadata else {
			return
		}

		let endTimestamp = metrics.endTime ?? now

		var tags = [PlaybackStatistics.EventTag]()
		if case .cached = asset?.getCacheState()?.status {
			tags.append(PlaybackStatistics.EventTag.CACHED)
		}
		if metadata.playbackSource == .LOCAL_STORAGE {
			tags.append(PlaybackStatistics.EventTag.OFFLINER_V2)
		}
		if featureFlagProvider.shouldUseImprovedDRMHandling() {
			tags.append(PlaybackStatistics.EventTag.IMPROVED_DRM)
		}
		if featureFlagProvider.shouldUseNewPlaybackEndpoints() {
			tags.append(PlaybackStatistics.EventTag.NEW_PLAYBACK_ENDPOINTS)
		}

		let endInfo = metrics.endInfo
		playerEventSender.send(PlaybackStatistics(
			streamingSessionId: id,
			idealStartTimestamp: metrics.idealStartTime,
			actualStartTimestamp: metrics.actualStartTime,
			productType: mediaProduct.productType.rawValue,
			actualProductId: metadata.productId,
			actualStreamType: metadata.streamType.rawValue,
			actualAssetPresentation: metadata.assetPresentation.rawValue,
			actualAudioMode: metadata.audioMode?.rawValue,
			actualQuality: mediaProduct.productType.quality(given: metadata),
			stalls: metrics.stalls,
			startReason: playbackStartReason,
			endReason: endInfo.reason.rawValue,
			endTimestamp: endTimestamp,
			tags: tags,
			errorMessage: endInfo.message,
			errorCode: endInfo.code
		))
	}

	func emitPlayLog() {
		let now = PlayerWorld.timeProvider.timestamp()
		guard let metrics,
		      let playbackContext,
		      let asset,
		      let actualStartTime = metrics.actualStartTime,
		      let startAssetPosition = metrics.startAssetPosition
		else {
			return
		}

		let endTimestamp = metrics.endTime ?? now
		let endAssetPosition = metrics.endAssetPosition ?? asset.getAssetPosition()

		playerEventSender.send(PlayLogEvent(
			playbackSessionId: id,
			startTimestamp: actualStartTime,
			startAssetPosition: startAssetPosition,
			isPostPaywall: true,
			productType: mediaProduct.productType,
			requestedProductId: mediaProduct.productId,
			actualProductId: playbackContext.productId,
			actualAssetPresentation: playbackContext.assetPresentation,
			actualAudioMode: playbackContext.audioMode,
			actualQuality: mediaProduct.productType.quality(given: playbackContext),
			sourceType: mediaProduct.playLogSource?.sourceType,
			sourceId: mediaProduct.playLogSource?.sourceId,
			actions: metrics.actions,
			endTimestamp: endTimestamp,
			endAssetPosition: endAssetPosition
		), extras: mediaProduct.extras)
	}

	func emitOfflinePlay() {
		guard let metrics,
		      metrics.actualStartTime != nil,
		      let metadata,
		      metadata.playbackSource.isOfflineSource(),
		      let playbackContext,
		      let productId = Int(playbackContext.productId),
		      let asset
		else {
			return
		}

		let endAssetPosition = metrics.endAssetPosition ?? asset.getAssetPosition()

		let now = PlayerWorld.timeProvider.timestamp()
		playerEventSender.send(
			OfflinePlay(
				id: productId,
				quality: mediaProduct.productType.quality(given: playbackContext),
				deliveredDuration: Float(endAssetPosition),
				playDate: now,
				productType: mediaProduct.productType,
				audioMode: playbackContext.audioMode,
				playbackSessionId: playbackContext.playbackSessionId
			)
		)
	}
}

// swiftlint:enable file_length
