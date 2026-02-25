import AVFoundation
import CoreMedia
import Foundation
import TidalAPI

final class StoreItemHandler {
	private let offlineApiClient: OfflineApiClientProtocol
	private let offlineStore: OfflineStore
	private let artworkDownloader: ArtworkDownloaderProtocol
	private let mediaDownloader: MediaDownloaderProtocol

	init(
		offlineApiClient: OfflineApiClientProtocol,
		offlineStore: OfflineStore,
		artworkDownloader: ArtworkDownloaderProtocol,
		mediaDownloader: MediaDownloaderProtocol
	) {
		self.offlineApiClient = offlineApiClient
		self.offlineStore = offlineStore
		self.artworkDownloader = artworkDownloader
		self.mediaDownloader = mediaDownloader
	}

	func handle(_ task: StoreItemTask) -> InternalTask {
		let metadata = OfflineMediaItem.Metadata(from: task)
		let imageURL = task.artwork?.attributes?.files.first.flatMap { URL(string: $0.href) }
		return InternalTaskImpl(
			task: task,
			download: Download(metadata: metadata, imageURL: imageURL),
			offlineApiClient: offlineApiClient,
			offlineStore: offlineStore,
			artworkDownloader: artworkDownloader,
			mediaDownloader: mediaDownloader
		)
	}
}

private final class InternalTaskImpl: InternalTask {
	let id: String
	let download: Download?

	private let task: StoreItemTask
	private let offlineApiClient: OfflineApiClientProtocol
	private let offlineStore: OfflineStore
	private let artworkDownloader: ArtworkDownloaderProtocol
	private let mediaDownloader: MediaDownloaderProtocol

	private var mediaDownload: Download { download! }

	init(
		task: StoreItemTask,
		download: Download,
		offlineApiClient: OfflineApiClientProtocol,
		offlineStore: OfflineStore,
		artworkDownloader: ArtworkDownloaderProtocol,
		mediaDownloader: MediaDownloaderProtocol
	) {
		self.id = task.id
		self.task = task
		self.download = download
		self.offlineApiClient = offlineApiClient
		self.offlineStore = offlineStore
		self.artworkDownloader = artworkDownloader
		self.mediaDownloader = mediaDownloader
	}

	func run() async {
		do {
			try await offlineApiClient.updateTask(taskId: id, state: .inProgress)
			await mediaDownload.updateState(.inProgress)
		} catch {
			print("StoreItemHandler error: \(error)")
			await mediaDownload.updateState(.failed)
			return
		}

		do {
			let artworkURL = try await artworkDownloader.downloadArtwork(for: task)

			let mediaResult = try await mediaDownloader.download(
				trackId: task.itemMetadata.resourceId,
				taskId: id,
				onProgress: { [weak self] progress in
					guard let download = self?.download else { return }
					await download.updateProgress(progress)
				}
			)

			let storeResult = StoreItemTaskResult(
				resourceType: task.itemMetadata.resourceType,
				resourceId: task.itemMetadata.resourceId,
				catalogMetadata: OfflineMediaItem.Metadata(from: task),
				playbackMetadata: mediaResult.playbackMetadata,
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
			print("StoreItemHandler error: \(error)")
			try? await offlineApiClient.updateTask(taskId: id, state: .failed)
			await mediaDownload.updateState(.failed)
		}
	}
}

// MARK: - Metadata Conversion

private extension OfflineMediaItem.Metadata {
	init(from task: StoreItemTask) {
		let artistNames = task.artists.compactMap(\.attributes?.name)
		switch task.itemMetadata {
		case .track(let track):
			self = .track(OfflineMediaItem.TrackMetadata(
				id: track.id,
				title: track.attributes?.title ?? "",
				artists: artistNames,
				duration: parseISO8601Duration(track.attributes?.duration)
			))
		case .video(let video):
			self = .video(OfflineMediaItem.VideoMetadata(
				id: video.id,
				title: video.attributes?.title ?? "",
				artists: artistNames,
				duration: parseISO8601Duration(video.attributes?.duration)
			))
		}
	}
}

private func parseISO8601Duration(_ duration: String?) -> Int {
	guard let duration, duration.hasPrefix("PT") else { return 0 }

	var total = 0
	var current = ""
	for char in duration.dropFirst(2) {
		switch char {
		case "H":
			total += (Int(current) ?? 0) * 3600
			current = ""
		case "M":
			total += (Int(current) ?? 0) * 60
			current = ""
		case "S":
			total += Int(current) ?? 0
			current = ""
		default:
			current.append(char)
		}
	}
	return total
}
