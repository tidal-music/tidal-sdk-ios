import AVFoundation
import Foundation
import TidalAPI

final class StoreVideoHandler {
	private let offlineApiClient: OfflineApiClientProtocol
	private let offlineStore: OfflineStore
	private let artworkDownloader: ArtworkDownloaderProtocol
	private let mediaDownloader: MediaDownloaderProtocol
	private let manifestFetcher: VideoManifestFetcherProtocol

	init(
		offlineApiClient: OfflineApiClientProtocol,
		offlineStore: OfflineStore,
		artworkDownloader: ArtworkDownloaderProtocol,
		mediaDownloader: MediaDownloaderProtocol,
		manifestFetcher: VideoManifestFetcherProtocol
	) {
		self.offlineApiClient = offlineApiClient
		self.offlineStore = offlineStore
		self.artworkDownloader = artworkDownloader
		self.mediaDownloader = mediaDownloader
		self.manifestFetcher = manifestFetcher
	}

	func handle(_ task: StoreVideoTask) -> InternalTask {
		let title = task.video.attributes?.title ?? ""
		let artists = task.artists.compactMap(\.attributes?.name)
		let imageURL = task.artwork?.attributes?.files.first.flatMap { URL(string: $0.href) }
		return InternalVideoTask(
			task: task,
			download: Download(title: title, artists: artists, imageURL: imageURL),
			offlineApiClient: offlineApiClient,
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader,
			mediaDownloader: mediaDownloader,
			manifestFetcher: manifestFetcher
		)
	}
}

private final class InternalVideoTask: InternalTask {
	let id: String
	let download: Download?

	private let task: StoreVideoTask
	private let offlineApiClient: OfflineApiClientProtocol
	private let offlineStore: OfflineStore
	private let artworkDownloader: ArtworkDownloaderProtocol
	private let mediaDownloader: MediaDownloaderProtocol
	private let manifestFetcher: VideoManifestFetcherProtocol

	private var mediaDownload: Download { download! }

	init(
		task: StoreVideoTask,
		download: Download,
		offlineApiClient: OfflineApiClientProtocol,
		offlineStore: OfflineStore,
		artworkDownloader: ArtworkDownloaderProtocol,
		mediaDownloader: MediaDownloaderProtocol,
		manifestFetcher: VideoManifestFetcherProtocol
	) {
		self.id = task.id
		self.task = task
		self.download = download
		self.offlineApiClient = offlineApiClient
		self.offlineStore = offlineStore
		self.artworkDownloader = artworkDownloader
		self.mediaDownloader = mediaDownloader
		self.manifestFetcher = manifestFetcher
	}

	func run() async {
		do {
			try await offlineApiClient.updateTask(taskId: id, state: .inProgress)
			await mediaDownload.updateState(.inProgress)
		} catch {
			print("StoreVideoHandler error: \(error)")
			await mediaDownload.updateState(.failed)
			return
		}

		do {
			let artworkURL = try await artworkDownloader.downloadArtwork(for: task.artwork)

			let manifest = try await manifestFetcher.fetchVideoManifest(videoId: task.video.id)

			let mediaResult = try await mediaDownloader.download(
				manifestURL: manifest.manifestURL,
				contentKeySession: manifest.contentKeySession,
				title: task.video.attributes?.title ?? "",
				onProgress: { [weak self] progress in
					guard let download = self?.download else { return }
					await download.updateProgress(progress)
				}
			)

			let catalogMetadata = OfflineMediaItem.Metadata.video(OfflineMediaItem.VideoMetadata(
				id: task.video.id,
				title: task.video.attributes?.title ?? "",
				artists: task.artists.compactMap(\.attributes?.name),
				duration: mediaResult.duration,
				explicit: task.video.attributes?.explicit ?? false
			))

			let storeResult = StoreItemTaskResult(
				resourceType: OfflineMediaItemType.videos.rawValue,
				resourceId: task.video.id,
				catalogMetadata: catalogMetadata,
				playbackMetadata: nil,
				collectionResourceType: task.collectionResourceType,
				collectionResourceId: task.collectionResourceId,
				volume: task.volume,
				position: task.position,
				mediaURL: mediaResult.mediaLocation,
				licenseURL: mediaResult.licenseLocation,
				artworkURL: artworkURL
			)

			try offlineStore.storeMediaItem(storeResult)

			try await offlineApiClient.updateTask(taskId: id, state: .completed)
			await mediaDownload.updateState(.completed)
		} catch {
			print("StoreVideoHandler error: \(error)")
			try? await offlineApiClient.updateTask(taskId: id, state: .failed)
			await mediaDownload.updateState(.failed)
		}
	}
}
