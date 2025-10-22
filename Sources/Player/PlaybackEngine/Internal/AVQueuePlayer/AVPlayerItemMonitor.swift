import AVFoundation
import Foundation

final class AVPlayerItemMonitor {
	private let failureMonitor: FailureMonitor
	private let failedToPlayToEndMonitor: FailedToPlayToEndMonitor
	private let stallMonitor: StallMonitor
	private let completelyDownloadedMonitor: CompletelyDownloadedMonitor
	private let readyToPlayMonitor: ReadyToPlayMonitor
	private let playerItemDidPlayToEndTimeMonitor: ItemPlayedToEndMonitor

	init(
		_ playerItem: AVPlayerItem,
		onFailure: @escaping (AVPlayerItem, Error?) -> Void,
		onStall: @escaping (AVPlayerItem) -> Void,
		onCompletelyDownloaded: @escaping (AVPlayerItem) -> Void,
		onReadyToPlayToPlay: @escaping (AVPlayerItem) -> Void,
		onItemPlayedToEnd: @escaping (AVPlayerItem) -> Void
	) {
		failureMonitor = FailureMonitor(playerItem, onFailure)
		failedToPlayToEndMonitor = FailedToPlayToEndMonitor(playerItem, onFailure)
		stallMonitor = StallMonitor(playerItem, onStall)
		completelyDownloadedMonitor = CompletelyDownloadedMonitor(playerItem, onCompletelyDownloaded)
		readyToPlayMonitor = ReadyToPlayMonitor(playerItem, onReadyToPlayToPlay)
		playerItemDidPlayToEndTimeMonitor = ItemPlayedToEndMonitor(playerItem: playerItem, onPlayedToEnd: onItemPlayedToEnd)
	}

	func isCompletelyDownloaded() -> Bool {
		completelyDownloadedMonitor.isCompletelyDownloaded()
	}
}
