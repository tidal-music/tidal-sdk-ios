import AVFoundation
import CoreMedia
import Foundation
import TidalAPI

final class StoreVideoHandler {
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
		let title = task.itemMetadata.title
		let artists = task.artists.compactMap(\.attributes?.name)
		let imageURL = task.artwork?.attributes?.files.first.flatMap { URL(string: $0.href) }
		return InternalTaskImpl(
			task: task,
			download: Download(title: title, artists: artists, imageURL: imageURL),
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
			print("StoreVideoHandler error: \(error)")
			await mediaDownload.updateState(.failed)
			return
		}

		do {
			let artworkURL = try await artworkDownloader.downloadArtwork(for: task)

			let (manifestURL, contentKeySession) = try await fetchManifest()

			let mediaResult = try await mediaDownloader.download(
				manifestURL: manifestURL,
				contentKeySession: contentKeySession,
				taskId: id,
				onProgress: { [weak self] progress in
					guard let download = self?.download else { return }
					await download.updateProgress(progress)
				}
			)

			let storeResult = StoreItemTaskResult(
				resourceType: task.itemMetadata.resourceType,
				resourceId: task.itemMetadata.resourceId,
				catalogMetadata: OfflineMediaItem.Metadata(from: task, duration: mediaResult.duration),
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

	private func fetchManifest() async throws -> (URL, AVContentKeySession?) {
		let response = try await VideoManifestsAPITidal.videoManifestsIdGet(
			id: task.itemMetadata.resourceId,
			uriScheme: .data,
			usage: .download
		)

		let attributes = response.data.attributes

		guard let hrefString = attributes?.link?.href,
			  let url = URL(string: hrefString) else {
			throw MediaDownloaderError.manifestNotFound
		}

		let contentKeySession = attributes?.drmData
			.map { _ in AVContentKeySession(keySystem: .fairPlayStreaming) }

		return (url, contentKeySession)
	}
}
