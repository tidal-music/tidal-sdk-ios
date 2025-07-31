import AVFoundation
import Foundation

/// Monitors and handles whether an AVPlayer's timeControlStatus is 'paused'.
final class IsPausedMonitor {
	private var observation: NSKeyValueObservation?

	init(_ player: AVPlayer, _ onStatusIsPaused: @escaping (AVPlayerItem) -> Void) {
		observation = player.observe(\.timeControlStatus, options: []) { player, _ in
			if player.timeControlStatus == .paused, let playerItem = player.currentItem {
				onStatusIsPaused(playerItem)
			}
		}
	}
	
	deinit {
		observation?.invalidate()
		observation = nil
	}
}
