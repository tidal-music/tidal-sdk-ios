import Auth
import AVFoundation
import Foundation

// MARK: - InternalPlayerLoader

typealias MainPlayerType = GenericMediaPlayer & LiveMediaPlayer & UCMediaPlayer & VideoPlayer

// MARK: - InternalPlayerLoader

final class InternalPlayerLoader: PlayerLoader {
	private let configuration: Configuration
	private let fairPlayLicenseFetcher: FairPlayLicenseFetcher

	private let credentialsProvider: CredentialsProvider

	private let featureFlagProvider: FeatureFlagProvider

	let mainPlayer: MainPlayerType
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
		mainPlayer: MainPlayerType.Type,
		externalPlayers: [GenericMediaPlayer.Type]
	) {
		self.configuration = configuration
		fairPlayLicenseFetcher = fairplayLicenseFetcher
		self.credentialsProvider = credentialsProvider
		self.featureFlagProvider = featureFlagProvider

		let fileManager = PlayerWorld.fileManagerClient
		self.mainPlayer = mainPlayer.init(
			cachePath: fileManager.cachesDirectory(),
			featureFlagProvider: featureFlagProvider
		)

		registerPlayer(self.mainPlayer)

		externalPlayers.forEach { externalPlayerType in
			registerPlayer(
				externalPlayerType.init(
					cachePath: fileManager.cachesDirectory(),
					featureFlagProvider: featureFlagProvider
				)
			)
		}
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

		let player = try getPlayer(
			for: offlinedProduct.audioMode,
			and: offlinedProduct.audioQuality,
			audioCodec: offlinedProduct.audioCodec,
			type: offlinedProduct.productType
		)

		let licenseLoader = offlinedProduct.licenseURL.flatMap {
			StoredLicenseLoader(localLicenseUrl: $0)
		}

		return await player.load(
			offlinedProduct.mediaURL,
			cacheKey: nil,
			loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
			and: licenseLoader
		)
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

		let player = try getPlayer(
			for: storedMediaProduct.audioMode,
			and: storedMediaProduct.audioQuality,
			audioCodec: storedMediaProduct.audioCodec,
			isOfflined: true,
			type: storedMediaProduct.productType
		)

		return await player.load(
			storedMediaProduct.url,
			cacheKey: nil,
			loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
			and: nil
		)
	}

	func load(_ playbackInfo: PlaybackInfo, streamingSessionId: String) async throws -> Asset {
		let loudnessNormalizer = LoudnessNormalizer.create(
			from: playbackInfo,
			preAmp: configuration.currentPreAmpValue
		)

		var licenseLoader: StreamingLicenseLoader?
		if playbackInfo.licenseSecurityToken != nil {
			licenseLoader = StreamingLicenseLoader(
				fairPlayLicenseFetcher: fairPlayLicenseFetcher,
				streamingSessionId: streamingSessionId
			)
		}

		switch playbackInfo.productType {
		case .TRACK:
			let player = try getPlayer(
				for: playbackInfo.audioMode,
				and: playbackInfo.audioQuality,
				with: playbackInfo.mediaType,
				audioCodec: playbackInfo.audioCodec,
				type: playbackInfo.productType
			)
			return await loadTrack(using: playbackInfo, with: loudnessNormalizer, and: licenseLoader, player: player)
		case .VIDEO:
			return await loadVideo(using: playbackInfo, with: loudnessNormalizer, and: licenseLoader, player: mainPlayer)
		case .BROADCAST:
			return await loadBroadcast(using: playbackInfo, and: licenseLoader, player: mainPlayer)
		case .UC:
			return try await loadUC(
				using: playbackInfo,
				with: streamingSessionId,
				and: loudnessNormalizer,
				player: mainPlayer
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
		mainPlayer.renderVideo(in: view)
	}
}

private extension InternalPlayerLoader {
	func registerPlayer(_ player: GenericMediaPlayer) {
		players.append(player)
	}

	func loadTrack(
		using playbackInfo: PlaybackInfo,
		with loudnessNormalizer: LoudnessNormalizer?,
		and licenseLoader: LicenseLoader?,
		player: GenericMediaPlayer
	) async -> Asset {
		var cacheKey: String? = playbackInfo.contentHash
		if playbackInfo.audioQuality == .HI_RES_LOSSLESS {
			// We intentionally disable caching for HiRes LossLess due to its large size
			// and not having the option yet to limit the maximum cache usage
			cacheKey = nil
		}

		let loudnessNormalizationConfiguration = LoudnessNormalizationConfiguration(
			loudnessNormalizationMode: loudnessNormalizationMode,
			loudnessNormalizer: loudnessNormalizer
		)

		return await player.load(
			playbackInfo.url,
			cacheKey: cacheKey,
			loudnessNormalizationConfiguration: loudnessNormalizationConfiguration,
			and: licenseLoader
		)
	}

	func loadBroadcast(
		using playbackInfo: PlaybackInfo,
		and licenseLoader: LicenseLoader?,
		player: LiveMediaPlayer
	) async -> Asset {
		await player.loadLive(playbackInfo.url, with: licenseLoader)
	}

	func loadVideo(
		using playbackInfo: PlaybackInfo,
		with loudnessNormalizer: LoudnessNormalizer?,
		and licenseLoader: LicenseLoader?,
		player: GenericMediaPlayer
	) async -> Asset {
		let loudnessNormalizationConfiguration = LoudnessNormalizationConfiguration(
			loudnessNormalizationMode: loudnessNormalizationMode,
			loudnessNormalizer: loudnessNormalizer
		)
		return await player.load(
			playbackInfo.url,
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
				isOfflined: isOfflined
			)
		}

		guard let matchingPlayer else {
			throw PlayerLoaderError.missingPlayer.error(.PENotSupported)
		}

		return matchingPlayer
	}
}
