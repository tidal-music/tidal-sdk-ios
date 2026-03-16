import AVFoundation
import Foundation
import TidalAPI

final class StoreTrackHandler {
	private let offlineStore: OfflineStore
	private let artworkDownloader: ArtworkDownloaderProtocol
	private let mediaDownloader: MediaDownloaderProtocol
	private let manifestFetcher: TrackManifestFetcherProtocol

	init(
		offlineStore: OfflineStore,
		artworkDownloader: ArtworkDownloaderProtocol,
		mediaDownloader: MediaDownloaderProtocol,
		manifestFetcher: TrackManifestFetcherProtocol
	) {
		self.offlineStore = offlineStore
		self.artworkDownloader = artworkDownloader
		self.mediaDownloader = mediaDownloader
		self.manifestFetcher = manifestFetcher
	}

	func handle(_ task: StoreTrackTask) -> InternalTask {
		let title = task.track.attributes?.title ?? ""
		let artists = task.artists.compactMap(\.attributes?.name)
		let imageURL = task.artwork?.attributes?.files.first.flatMap { URL(string: $0.href) }
		return InternalTrackTask(
			task: task,
			download: Download(title: title, artists: artists, imageURL: imageURL),
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader,
			mediaDownloader: mediaDownloader,
			manifestFetcher: manifestFetcher
		)
	}
}

private final class InternalTrackTask: InternalTask {
	let id: String
	let download: Download?

	private let task: StoreTrackTask
	private let offlineStore: OfflineStore
	private let artworkDownloader: ArtworkDownloaderProtocol
	private let mediaDownloader: MediaDownloaderProtocol
	private let manifestFetcher: TrackManifestFetcherProtocol

	init(
		task: StoreTrackTask,
		download: Download,
		offlineStore: OfflineStore,
		artworkDownloader: ArtworkDownloaderProtocol,
		mediaDownloader: MediaDownloaderProtocol,
		manifestFetcher: TrackManifestFetcherProtocol
	) {
		self.id = task.id
		self.task = task
		self.download = download
		self.offlineStore = offlineStore
		self.artworkDownloader = artworkDownloader
		self.mediaDownloader = mediaDownloader
		self.manifestFetcher = manifestFetcher
	}

	func run() async throws {
		async let artworkTask = artworkDownloader.downloadArtwork(for: task.artwork)
		async let manifestTask = manifestFetcher.fetchTrackManifest(trackId: task.track.id)

		let (artworkURL, manifest) = try await (artworkTask, manifestTask)

		let mediaResult = try await mediaDownloader.download(
			manifestURL: manifest.manifestURL,
			contentKeySession: manifest.contentKeySession,
			title: "\(task.artists.compactMap {$0.attributes?.name}.joined(separator: ",")) - \(task.track.attributes?.title ?? "")",
			onProgress: { [weak self] progress in
				guard let download = self?.download else { return }
				await download.updateProgress(progress)
			}
		)

		let catalogMetadata = OfflineMediaItem.Metadata.track(OfflineMediaItem.TrackMetadata(
			id: task.track.id,
			title: task.track.attributes?.title ?? "",
			artists: task.artists.compactMap(\.attributes?.name),
			duration: mediaResult.duration,
			explicit: task.track.attributes?.explicit ?? false
		))

		let storeResult = StoreItemTaskResult(
			resourceType: OfflineMediaItemType.tracks.rawValue,
			resourceId: task.track.id,
			catalogMetadata: catalogMetadata,
			playbackMetadata: manifest.playbackMetadata,
			collectionResourceType: task.collectionResourceType,
			collectionResourceId: task.collectionResourceId,
			volume: task.volume,
			position: task.position,
			mediaURL: mediaResult.mediaLocation,
			licenseURL: mediaResult.licenseLocation,
			artworkURL: artworkURL
		)

		try offlineStore.storeMediaItem(storeResult)
	}
}
