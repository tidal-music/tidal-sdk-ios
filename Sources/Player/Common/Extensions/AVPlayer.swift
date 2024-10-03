import Foundation
import MediaPlayer

// MARK: - Constants

private enum Constants {
	static let allowedSeekTolerance: Double = 0.1
}

extension AVPlayer {
	func seek(to position: Double) async -> Bool {
		await withCheckedContinuation { continuation in
			guard let currentItem else {
				continuation.resume(returning: false)
				PlayerWorld.logger?.log(loggable: PlayerLoggable.avplayerSeekWithoutCurrentItem)
				return
			}

			let timeToSeek = CMTime(seconds: min(position, currentItem.duration.seconds), preferredTimescale: 1000)

			seek(to: timeToSeek) { finished in
				// Adding a small delay before checking currentTime()
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
					let currentTime = self.currentTime()
					let timeDifference = CMTimeGetSeconds(currentTime) - CMTimeGetSeconds(timeToSeek)

					if abs(timeDifference) < Constants.allowedSeekTolerance {
						continuation.resume(returning: finished)
					} else {
						continuation.resume(returning: false)
					}
				}
			}
		}
	}
}
