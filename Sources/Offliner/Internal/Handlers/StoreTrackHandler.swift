import AVFoundation
import CoreMedia
import Foundation
import TidalAPI

final class StoreTrackHandler {
	private let offlineApiClient: OfflineApiClientProtocol
	private let offlineStore: OfflineStore
	private let artworkDownloader: ArtworkDownloaderProtocol
	private let mediaDownloader: MediaDownloaderProtocol
	var audioFormats: [AudioFormat]

	init(
		offlineApiClient: OfflineApiClientProtocol,
		offlineStore: OfflineStore,
		artworkDownloader: ArtworkDownloaderProtocol,
		mediaDownloader: MediaDownloaderProtocol,
		audioFormats: [AudioFormat]
	) {
		self.offlineApiClient = offlineApiClient
		self.offlineStore = offlineStore
		self.artworkDownloader = artworkDownloader
		self.mediaDownloader = mediaDownloader
		self.audioFormats = audioFormats
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
			mediaDownloader: mediaDownloader,
			audioFormats: audioFormats
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
	private let audioFormats: [AudioFormat]

	private var mediaDownload: Download { download! }

	init(
		task: StoreItemTask,
		download: Download,
		offlineApiClient: OfflineApiClientProtocol,
		offlineStore: OfflineStore,
		artworkDownloader: ArtworkDownloaderProtocol,
		mediaDownloader: MediaDownloaderProtocol,
		audioFormats: [AudioFormat]
	) {
		self.id = task.id
		self.task = task
		self.download = download
		self.offlineApiClient = offlineApiClient
		self.offlineStore = offlineStore
		self.artworkDownloader = artworkDownloader
		self.mediaDownloader = mediaDownloader
		self.audioFormats = audioFormats
	}

	func run() async {
		do {
			try await offlineApiClient.updateTask(taskId: id, state: .inProgress)
			await mediaDownload.updateState(.inProgress)
		} catch {
			print("StoreTrackHandler error: \(error)")
			await mediaDownload.updateState(.failed)
			return
		}

		do {
			let artworkURL = try await artworkDownloader.downloadArtwork(for: task)

			let (manifestURL, contentKeySession, playbackMetadata) = try await fetchManifest()

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
				playbackMetadata: playbackMetadata,
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
			print("StoreTrackHandler error: \(error)")
			try? await offlineApiClient.updateTask(taskId: id, state: .failed)
			await mediaDownload.updateState(.failed)
		}
	}

	private func fetchManifest() async throws -> (URL, AVContentKeySession?, OfflineMediaItem.PlaybackMetadata?) {
		let response = try await TrackManifestsAPITidal.trackManifestsIdGet(
			id: task.itemMetadata.resourceId,
			manifestType: .hls,
			formats: audioFormats.map(\.toAPIFormat),
			uriScheme: .data,
			usage: .download,
			adaptive: false
		)

		let attributes = response.data.attributes

		guard let uriString = attributes?.uri,
			  let url = URL(string: uriString) else {
			throw MediaDownloaderError.manifestNotFound
		}

		let contentKeySession = attributes?.drmData
			.map { _ in AVContentKeySession(keySystem: .fairPlayStreaming) }

		let format = attributes?.formats?.first.flatMap { AudioFormat(rawValue: $0.rawValue) }

		let playbackMetadata = format.map { format in
			OfflineMediaItem.PlaybackMetadata(
				format: format,
				albumNormalizationData: .init(attributes?.albumAudioNormalizationData),
				trackNormalizationData: .init(attributes?.trackAudioNormalizationData)
			)
		}

		return (url, contentKeySession, playbackMetadata)
	}
}

// MARK: - NormalizationData Conversion

private extension OfflineMediaItem.NormalizationData {
	init?(_ apiData: AudioNormalizationData?) {
		guard let apiData else { return nil }
		self.init(peakAmplitude: apiData.peakAmplitude, replayGain: apiData.replayGain)
	}
}
