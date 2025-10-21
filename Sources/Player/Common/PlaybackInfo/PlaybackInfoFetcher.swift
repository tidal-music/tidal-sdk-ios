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
		if featureFlagProvider.shouldUseNewPlaybackEndpoints() {
			return try await getTrackPlaybackInfoFromManifestEndpoint(
				trackId: trackId,
				playbackMode: playbackMode,
				streamingSessionId: streamingSessionId
			)
		} else {
			return try await getTrackPlaybackInfoFromLegacyEndpoint(
				trackId: trackId,
				playbackMode: playbackMode,
				streamingSessionId: streamingSessionId
			)
		}
	}

	private func getTrackPlaybackInfoFromLegacyEndpoint(
		trackId: String,
		playbackMode: PlaybackMode,
		streamingSessionId: String
	) async throws -> PlaybackInfo {
		let playbackInfo: TrackPlaybackInfo = try await getPlaybackInfo(
			url: getTrackPlaybackInfoUrl(trackId: trackId, playbackMode: playbackMode),
			streamingSessionId: streamingSessionId,
			playlistUUID: nil
		)

		guard let url = PlaybackInfoFetcher.extractUrl(
			manifestMimeType: playbackInfo.manifestMimeType,
			manifest: playbackInfo.manifest
		) else {
			throw PlaybackInfoFetcherError.unableToExtractManifestUrl.error(.EUnexpected)
		}

		return PlaybackInfo(
			productType: .TRACK,
			productId: String(playbackInfo.trackId),
			streamType: .ON_DEMAND,
			assetPresentation: playbackInfo.assetPresentation,
			audioMode: playbackInfo.audioMode,
			audioQuality: playbackInfo.audioQuality,
			audioCodec: PlaybackInfoFetcher.extractCodec(
				manifestMimeType: playbackInfo.manifestMimeType,
				manifest: playbackInfo.manifest
			),
			audioSampleRate: playbackInfo.sampleRate,
			audioBitDepth: playbackInfo.bitDepth,
			videoQuality: nil,
			streamingSessionId: playbackInfo.streamingSessionId,
			contentHash: playbackInfo.manifestHash,
			mediaType: playbackInfo.manifestMimeType,
			url: url,
			licenseSecurityToken: playbackInfo.licenseSecurityToken,
			albumReplayGain: playbackInfo.albumReplayGain,
			albumPeakAmplitude: playbackInfo.albumPeakAmplitude,
			trackReplayGain: playbackInfo.trackReplayGain,
			trackPeakAmplitude: playbackInfo.trackPeakAmplitude,
			offlineRevalidateAt: playbackInfo.offlineRevalidateAt,
			offlineValidUntil: playbackInfo.offlineValidUntil
		)
	}

	private func getTrackPlaybackInfoFromManifestEndpoint(
		trackId: String,
		playbackMode: PlaybackMode,
		streamingSessionId: String
	) async throws -> PlaybackInfo {
		let start = PlayerWorld.timeProvider.timestamp()
		do {
			// Determine requested quality and corresponding acceptable formats
			let requestedAudioQuality = getAudioQuality(given: playbackMode)
			let formats = getFormatsForAudioQuality(requestedAudioQuality)

			// Ensure credentials provider is set
			if OpenAPIClientAPI.credentialsProvider == nil {
				OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
			}

			let manifestResponse = try await TrackManifestsAPITidal.trackManifestsIdGet(
				id: trackId,
				manifestType: .hls,
				formats: formats,
				uriScheme: .data,
				usage: playbackMode == .OFFLINE ? .download : .playback,
				adaptive: .false,
				customHeaders: ["x-playback-session-id": streamingSessionId]
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

			return PlaybackInfo(
				productType: .TRACK,
				productId: trackId,
				streamType: .ON_DEMAND,
				assetPresentation: convertTrackPresentation(attributes?.trackPresentation),
				audioMode: .STEREO, // Default value, may need refinement
				audioQuality: actualAudioQuality,
				audioCodec: getAudioCodecFromFormats(attributes?.formats),
				audioSampleRate: nil, // Not available in new API
				audioBitDepth: nil, // Not available in new API
				videoQuality: nil,
				streamingSessionId: streamingSessionId,
				contentHash: attributes?.hash ?? "NA",
				mediaType: "application/vnd.apple.mpegurl", // HLS MIME type
				url: manifestUrl,
				licenseSecurityToken: extractLicenseTokenFromDrmData(attributes?.drmData),
				albumReplayGain: attributes?.albumAudioNormalizationData?.replayGain,
				albumPeakAmplitude: attributes?.albumAudioNormalizationData?.peakAmplitude,
				trackReplayGain: attributes?.trackAudioNormalizationData?.replayGain,
				trackPeakAmplitude: attributes?.trackAudioNormalizationData?.peakAmplitude,
				offlineRevalidateAt: nil, // May need to be derived from DRM data
				offlineValidUntil: nil // May need to be derived from DRM data
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

	func getTrackPlaybackInfoUrl(trackId: String, playbackMode: PlaybackMode) throws -> URL {
		let audioQuality = getAudioQuality(given: playbackMode)
		let immersiveAudio = configuration.isImmersiveAudio

		let path = "https://api.tidal.com/v1/tracks/\(trackId)/playbackinfo"
		let parameters =
			"audioquality=\(audioQuality)&assetpresentation=FULL&playbackmode=\(playbackMode)&immersiveaudio=\(immersiveAudio)"

		return try PlaybackInfoFetcher.createUrl(from: "\(path)?\(parameters)")
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
		let playbackInfo: VideoPlaybackInfo = try await getPlaybackInfo(
			url: getVideoPlaybackInfoUrl(videoId: videoId, playbackMode: playbackMode),
			streamingSessionId: streamingSessionId,
			playlistUUID: nil
		)

		guard let url = PlaybackInfoFetcher.extractUrl(
			manifestMimeType: playbackInfo.manifestMimeType,
			manifest: playbackInfo.manifest
		) else {
			throw PlaybackInfoFetcherError.unableToExtractManifestUrl.error(.EUnexpected)
		}

		return PlaybackInfo(
			productType: .VIDEO,
			productId: String(playbackInfo.videoId),
			streamType: playbackInfo.streamType,
			assetPresentation: playbackInfo.assetPresentation,
			audioMode: nil,
			audioQuality: nil,
			audioCodec: nil,
			audioSampleRate: nil,
			audioBitDepth: nil,
			videoQuality: playbackInfo.videoQuality,
			streamingSessionId: playbackInfo.streamingSessionId,
			contentHash: playbackInfo.manifestHash ?? "NA",
			mediaType: playbackInfo.manifestMimeType,
			url: url,
			licenseSecurityToken: playbackInfo.licenseSecurityToken,
			albumReplayGain: playbackInfo.albumReplayGain,
			albumPeakAmplitude: playbackInfo.albumPeakAmplitude,
			trackReplayGain: playbackInfo.trackReplayGain,
			trackPeakAmplitude: playbackInfo.trackPeakAmplitude,
			offlineRevalidateAt: playbackInfo.offlineRevalidateAt,
			offlineValidUntil: playbackInfo.offlineValidUntil
		)
	}

	func getVideoPlaybackInfoUrl(videoId: String, playbackMode: PlaybackMode) throws -> URL {
		let videoQuality = getVideoQuality(given: playbackMode)
		let path = "https://api.tidal.com/v1/videos/\(videoId)/playbackinfo"
		let parameters = "videoquality=\(videoQuality)&assetpresentation=FULL&playbackmode=\(playbackMode)"

		return try PlaybackInfoFetcher.createUrl(from: "\(path)?\(parameters)")
	}

	func getVideoQuality(given playbackMode: PlaybackMode) -> VideoQuality {
		if playbackMode == .OFFLINE {
			return configuration.offlineVideoQuality
		}

		return VideoQuality.HIGH
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
			offlineValidUntil: nil
		)
	}

	func getPlaybackInfo<T: Decodable>(url: URL, streamingSessionId: String, playlistUUID: String?) async throws -> T {
		let start = PlayerWorld.timeProvider.timestamp()
		do {
			let playbackInfo: T
			let token = try await credentialsProvider.getAuthBearerToken()
			playbackInfo = try await httpClient.getJson(
				url: url,
				headers: [
					"Authorization": token,
					"x-tidal-streamingsessionid": streamingSessionId,
					"x-tidal-playlistuuid": playlistUUID,
				].compactMapValues { $0 }
			)

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

			return playbackInfo

		} catch {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.getPlaybackInfoFailed(error: error))

			// TODO: Should we update this to handle proper conversion from TidalError, otherwise they will always be EUnexpected
			let error = PlaybackInfoErrorResponseConverter.convert(error)
			let playerError = PlayerInternalError.from(error)

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

			throw error
		}
	}

	// MARK: - New API Helper Methods
	
	private func getFormatsForAudioQuality(_ audioQuality: AudioQuality) -> String {
		let formats: [TrackManifestsAttributes.Formats]
		
		switch audioQuality {
		case .HI_RES, .HI_RES_LOSSLESS:
			formats = [.heaacv1, .aaclc, .flac, .flacHires]
		case .LOSSLESS:
			formats = [.heaacv1, .aaclc, .flac]
		case .HIGH:
			formats = [.heaacv1, .aaclc]
		case .LOW:
			formats = [.heaacv1]
		}
		
		return formats.map(\.rawValue).joined(separator: ",")
	}

	private func convertTrackPresentation(_ presentation: TrackManifestsAttributes.TrackPresentation?) -> AssetPresentation {
		switch presentation {
		case .full:
			return .FULL
		case .preview:
			return .PREVIEW
		case nil:
			return .FULL // Default fallback
		}
	}
	
	private func getAudioCodecFromFormats(_ formats: [TrackManifestsAttributes.Formats]?) -> AudioCodec? {
		guard let formats = formats, !formats.isEmpty else {
			return nil
		}
		
		// Define priority order (highest quality first)
		let codecPriority: [(TrackManifestsAttributes.Formats, AudioCodec)] = [
			(.flacHires, .FLAC),
			(.flac, .FLAC),
			(.aaclc, .AAC_LC),
			(.heaacv1, .HE_AAC_V1)
		]
		
		// Return the highest quality codec available
		for (format, codec) in codecPriority {
			if formats.contains(format) {
				return codec
			}
		}
		
		return nil
	}
	
	/// Extracts license security token from new DRM data format
	/// Note: Current DRM system doesn't actually use licenseSecurityToken - it uses dynamic URLs
	private func extractLicenseTokenFromDrmData(_ drmData: DrmData?) -> String? {
		// The current FairPlayLicenseFetcher doesn't use licenseSecurityToken at all
		// It makes direct requests to licenseUrl with Authorization header
		// For compatibility, we could return the licenseUrl itself or extract token from it
		guard let drmData = drmData,
		      let _ = drmData.licenseUrl else {
			return nil
		}
		
		// For now, return nil since licenseSecurityToken is not used in current DRM implementation
		// Future enhancement: Parse token from licenseUrl or use licenseUrl as token
		// TODO: Verify with backend team if token extraction is needed from licenseUrl
		return nil
	}

	static func extractUrl(manifestMimeType: String, manifest: String) -> URL? {
		switch manifestMimeType {
		case MediaTypes.HLS:
			return URL(string: "data:\(MediaTypes.HLS);base64,\(manifest)")
		case MediaTypes.BTS:
			guard let data = Data(base64Encoded: manifest) else {
				return nil
			}
			guard let btsManifest = try? JSONDecoder().decode(BtsManifest.self, from: data) else {
				return nil
			}
			return URL(string: btsManifest.urls[0])
		case MediaTypes.EMU:
			guard let data = Data(base64Encoded: manifest) else {
				return nil
			}
			guard let emuManifest = try? JSONDecoder().decode(EmuManifest.self, from: data) else {
				return nil
			}
			return URL(string: emuManifest.urls[0])
		default:
			return nil
		}
	}

	static func extractCodec(manifestMimeType: String, manifest: String) -> AudioCodec? {
		switch manifestMimeType {
		case MediaTypes.HLS, MediaTypes.EMU: // No codec data in the manifest?
			return nil
		case MediaTypes.BTS:
			guard let data = Data(base64Encoded: manifest) else {
				return nil
			}
			guard let btsManifest = try? JSONDecoder().decode(BtsManifest.self, from: data) else {
				return nil
			}
			let codecs = btsManifest.codecs.components(separatedBy: ",")
			return AudioCodec(rawValue: codecs.first)
		default:
			return nil
		}
	}

	static func createUrl(from urlString: String) throws -> URL {
		guard let url = URL(string: urlString) else {
			throw PlaybackInfoFetcherError.unableToCreateUrl.error(.EUnexpected)
		}

		return url
	}
}

extension PlaybackInfoFetcher {
	/// Inverse mapping: derive AudioQuality from returned manifest formats
	static func getAudioQualityFromFormats(
		_ formats: [TrackManifestsAttributes.Formats]?,
		fallback: AudioQuality
	) -> AudioQuality {
		guard let formats, formats.isEmpty == false else {
			return fallback
		}
		if formats.contains(.flacHires) { return .HI_RES_LOSSLESS }
		if formats.contains(.flac) { return .LOSSLESS }
		if formats.contains(.aaclc) { return .HIGH }
		if formats.contains(.heaacv1) { return .LOW }
		return fallback
	}
}
