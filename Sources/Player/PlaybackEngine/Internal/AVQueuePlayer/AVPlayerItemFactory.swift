import AVFoundation
import Foundation

enum AVPlayerItemFactory {
	static func createPlayerItem(_ asset: AVURLAsset) -> AVPlayerItem {
		let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: [#keyPath(AVAsset.duration)])
		playerItem.preferredForwardBufferDuration = 0
		playerItem.variantPreferences = .scalabilityToLosslessAudio
		playerItem.startsOnFirstEligibleVariant = true
		return playerItem
	}

	static func loadAsset(
		_ urlAsset: AVURLAsset,
		loudnessNormalizationConfiguration: LoudnessNormalizationConfiguration,
		contentKeySessionDelegate: AVContentKeySessionDelegate?,
		contentKeyDelegateQueue: DispatchQueue,
		player: GenericMediaPlayer
	) -> (asset: AVPlayerAsset, playerItem: AVPlayerItem) {
		let contentKeySession = contentKeySessionDelegate.map { delegate -> AVContentKeySession in
			let session = AVContentKeySession(keySystem: .fairPlayStreaming)
			session.setDelegate(delegate, queue: contentKeyDelegateQueue)
			session.addContentKeyRecipient(urlAsset)
			return session
		}

		let asset = AVPlayerAsset(
			with: player,
			loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
			contentKeySession,
			and: contentKeySessionDelegate
		)

		let playerItem = createPlayerItem(urlAsset)

		return (asset, playerItem)
	}
}
