import Foundation
import MediaPlayer

extension AVPlayer {
	func seek(to position: Double) async -> Bool {
		await withCheckedContinuation { continuation in
			guard let currentItem else {
				continuation.resume(returning: false)
				return
			}

			seek(to: CMTime(seconds: min(position, currentItem.duration.seconds), preferredTimescale: 1000)) { finished in
				continuation.resume(returning: finished)
			}
		}
	}
}
