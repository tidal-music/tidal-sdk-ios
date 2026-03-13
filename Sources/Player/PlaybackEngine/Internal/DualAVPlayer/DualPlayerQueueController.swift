import AVFoundation

// MARK: - Constants

private enum Constants {
	static let defaultVolume: Float = 1
	static let crossfadeDuration: Double = 5
}

// MARK: - Crossfader

/// Manages crossfade state between two AVPlayer instances.
/// A new instance is created each time the active player switches.
private final class Crossfader {
	let activePlayer: AVPlayer
	let otherPlayer: AVPlayer

	private var isFading = false
	private var fadeTrackDuration: Double = 0

	/// Provides the loudness-normalized volume for a given player.
	private let normalizedVolumeProvider: (AVPlayer) -> Float

	var isCrossfading: Bool { isFading }

	init(
		activePlayer: AVPlayer,
		otherPlayer: AVPlayer,
		normalizedVolumeProvider: @escaping (AVPlayer) -> Float
	) {
		self.activePlayer = activePlayer
		self.otherPlayer = otherPlayer
		self.normalizedVolumeProvider = normalizedVolumeProvider
	}

	/// Called every playback progress tick on the active player.
	/// Starts the other player and ramps volumes when within the crossfade zone.
	func update(position: Double, duration: Double) {
		let crossfadeStart = duration - Constants.crossfadeDuration
		guard position >= crossfadeStart else {
			return
		}

		if !isFading {
			guard otherPlayer.currentItem != nil else {
				return
			}

			isFading = true
			fadeTrackDuration = duration
			otherPlayer.volume = 0
			otherPlayer.play()
		}

		let elapsed = position - (fadeTrackDuration - Constants.crossfadeDuration)
		let progress = min(Float(elapsed / Constants.crossfadeDuration), 1.0)

		let activeVolume = normalizedVolumeProvider(activePlayer)
		let otherVolume = normalizedVolumeProvider(otherPlayer)

		activePlayer.volume = activeVolume * (1.0 - progress)
		otherPlayer.volume = otherVolume * progress
	}

	/// Called when the active track ends naturally. Restores volume on the new active player.
	func finish() {
		isFading = false
		fadeTrackDuration = 0
		activePlayer.volume = normalizedVolumeProvider(activePlayer)
	}

	/// Called when crossfade should be aborted (e.g. unload, reset, seek).
	func cancel() {
		isFading = false
		fadeTrackDuration = 0
		otherPlayer.pause()
		otherPlayer.volume = 0
		activePlayer.volume = normalizedVolumeProvider(activePlayer)
	}

	func play() {
		activePlayer.play()
		if isFading {
			otherPlayer.play()
		}
	}

	func pause() {
		activePlayer.pause()
		if isFading {
			otherPlayer.pause()
		}
	}
}

// MARK: - DualPlayerQueueController

final class DualPlayerQueueController: PlaybackQueueController {
	private var playerA: AVPlayer
	private var playerB: AVPlayer
	private var playerMonitorA: AVPlayerMonitor?
	private var playerMonitorB: AVPlayerMonitor?

	private let playbackTimeProgressQueueA = DispatchQueue(label: "com.tidal.player.dual.playbacktimeprogress.a.queue")
	private let playbackTimeProgressQueueB = DispatchQueue(label: "com.tidal.player.dual.playbacktimeprogress.b.queue")

	private var crossfader: Crossfader!
	private var playerItemOwners: [AVPlayerItem: AVPlayer] = [:]
	private var storedCallbacks: PlayerMonitorCallbacks?
	private var storedVolumeProvider: ((AVPlayer) -> Float)?

	var activePlayer: AVPlayer { crossfader.activePlayer }
	var supportsVideo: Bool { false }
	var supportsUC: Bool { false }

	init() {
		playerA = DualPlayerQueueController.createPlayer()
		playerB = DualPlayerQueueController.createPlayer()
		crossfader = makeCrossfader(activePlayer: playerA, otherPlayer: playerB)
	}

	func play() {
		crossfader.play()
	}

	func pause() {
		crossfader.pause()
	}

	func setVolume(_ volume: Float) {
		crossfader.activePlayer.volume = volume
	}

	func applyPlayingVolume(_ volume: Float) {
		if !crossfader.isCrossfading {
			crossfader.activePlayer.volume = volume
		}
	}

	func enqueue(_ playerItem: AVPlayerItem) {
		guard playerItemOwners[playerItem] == nil else {
			return
		}
		let targetPlayer = targetPlayerForLoad()
		playerItemOwners[playerItem] = targetPlayer
		targetPlayer.replaceCurrentItem(with: playerItem)
	}

	func removeItem(_ playerItem: AVPlayerItem) {
		let owner = playerItemOwners.removeValue(forKey: playerItem)
		if owner?.currentItem == playerItem {
			owner?.replaceCurrentItem(with: nil)
		}
	}

	func advanceToNextItem() {
		crossfader.cancel()
		if let (_, nextOwner) = playerItemOwners.first {
			switchActivePlayer(to: nextOwner)
		}
	}

	func removeAll() {
		crossfader.cancel()
		playerItemOwners.removeAll()
		playerA.pause()
		playerA.replaceCurrentItem(with: nil)
		playerB.pause()
		playerB.replaceCurrentItem(with: nil)
	}

	func isOnActivePlayer(_ playerItem: AVPlayerItem) -> Bool {
		playerItemOwners[playerItem] === crossfader.activePlayer
	}

	func onPlayedToEnd(_ playerItem: AVPlayerItem) -> PlayedToEndResult {
		let owner = playerItemOwners[playerItem]
		owner?.pause()

		playerItemOwners.removeValue(forKey: playerItem)
		owner?.replaceCurrentItem(with: nil)

		let wasCrossfading = crossfader.isCrossfading
		crossfader.finish()

		guard owner === crossfader.activePlayer else {
			return .notHandled
		}

		if let (_, nextOwner) = playerItemOwners.first {
			switchActivePlayer(to: nextOwner)
		}

		return PlayedToEndResult(completed: true, shouldTriggerPlaying: !wasCrossfading)
	}

	func setupMonitoring(callbacks: PlayerMonitorCallbacks, normalizedVolumeProvider: @escaping (AVPlayer) -> Float) {
		storedCallbacks = callbacks
		storedVolumeProvider = normalizedVolumeProvider
		setupPlayerMonitor(playerA, queue: playbackTimeProgressQueueA, callbacks: callbacks)
		setupPlayerMonitor(playerB, queue: playbackTimeProgressQueueB, callbacks: callbacks)
	}

	func teardown() {
		crossfader.cancel()
		playerMonitorA = nil
		playerMonitorB = nil
		playerItemOwners.removeAll()
		playerA.pause()
		playerA.replaceCurrentItem(with: nil)
		playerB.pause()
		playerB.replaceCurrentItem(with: nil)
	}

	func reset() {
		teardown()
		playerA = DualPlayerQueueController.createPlayer()
		playerB = DualPlayerQueueController.createPlayer()
		crossfader = makeCrossfader(activePlayer: playerA, otherPlayer: playerB)
		if let callbacks = storedCallbacks, let volumeProvider = storedVolumeProvider {
			setupMonitoring(callbacks: callbacks, normalizedVolumeProvider: volumeProvider)
		}
	}
}

// MARK: - Private

private extension DualPlayerQueueController {
	static func createPlayer() -> AVPlayer {
		let player = AVPlayer()
		player.automaticallyWaitsToMinimizeStalling = true
		player.actionAtItemEnd = .none
		player.allowsExternalPlayback = false
		return player
	}

	func targetPlayerForLoad() -> AVPlayer {
		if crossfader.activePlayer.currentItem == nil {
			return crossfader.activePlayer
		}
		return crossfader.otherPlayer
	}

	func makeCrossfader(activePlayer: AVPlayer, otherPlayer: AVPlayer) -> Crossfader {
		Crossfader(activePlayer: activePlayer, otherPlayer: otherPlayer) { [weak self] player in
			self?.storedVolumeProvider?(player) ?? Constants.defaultVolume
		}
	}

	func switchActivePlayer(to newActive: AVPlayer) {
		let newOther = newActive === playerA ? playerB : playerA
		crossfader = makeCrossfader(activePlayer: newActive, otherPlayer: newOther)
	}

	func setupPlayerMonitor(_ player: AVPlayer, queue: DispatchQueue, callbacks: PlayerMonitorCallbacks) {
		let monitor = AVPlayerMonitor(
			player,
			queue,
			onIsPlaying: { [weak self] item in
				guard let self, self.isOnActivePlayer(item) else { return }
				callbacks.onIsPlaying(item)
			},
			onIsPaused: { [weak self] item in
				guard let self, self.isOnActivePlayer(item) else { return }
				callbacks.onIsPaused(item)
			},
			onFailure: callbacks.onFailure,
			onItemChanged: { _ in },
			onWaitingToPlay: { [weak self] item in
				guard let self, self.isOnActivePlayer(item) else { return }
				callbacks.onWaitingToPlay(item)
			},
			onPlaybackProgress: { [weak self] item in
				callbacks.onPlaybackProgress(item)

				guard let self, self.isOnActivePlayer(item) else { return }

				let position = CMTimeGetSeconds(item.currentTime())
				let duration = CMTimeGetSeconds(item.duration)
				guard duration.isFinite, duration > Constants.crossfadeDuration else { return }

				self.crossfader.update(position: position, duration: duration)
			}
		)

		if player === playerA {
			playerMonitorA = monitor
		} else {
			playerMonitorB = monitor
		}
	}
}
