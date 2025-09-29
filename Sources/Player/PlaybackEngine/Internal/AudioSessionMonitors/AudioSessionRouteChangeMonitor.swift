#if !os(macOS)
	import AVFoundation
	import Foundation

	/// Handles changes to the audio route, essentially pausing playback if an audio route becomes unavailable. This happens
	/// when e.g. bluetooth headphones are disconnected.
final class AudioSessionRouteChangeMonitor {
    private weak var playerEngine: PlayerEngine?
    private var configuration: Configuration?
    private weak var audioSession: AVAudioSession?

    // Track short-lived Bluetooth dropouts to auto-resume playback when possible.
    private var wasPlayingBeforeRouteLoss: Bool = false
    // Timestamp in ms (wall-clock via TimeProvider)
    private var lastRouteLossAt: UInt64?
    private let autoResumeWindowSeconds: TimeInterval = 10 // Only auto-resume if BT returns quickly

		init(_ playerEngine: PlayerEngine, configuration: Configuration) {
			self.playerEngine = playerEngine
			self.configuration = configuration
			audioSession = AVAudioSession.sharedInstance()

			NotificationCenter.default.addObserver(
				self,
				selector: #selector(handle),
				name: AVAudioSession.routeChangeNotification,
				object: audioSession
			)
		}

    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: AVAudioSession.routeChangeNotification,
            object: audioSession
        )
    }

    @objc private func handle(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue)
        else {
            PlayerWorld.logger?.log(loggable: PlayerLoggable.changeMonitorHandleNotificationWithoutRequiredData)
            return
        }

        switch reason {
        case .oldDeviceUnavailable:
            // Pause on device loss and remember if we were playing on BT to auto-resume shortly after.
            wasPlayingBeforeRouteLoss = playerEngine?.getState() == .PLAYING && isBluetoothOutputActive(in: audioSession)
            lastRouteLossAt = PlayerWorld.timeProvider.timestamp()
            playerEngine?.pause()
        case .newDeviceAvailable, .categoryChange, .override, .wakeFromSleep:
            // If we recently lost a BT route while playing, and BT is back quickly, resume playback.
            if shouldAttemptAutoResume() && isBluetoothOutputActive(in: audioSession) {
                wasPlayingBeforeRouteLoss = false
                lastRouteLossAt = nil
                playerEngine?.play(timestamp: PlayerWorld.timeProvider.timestamp())
            }
        default: ()
            PlayerWorld.logger?
                .log(loggable: PlayerLoggable.changeMonitorHandleNotificationDefaultReason(reason: String(describing: reason)))
        }

        updateVolume()
    }

		private func updateVolume() {
			// We need to update the volume when transitioning from/to an Airplay route
			// due to having different pre amp values for the loudness normalization calculation
			guard let playerItem = playerEngine?.currentItem,
			      let asset = playerItem.asset,
			      let configuration
			else {
				PlayerWorld.logger?.log(loggable: PlayerLoggable.changeMonitorUpdateVolumeWithoutRequiredData)
				return
			}

			let preAmpValue = configuration.currentPreAmpValue
			asset.updatePreAmp(preAmpValue)
			asset.updateVolume()
    }
}
#endif

private extension AudioSessionRouteChangeMonitor {
    func isBluetoothOutputActive(in session: AVAudioSession?) -> Bool {
        guard let session else { return false }
        let outputs = session.currentRoute.outputs
        return outputs.contains { output in
            output.portType == .bluetoothA2DP ||
            output.portType == .bluetoothLE ||
            output.portType == .bluetoothHFP
        }
    }

    func shouldAttemptAutoResume() -> Bool {
        guard wasPlayingBeforeRouteLoss, let lostAt = lastRouteLossAt else { return false }
        // Use TimeProvider (NTP-backed wall clock) to compute an interval.
        let now = PlayerWorld.timeProvider.timestamp()
        let elapsedMs = now &- lostAt
        return elapsedMs <= UInt64(autoResumeWindowSeconds * 1000)
    }
}
