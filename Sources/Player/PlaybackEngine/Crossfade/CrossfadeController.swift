import Foundation

// MARK: - CrossfadeController

/// Internal crossfade orchestrator owned by `Player`.
///
/// Monitors playback position and triggers crossfade transitions using AVAudioMix volume ramps.
/// The app only needs to set `Configuration.crossfadeDuration` — the SDK handles everything else.
///
/// Position-based completion (not wall-clock timers) ensures pause/resume works correctly,
/// since AVAudioMix ramps are tied to the media timeline.
final class CrossfadeController {
	// MARK: - State

	/// Whether a crossfade transition is currently in progress.
	private(set) var isCrossfading: Bool = false

	/// Handle for the preloaded next track, ready for crossfade.
	private var preloadedHandle: PlayerLoaderHandle?

	// MARK: - Internal

	/// Preloads the next track for crossfade. Called by `Player.setNext()` when crossfade is enabled.
	func preload(_ handle: PlayerLoaderHandle) {
		preloadedHandle?.cancel()
		preloadedHandle = handle
	}

	/// Clears any preloaded handle (e.g. when crossfade is disabled or next changes).
	func clearPreload() {
		preloadedHandle?.cancel()
		preloadedHandle = nil
	}

	/// Called periodically by `Player` with the current playback position.
	/// Checks if crossfade should start, and if an in-progress crossfade has completed.
	///
	/// - Parameters:
	///   - player: The Player instance (for calling beginCrossfade/completeCrossfade).
	///   - currentTime: Current playback position of the active track.
	///   - duration: Total duration of the active track.
	///   - crossfadeDuration: The configured crossfade duration.
	/// - Returns: `true` if a crossfade was just started (caller should notify listener).
	@discardableResult
	func update(
		player: Player,
		currentTime: TimeInterval,
		duration: TimeInterval,
		crossfadeDuration: TimeInterval
	) -> Bool {
		if isCrossfading {
			checkCompletion(player: player, currentTime: currentTime, crossfadeDuration: crossfadeDuration)
			return false
		} else {
			return checkStart(player: player, currentTime: currentTime, duration: duration, crossfadeDuration: crossfadeDuration)
		}
	}

	/// Immediately completes the crossfade (tears down outgoing engine).
	/// Called by `Player` on seek, reset, ended, or failed.
	func finishImmediately(player: Player) {
		guard isCrossfading else {
			return
		}
		isCrossfading = false
		player.completeCrossfade()
	}

	/// Cancels everything and resets state.
	func invalidate(player: Player) {
		finishImmediately(player: player)
		clearPreload()
	}

	// MARK: - Private

	/// - Returns: `true` if crossfade was started.
	private func checkStart(
		player: Player,
		currentTime: TimeInterval,
		duration: TimeInterval,
		crossfadeDuration: TimeInterval
	) -> Bool {
		guard duration > 0 else {
			return false
		}

		// Don't crossfade very short tracks (shorter than crossfade + 5s buffer)
		let minimumDuration = crossfadeDuration + 5.0
		guard duration >= minimumDuration else {
			return false
		}

		let crossfadeStartPoint = duration - crossfadeDuration
		guard currentTime >= crossfadeStartPoint else {
			return false
		}

		guard let handle = preloadedHandle, !handle.isCancelled else {
			return false
		}

		preloadedHandle = nil
		isCrossfading = true

		player.beginCrossfade(with: handle, duration: crossfadeDuration)
		return true
	}

	private func checkCompletion(
		player: Player,
		currentTime: TimeInterval,
		crossfadeDuration: TimeInterval
	) {
		// The incoming track's ramp started at time zero and lasts crossfadeDuration.
		// Once currentTime passes that, the ramp is done.
		guard currentTime >= crossfadeDuration else {
			return
		}

		isCrossfading = false
		player.completeCrossfade()
	}
}
