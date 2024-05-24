import Auth
import AVFoundation
import EventProducer
import Foundation

// swiftlint:disable file_length
// swiftlint:disable:next identifier_name
var PlayerWorld = PlayerWorldClient.live

// MARK: - Player

public final class Player {
	// MARK: - Singleton properties

	static var shared: Player?

	// MARK: - Atomic properties

	@Atomic
	private(set) var playerEngine: PlayerEngine
	@Atomic
	var offlineEngine: OfflineEngine?
	@Atomic
	var userConfiguration: UserConfiguration?

	// MARK: - Properties

	private let queue: OperationQueue

	/// Configuration of the player
	private let playerURLSession: URLSession

	/// - Important: After the configuration is set, the configuration updates down the stream to make sure the change effect is
	/// immediate.
	public var configuration: Configuration {
		// After receiving a new value, we need to update the configuration of the player
		// so that it can perform necessary updates regarding the loudness normalization
		// immediately.
		didSet {
			playerEngine.updateConfiguration(configuration)
			streamingPrivilegesHandler.updateConfiguration(configuration)
		}
	}

	private var storage: Storage
	private var djProducer: DJProducer
	private var playerEventSender: PlayerEventSender
	private var fairplayLicenseFetcher: FairPlayLicenseFetcher
	private var streamingPrivilegesHandler: StreamingPrivilegesHandler
	private var networkMonitor: NetworkMonitor
	private var notificationsHandler: NotificationsHandler
	private let featureFlagProvider: FeatureFlagProvider
	private var registeredPlayers: [GenericMediaPlayer.Type] = []
	private let credentialsProvider: CredentialsProvider

	// MARK: - Initialization

	init(
		queue: OperationQueue,
		urlSession: URLSession,
		configuration: Configuration,
		storage: Storage,
		djProducer: DJProducer,
		playerEventSender: PlayerEventSender,
		fairplayLicenseFetcher: FairPlayLicenseFetcher,
		streamingPrivilegesHandler: StreamingPrivilegesHandler,
		networkMonitor: NetworkMonitor,
		notificationsHandler: NotificationsHandler,
		playerEngine: PlayerEngine,
		offlineEngine: OfflineEngine?,
		featureFlagProvider: FeatureFlagProvider,
		externalPlayers: [GenericMediaPlayer.Type],
		credentialsProvider: CredentialsProvider
	) {
		self.queue = queue
		playerURLSession = urlSession
		self.configuration = configuration
		self.storage = storage
		self.djProducer = djProducer
		self.fairplayLicenseFetcher = fairplayLicenseFetcher
		self.streamingPrivilegesHandler = streamingPrivilegesHandler
		self.networkMonitor = networkMonitor
		self.playerEventSender = playerEventSender
		self.notificationsHandler = notificationsHandler
		self.playerEngine = playerEngine
		self.offlineEngine = offlineEngine
		self.featureFlagProvider = featureFlagProvider
		registeredPlayers = externalPlayers
		self.credentialsProvider = credentialsProvider
	}
}

public extension Player {
	/// Bootstraps Player and returns the instance.
	/// - Important: It must be called only once when initializing it so it is caller responsibility to keep the reference to it,
	/// otherwise it will return nil.
	/// - Parameters:
	///   - clientToken: The client token that was used to create the access token.
	///   - clientVersion: App version.
	///   - listener: Listener for relevant changes of Player instance.
	///   - listenerQueue: Queue in which the listener post notifications of relevant changes if Player instance.
	///   - featureFlagProvider: A provider of feature flags.
	///   - externalPlayers: Array with external players to be used
	///   - credentialsProvider: Provider of credentials used to authenticate the user.
	///   - eventSender: Event sender to which events are sent.
	/// - Returns: Instance of Player if not initialized yet, or nil if initized already.
	static func bootstrap(
		clientToken: String,
		listener: PlayerListener,
		listenerQueue: DispatchQueue = .main,
		featureFlagProvider: FeatureFlagProvider = .standard,
		externalPlayers: [GenericMediaPlayer.Type] = [],
		credentialsProvider: CredentialsProvider,
		eventSender: EventSender
	) -> Player? {
		if shared != nil {
			return nil
		}

		Time.initialise()

		let timeoutPolicy = TimeoutPolicy.standard
		let sharedPlayerURLSession = URLSession.new(with: timeoutPolicy, name: "Player Player", serviceType: .responsiveAV)
		let configuration = Configuration(clientToken: clientToken)
		let storage = Storage()

		let djProducerTimeoutPolicy = TimeoutPolicy.shortLived
		let djProducerSession = URLSession.new(with: djProducerTimeoutPolicy, name: "Player DJ Session")
		let djProducerHTTPClient = HttpClient(using: djProducerSession)

		let djProducer = DJProducer(
			httpClient: djProducerHTTPClient,
			credentialsProvider: credentialsProvider,
			featureFlagProvider: featureFlagProvider
		)

		let playerEventSender = PlayerEventSender(
			configuration: configuration,
			httpClient: HttpClient(using: URLSession.new(
				with: timeoutPolicy,
				serviceType: .background
			)),
			credentialsProvider: credentialsProvider,
			dataWriter: DataWriter(),
			featureFlagProvider: featureFlagProvider,
			eventSender: eventSender
		)
		let fairplayLicenseFetcher = FairPlayLicenseFetcher(
			with: HttpClient(using: sharedPlayerURLSession),
			credentialsProvider: credentialsProvider,
			and: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)

		let streamingPrivilegesHandler = StreamingPrivilegesHandler(
			configuration: configuration,
			httpClient: HttpClient(using: URLSession.new(with: timeoutPolicy, serviceType: .default)),
			credentialsProvider: credentialsProvider
		)

		let networkMonitor = NetworkMonitor()
		let notificationsHandler = NotificationsHandler(listener: listener, queue: listenerQueue)

		let playerEngine = Player.newPlayerEngine(
			sharedPlayerURLSession,
			configuration,
			storage,
			djProducer,
			fairplayLicenseFetcher,
			networkMonitor,
			playerEventSender,
			notificationsHandler,
			featureFlagProvider,
			externalPlayers,
			credentialsProvider
		)

		var offlineEngine: OfflineEngine?
		if PlayerWorld.developmentFeatureFlagProvider.isOffliningEnabled {
			let offlinerHttpClient = HttpClient(using: URLSession.new(with: timeoutPolicy))
			let playbackInfoFetcher = PlaybackInfoFetcher(
				with: configuration,
				offlinerHttpClient,
				credentialsProvider,
				networkMonitor,
				and: playerEventSender,
				featureFlagProvider: featureFlagProvider
			)
			let downloader = Downloader(
				playbackInfoFetcher: playbackInfoFetcher,
				fairPlayLicenseFetcher: fairplayLicenseFetcher,
				networkMonitor: networkMonitor
			)

			offlineEngine = OfflineEngine(downloader: downloader, offlineStorage: storage, playerEventSender: playerEventSender)
		}

		shared = Player(
			queue: OperationQueue.new(),
			urlSession: sharedPlayerURLSession,
			configuration: configuration,
			storage: storage,
			djProducer: djProducer,
			playerEventSender: playerEventSender,
			fairplayLicenseFetcher: fairplayLicenseFetcher,
			streamingPrivilegesHandler: streamingPrivilegesHandler,
			networkMonitor: networkMonitor,
			notificationsHandler: notificationsHandler,
			playerEngine: playerEngine,
			offlineEngine: offlineEngine,
			featureFlagProvider: featureFlagProvider,
			externalPlayers: externalPlayers,
			credentialsProvider: credentialsProvider
		)

		return shared
	}

	func setUpUserConfiguration(_ userConfiguration: UserConfiguration) {
		queue.dispatch {
			self.userConfiguration = userConfiguration
			self.playerEventSender.updateUserConfiguration(userConfiguration: userConfiguration)
			self.streamingPrivilegesHandler.disconnect()
		}
	}

	func shutdown() {
		reset()
	}

	func load(_ mediaProduct: MediaProduct) {
		let time = PlayerWorld.timeProvider.timestamp()
		queue.dispatch {
			self.playerEngine.notificationsHandler = nil
			self.playerEngine.reset()

			self.playerEngine = Player.newPlayerEngine(
				self.playerURLSession,
				self.configuration,
				self.storage,
				self.djProducer,
				self.fairplayLicenseFetcher,
				self.networkMonitor,
				self.playerEventSender,
				self.notificationsHandler,
				self.featureFlagProvider,
				self.registeredPlayers,
				self.credentialsProvider
			)

			self.djProducer.delegate = self.playerEngine

			self.streamingPrivilegesHandler.delegate = self.playerEngine

			self.playerEngine.load(mediaProduct, timestamp: time, isPreload: false)
		}
	}

	func preload(_ mediaProduct: MediaProduct) -> PlayerLoaderHandle {
		let time = PlayerWorld.timeProvider.timestamp()

		let internalPlayerLoader = InternalPlayerLoader(
			with: configuration,
			and: fairplayLicenseFetcher,
			featureFlagProvider: featureFlagProvider,
			credentialsProvider: credentialsProvider,
			mainPlayer: AVQueuePlayerWrapper.self,
			externalPlayers: registeredPlayers
		)

		let player = PlayerEngine(
			with: OperationQueue.new(),
			HttpClient(using: playerURLSession),
			credentialsProvider,
			fairplayLicenseFetcher,
			djProducer,
			configuration,
			playerEventSender,
			networkMonitor,
			storage,
			internalPlayerLoader,
			featureFlagProvider,
			nil // We don't want to notify the client about this player yet
		)

		player.load(mediaProduct, timestamp: time, isPreload: true)

		return PlayerLoaderHandle(product: mediaProduct, player: player)
	}

	func setNext(_ mediaProduct: MediaProduct?) {
		let time = PlayerWorld.timeProvider.timestamp()
		queue.dispatch {
			self.playerEngine.setNext(mediaProduct, timestamp: time)
		}
	}

	func skipToNext() {
		let now = PlayerWorld.timeProvider.timestamp()
		queue.dispatch {
			self.playerEngine.skipToNext(timestamp: now)
		}
	}

	func reset() {
		queue.dispatch {
			self.djProducer.stop(immediately: true)
			self.playerEngine.reset()
		}
	}

	func play() {
		let time = PlayerWorld.timeProvider.timestamp()
		queue.dispatch {
			self.playerEngine.play(timestamp: time)

			SafeTask {
				await self.streamingPrivilegesHandler.notify()
			}
		}
	}

	func play(_ handle: PlayerLoaderHandle) {
		let time = PlayerWorld.timeProvider.timestamp()
		queue.dispatch {
			self.playerEngine.notificationsHandler = nil
			self.playerEngine.reset()

			self.playerEngine = handle.player
			self.playerEngine.notificationsHandler = self.notificationsHandler
			self.djProducer.delegate = self.playerEngine
			self.streamingPrivilegesHandler.delegate = self.playerEngine

			self.playerEngine.play(timestamp: time)

			SafeTask {
				await self.streamingPrivilegesHandler.notify()
			}
		}
	}

	func pause() {
		queue.dispatch {
			self.playerEngine.pause()
		}
	}

	func seek(_ time: Double) {
		queue.dispatch {
			self.playerEngine.seek(time)
		}
	}

	func getAssetPosition() -> Double? {
		playerEngine.getAssetPosition()
	}

	func getActiveMediaProduct() -> MediaProduct? {
		playerEngine.getActiveMediaProduct()
	}

	func getActivePlaybackContext() -> PlaybackContext? {
		playerEngine.getActivePlaybackContext()
	}

	func getState() -> State {
		playerEngine.getState()
	}

	func renderVideo(in view: AVPlayerLayer) {
		queue.dispatch {
			self.playerEngine.renderVideo(in: view)
		}
	}

	func startDjSession(title: String) {
		queue.dispatch {
			let now = PlayerWorld.timeProvider.timestamp()
			self.playerEngine.startDjSession(title: title, timestamp: now)
		}
	}

	func stopDjSession(immediately: Bool = true) {
		queue.dispatch {
			self.playerEngine.stopDjSession(immediately: immediately)
		}
	}

	func isLive() -> Bool {
		djProducer.isLive
	}
}

private extension Player {
	static func newPlayerEngine(
		_ urlSession: URLSession,
		_ configuration: Configuration,
		_ storage: Storage,
		_ djProducer: DJProducer,
		_ fairplayLicenseFetcher: FairPlayLicenseFetcher,
		_ networkMonitor: NetworkMonitor,
		_ playerEventSender: PlayerEventSender,
		_ notificationsHandler: NotificationsHandler?,
		_ featureFlagProvider: FeatureFlagProvider,
		_ externalPlayers: [GenericMediaPlayer.Type],
		_ credentialsProvider: CredentialsProvider
	) -> PlayerEngine {
		let internalPlayerLoader = InternalPlayerLoader(
			with: configuration,
			and: fairplayLicenseFetcher,
			featureFlagProvider: featureFlagProvider,
			credentialsProvider: credentialsProvider,
			mainPlayer: AVQueuePlayerWrapper.self,
			externalPlayers: externalPlayers
		)

		let playerInstance = PlayerEngine(
			with: OperationQueue.new(),
			HttpClient(using: urlSession),
			credentialsProvider,
			fairplayLicenseFetcher,
			djProducer,
			configuration,
			playerEventSender,
			networkMonitor,
			storage,
			internalPlayerLoader,
			featureFlagProvider,
			notificationsHandler
		)

		return playerInstance
	}
}

private extension OperationQueue {
	static func new() -> OperationQueue {
		let playerOperationQueue = OperationQueue()
		playerOperationQueue.qualityOfService = .userInitiated
		playerOperationQueue.maxConcurrentOperationCount = 1

		return playerOperationQueue
	}
}

// swiftlint:enable file_length
