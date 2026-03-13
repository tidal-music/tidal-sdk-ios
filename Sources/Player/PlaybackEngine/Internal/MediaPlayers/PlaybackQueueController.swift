import AVFoundation

// MARK: - PlayerMonitorCallbacks

struct PlayerMonitorCallbacks {
	let onIsPlaying: (AVPlayerItem) -> Void
	let onIsPaused: (AVPlayerItem) -> Void
	let onFailure: (AVPlayerItem, Error?) -> Void
	let onItemChanged: (AVPlayerItem) -> Void
	let onWaitingToPlay: (AVPlayerItem) -> Void
	let onPlaybackProgress: (AVPlayerItem) -> Void
}

// MARK: - PlayedToEndResult

struct PlayedToEndResult {
	static let notHandled = PlayedToEndResult(completed: false, shouldTriggerPlaying: false)

	/// Whether the controller handled the track transition (true for dual-player, false for queue-based).
	let completed: Bool
	/// Whether the wrapper should trigger a playing callback for the new active item.
	let shouldTriggerPlaying: Bool
}

// MARK: - PlaybackQueueController

/// Abstracts the player queue mechanism — either a single AVQueuePlayer or two alternating AVPlayers with crossfade.
/// The host wrapper delegates all player-lifecycle and queue-management operations to this protocol.
protocol PlaybackQueueController: AnyObject {
	var activePlayer: AVPlayer { get }
	var supportsVideo: Bool { get }
	var supportsUC: Bool { get }

	init()

	func play()
	func pause()
	func setVolume(_ volume: Float)

	/// Sets volume when entering the playing state.
	/// Implementations may skip this during crossfade to avoid overriding ramped volumes.
	func applyPlayingVolume(_ volume: Float)

	func enqueue(_ playerItem: AVPlayerItem)
	func removeItem(_ playerItem: AVPlayerItem)
	func advanceToNextItem()
	func removeAll()

	/// Whether the given player item is on the currently active player.
	/// Used by the wrapper to filter monitoring events (e.g. stalls) from inactive players.
	func isOnActivePlayer(_ playerItem: AVPlayerItem) -> Bool

	/// Called when a track plays to its natural end.
	/// The controller handles player-level cleanup (pause, nil current item, crossfade finish, switch active).
	/// Returns a result indicating whether the wrapper should notify delegates.
	func onPlayedToEnd(_ playerItem: AVPlayerItem) -> PlayedToEndResult

	/// Sets up player monitoring with callbacks to the wrapper.
	/// - Parameters:
	///   - callbacks: Monitoring event callbacks that the controller forwards (with optional filtering).
	///   - normalizedVolumeProvider: Closure that returns the loudness-normalized volume for a given player's current item.
	func setupMonitoring(callbacks: PlayerMonitorCallbacks, normalizedVolumeProvider: @escaping (AVPlayer) -> Float)

	/// Stops playback and releases monitors without recreating players.
	func teardown()

	/// Full reset: tears down, recreates players, and re-establishes monitoring.
	func reset()
}
