import Auth
import AVFoundation
import Foundation

// MARK: - PlayerLoaderError

enum PlayerLoaderError: Int {
	case missingPlayer = 1

	func error(_ errorId: ErrorId) -> Error {
		PlayerInternalError(
			errorId: errorId,
			errorType: .playerLoaderError,
			code: rawValue
		)
	}
}

// MARK: - PlayerLoader

protocol PlayerLoader: AnyObject {
	init(
		with configuration: Configuration,
		and fairplayLicenseFetcher: FairPlayLicenseFetcher,
		featureFlagProvider: FeatureFlagProvider,
		credentialsProvider: CredentialsProvider,
		mainPlayer: (GenericMediaPlayer & LiveMediaPlayer & UCMediaPlayer & VideoPlayer).Type,
		externalPlayers: [GenericMediaPlayer.Type]
	)

	func load(_ playbableStorageItem: PlayableStorageItem) async throws -> Asset

	func load(_ storedMediaProduct: StoredMediaProduct) async throws -> Asset

	func load(_ playbackInfo: PlaybackInfo, streamingSessionId: String) async throws -> Asset

	func unload()

	func reset()

	func renderVideo(in view: AVPlayerLayer)
}
