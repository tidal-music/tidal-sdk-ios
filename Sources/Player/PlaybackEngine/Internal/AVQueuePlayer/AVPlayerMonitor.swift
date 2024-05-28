import AVFoundation
import Foundation

final class AVPlayerMonitor {
	private let isPlayingMonitor: IsPlayingMonitor
	private let isPausedMonitor: IsPausedMonitor
	private let failureMonitor: FailureMonitor
	private let itemChangedMonitor: ItemChangedMonitor
	private let waitingToPlayMonitor: WaitingToPlayMonitor
	private let playbackTimeProgressMonitor: PlaybackTimeProgressMonitor

	init(
		_ player: AVPlayer,
		_ queue: DispatchQueue,
		onIsPlaying: @escaping (AVPlayerItem) -> Void,
		onIsPaused: @escaping (AVPlayerItem) -> Void,
		onFailure: @escaping (AVPlayerItem, Error?) -> Void,
		onItemChanged: @escaping (AVPlayerItem) -> Void,
		onWaitingToPlay: @escaping (AVPlayerItem) -> Void,
		onPlaybackProgress: @escaping (AVPlayerItem) -> Void
	) {
		isPlayingMonitor = IsPlayingMonitor(player, onIsPlaying)
		isPausedMonitor = IsPausedMonitor(player, onIsPaused)
		failureMonitor = FailureMonitor(player, onFailure)
		itemChangedMonitor = ItemChangedMonitor(player, onItemChanged)
		waitingToPlayMonitor = WaitingToPlayMonitor(player, onWaitingToPlay)
		playbackTimeProgressMonitor = PlaybackTimeProgressMonitor(player, queue, onPlaybackProgress)
	}
}
