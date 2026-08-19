import Foundation
import TidalAPI

// MARK: - ManifestFetchResult

struct ManifestFetchResult {
	let manifestURL: URL
	let drmData: DrmData?
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
			uriScheme: simulatorSafeURIScheme(.data),
			usage: .download,
			adaptive: false
		)

		let attributes = response.data.attributes

		try validateFullTrackPresentation(attributes?.trackPresentation)

		guard let uriString = attributes?.uri,
		      let url = URL(string: uriString)
		else {
			throw MediaDownloaderError.manifestNotFound
		}

		let format = attributes?.formats?.first.flatMap { AudioFormat(rawValue: $0.rawValue) }

		let playbackMetadata = format.map { format in
			OfflineMediaItem.PlaybackMetadata(
				format: format,
				albumNormalizationData: .init(attributes?.albumAudioNormalizationData),
				trackNormalizationData: .init(attributes?.trackAudioNormalizationData)
			)
		}

		return ManifestFetchResult(manifestURL: url, drmData: attributes?.drmData, playbackMetadata: playbackMetadata)
	}
}

func validateFullTrackPresentation(_ presentation: TrackManifestsAttributes.TrackPresentation?) throws {
	guard presentation == .full else {
		throw MediaDownloaderError.previewManifest
	}
}

// MARK: - VideoManifestFetcher

final class VideoManifestFetcher: VideoManifestFetcherProtocol {
	func fetchVideoManifest(videoId: String) async throws -> ManifestFetchResult {
		let response = try await VideoManifestsAPITidal.videoManifestsIdGet(
			id: videoId,
			uriScheme: simulatorSafeURIScheme(.data),
			usage: .download
		)

		let attributes = response.data.attributes

		guard let hrefString = attributes?.link?.href,
		      let url = URL(string: hrefString)
		else {
			throw MediaDownloaderError.manifestNotFound
		}

		return ManifestFetchResult(manifestURL: url, drmData: attributes?.drmData, playbackMetadata: nil)
	}
}

// MARK: - Simulator URI Scheme

/// Simulators reject `data:` manifest URIs in `AVAssetDownloadTask` with `NSURLErrorUnsupportedURL`. Request regular
/// HTTPS manifests there so development and UI-validation downloads can complete; devices keep the `data:` scheme,
/// which avoids a second manifest fetch at download time.
private func simulatorSafeURIScheme(
	_ scheme: TrackManifestsAPITidal.UriScheme_trackManifestsIdGet
) -> TrackManifestsAPITidal.UriScheme_trackManifestsIdGet {
	#if targetEnvironment(simulator)
		.https
	#else
		scheme
	#endif
}

private func simulatorSafeURIScheme(
	_ scheme: VideoManifestsAPITidal.UriScheme_videoManifestsIdGet
) -> VideoManifestsAPITidal.UriScheme_videoManifestsIdGet {
	#if targetEnvironment(simulator)
		.https
	#else
		scheme
	#endif
}

// MARK: - NormalizationData Conversion

private extension OfflineMediaItem.NormalizationData {
	init?(_ apiData: AudioNormalizationData?) {
		guard let apiData else {
			return nil
		}
		self.init(peakAmplitude: apiData.peakAmplitude, replayGain: apiData.replayGain)
	}
}
