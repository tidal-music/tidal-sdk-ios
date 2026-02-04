import Auth
import AVFoundation
import CoreMedia
import Foundation

final class StoreItemHandler {
	private let backendClient: BackendClientProtocol
	private let offlineStore: OfflineStore
	private let artworkDownloader: ArtworkDownloaderProtocol
	private let mediaDownloader: MediaDownloaderProtocol

	init(
		backendClient: BackendClientProtocol,
		offlineStore: OfflineStore,
		artworkDownloader: ArtworkDownloaderProtocol,
		mediaDownloader: MediaDownloaderProtocol
	) {
		self.backendClient = backendClient
		self.offlineStore = offlineStore
		self.artworkDownloader = artworkDownloader
		self.mediaDownloader = mediaDownloader
	}

	func start(_ download: Download, onFinished: @escaping @Sendable () async -> Void) async {
		let task = download.task

		do {
			try await backendClient.updateTask(taskId: task.id, state: .inProgress)
			download.updateState(.inProgress)
		} catch {
			await onFinished()
			return
		}

		do {
			let artworkURL = try await artworkDownloader.downloadArtwork(for: task)

			let result = try await mediaDownloader.download(
				manifestURL: URL(string: "http://tidal.com/manifest.m3u8")!,
				taskId: task.id,
				onProgress: { progress in
					download.updateProgress(progress)
				}
			)

			try offlineStore.storeMediaItem(
				task: task,
				mediaURL: result.mediaURL,
				licenseURL: result.licenseURL,
				artworkURL: artworkURL
			)

			try await backendClient.updateTask(taskId: task.id, state: .completed)
			download.updateState(.completed)
		} catch {
			try? await backendClient.updateTask(taskId: task.id, state: .failed)
			download.updateState(.failed)
		}

		await onFinished()
	}
}
