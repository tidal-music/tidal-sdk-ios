import AVFoundation
import Foundation

/// Monitors and handles whether an AVPlayerItem is completely downloaded.
final class CompletelyDownloadedMonitor {
	private var observation: NSKeyValueObservation?
	private var completelyDownloaded = false

	init(_ playerItem: AVPlayerItem, _ onFullyDownloaded: @escaping (AVPlayerItem) -> Void) {
		observation = playerItem.observe(\.loadedTimeRanges, options: []) { [weak self] playerItem, _ in
			guard let self else {
				return
			}

			let isCompletelyDownloaded = playerItemCompletelyDownloaded(playerItem)
			if completelyDownloaded != isCompletelyDownloaded {
				completelyDownloaded = isCompletelyDownloaded
				onFullyDownloaded(playerItem)
			}
		}
	}

	deinit {
		observation?.invalidate()
		observation = nil
	}

	func isCompletelyDownloaded() -> Bool {
		completelyDownloaded
	}

	private func playerItemCompletelyDownloaded(_ playerItem: AVPlayerItem) -> Bool {
		let lastLoadedTime = playerItem.loadedTimeRanges
			.map { $0.timeRangeValue }
			.map { CMTimeGetSeconds(CMTimeAdd($0.start, $0.duration)) }
			.max() ?? 0.0

		return lastLoadedTime >= CMTimeGetSeconds(playerItem.duration) * 0.98
	}
}
