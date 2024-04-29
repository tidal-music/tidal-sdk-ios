import AVFoundation
import Foundation

/// Monitors and handles when an AVPlayers currentItem changes. Can be used to detect whether playback is completed.
final class ItemChangedMonitor {
	private var observation: NSKeyValueObservation?

	init(_ player: AVPlayer, _ onCurrentItemChange: @escaping (AVPlayerItem) -> Void) {
		observation = player.observe(\.currentItem, options: [.old]) { _, change in
			guard let oldValue = change.oldValue, let old = oldValue else {
				return
			}

			onCurrentItemChange(old)
		}
	}
}
