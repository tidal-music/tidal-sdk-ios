import Auth
import Foundation

// MARK: - PlaybackInfoFetcher

final class PlaybackInfoFetcher {
	private let configuration: Configuration
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
		case .BROADCAST:
			try await getBroadcastPlaybackInfo(
				broadcastId: mediaProduct.productId,
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
}

private extension PlaybackInfoFetcher {
	func getTrackPlaybackInfo(
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

	func getTrackPlaybackInfoUrl(trackId: String, playbackMode: PlaybackMode) throws -> URL {
		let audioQuality = getAudioQuality(given: playbackMode)
		let immersiveAudio = configuration.isImmersiveAudio

		let path = "https://api.tidal.com/v1/tracks/\(trackId)/playbackinfo"
		let parameters = "audioquality=\(audioQuality)&assetpresentation=FULL&playbackmode=\(playbackMode)&immersiveaudio=\(immersiveAudio)"

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

	func getBroadcastPlaybackInfo(broadcastId: String, streamingSessionId: String) async throws -> PlaybackInfo {
		let playbackInfo: BroadcastPlaybackInfo = try await getPlaybackInfo(
			url: getBroadcastPlaybackInfoUrl(broadcastId: broadcastId),
			streamingSessionId: streamingSessionId,
			playlistUUID: nil
		)

		guard let url = PlaybackInfoFetcher.extractUrl(
			manifestMimeType: playbackInfo.manifestType,
			manifest: playbackInfo.manifest
		) else {
			throw PlaybackInfoFetcherError.unableToExtractManifestUrl.error(.EUnexpected)
		}

		return PlaybackInfo(
			productType: .BROADCAST,
			productId: playbackInfo.id,
			streamType: .LIVE,
			assetPresentation: .FULL,
			audioMode: nil,
			audioQuality: playbackInfo.audioQuality,
			audioCodec: PlaybackInfoFetcher.extractCodec(
				manifestMimeType: playbackInfo.manifestType,
				manifest: playbackInfo.manifest
			),
			audioSampleRate: nil,
			audioBitDepth: nil,
			videoQuality: nil,
			streamingSessionId: streamingSessionId,
			contentHash: "NA",
			mediaType: playbackInfo.manifestType,
			url: url,
			licenseSecurityToken: nil,
			albumReplayGain: nil,
			albumPeakAmplitude: nil,
			trackReplayGain: nil,
			trackPeakAmplitude: nil,
			offlineRevalidateAt: nil,
			offlineValidUntil: nil
		)
	}

	func getBroadcastPlaybackInfoUrl(broadcastId: String) throws -> URL {
		let audioQuality = getAudioQuality(given: .STREAM)
		let path = "https://api.tidal.com/v1/broadcasts/\(broadcastId)/playbackinfo"
		let parameters = "audioquality=\(audioQuality)"

		return try PlaybackInfoFetcher.createUrl(from: "\(path)?\(parameters)")
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
			PlayerWorld.logger?.log(loggable: PlayerLoggable.getPlaybackInfo(error: error))

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
