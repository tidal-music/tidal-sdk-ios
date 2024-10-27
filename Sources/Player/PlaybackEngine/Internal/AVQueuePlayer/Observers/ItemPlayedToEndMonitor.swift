import AVFoundation
import Foundation

final class ItemPlayedToEndMonitor {
	private let playerItem: AVPlayerItem
	private let onPlayedToEnd: (AVPlayerItem) -> Void

	init(playerItem: AVPlayerItem, onPlayedToEnd: @escaping (AVPlayerItem) -> Void) {
		self.playerItem = playerItem
		self.onPlayedToEnd = onPlayedToEnd

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(playerItemDidPlayToEndTime(notification:)),
			name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
			object: playerItem
		)
	}

	deinit {
		NotificationCenter.default.removeObserver(
			self,
			name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
			object: playerItem
		)
	}

	@objc
	private func playerItemDidPlayToEndTime(notification: Notification) {
		if let playerItem = notification.object as? AVPlayerItem {
			print("--> PlayerItemDidPlayToEndTimeMonitor.playerItemDidPlayToEndTime(notification: \(notification))")
			onPlayedToEnd(playerItem)
		}
	}
}
