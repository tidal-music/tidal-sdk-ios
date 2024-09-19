import Auth
import AVFoundation
import Foundation

// swiftlint:disable file_length

// MARK: - PlayerEngine

final class PlayerEngine {
	private let queue: OperationQueue
	private let playbackInfoFetcher: PlaybackInfoFetcher
	private let fairplayLicenseFetcher: FairPlayLicenseFetcher
	private let djModeProducer: DJProducer
	private let featureFlagProvider: FeatureFlagProvider

	/// Configuration used in ``PlaybackInfoFetcher`` and for loudness normalization.
	private var configuration: Configuration {
		// After receiving a new value, we need to update the loudness normalization of the current and next items.
		didSet {
			updateLoudnessNormalizationMode(configuration.loudnessNormalizationMode)
		}
	}

	private let networkMonitor: NetworkMonitor
	private let playerEventSender: PlayerEventSender
	private let playerItemLoader: PlayerItemLoader

	@Atomic var notificationsHandler: NotificationsHandler?

	@Atomic private var state: InternalState {
		didSet {
			guard state != oldValue else {
				return
			}

			if state.publicState != oldValue.publicState {
				notificationsHandler?.stateChanged(to: state.publicState)
			}

			guard let currentItem else {
				return
			}

			if state == .PAUSED {
				djModeProducer.pause(currentItem.mediaProduct)
				return
			}

			if state == .PLAYING, oldValue == .PAUSED || oldValue == .STALLED {
				djModeProducer.play(currentItem.mediaProduct, at: currentItem.assetPosition)
				return
			}
		}
	}

	@Atomic private(set) var currentItem: PlayerItem? {
		didSet {
			if let oldValue, !shouldSendEventsInDeinit, oldValue.id != currentItem?.id {
				oldValue.emitEvents()
			}

			notificationsHandler?.mediaTransitioned(to: currentItem)

			guard let currentItem, currentItem.metadata != nil else {
				return
			}

			djModeProducer.play(currentItem.mediaProduct, at: 0)
		}
	}

	@Atomic private(set) var nextItem: PlayerItem? {
		didSet {
			if let oldValue, !shouldSendEventsInDeinit {
				// If previous next item is same as current item, it means we will send metrics later on, so don't send it now.
				guard oldValue.id != currentItem?.id else {
					return
				}

				// For the next item, we will only send StreamingSessionStart (from init) and StreamingSessionEnd (from sending
				// streaming metrics) since the others are related to playing and this item has not been played (just in memory
				// for optimization reasons).
				oldValue.emitEvents()
			}
		}
	}

	@Atomic private var currentError: Error?
	@Atomic private var nextError: Error?

	/// Flag whether we should emit events on the deinit of the current and next items.
	private var shouldSendEventsInDeinit: Bool {
		featureFlagProvider.shouldSendEventsInDeinit()
	}

	#if !os(macOS)
		private var audioSessionInterruptionMonitor: AudioSessionInterruptionMonitor!
		private var audioSessionRouteChangeMonitor: AudioSessionRouteChangeMonitor!
		// swiftlint:disable:next identifier_name
		private var audioSessionMediaServicesWereResetMonitor: AudioSessionMediaServicesWereResetMonitor!
	#endif

	init(
		with queue: OperationQueue,
		_ httpClient: HttpClient,
		_ credentialsProvider: CredentialsProvider,
		_ fairplayLicenseFetcher: FairPlayLicenseFetcher,
		_ djProducer: DJProducer,
		_ configuration: Configuration,
		_ playerEventSender: PlayerEventSender,
		_ networkMonitor: NetworkMonitor,
		_ offlineStorage: OfflineStorage?,
		_ offlinePlaybackPrivilegeCheck: (() -> Bool)?,
		_ playerLoader: PlayerLoader,
		_ featureFlagProvider: FeatureFlagProvider,
		_ notificationsHandler: NotificationsHandler?
	) {
		self.queue = queue
		playbackInfoFetcher = PlaybackInfoFetcher(
			with: configuration,
			httpClient,
			credentialsProvider,
			networkMonitor,
			and: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)
		self.fairplayLicenseFetcher = fairplayLicenseFetcher
		djModeProducer = djProducer
		self.configuration = configuration
		self.networkMonitor = networkMonitor
		self.playerEventSender = playerEventSender
		self.notificationsHandler = notificationsHandler
		self.featureFlagProvider = featureFlagProvider

		playerItemLoader = PlayerItemLoader(
			with: offlineStorage,
			offlinePlaybackPrivilegeCheck,
			playbackInfoFetcher,
			and: playerLoader
		)

		state = .IDLE
		currentItem = nil
		nextItem = nil
		nextError = nil

		#if !os(macOS)
			audioSessionInterruptionMonitor = AudioSessionInterruptionMonitor(self)
			audioSessionRouteChangeMonitor = AudioSessionRouteChangeMonitor(self, configuration: configuration)
			audioSessionMediaServicesWereResetMonitor = AudioSessionMediaServicesWereResetMonitor(playerEngine: self)
		#endif
	}

	func startDjSession(title: String, timestamp: UInt64) {
		queue.dispatch {
			if let currentItem = self.currentItem {
				self.djModeProducer.start(title, with: currentItem.mediaProduct, at: currentItem.assetPosition)
				currentItem.play(timestamp: timestamp)
			}
		}
	}

	func stopDjSession(immediately: Bool = true) {
		queue.dispatch {
			self.djModeProducer.stop(immediately: immediately)
		}
	}

	func load(_ mediaProduct: MediaProduct, timestamp: UInt64, isPreload: Bool = false) {
		queue.dispatch {
			self.state = .NOT_PLAYING
			self.currentItem = PlayerItem(
				startReason: .EXPLICIT,
				mediaProduct: mediaProduct,
				networkType: self.networkMonitor.getNetworkType(),
				outputDevice: PlayerWorld.audioInfoProvider.currentOutputPortName(),
				sessionType: .PLAYBACK,
				playerItemMonitor: self,
				playerEventSender: self.playerEventSender,
				timestamp: timestamp,
				featureFlagProvider: self.featureFlagProvider,
				isPreload: isPreload
			)

			if let currentItem = self.currentItem {
				await self.load(currentItem)
			}
		}
	}

	func skipToNext(timestamp: UInt64) {
		queue.dispatch {
			guard let playerItem = self.nextItem else {
				return
			}
			self.currentItem?.unloadFromPlayer()

			// The order is important due to logic for emitting events in didSet of the items.
			self.currentItem = playerItem
			self.nextItem = nil

			// When we preload it, we set startReason to .IMPLICIT.
			// So when user explicitly skips to next, we should make sure the startReason is set correctly to .EXPLICIT.
			// In that case, the StreamingSessionStart emitted will be .IMPLICIT, while PlaybackStatistics, .EXPLICIT.
			playerItem.updatePlaybackStartReason(to: .EXPLICIT)

			if playerItem.isLoaded, self.nextError == nil {
				// We will immediately start playing, so no need to change the state.
				// However, some players can work differently than AVPlayer and might need to change state between transitions.
				if let currentPlayer = self.currentPlayer(), currentPlayer.shouldSwitchStateOnSkipToNext {
					self.state = .STALLED
				}

				playerItem.play(timestamp: timestamp)
				return
			}

			if let error = self.nextError, !error.isNetworkError() {
				self.handle(error, in: playerItem)
				return
			}

			self.state = .STALLED
			self.nextError = nil
			await self.load(playerItem)

			playerItem.play(timestamp: timestamp)
		}
	}

	func setNext(_ mediaProduct: MediaProduct?, timestamp: UInt64) {
		queue.dispatch {
			guard self.state != .IDLE else {
				return
			}

			if self.featureFlagProvider.shouldUseImprovedCaching() {
				guard self.nextItem?.mediaProduct != mediaProduct else {
					return
				}
			}

			self.nextItem?.unload()
			self.nextItem = nil

			guard let mediaProduct else {
				return
			}

			self.nextItem = PlayerItem(
				startReason: .IMPLICIT,
				mediaProduct: mediaProduct,
				networkType: self.networkMonitor.getNetworkType(),
				outputDevice: PlayerWorld.audioInfoProvider.currentOutputPortName(),
				sessionType: .PLAYBACK,
				playerItemMonitor: self,
				playerEventSender: self.playerEventSender,
				timestamp: timestamp,
				featureFlagProvider: self.featureFlagProvider
			)

			if let currentItem = self.currentItem, currentItem.isCompletelyDownloaded {
				await self.load(self.nextItem!)
			}
		}
	}

	func resetOrUnload() {
		if featureFlagProvider.shouldUseImprovedCaching() {
			unload()
		} else {
			reset()
		}
	}

	/// The Player SDK creates new PlayerEngine instances when starting a new explicit playback.
	/// This means it discards the previous instance, which won't be reused.
	/// Which allows us to optimize how we clean up as it won't be reused (no need to queue up the clean operation)
	func unload() {
		cancellAllNetworkRequests()
		queue.cancelAllOperations()

		currentItem = nil
		nextItem = nil
		nextError = nil

		playerItemLoader.unload()
		state = .IDLE
	}

	/// The Player SDK creates new PlayerEngine instances when starting a new explicit playback.
	/// In theory, this should allows us to never need to reuse an instance.
	/// But that requires a bit more changes, so until then, when the client calls reset,
	/// we still need to call reset to the active instance. which cleans up synchronously to avoid thread issues.
	func reset() {
		// Unload and nullify the current item so that it immediately stops playing.
		currentItem?.unloadFromPlayer()
		currentItem = nil

		cancellAllNetworkRequests()
		queue.cancelAllOperations()
		queue.dispatch {
			self.reset(to: .IDLE)
		}
	}

	func play(timestamp: UInt64) {
		queue.dispatch {
			if let error = self.currentError, let currentItem = self.currentItem {
				self.currentError = nil
				self.handle(error, in: currentItem)
				return
			}

			if let currentItem = self.currentItem {
				currentItem.play(timestamp: timestamp)
			}
		}
	}

	func pause() {
		currentItem?.pause()
	}

	func seek(_ time: Double) {
		currentItem?.seek(to: time)
	}

	func getAssetPosition() -> Double? {
		currentItem?.assetPosition
	}

	func getActiveMediaProduct() -> MediaProduct? {
		currentItem?.mediaProduct
	}

	func getActivePlaybackContext() -> PlaybackContext? {
		currentItem?.playbackContext
	}

	func getState() -> State {
		state.publicState
	}

	func renderVideo(in view: AVPlayerLayer) {
		playerItemLoader.renderVideo(in: view)
	}

	func isLive() -> Bool {
		djModeProducer.isLive
	}

	func currentPlayer() -> GenericMediaPlayer? {
		currentItem?.asset?.player
	}

	func mediaServicesWereReset() {
		// When media services are reset, Apple recommends to reinitialize the app's audio objects, which is out case is the player,
		// and which is performed directly by the SDK. It's also recommended to reset the audio session’s category, options, and mode
		// configuration. This is performed below.
		self.reset()

		// Then we should also set it up again the audio session as done initially. Since this is done outside the SDK, we delegate it
		// to the notification handler to do it.
		notificationsHandler?.mediaServicesWereReset()
	}
}

// MARK: PlayerItemMonitor

extension PlayerEngine: PlayerItemMonitor {
	func loaded(playerItem: PlayerItem) {
		queue.dispatch {
			guard playerItem === self.currentItem else {
				return
			}

			// We need to perform this so didSet is called and the notification handler notifies the listener.
			self.currentItem = self.currentItem
		}
	}

	func playing(playerItem: PlayerItem) {
		queue.dispatch {
			guard playerItem === self.currentItem else {
				return
			}

			self.state = .PLAYING
		}
	}

	func paused(playerItem: PlayerItem) {
		queue.dispatch {
			guard playerItem === self.currentItem else {
				return
			}

			self.state = .PAUSED
		}
	}

	func stalled(playerItem: PlayerItem) {
		queue.dispatch {
			guard playerItem === self.currentItem else {
				return
			}

			self.state = .STALLED
		}
	}

	func completed(playerItem: PlayerItem) {
		queue.dispatch {
			guard playerItem === self.currentItem else {
				return
			}

			self.notificationsHandler?.ended(playerItem)

			// The order is important due to logic for emitting events in didSet of the items.
			self.currentItem = self.nextItem
			self.nextItem = nil

			guard let item = self.currentItem else {
				self.reset(to: .IDLE)
				return
			}

			if item.isLoaded, self.nextError == nil {
				let now = PlayerWorld.timeProvider.timestamp()
				item.play(timestamp: now)
				return
			}

			if let error = self.nextError, !error.isNetworkError() {
				self.handle(error, in: item)
				return
			}

			self.state = .STALLED
			self.nextError = nil
			await self.load(item)

			let now = PlayerWorld.timeProvider.timestamp()
			item.play(timestamp: now)
		}
	}

	func downloaded(playerItem: PlayerItem) {
		queue.dispatch {
			if playerItem === self.currentItem, let nextItem = self.nextItem {
				await self.load(nextItem)
			}
		}
	}

	func failed(playerItem: PlayerItem, with error: Error) {
		queue.dispatch {
			self.handle(error, in: playerItem)
		}
	}

	func djSessionTransition(playerItem: PlayerItem, transition: DJSessionTransition) {
		queue.dispatch {
			if playerItem === self.currentItem {
				self.notificationsHandler?.djSessionTransitioned(to: transition)
			}
		}
	}

	func playbackMetadataLoaded(playerItem: PlayerItem) {
		queue.dispatch {
			if playerItem === self.currentItem {
				if let sampleRate = playerItem.playbackContext?.audioSampleRate {
					#if os(iOS) || os(tvOS)
						// Should we only do it for AVPlayer items? (external player is already doing it internally)
						try? AVAudioSession.sharedInstance().setPreferredSampleRate(Double(sampleRate))
					#endif
				}
			}
		}
	}
}

// MARK: StreamingPrivilegesHandlerDelegate

extension PlayerEngine: StreamingPrivilegesHandlerDelegate {
	func streamingPrivilegesLost(to clientName: String?) {
		queue.dispatch {
			guard self.state == .PLAYING || self.state == .STALLED, let currentItem = self.currentItem else {
				return
			}

			self.notificationsHandler?.streamingPrivilegesLost(to: clientName)
			currentItem.pause()
		}
	}
}

// MARK: DJProducerListener

extension PlayerEngine: DJProducerListener {
	func djSessionStarted(metadata: DJSessionMetadata) {
		notificationsHandler?.djSessionStarted(with: metadata)
	}

	func djSessionEnded(reason: DJSessionEndReason) {
		notificationsHandler?.djSessionEnded(with: reason)
	}
}

private extension PlayerEngine {
	func cancellAllNetworkRequests() {
		// 1. The FairPlayLicenseFetcher is shared with all the players, so they can reuse the certificate
		// It uses a different HTTPClient, but shares the underlying urlSession for TLS optimizations
		// We can't currently cancel license requests because we don´t identify requests by player inside the HTTPClient.

		// 2. The djModeProducer is shared with all the players
		// We can't currently cancel its requests because we don´t identify requests by player inside the HTTPClient.

		playbackInfoFetcher.cancellNetworkRequests()
	}

	func reset(to state: InternalState) {
		currentItem = nil
		currentError = nil
		nextItem?.unload()
		nextItem = nil
		nextError = nil
		playerItemLoader.reset()
		self.state = state
	}

	func load(_ playerItem: PlayerItem) async {
		guard !playerItem.isLoaded else {
			return
		}

		do {
			try await playerItemLoader.load(playerItem)
		} catch {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.loadPlayerItemFailed(error: error))
			handle(error, in: playerItem)
		}
	}

	func handle(_ error: Error, in playerItem: PlayerItem) {
		guard let notificationsHandler else {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.handleErrorNoNotificationsHandler)
			currentError = error
			return
		}

		if error is CancellationError {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.handleErrorCancellation)
			return
		}

		if playerItem === currentItem {
			if error is StreamingPrivilegesLostError {
				streamingPrivilegesLost(to: nil)
				return
			}

			notificationsHandler.failed(with: PlayerInternalError.from(error).toPlayerError())
			reset(to: .NOT_PLAYING)

			djModeProducer.reset(error)

			return
		} else {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.handleErrorPlayerItemNotCurrent)
		}

		if playerItem === nextItem {
			nextError = error
			return
		} else {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.handleErrorPlayerItemNotNext)
		}
	}
}

// MARK: - Loudness normalization

extension PlayerEngine {
	func updateConfiguration(_ configuration: Configuration) {
		self.configuration = configuration
	}

	/// Updates the loudness normalization mode of current and next items. This allows for immediate change after the
	/// user changes the loudness normalization settings of current item and next item (which might already be loaded).
	func updateLoudnessNormalizationMode(_ loudnessNormalizationMode: LoudnessNormalizationMode) {
		let preAmpValue = configuration.currentPreAmpValue

		currentItem?.asset?.setLoudnessNormalizationMode(loudnessNormalizationMode)
		currentItem?.asset?.updatePreAmp(preAmpValue)
		currentItem?.asset?.updateVolume()

		// For the next item, no need to update the volume, because it will only change
		// the volume of the player, which should be for the current item being played,
		// and irrelevant for the next item.
		nextItem?.asset?.setLoudnessNormalizationMode(loudnessNormalizationMode)
		nextItem?.asset?.updatePreAmp(preAmpValue)
	}
}

// swiftlint:enable file_length
