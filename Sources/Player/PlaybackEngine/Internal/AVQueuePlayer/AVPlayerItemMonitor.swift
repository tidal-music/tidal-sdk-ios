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
	private var formatVariantMonitor: FormatVariantMonitor?

	init(
		_ playerItem: AVPlayerItem,
		queue: OperationQueue,
		onFailure: @escaping (AVPlayerItem, Error?) -> Void,
		onStall: @escaping (AVPlayerItem) -> Void,
		onCompletelyDownloaded: @escaping (AVPlayerItem) -> Void,
		onReadyToPlayToPlay: @escaping (AVPlayerItem) -> Void,
		onItemPlayedToEnd: @escaping (AVPlayerItem) -> Void,
		onAudioQualityChanged: @escaping (AVPlayerItem, AudioQuality) -> Void,
		onFormatVariantChanged: @escaping (AVPlayerItem, FormatVariantMetadata) -> Void
	) {
		self.playerItem = playerItem
		failureMonitor = FailureMonitor(playerItem, onFailure)
		failedToPlayToEndMonitor = FailedToPlayToEndMonitor(playerItem, onFailure)
		stallMonitor = StallMonitor(playerItem, onStall)
		completelyDownloadedMonitor = CompletelyDownloadedMonitor(playerItem, onCompletelyDownloaded)
		readyToPlayMonitor = ReadyToPlayMonitor(playerItem, onReadyToPlayToPlay)
		playerItemDidPlayToEndTimeMonitor = ItemPlayedToEndMonitor(playerItem: playerItem, onPlayedToEnd: onItemPlayedToEnd)

		abrMonitor = AVPlayerItemABRMonitor(
			playerItem: playerItem,
			queue: queue
		) { [weak self] newQuality in
			guard let self else {
				return
			}
			onAudioQualityChanged(self.playerItem, newQuality)
		}

		formatVariantMonitor = FormatVariantMonitor(
			playerItem: playerItem,
			queue: queue
		) { [weak self] formatMetadata in
			guard let self else {
				return
			}
			onFormatVariantChanged(self.playerItem, formatMetadata)
		}
	}

	func isCompletelyDownloaded() -> Bool {
		completelyDownloadedMonitor.isCompletelyDownloaded()
	}
}
