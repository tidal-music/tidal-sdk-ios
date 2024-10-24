import AVFoundation
import Foundation

// MARK: - PlayerItemLoader

final class PlayerItemLoader {
	private let offlineStorage: OfflineStorage?
	private let playbackInfoFetcher: PlaybackInfoFetcher
	private var playerLoader: PlayerLoader

	init(
		with offlineStorage: OfflineStorage?,
		_ playbackInfoFetcher: PlaybackInfoFetcher,
		and playerLoader: PlayerLoader
	) {
		self.offlineStorage = offlineStorage
		self.playbackInfoFetcher = playbackInfoFetcher
		self.playerLoader = playerLoader
	}

	func load(_ playerItem: PlayerItem) async throws {
		let (metadata, asset) = try await load(playerItem.mediaProduct, with: playerItem.id)

		playerItem.set(metadata)
		playerItem.set(asset)
	}

	func unload() {
		playerLoader.unload()
	}

	func reset() {
		playerLoader.reset()
	}

	func renderVideo(in view: AVPlayerLayer) {
		playerLoader.renderVideo(in: view)
	}
}

private extension PlayerItemLoader {
	func load(_ mediaProduct: MediaProduct, with streamingSessionId: String) async throws -> (Metadata, Asset) {
		if let storedMediaProduct = mediaProduct as? StoredMediaProduct {
			return try await (metadata(of: storedMediaProduct), playerLoader.load(storedMediaProduct))
		}

		if let offlineEntry = try? offlineStorage?.get(key: mediaProduct.productId),
		   let offlinedMediaProduct = PlayableOfflinedMediaProduct(from: offlineEntry)
		{
			return try await (metadata(of: offlinedMediaProduct), playerLoader.load(offlinedMediaProduct))
		}

		let playbackInfo = try await playbackInfoFetcher.getPlaybackInfo(
			streamingSessionId: streamingSessionId,
			mediaProduct: mediaProduct,
			playbackMode: .STREAM
		)

		return try await (metadata(of: playbackInfo), playerLoader.load(playbackInfo, streamingSessionId: streamingSessionId))
	}
}

private extension PlayerItemLoader {
	func metadata(of playableStorageMediaProduct: PlayableOfflinedMediaProduct) -> Metadata {
		Metadata(
			productId: playableStorageMediaProduct.actualProductId,
			streamType: .ON_DEMAND,
			assetPresentation: playableStorageMediaProduct.assetPresentation,
			audioMode: playableStorageMediaProduct.audioMode,
			audioQuality: playableStorageMediaProduct.audioQuality,
			audioCodec: playableStorageMediaProduct.audioCodec,
			audioSampleRate: playableStorageMediaProduct.audioSampleRate,
			audioBitDepth: playableStorageMediaProduct.audioBitDepth,
			videoQuality: playableStorageMediaProduct.videoQuality,
			playbackSource: .LOCAL_STORAGE
		)
	}

	func metadata(of storedMediaProduct: StoredMediaProduct) -> Metadata {
		Metadata(
			productId: storedMediaProduct.productId,
			streamType: .ON_DEMAND,
			assetPresentation: storedMediaProduct.assetPresentation,
			audioMode: storedMediaProduct.audioMode,
			audioQuality: storedMediaProduct.audioQuality,
			audioCodec: storedMediaProduct.audioCodec,
			audioSampleRate: storedMediaProduct.audioSampleRate,
			audioBitDepth: storedMediaProduct.audioBitDepth,
			videoQuality: storedMediaProduct.videoQuality,
			playbackSource: .LOCAL_STORAGE_LEGACY
		)
	}

	func metadata(of playbackInfo: PlaybackInfo) -> Metadata {
		Metadata(
			productId: playbackInfo.productId,
			streamType: playbackInfo.streamType,
			assetPresentation: playbackInfo.assetPresentation,
			audioMode: playbackInfo.audioMode,
			audioQuality: playbackInfo.audioQuality,
			audioCodec: playbackInfo.audioCodec,
			audioSampleRate: playbackInfo.audioSampleRate,
			audioBitDepth: playbackInfo.audioBitDepth,
			videoQuality: playbackInfo.videoQuality,
			playbackSource: .INTERNET
		)
	}
}
