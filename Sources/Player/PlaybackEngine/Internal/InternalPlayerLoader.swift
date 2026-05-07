import Auth
import AVFoundation
import Foundation

// MARK: - InternalPlayerLoader

final class InternalPlayerLoader: PlayerLoader {
	private var configuration: Configuration
	private let fairPlayLicenseFetcher: FairPlayLicenseFetcher

	private let credentialsProvider: CredentialsProvider

	private let featureFlagProvider: FeatureFlagProvider

	private let crossfadePlayer: CrossfadingPlayerWrapper
	private let videoPlayer: AVQueuePlayerWrapper
	var players: [GenericMediaPlayer] = []

	// MARK: - Convenience properties

	private var loudnessNormalizationMode: LoudnessNormalizationMode {
		configuration.loudnessNormalizationMode
	}

	// MARK: Initialization

	required init(
		with configuration: Configuration,
		and fairplayLicenseFetcher: FairPlayLicenseFetcher,
		featureFlagProvider: FeatureFlagProvider,
		credentialsProvider: CredentialsProvider,
		avQueuePlayerWrapper: AVQueuePlayerWrapper,
		crossfadingPlayerWrapper: CrossfadingPlayerWrapper,
		externalPlayers: [GenericMediaPlayer.Type]
	) {
		self.configuration = configuration
		fairPlayLicenseFetcher = fairplayLicenseFetcher
		self.credentialsProvider = credentialsProvider
		self.featureFlagProvider = featureFlagProvider
		crossfadePlayer = crossfadingPlayerWrapper
		crossfadePlayer.crossfadeDuration = configuration.crossfadeDuration
		videoPlayer = avQueuePlayerWrapper

		let fileManager = PlayerWorld.fileManagerClient
		let cachePath = fileManager.cachesDirectory()

		externalPlayers.forEach { externalPlayerType in
			registerPlayer(
				externalPlayerType.init(
					cachePath: cachePath,
					featureFlagProvider: featureFlagProvider
				)
			)
		}

		registerPlayer(crossfadingPlayerWrapper)
		registerPlayer(videoPlayer)
	}

	func updateConfiguration(_ configuration: Configuration) {
		self.configuration = configuration
		crossfadePlayer.crossfadeDuration = configuration.crossfadeDuration
	}

	func load(_ offlinedProduct: PlayableOfflinedMediaProduct) async throws -> Asset {
		let loudnessNormalizer = LoudnessNormalizer.create(
			from: offlinedProduct,
			preAmp: configuration.currentPreAmpValue
		)
		let loudnessNormalizationConfiguration = LoudnessNormalizationConfiguration(
			loudnessNormalizationMode: loudnessNormalizationMode,
			loudnessNormalizer: loudnessNormalizer
		)

		let licenseLoader = offlinedProduct.licenseURL.flatMap {
			StoredLicenseLoader(localLicenseUrl: $0)
		}

		switch offlinedProduct.productType {
		case .TRACK:
			let player = try getPlayer(
				for: offlinedProduct.audioMode,
				and: offlinedProduct.audioQuality,
				with: offlinedProduct.mediaType,
				audioCodec: offlinedProduct.audioCodec,
				isOfflined: true,
				type: offlinedProduct.productType
			)
			return await loadTrack(
				url: offlinedProduct.mediaURL,
				loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
				licenseLoader: licenseLoader,
				player: player
			)
		case .VIDEO:
			return await loadVideo(
				url: offlinedProduct.mediaURL,
				loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
				licenseLoader: licenseLoader
			)
		case .UC:
			return await loadUC(
				url: offlinedProduct.mediaURL,
				loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
				licenseLoader: licenseLoader
			)
		}
	}

	func load(_ storedMediaProduct: StoredMediaProduct) async throws -> Asset {
		let loudnessNormalizer = LoudnessNormalizer.create(
			from: storedMediaProduct,
			preAmp: configuration.currentPreAmpValue
		)
		let loudnessNormalizationConfiguration = LoudnessNormalizationConfiguration(
			loudnessNormalizationMode: loudnessNormalizationMode,
			loudnessNormalizer: loudnessNormalizer
		)

		switch storedMediaProduct.productType {
		case .TRACK:
			let player = try getPlayer(
				for: storedMediaProduct.audioMode,
				and: storedMediaProduct.audioQuality,
				with: MediaTypes.BTS,
				audioCodec: storedMediaProduct.audioCodec,
				isOfflined: true,
				type: storedMediaProduct.productType
			)
			return await loadTrack(
				url: storedMediaProduct.url,
				loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
				licenseLoader: nil,
				player: player
			)
		case .VIDEO:
			return await loadVideo(
				url: storedMediaProduct.url,
				loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
				licenseLoader: nil
			)
		case .UC:
			return await loadUC(
				url: storedMediaProduct.url,
				loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
				licenseLoader: nil
			)
		}
	}

	func load(_ item: OfflinePlaybackItem) async throws -> Asset {
		let loudnessNormalizer = LoudnessNormalizer(
			preAmp: configuration.currentPreAmpValue,
			replayGain: item.albumReplayGain,
			peakAmplitude: item.albumPeakAmplitude
		)
		let loudnessNormalizationConfiguration = LoudnessNormalizationConfiguration(
			loudnessNormalizationMode: loudnessNormalizationMode,
			loudnessNormalizer: loudnessNormalizer
		)

		let playbackMetadata = item.format.flatMap { AssetPlaybackMetadata(formatString: $0) }

		let licenseLoader = item.licenseURL.flatMap {
			StoredLicenseLoader(localLicenseUrl: $0)
		}

		switch item.productType {
		case .TRACK:
			let player = try getPlayer(
				for: playbackMetadata?.audioMode,
				and: playbackMetadata?.audioQuality,
				with: nil,
				audioCodec: AudioCodec(from: playbackMetadata?.audioQuality, mode: playbackMetadata?.audioMode),
				isOfflined: true,
				type: item.productType
			)
			return await loadTrack(
				url: item.mediaURL,
				loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
				licenseLoader: licenseLoader,
				player: player
			)
		case .VIDEO:
			return await loadVideo(
				url: item.mediaURL,
				loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
				licenseLoader: licenseLoader
			)
		case .UC:
			return await loadUC(
				url: item.mediaURL,
				loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
				licenseLoader: licenseLoader
			)
		}
	}

	func load(_ playbackInfo: PlaybackInfo, streamingSessionId: String) async throws -> Asset {
		let loudnessNormalizer = LoudnessNormalizer.create(
			from: playbackInfo,
			preAmp: configuration.currentPreAmpValue
		)

		var licenseLoader: StreamingLicenseLoader?
		// Skip license loader on simulator since AVContentKeySession doesn't support FairPlay
		if !PlayerWorld.isSimulator,
		   playbackInfo.licenseSecurityToken != nil || playbackInfo.productType == .TRACK {
			licenseLoader = StreamingLicenseLoader(
				fairPlayLicenseFetcher: fairPlayLicenseFetcher,
				streamingSessionId: streamingSessionId,
				featureFlagProvider: featureFlagProvider
			)
		}

		let loudnessNormalizationConfiguration = LoudnessNormalizationConfiguration(
			loudnessNormalizationMode: loudnessNormalizationMode,
			loudnessNormalizer: loudnessNormalizer
		)

		switch playbackInfo.productType {
		case .TRACK:
			let player = try getPlayer(
				for: playbackInfo.audioMode,
				and: playbackInfo.audioQuality,
				with: playbackInfo.mediaType,
				audioCodec: playbackInfo.audioCodec,
				isOfflined: false,
				type: playbackInfo.productType
			)
			let asset = await loadTrack(
				url: playbackInfo.url,
				loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
				licenseLoader: licenseLoader,
				player: player
			)
			asset.setAdaptiveAudioQualities(playbackInfo.adaptiveAudioQualities)
			return asset
		case .VIDEO:
			return await loadVideo(
				url: playbackInfo.url,
				loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
				licenseLoader: licenseLoader
			)
		case .UC:
			return try await loadUC(
				using: playbackInfo,
				with: streamingSessionId,
				and: loudnessNormalizer,
				player: videoPlayer
			)
		}
	}

	func unload() {
		players.forEach { $0.unload() }
	}

	func reset() {
		players.forEach { $0.reset() }
	}

	func renderVideo(in view: AVPlayerLayer) {
		videoPlayer.renderVideo(in: view)
	}
}

private extension InternalPlayerLoader {
	func registerPlayer(_ player: GenericMediaPlayer) {
		players.append(player)
	}

	func loadTrack(
		url: URL,
		loudnessNormalizationConfiguration: LoudnessNormalizationConfiguration,
		licenseLoader: LicenseLoader?,
		player: GenericMediaPlayer
	) async -> Asset {
		await player.load(
			url,
			cacheKey: nil,
			loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
			and: licenseLoader
		)
	}

	func loadVideo(
		url: URL,
		loudnessNormalizationConfiguration: LoudnessNormalizationConfiguration,
		licenseLoader: LicenseLoader?
	) async -> Asset {
		await videoPlayer.load(
			url,
			cacheKey: nil,
			loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
			and: licenseLoader
		)
	}

	func loadUC(
		url: URL,
		loudnessNormalizationConfiguration: LoudnessNormalizationConfiguration,
		licenseLoader: LicenseLoader?
	) async -> Asset {
		await videoPlayer.load(
			url,
			cacheKey: nil,
			loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
			and: licenseLoader
		)
	}

	func loadUC(
		using playbackInfo: PlaybackInfo,
		with streamingSessionId: String,
		and loudnessNormalizer: LoudnessNormalizer?,
		player: UCMediaPlayer
	) async throws -> Asset {
		do {
			let loudnessNormalizationConfiguration = LoudnessNormalizationConfiguration(
				loudnessNormalizationMode: loudnessNormalizationMode,
				loudnessNormalizer: loudnessNormalizer
			)

			let token: String = try await credentialsProvider.getAuthBearerToken()

			let headers: [String: String] = [
				"Authorization": token,
				"X-Tidal-Streaming-Session-Id": streamingSessionId,
			]

			return await player.loadUC(
				playbackInfo.url,
				loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
				headers: headers
			)

		} catch {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.loadUCFailed(error: error))
			throw error
		}
	}

	func getPlayer(
		for audioMode: AudioMode?,
		and audioQuality: AudioQuality?,
		with mediaType: String? = nil,
		audioCodec: AudioCodec? = nil,
		isOfflined: Bool = false,
		type productType: ProductType
	) throws -> GenericMediaPlayer {
		let matchingPlayer = players.first { player in
			player.canPlay(
				productType: productType,
				codec: audioCodec ?? AudioCodec(
					from: audioQuality,
					mode: audioMode
				),
				mediaType: mediaType,
				isOfflined: isOfflined,
				crossfade: configuration.crossfadeDuration > 0
			)
		}

		guard let matchingPlayer else {
			throw PlayerLoaderError.missingPlayer.error(.PENotSupported)
		}

		return matchingPlayer
	}
}
