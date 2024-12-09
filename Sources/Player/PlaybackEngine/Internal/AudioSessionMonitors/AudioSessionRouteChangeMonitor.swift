#if !os(macOS)
	import AVFoundation
	import Foundation

	/// Handles changes to the audio route, essentially pausing playback if an audio route becomes unavailable. This happens
	/// when e.g. bluetooth headphones are disconnected.
	final class AudioSessionRouteChangeMonitor {
		private weak var playerEngine: PlayerEngine?
		private var configuration: Configuration?
		private weak var audioSession: AVAudioSession?

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
				playerEngine?.pause()
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
