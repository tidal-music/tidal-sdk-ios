import AVFoundation
import Foundation

/// Monitors and handles when an AVPlayerItem is ready to be played.
final class ReadyToPlayMonitor {
	private let observation: NSKeyValueObservation

	init(_ playerItem: AVPlayerItem, _ onDurationReady: @escaping (AVPlayerItem) -> Void) {
		observation = playerItem.observe(\.status, options: []) { playerItem, _ in
			if playerItem.status == .readyToPlay {
				onDurationReady(playerItem)
			}
		}
	}
}
