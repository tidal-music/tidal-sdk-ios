import AVFoundation
import Foundation

/// Monitors and handles if failures occur in an AVPlayerItem or AVPlayer.
final class FailureMonitor {
	private let observation: NSKeyValueObservation

	init(_ playerItem: AVPlayerItem, _ onFailure: @escaping (AVPlayerItem, Error?) -> Void) {
		observation = playerItem.observe(\.status, options: []) { playerItem, _ in
			if playerItem.status == .failed {
				onFailure(playerItem, playerItem.error)
			}
		}
	}

	init(_ player: AVPlayer, _ onFailure: @escaping (AVPlayerItem, Error?) -> Void) {
		observation = player.observe(\.status, options: []) { player, _ in
			if player.status == .failed, let playerItem = player.currentItem {
				onFailure(playerItem, playerItem.error)
			}
		}
	}
}
