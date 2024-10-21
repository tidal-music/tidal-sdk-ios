#if !os(macOS)
	import AVFoundation
	import Foundation

// swiftlint:disable:next type_name
final class AudioSessionMediaServicesWereResetMonitor {
	private weak var playerEngine: PlayerEngine?
	private weak var audioSession: AVAudioSession?

	init(playerEngine: PlayerEngine) {
		self.playerEngine = playerEngine
		audioSession = AVAudioSession.sharedInstance()

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(handleMediaServicesWereLost),
			name: AVAudioSession.mediaServicesWereLostNotification,
			object: audioSession
		)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(handleMediaServicesWereReset),
			name: AVAudioSession.mediaServicesWereResetNotification,
			object: audioSession
		)
	}

	deinit {
		NotificationCenter.default.removeObserver(
			self,
			name: AVAudioSession.mediaServicesWereLostNotification,
			object: audioSession
		)

		NotificationCenter.default.removeObserver(
			self,
			name: AVAudioSession.mediaServicesWereResetNotification,
			object: audioSession
		)
	}
}

private extension AudioSessionMediaServicesWereResetMonitor {

	@objc
	func handleMediaServicesWereLost(notification: Notification) {
		PlayerWorld.logger?.log(loggable: PlayerLoggable.handleMediaServicesWereReset)
	}

	@objc
	func handleMediaServicesWereReset(notification: Notification) {
		PlayerWorld.logger?.log(loggable: PlayerLoggable.handleMediaServicesWereReset)

		self.playerEngine?.resetPlayerAndSetUpAudioSessionAfterMediaServiceWereReset()
	}
}
#endif
