import AVFoundation
import Foundation

/// Monitors and handles when a stall occur.
final class StallMonitor {
	private let onStall: (AVPlayerItem) -> Void

	init(_ playerItem: AVPlayerItem, _ onStall: @escaping (AVPlayerItem) -> Void) {
		self.onStall = onStall

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(StallMonitor.stalled),
			name: NSNotification.Name.AVPlayerItemPlaybackStalled,
			object: playerItem
		)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	@objc private func stalled(notification: Notification) {
		if let playerItem = notification.object as? AVPlayerItem {
			onStall(playerItem)
		}
	}
}
