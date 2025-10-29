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
		adaptiveQualities: [AudioQuality]?,
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

		// MARK: Debug-Only Monitoring
		// AVPlayerItemABRMonitor is only active when running in Xcode debug mode.
		// This provides bitrate-based quality detection for debugging ABR behavior.
		// Quality monitoring for production is handled by FormatVariantMonitor using HLS timed metadata.
		#if DEBUG
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
		#endif

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
