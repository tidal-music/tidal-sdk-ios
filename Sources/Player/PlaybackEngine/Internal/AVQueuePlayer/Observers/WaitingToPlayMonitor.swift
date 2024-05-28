import AVFoundation
import Foundation

/// Monitors and handles when AVPlayer is waiting to play
final class WaitingToPlayMonitor {
	private var observation: NSKeyValueObservation?

	init(_ player: AVPlayer, _ onWaitingtoPlay: @escaping (AVPlayerItem) -> Void) {
		observation = player.observe(\.timeControlStatus, options: []) { player, _ in
			if let playerItem = player.currentItem, player.timeControlStatus == .waitingToPlayAtSpecifiedRate {
				onWaitingtoPlay(playerItem)
			}
		}
	}
}
