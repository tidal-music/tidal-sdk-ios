import AVFoundation
import Foundation
import TidalAPI

// MARK: - ManifestFetchResult

struct ManifestFetchResult {
	let manifestURL: URL
	let contentKeySession: AVContentKeySession?
	let playbackMetadata: OfflineMediaItem.PlaybackMetadata?
}

// MARK: - TrackManifestFetcherProtocol

protocol TrackManifestFetcherProtocol {
	var audioFormats: [AudioFormat] { get set }
	func fetchTrackManifest(trackId: String) async throws -> ManifestFetchResult
}

// MARK: - VideoManifestFetcherProtocol

protocol VideoManifestFetcherProtocol {
	func fetchVideoManifest(videoId: String) async throws -> ManifestFetchResult
}

// MARK: - TrackManifestFetcher

final class TrackManifestFetcher: TrackManifestFetcherProtocol {
	var audioFormats: [AudioFormat]

	init(audioFormats: [AudioFormat]) {
		self.audioFormats = audioFormats
	}

	func fetchTrackManifest(trackId: String) async throws -> ManifestFetchResult {
		let response = try await TrackManifestsAPITidal.trackManifestsIdGet(
			id: trackId,
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

		return ManifestFetchResult(manifestURL: url, contentKeySession: contentKeySession, playbackMetadata: playbackMetadata)
	}
}

// MARK: - VideoManifestFetcher

final class VideoManifestFetcher: VideoManifestFetcherProtocol {
	func fetchVideoManifest(videoId: String) async throws -> ManifestFetchResult {
		let response = try await VideoManifestsAPITidal.videoManifestsIdGet(
			id: videoId,
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

		return ManifestFetchResult(manifestURL: url, contentKeySession: contentKeySession, playbackMetadata: nil)
	}
}

// MARK: - NormalizationData Conversion

private extension OfflineMediaItem.NormalizationData {
	init?(_ apiData: AudioNormalizationData?) {
		guard let apiData else { return nil }
		self.init(peakAmplitude: apiData.peakAmplitude, replayGain: apiData.replayGain)
	}
}
