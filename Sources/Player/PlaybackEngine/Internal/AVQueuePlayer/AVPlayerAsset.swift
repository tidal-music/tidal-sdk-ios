import AVFoundation
import Foundation

// MARK: - AVPlayerAsset

class AVPlayerAsset: Asset {
	private let contentKeySession: AVContentKeySession?
	private let contentKeySessionDelegate: AVContentKeySessionDelegate?

	required init(
		with player: AVQueuePlayerWrapper,
		loudnessNormalizationConfiguration: LoudnessNormalizationConfiguration,
		_ contentKeySession: AVContentKeySession?,
		and contentKeySessionDelegate: AVContentKeySessionDelegate?
	) {
		self.contentKeySession = contentKeySession
		self.contentKeySessionDelegate = contentKeySessionDelegate
		super.init(with: player, loudnessNormalizationConfiguration: loudnessNormalizationConfiguration)
	}

	func setAssetPosition(_ playerItem: AVPlayerItem) {
		assetPosition = CMTimeGetSeconds(playerItem.currentTime())
	}
}

