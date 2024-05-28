#if !os(macOS)
	import AVFoundation
	import Foundation

	/// Monitors and handles audio interruptions sent by the operating system. The operating system may suspend playback if it
	/// deems that something more important needs to use the audio output, for instance phone calls.
	final class AudioSessionInterruptionMonitor {
		private weak var playerEngine: PlayerEngine?
		private weak var audioSession: AVAudioSession?
		private var wasPlayingWhenInterrupted: Bool

		init(_ playerEngine: PlayerEngine) {
			self.playerEngine = playerEngine
			audioSession = AVAudioSession.sharedInstance()
			wasPlayingWhenInterrupted = false

			NotificationCenter.default.addObserver(
				self,
				selector: #selector(handle),
				name: AVAudioSession.interruptionNotification,
				object: audioSession
			)
		}

		deinit {
			NotificationCenter.default.removeObserver(
				self,
				name: AVAudioSession.interruptionNotification,
				object: audioSession
			)
		}

		@objc private func handle(notification: Notification) {
			guard let userInfo = notification.userInfo,
			      let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
			      let type = AVAudioSession.InterruptionType(rawValue: typeValue)
			else {
				return
			}

			switch type {
			case .began:
				wasPlayingWhenInterrupted = playerEngine?.getState() == .PLAYING
				playerEngine?.pause()
			case .ended:
				guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else {
					return
				}

				let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
				guard options.contains(.shouldResume) else {
					return
				}

				// wasPlayingWhenInterrupted is always false for AVQueuePlayer, shouldResume is enough.
				// Use wasPlayingWhenInterrupted only for external Players that need it in order to handle interruptions correctly.
				if let currentPlayer = playerEngine?.currentPlayer(), currentPlayer.shouldVerifyItWasPlayingBeforeInterruption {
					if wasPlayingWhenInterrupted {
						playerEngine?.play(timestamp: PlayerWorld.timeProvider.timestamp())
					}
				} else {
					playerEngine?.play(timestamp: PlayerWorld.timeProvider.timestamp())
				}

			default: ()
			}
		}
	}
#endif
