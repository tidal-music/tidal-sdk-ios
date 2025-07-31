import AVFoundation
import Foundation

/// Monitors and handles whether an AVPlayer's timeControlStatus is 'playing'.
final class IsPlayingMonitor {
	private var observation: NSKeyValueObservation?

	init(_ player: AVPlayer, _ onStatusIsPlaying: @escaping (AVPlayerItem) -> Void) {
		observation = player.observe(\.timeControlStatus, options: []) { player, _ in
			if player.timeControlStatus == .playing, let playerItem = player.currentItem {
				onStatusIsPlaying(playerItem)
			}
		}
	}
	
	deinit {
		observation?.invalidate()
		observation = nil
	}
}
