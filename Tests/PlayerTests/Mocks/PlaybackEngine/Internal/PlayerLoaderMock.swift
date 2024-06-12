import Auth
import AVFoundation
@testable import Player

final class PlayerLoaderMock: PlayerLoader {
	/// Change it if you would like to make related assertions
	var player = PlayerMock()

	private(set) var loadPlayableStorageItems = [PlayableStorageItem]()
	private(set) var loadStoredMediaProducts = [StoredMediaProduct]()
	private(set) var loadPlaybackInfos = [PlaybackInfo]()
	private(set) var unloadCallCount = 0
	private(set) var resetCallCount = 0

	required init(
		with configuration: Configuration,
		and fairplayLicenseFetcher: FairPlayLicenseFetcher,
		featureFlagProvider: FeatureFlagProvider = .mock,
		credentialsProvider: CredentialsProvider = CredentialsProviderMock(),
		mainPlayer: (GenericMediaPlayer & LiveMediaPlayer & UCMediaPlayer & VideoPlayer).Type = PlayerMock.self,
		externalPlayers: [GenericMediaPlayer.Type] = []
	) {}

	convenience init() {
		self.init(
			with: Configuration.mock(),
			and: FairPlayLicenseFetcher.mock(),
			featureFlagProvider: .mock,
			externalPlayers: []
		)
	}

	func load(_ playbableStorageItem: PlayableStorageItem) async -> Asset {
		loadPlayableStorageItems.append(playbableStorageItem)
		return player.load()
	}

	func load(_ storedMediaProduct: StoredMediaProduct) async -> Asset {
		loadStoredMediaProducts.append(storedMediaProduct)
		return player.load()
	}

	func load(_ playbackInfo: PlaybackInfo, streamingSessionId: String) async -> Asset {
		loadPlaybackInfos.append(playbackInfo)
		return player.load()
	}

	func unload() {
		unloadCallCount += 1
		player.unload()
	}

	func reset() {
		resetCallCount += 1
		player.reset()
	}

	func renderVideo(in view: AVPlayerLayer) {}
}
