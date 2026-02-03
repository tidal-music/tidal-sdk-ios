import Auth
import AVFoundation
import CoreMedia
import Foundation

final class StoreItemHandler {
	private let backendRepository: BackendRepositoryProtocol
	private let localRepository: LocalRepository
	private let artworkDownloader: ArtworkRepositoryProtocol
	private let mediaDownloader: MediaDownloaderProtocol

	init(
		backendRepository: BackendRepositoryProtocol,
		localRepository: LocalRepository,
		artworkDownloader: ArtworkRepositoryProtocol,
		mediaDownloader: MediaDownloaderProtocol
	) {
		self.backendRepository = backendRepository
		self.localRepository = localRepository
		self.artworkDownloader = artworkDownloader
		self.mediaDownloader = mediaDownloader
	}

	func start(_ download: Download, onFinished: @escaping @Sendable () async -> Void) async {
		let task = download.task

		do {
			try await backendRepository.updateTask(taskId: task.id, state: .inProgress)
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

			try localRepository.storeMediaItem(
				task: task,
				mediaURL: result.mediaURL,
				licenseURL: result.licenseURL,
				artworkURL: artworkURL
			)

			try await backendRepository.updateTask(taskId: task.id, state: .completed)
			download.updateState(.completed)
		} catch {
			try? await backendRepository.updateTask(taskId: task.id, state: .failed)
			download.updateState(.failed)
		}

		await onFinished()
	}
}
