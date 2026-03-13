import AVFoundation

final class SingleQueueController: PlaybackQueueController {
	private var player: AVQueuePlayer
	private var playerMonitor: AVPlayerMonitor?
	private let playbackTimeProgressQueue = DispatchQueue(label: "com.tidal.player.playbacktimeprogress.queue")
	private var storedCallbacks: PlayerMonitorCallbacks?

	var activePlayer: AVPlayer { player }
	var supportsVideo: Bool { true }
	var supportsUC: Bool { true }

	init() {
		player = SingleQueueController.createPlayer()
	}

	func play() {
		if player.items().isEmpty {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.playWithoutQueuedItems)
		}
		player.play()
	}

	func pause() {
		player.pause()
	}

	func setVolume(_ volume: Float) {
		player.volume = volume
	}

	func applyPlayingVolume(_ volume: Float) {
		player.volume = volume
	}

	func enqueue(_ playerItem: AVPlayerItem) {
		if player.canInsert(playerItem, after: nil) {
			player.insert(playerItem, after: nil)
		}
	}

	func removeItem(_ playerItem: AVPlayerItem) {
		if !player.canInsert(playerItem, after: nil) {
			player.remove(playerItem)
		}
	}

	func advanceToNextItem() {
		player.advanceToNextItem()
	}

	func removeAll() {
		player.pause()
		player.removeAllItems()
	}

	func isOnActivePlayer(_ playerItem: AVPlayerItem) -> Bool {
		true
	}

	func onPlayedToEnd(_ playerItem: AVPlayerItem) -> PlayedToEndResult {
		.notHandled
	}

	func setupMonitoring(callbacks: PlayerMonitorCallbacks, normalizedVolumeProvider: @escaping (AVPlayer) -> Float) {
		storedCallbacks = callbacks
		playerMonitor = AVPlayerMonitor(
			player,
			playbackTimeProgressQueue,
			onIsPlaying: callbacks.onIsPlaying,
			onIsPaused: callbacks.onIsPaused,
			onFailure: callbacks.onFailure,
			onItemChanged: callbacks.onItemChanged,
			onWaitingToPlay: callbacks.onWaitingToPlay,
			onPlaybackProgress: callbacks.onPlaybackProgress
		)
	}

	func teardown() {
		playerMonitor = nil
	}

	func reset() {
		playerMonitor = nil
		player.pause()
		player.removeAllItems()
		player = SingleQueueController.createPlayer()
		if let callbacks = storedCallbacks {
			setupMonitoring(callbacks: callbacks, normalizedVolumeProvider: { _ in 1.0 })
		}
	}
}

private extension SingleQueueController {
	static func createPlayer() -> AVQueuePlayer {
		let player = AVQueuePlayer()
		player.automaticallyWaitsToMinimizeStalling = true
		player.actionAtItemEnd = .advance
		player.allowsExternalPlayback = false
		return player
	}
}
