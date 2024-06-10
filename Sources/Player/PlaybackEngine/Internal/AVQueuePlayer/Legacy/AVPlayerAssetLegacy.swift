import AVFoundation
import Foundation

// MARK: - AVPlayerAssetLegacy

class AVPlayerAssetLegacy: Asset {
	private let contentKeySession: AVContentKeySession?
	private let contentKeySessionDelegate: AVContentKeySessionDelegate?

	required init(
		with player: AVQueuePlayerWrapperLegacy,
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

// MARK: - LiveAVPlayerAssetLegacy

final class LiveAVPlayerAssetLegacy: AVPlayerAssetLegacy {
	required init(
		with player: AVQueuePlayerWrapperLegacy,
		loudnessNormalizationConfiguration: LoudnessNormalizationConfiguration,
		_ contentKeySession: AVContentKeySession?,
		and contentKeySessionDelegate: AVContentKeySessionDelegate?
	) {
		super.init(
			with: player,
			loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
			contentKeySession,
			and: contentKeySessionDelegate
		)
	}

	override func setAssetPosition(_ playerItem: AVPlayerItem) {
		if let date = playerItem.currentDate() {
			assetPosition = date.timeIntervalSince1970
		}
	}
}
