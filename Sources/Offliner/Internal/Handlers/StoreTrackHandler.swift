import AVFoundation
import Foundation
import TidalAPI

final class StoreTrackHandler {
	private let offlineStore: OfflineStore
	private let artworkDownloader: ArtworkDownloaderProtocol
	private let mediaDownloader: MediaDownloaderProtocol
	private let manifestFetcher: TrackManifestFetcherProtocol
	private let licenseDownloader: LicenseDownloader

	init(
		offlineStore: OfflineStore,
		artworkDownloader: ArtworkDownloaderProtocol,
		mediaDownloader: MediaDownloaderProtocol,
		manifestFetcher: TrackManifestFetcherProtocol,
		licenseDownloader: LicenseDownloader
	) {
		self.offlineStore = offlineStore
		self.artworkDownloader = artworkDownloader
		self.mediaDownloader = mediaDownloader
		self.manifestFetcher = manifestFetcher
		self.licenseDownloader = licenseDownloader
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
			manifestFetcher: manifestFetcher,
			licenseDownloader: licenseDownloader
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
	private let licenseDownloader: LicenseDownloader

	init(
		task: StoreTrackTask,
		download: Download,
		offlineStore: OfflineStore,
		artworkDownloader: ArtworkDownloaderProtocol,
		mediaDownloader: MediaDownloaderProtocol,
		manifestFetcher: TrackManifestFetcherProtocol,
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
			async let manifestTask = manifestFetcher.fetchTrackManifest(trackId: task.track.id)

			let (artworkURL, manifest) = try await (artworkTask, manifestTask)
			cleanup.artworkLocation = artworkURL

			let licenseResult = try await licenseDownloader.downloadLicense(drmData: manifest.drmData)
			cleanup.licenseLocation = licenseResult?.licenseURL

			let mediaResult = try await mediaDownloader.download(
				manifestURL: manifest.manifestURL,
				licenseDownloadResult: licenseResult,
				title: "\(task.artists.compactMap { $0.attributes?.name }.joined(separator: ",")) - \(task.track.attributes?.title ?? "")",
				onProgress: { [weak self] progress in
					guard let download = self?.download else { return }
					await download.updateProgress(progress)
				}
			)
			cleanup.mediaLocation = mediaResult.mediaLocation

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
				licenseURL: licenseResult?.licenseURL,
				artworkURL: artworkURL
			)

			try offlineStore.storeMediaItem(storeResult)
		}
	}
}
