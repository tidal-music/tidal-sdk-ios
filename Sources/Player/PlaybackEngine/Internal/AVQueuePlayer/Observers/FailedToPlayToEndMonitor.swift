import AVFoundation
import Foundation

final class FailedToPlayToEndMonitor {
	private let playerItem: AVPlayerItem
	private let onFailed: (AVPlayerItem, Error?) -> Void

	init(_ playerItem: AVPlayerItem, _ onFailed: @escaping (AVPlayerItem, Error?) -> Void) {
		self.playerItem = playerItem
		self.onFailed = onFailed

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(FailedToPlayToEndMonitor.failure),
			name: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime,
			object: playerItem
		)
	}

	deinit {
		NotificationCenter.default.removeObserver(
			self,
			name: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime,
			object: playerItem
		)
	}

	@objc private func failure(notification: Notification) {
		let error = notification.userInfo?["AVPlayerItemFailedToPlayToEndTimeErrorKey"] as? Error
		onFailed(playerItem, error)
	}
}
