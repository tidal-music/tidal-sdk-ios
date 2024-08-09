import AVFoundation
import Foundation

final class PlaybackTimeProgressMonitor {
	private static let INTERVAL = CMTimeMakeWithSeconds(PlaybackTimeProgressMonitorConstants.timeInterval, preferredTimescale: 1000)

	private let player: AVPlayer
	private let onPlaybackProgress: (AVPlayerItem) -> Void
	private var observer: Any?

	init(_ player: AVPlayer, _ queue: DispatchQueue, _ onPlaybackProgress: @escaping (AVPlayerItem) -> Void) {
		self.player = player
		self.onPlaybackProgress = onPlaybackProgress

		observer = player
			.addPeriodicTimeObserver(forInterval: PlaybackTimeProgressMonitor.INTERVAL, queue: queue) { [weak self] _ in
				guard let self, let item = self.player.currentItem else {
					return
				}

				onPlaybackProgress(item)
			}
	}

	deinit {
		if let observer {
			player.removeTimeObserver(observer)
		}
	}
}
