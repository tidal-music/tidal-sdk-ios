import AVFoundation
import Foundation
import TidalAPI

final class StoreVideoHandler {
	private let offlineStore: OfflineStore
	private let artworkDownloader: ArtworkDownloaderProtocol
	private let mediaDownloader: MediaDownloaderProtocol
	private let manifestFetcher: VideoManifestFetcherProtocol
	private let licenseDownloader: LicenseDownloader

	init(
		offlineStore: OfflineStore,
		artworkDownloader: ArtworkDownloaderProtocol,
		mediaDownloader: MediaDownloaderProtocol,
		manifestFetcher: VideoManifestFetcherProtocol,
		licenseDownloader: LicenseDownloader
	) {
		self.offlineStore = offlineStore
		self.artworkDownloader = artworkDownloader
		self.mediaDownloader = mediaDownloader
		self.manifestFetcher = manifestFetcher
		self.licenseDownloader = licenseDownloader
	}

	func handle(_ task: StoreVideoTask) -> InternalTask {
		let title = task.video.attributes?.title ?? ""
		let artists = task.artists.compactMap(\.attributes?.name)
		let imageURL = task.artwork?.attributes?.files.first.flatMap { URL(string: $0.href) }
		return InternalVideoTask(
			task: task,
			download: Download(title: title, artists: artists, imageURL: imageURL),
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader,
			mediaDownloader: mediaDownloader,
			manifestFetcher: manifestFetcher,
			licenseDownloader: licenseDownloader
		)
	}
}

private final class InternalVideoTask: InternalTask {
	let id: String
	let download: Download?

	private let task: StoreVideoTask
	private let offlineStore: OfflineStore
	private let artworkDownloader: ArtworkDownloaderProtocol
	private let mediaDownloader: MediaDownloaderProtocol
	private let manifestFetcher: VideoManifestFetcherProtocol
	private let licenseDownloader: LicenseDownloader

	init(
		task: StoreVideoTask,
		download: Download,
		offlineStore: OfflineStore,
		artworkDownloader: ArtworkDownloaderProtocol,
		mediaDownloader: MediaDownloaderProtocol,
		manifestFetcher: VideoManifestFetcherProtocol,
		licenseDownloader: LicenseDownloader
	) {
		self.id = task.id
		self.task = task
		self.download = download
		self.offlineStore = offlineStore
		self.artworkDownloader = artworkDownloader
		self.mediaDownloader = mediaDownloader
		self.manifestFetcher = manifestFetcher
		self.licenseDownloader = licenseDownloader
	}

	func run() async throws {
		try await withFileCleanup { cleanup in
			async let artworkTask = artworkDownloader.downloadArtwork(for: task.artwork)
			async let manifestTask = manifestFetcher.fetchVideoManifest(videoId: task.video.id)

			let (artworkURL, manifest) = try await (artworkTask, manifestTask)
			cleanup.artworkLocation = artworkURL

			let licenseResult = try await licenseDownloader.downloadLicense(drmData: manifest.drmData)
			cleanup.licenseLocation = licenseResult?.licenseURL

			let mediaResult = try await mediaDownloader.download(
				manifestURL: manifest.manifestURL,
				licenseDownloadResult: licenseResult,
				title: "\(task.artists.compactMap { $0.attributes?.name }.joined(separator: ",")) - \(task.video.attributes?.title ?? "")",
				onProgress: { [weak self] progress in
					guard let download = self?.download else { return }
					await download.updateProgress(progress)
				}
			)
			cleanup.mediaLocation = mediaResult.mediaLocation

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
				licenseURL: licenseResult?.licenseURL,
				artworkURL: artworkURL
			)

			try offlineStore.storeMediaItem(storeResult)
		}
	}
}
