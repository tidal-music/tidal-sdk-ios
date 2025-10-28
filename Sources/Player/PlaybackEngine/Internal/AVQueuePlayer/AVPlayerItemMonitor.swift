import AVFoundation
import Foundation

final class AVPlayerItemMonitor {
	private let playerItem: AVPlayerItem
	private let failureMonitor: FailureMonitor
	private let failedToPlayToEndMonitor: FailedToPlayToEndMonitor
	private let stallMonitor: StallMonitor
	private let completelyDownloadedMonitor: CompletelyDownloadedMonitor
	private let readyToPlayMonitor: ReadyToPlayMonitor
	private let playerItemDidPlayToEndTimeMonitor: ItemPlayedToEndMonitor
	private var abrMonitor: AVPlayerItemABRMonitor?

	init(
		_ playerItem: AVPlayerItem,
		queue: OperationQueue,
		adaptiveQualities: [AudioQuality]?,
		onFailure: @escaping (AVPlayerItem, Error?) -> Void,
		onStall: @escaping (AVPlayerItem) -> Void,
		onCompletelyDownloaded: @escaping (AVPlayerItem) -> Void,
		onReadyToPlayToPlay: @escaping (AVPlayerItem) -> Void,
		onItemPlayedToEnd: @escaping (AVPlayerItem) -> Void,
		onAudioQualityChanged: ((AVPlayerItem, AudioQuality) -> Void)?
	) {
		self.playerItem = playerItem
		failureMonitor = FailureMonitor(playerItem, onFailure)
		failedToPlayToEndMonitor = FailedToPlayToEndMonitor(playerItem, onFailure)
		stallMonitor = StallMonitor(playerItem, onStall)
		completelyDownloadedMonitor = CompletelyDownloadedMonitor(playerItem, onCompletelyDownloaded)
		readyToPlayMonitor = ReadyToPlayMonitor(playerItem, onReadyToPlayToPlay)
		playerItemDidPlayToEndTimeMonitor = ItemPlayedToEndMonitor(playerItem: playerItem, onPlayedToEnd: onItemPlayedToEnd)

		if let onAudioQualityChanged {
			abrMonitor = AVPlayerItemABRMonitor(
				playerItem: playerItem,
				queue: queue,
				onQualityChanged: { [weak self] newQuality in
					guard let self else {
						return
					}
					onAudioQualityChanged(self.playerItem, newQuality)
				}
			)
		}
	}

	func isCompletelyDownloaded() -> Bool {
		completelyDownloadedMonitor.isCompletelyDownloaded()
	}
}
