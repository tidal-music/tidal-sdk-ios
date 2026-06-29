import Auth
import Foundation
import TidalAPI

// MARK: - PlaybackInfoFetcher

final class PlaybackInfoFetcher {
	private var configuration: Configuration
	private let httpClient: HttpClient
	private let credentialsProvider: CredentialsProvider
	private let networkMonitor: NetworkMonitor
	private let playerEventSender: PlayerEventSender
	private let featureFlagProvider: FeatureFlagProvider

	init(
		with configuration: Configuration,
		_ httpClient: HttpClient,
		_ credentialsProvider: CredentialsProvider,
		_ networkMonitor: NetworkMonitor,
		and playerEventSender: PlayerEventSender,
		featureFlagProvider: FeatureFlagProvider
	) {
		self.configuration = configuration
		self.httpClient = httpClient
		self.credentialsProvider = credentialsProvider
		self.networkMonitor = networkMonitor
		self.playerEventSender = playerEventSender
		self.featureFlagProvider = featureFlagProvider
	}

	func getPlaybackInfo(
		streamingSessionId: String,
		mediaProduct: MediaProduct,
		playbackMode: PlaybackMode
	) async throws -> PlaybackInfo {
		switch mediaProduct.productType {
		case .TRACK:
			try await getTrackPlaybackInfo(
				trackId: mediaProduct.productId,
				playbackMode: playbackMode,
				streamingSessionId: streamingSessionId
			)
		case .VIDEO:
			try await getVideoPlaybackInfo(
				videoId: mediaProduct.productId,
				playbackMode: playbackMode,
				streamingSessionId: streamingSessionId
			)
		case let .UC(url):
			await getUCPlaybackInfo(
				trackId: mediaProduct.productId,
				trackURL: url,
				playbackMode: playbackMode,
				streamingSessionId: streamingSessionId
			)
		}
	}

	func cancellNetworkRequests() {
		httpClient.cancelAllRequests()
	}

	func updateConfiguration(_ configuration: Configuration) {
		self.configuration = configuration
	}
}

private extension PlaybackInfoFetcher {
	func getTrackPlaybackInfo(
		trackId: String,
		playbackMode: PlaybackMode,
		streamingSessionId: String
	) async throws -> PlaybackInfo {
		let start = PlayerWorld.timeProvider.timestamp()
		do {
			let requestedAudioQuality = getAudioQuality(given: playbackMode)
			let adaptivePlaybackEnabled = playbackMode == .STREAM && configuration.allowVariablePlayback
			let formats = formats(for: requestedAudioQuality)

			// Ensure credentials provider is set
			if OpenAPIClientAPI.credentialsProvider == nil {
				OpenAPIClientAPI.credentialsProvider = credentialsProvider
			}

			let manifestResponse = try await TrackManifestsAPITidal.trackManifestsIdGet(
				id: trackId,
				manifestType: .hls,
				formats: formats,
				uriScheme: .data,
				usage: playbackMode == .OFFLINE ? .download : .playback,
				adaptive: adaptivePlaybackEnabled
			)

			let manifestData = manifestResponse.data
			let attributes = manifestData.attributes

			guard let manifestUri = attributes?.uri else {
				throw PlaybackInfoFetcherError.unableToExtractManifestUrl.error(.EUnexpected)
			}

			guard let manifestUrl = URL(string: manifestUri) else {
				throw PlaybackInfoFetcherError.unableToExtractManifestUrl.error(.EUnexpected)
			}

			let endTimestamp = PlayerWorld.timeProvider.timestamp()
			playerEventSender.send(
				PlaybackInfoFetch(
					streamingSessionId: streamingSessionId,
					startTimestamp: start,
					endTimestamp: endTimestamp,
					endReason: .COMPLETE,
					errorMessage: nil,
					errorCode: nil
				)
			)

			// Determine actual audio quality from the returned formats (inverse mapping)
			let actualAudioQuality = PlaybackInfoFetcher.getAudioQualityFromFormats(attributes?.formats, fallback: requestedAudioQuality)
			let adaptiveAudioQualities = adaptivePlaybackEnabled
				? PlaybackInfoFetcher.buildQualityLadder(from: attributes?.formats)
				: nil

			// Check if adaptive playback is enabled
			let isAdaptivePlaybackEnabled = configuration.allowVariablePlayback

			return PlaybackInfo(
				productType: .TRACK,
				productId: trackId,
				streamType: .ON_DEMAND,
				assetPresentation: convertTrackPresentation(attributes?.trackPresentation),
				audioMode: getAudioModeFromFormats(attributes?.formats),
				audioQuality: actualAudioQuality,
				audioCodec: getAudioCodecFromFormats(attributes?.formats),
				audioSampleRate: nil, // Not available in new API
				audioBitDepth: nil, // Not available in new API
				adaptiveAudioQualities: adaptiveAudioQualities,
				videoQuality: nil,
				streamingSessionId: streamingSessionId,
				contentHash: attributes?.hash ?? "NA",
				mediaType: "application/vnd.apple.mpegurl", // HLS MIME type
				url: manifestUrl,
				licenseSecurityToken: nil,
				albumReplayGain: attributes?.albumAudioNormalizationData?.replayGain,
				albumPeakAmplitude: attributes?.albumAudioNormalizationData?.peakAmplitude,
				trackReplayGain: attributes?.trackAudioNormalizationData?.replayGain,
				trackPeakAmplitude: attributes?.trackAudioNormalizationData?.peakAmplitude,
				offlineRevalidateAt: nil, // May need to be derived from DRM data
				offlineValidUntil: nil, // May need to be derived from DRM data
				isAdaptivePlaybackEnabled: isAdaptivePlaybackEnabled,
				previewReason: convertPreviewReason(attributes?.previewReason)
			)

		} catch {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.getPlaybackInfoFailed(error: error))

			let convertedError = PlaybackInfoErrorResponseConverter.convert(error)
			let playerError = PlayerInternalError.from(convertedError)

			let endTimestamp = PlayerWorld.timeProvider.timestamp()
			playerEventSender.send(
				PlaybackInfoFetch(
					streamingSessionId: streamingSessionId,
					startTimestamp: start,
					endTimestamp: endTimestamp,
					endReason: error is CancellationError ? .OTHER : .ERROR,
					errorMessage: playerError.technicalDescription,
					errorCode: playerError.code
				)
			)

			throw convertedError
		}
	}

	func getAudioQuality(given playbackMode: PlaybackMode) -> AudioQuality {
		if playbackMode == .OFFLINE {
			return configuration.offlineAudioQuality
		}

		if networkMonitor.getNetworkType() == .MOBILE {
			return configuration.streamingCellularAudioQuality
		}

		return configuration.streamingWifiAudioQuality
	}

	func getVideoPlaybackInfo(
		videoId: String,
		playbackMode: PlaybackMode,
		streamingSessionId: String
	) async throws -> PlaybackInfo {
		let start = PlayerWorld.timeProvider.timestamp()
		do {
			// Ensure credentials provider is set
			if OpenAPIClientAPI.credentialsProvider == nil {
				OpenAPIClientAPI.credentialsProvider = credentialsProvider
			}

			let response = try await VideoManifestsAPITidal.videoManifestsIdGet(
				id: videoId,
				uriScheme: .data,
				usage: playbackMode == .OFFLINE ? .download : .playback
			)

			let attributes = response.data.attributes

			guard let hrefString = attributes?.link?.href,
			      let url = URL(string: hrefString)
			else {
				throw PlaybackInfoFetcherError.unableToExtractManifestUrl.error(.EUnexpected)
			}

			let endTimestamp = PlayerWorld.timeProvider.timestamp()
			playerEventSender.send(
				PlaybackInfoFetch(
					streamingSessionId: streamingSessionId,
					startTimestamp: start,
					endTimestamp: endTimestamp,
					endReason: .COMPLETE,
					errorMessage: nil,
					errorCode: nil
				)
			)

			return PlaybackInfo(
				productType: .VIDEO,
				productId: videoId,
				streamType: .ON_DEMAND,
				assetPresentation: convertVideoPresentation(attributes?.videoPresentation),
				audioMode: nil,
				audioQuality: nil,
				audioCodec: nil,
				audioSampleRate: nil,
				audioBitDepth: nil,
				adaptiveAudioQualities: nil,
				videoQuality: nil,
				streamingSessionId: streamingSessionId,
				contentHash: "NA",
				mediaType: "application/vnd.apple.mpegurl",
				url: url,
				licenseSecurityToken: nil,
				albumReplayGain: nil,
				albumPeakAmplitude: nil,
				trackReplayGain: nil,
				trackPeakAmplitude: nil,
				offlineRevalidateAt: nil,
				offlineValidUntil: nil,
				isAdaptivePlaybackEnabled: false,
				previewReason: convertVideoPreviewReason(attributes?.previewReason)
			)

		} catch {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.getPlaybackInfoFailed(error: error))

			let convertedError = PlaybackInfoErrorResponseConverter.convert(error)
			let playerError = PlayerInternalError.from(convertedError)

			let endTimestamp = PlayerWorld.timeProvider.timestamp()
			playerEventSender.send(
				PlaybackInfoFetch(
					streamingSessionId: streamingSessionId,
					startTimestamp: start,
					endTimestamp: endTimestamp,
					endReason: error is CancellationError ? .OTHER : .ERROR,
					errorMessage: playerError.technicalDescription,
					errorCode: playerError.code
				)
			)

			throw convertedError
		}
	}

	func getUCPlaybackInfo(
		trackId: String,
		trackURL: URL,
		playbackMode: PlaybackMode,
		streamingSessionId: String
	) async -> PlaybackInfo {
		PlaybackInfo(
			productType: .UC(url: trackURL),
			productId: trackId,
			streamType: .ON_DEMAND,
			assetPresentation: .FULL,
			audioMode: .STEREO,
			audioQuality: .LOW,
			audioCodec: .HE_AAC_V1,
			audioSampleRate: nil,
			audioBitDepth: nil,
			adaptiveAudioQualities: nil,
			videoQuality: nil,
			streamingSessionId: streamingSessionId,
			contentHash: "",
			mediaType: MediaTypes.HLS,
			url: trackURL,
			licenseSecurityToken: nil,
			albumReplayGain: nil,
			albumPeakAmplitude: nil,
			trackReplayGain: nil,
			trackPeakAmplitude: nil,
			offlineRevalidateAt: nil,
			offlineValidUntil: nil,
			isAdaptivePlaybackEnabled: false,
			previewReason: nil // User content doesn't use previewReason
		)
	}

	// MARK: - New API Helper Methods

	private func convertTrackPresentation(_ presentation: TrackManifestsAttributes.TrackPresentation?) -> AssetPresentation {
		switch presentation {
		case .full:
			.FULL
		case .preview:
			.PREVIEW
		case nil:
			.FULL
		}
	}

	private func convertVideoPresentation(_ presentation: VideoManifestsAttributes.VideoPresentation?) -> AssetPresentation {
		switch presentation {
		case .full:
			.FULL
		case .preview:
			.PREVIEW
		case nil:
			.FULL
		}
	}

	private func convertVideoPreviewReason(_ reason: VideoManifestsAttributes.PreviewReason?) -> PreviewReason? {
		guard let reason else {
			return nil
		}

		switch reason {
		case .fullRequiresSubscription:
			return .FULL_REQUIRES_SUBSCRIPTION
		case .fullRequiresPurchase:
			return .FULL_REQUIRES_PURCHASE
		case .fullRequiresHigherAccessTier:
			return .FULL_REQUIRES_HIGHER_ACCESS_TIER
		}
	}

	private func convertPreviewReason(_ reason: TrackManifestsAttributes.PreviewReason?) -> PreviewReason? {
		guard let reason else {
			return nil
		}

		switch reason {
		case .fullRequiresSubscription:
			return .FULL_REQUIRES_SUBSCRIPTION
		case .fullRequiresPurchase:
			return .FULL_REQUIRES_PURCHASE
		case .fullRequiresHigherAccessTier:
			return .FULL_REQUIRES_HIGHER_ACCESS_TIER
		}
	}

	private func getAudioCodecFromFormats(_ formats: [TrackManifestsAttributes.Formats]?) -> AudioCodec? {
		guard let formats, !formats.isEmpty else {
			return nil
		}

		// Define priority order (highest quality first)
		let codecPriority: [(TrackManifestsAttributes.Formats, AudioCodec)] = [
			(.flacHires, .FLAC),
			(.flac, .FLAC),
			(.aaclc, .AAC_LC),
			(.heaacv1, .HE_AAC_V1),
			(.eac3Joc, .EAC3),
		]

		// Return the highest quality codec available
		for (format, codec) in codecPriority where formats.contains(format) {
			return codec
		}

		return nil
	}

	private func getAudioModeFromFormats(_ formats: [TrackManifestsAttributes.Formats]?) -> AudioMode {
		if let formats, formats.contains(.eac3Joc) {
			return .DOLBY_ATMOS
		}

		return .STEREO
	}
}

extension PlaybackInfoFetcher {
	private func formats(for audioQuality: AudioQuality) -> [TrackManifestsAPITidal.Formats_trackManifestsIdGet] {
		var formats: [TrackManifestsAPITidal.Formats_trackManifestsIdGet] = switch audioQuality {
		case .HI_RES, .HI_RES_LOSSLESS:
			[.heaacv1, .aaclc, .flac, .flacHires]
		case .LOSSLESS:
			[.heaacv1, .aaclc, .flac]
		case .HIGH:
			[.heaacv1, .aaclc]
		case .LOW:
			[.heaacv1]
		}

		if configuration.isImmersiveAudio {
			formats.append(.eac3Joc)
		}

		return formats
	}

	private static func audioQualities(upTo maxQuality: AudioQuality) -> [AudioQuality] {
		switch maxQuality {
		case .LOW:
			[.LOW]
		case .HIGH:
			[.LOW, .HIGH]
		case .LOSSLESS:
			[.LOW, .HIGH, .LOSSLESS]
		case .HI_RES:
			[.LOW, .HIGH, .LOSSLESS, .HI_RES]
		case .HI_RES_LOSSLESS:
			[.LOW, .HIGH, .LOSSLESS, .HI_RES, .HI_RES_LOSSLESS]
		}
	}

	static func buildQualityLadder(
		from formats: [TrackManifestsAttributes.Formats]?
	) -> [AudioQuality]? {
		guard let formats, formats.isEmpty == false else {
			return nil
		}

		let orderedPairs: [(TrackManifestsAttributes.Formats, AudioQuality)] = [
			(.heaacv1, .LOW),
			(.aaclc, .HIGH),
			(.flac, .LOSSLESS),
			(.flacHires, .HI_RES_LOSSLESS),
		]

		let ladder = orderedPairs.compactMap { format, quality in
			formats.contains(format) ? quality : nil
		}

		return ladder.isEmpty ? nil : ladder
	}

	static func buildQualityLadder(upTo maxQuality: AudioQuality) -> [AudioQuality] {
		audioQualities(upTo: maxQuality)
	}

	/// Inverse mapping: derive AudioQuality from returned manifest formats
	static func getAudioQualityFromFormats(
		_ formats: [TrackManifestsAttributes.Formats]?,
		fallback: AudioQuality
	) -> AudioQuality {
		guard let formats, formats.isEmpty == false else {
			return fallback
		}
		if formats.contains(.flacHires) {
			return .HI_RES_LOSSLESS
		}
		if formats.contains(.flac) {
			return .LOSSLESS
		}
		if formats.contains(.aaclc) {
			return .HIGH
		}
		if formats.contains(.heaacv1) {
			return .LOW
		}
		return fallback
	}
}
