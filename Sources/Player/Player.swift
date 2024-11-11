import Auth
import AVFoundation
import EventProducer
import Foundation
import GRDB

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
	private(set) var offlineStorage: OfflineStorage

	@Atomic
	private(set) var offlineEngine: OfflineEngine

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
			offlineEngine.updateConfiguration(configuration)
			streamingPrivilegesHandler.updateConfiguration(configuration)
		}
	}

	private var djProducer: DJProducer
	private var playerEventSender: PlayerEventSender
	private var fairplayLicenseFetcher: FairPlayLicenseFetcher
	private var streamingPrivilegesHandler: StreamingPrivilegesHandler
	private var networkMonitor: NetworkMonitor
	private var notificationsHandler: NotificationsHandler
	private let featureFlagProvider: FeatureFlagProvider
	private var externalPlayersSupplier: (() -> [GenericMediaPlayer.Type])?
	private let credentialsProvider: CredentialsProvider
	private let offlinePlaybackPrivilegeCheck: (() -> Bool)?

	// MARK: - Initialization

	init(
		queue: OperationQueue,
		urlSession: URLSession,
		configuration: Configuration,
		offlineStorage: OfflineStorage,
		djProducer: DJProducer,
		playerEventSender: PlayerEventSender,
		fairplayLicenseFetcher: FairPlayLicenseFetcher,
		streamingPrivilegesHandler: StreamingPrivilegesHandler,
		networkMonitor: NetworkMonitor,
		notificationsHandler: NotificationsHandler,
		playerEngine: PlayerEngine,
		offlineEngine: OfflineEngine,
		featureFlagProvider: FeatureFlagProvider,
		externalPlayersSupplier: (() -> [GenericMediaPlayer.Type])?,
		credentialsProvider: CredentialsProvider,
		offlinePlaybackPrivilegeCheck: (() -> Bool)?
	) {
		self.queue = queue
		playerURLSession = urlSession
		self.configuration = configuration
		self.offlineStorage = offlineStorage
		self.djProducer = djProducer
		self.fairplayLicenseFetcher = fairplayLicenseFetcher
		self.streamingPrivilegesHandler = streamingPrivilegesHandler
		self.networkMonitor = networkMonitor
		self.playerEventSender = playerEventSender
		self.notificationsHandler = notificationsHandler
		self.playerEngine = playerEngine
		self.offlineEngine = offlineEngine
		self.featureFlagProvider = featureFlagProvider
		self.externalPlayersSupplier = externalPlayersSupplier
		self.credentialsProvider = credentialsProvider
		self.offlinePlaybackPrivilegeCheck = offlinePlaybackPrivilegeCheck
	}
}

public extension Player {
	/// Bootstraps Player and returns the instance.
	/// - Important: It must be called only once when initializing it so it is caller responsibility to keep the reference to it,
	/// otherwise it will return nil.
	/// - Parameters:
	///   - listener: Listener for relevant changes of Player instance.
	///   - listenerQueue: Queue in which the listener post notifications of relevant changes if Player instance.
	///   - featureFlagProvider: A provider of feature flags.
	///   - externalPlayers: Array with external players to be used
	///   - credentialsProvider: Provider of credentials used to authenticate the user.
	///   - eventSender: Event sender to which events are sent.
	///   - userClientIdSupplier: Optional function block to supply user cliend id.
	///   - shouldAddLogging: Flag whether we should add logging. Default is false, meaning in places where logger is used, no
	/// logging is actually performed.
	/// - Returns: Instance of Player if not initialized yet, or nil if initized already.
	static func bootstrap(
		playerListener: PlayerListener,
		offlineEngineListener: OfflineEngineListener? = nil,
		listenerQueue: DispatchQueue = .main,
		featureFlagProvider: FeatureFlagProvider = .standard,
		credentialsProvider: CredentialsProvider,
		eventSender: EventSender,
		externalPlayersSupplier: (() -> [GenericMediaPlayer.Type])? = nil,
		userClientIdSupplier: (() -> Int)? = nil,
		shouldAddLogging: Bool = false,
		offlinePlaybackPrivilegeCheck: (() -> Bool)? = nil
	) -> Player? {
		if shared != nil {
			return nil
		}

		guard let offlineStorage = Player.initializedOfflineStorage() else {
			return nil
		}

		Time.initialise()

		// When we have logging enabled, we create a logger to be used inside Player module and set it in PlayerWorld.
		if shouldAddLogging {
			PlayerWorld.logger = TidalLogger(label: "Player", level: .trace)
		}

		let timeoutPolicy = TimeoutPolicy.standard
		let sharedPlayerURLSession = URLSession.new(with: timeoutPolicy, name: "Player Player", serviceType: .responsiveAV)
		let configuration = Configuration()

		// DJProducer Initialization
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
			eventSender: eventSender,
			userClientIdSupplier: userClientIdSupplier
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
		let notificationsHandler = NotificationsHandler(
			listener: playerListener,
			offlineEngineListener: offlineEngineListener,
			queue: listenerQueue
		)

		let offlineEngine = Player.newOfflineEngine(
			offlineStorage,
			configuration,
			playerEventSender,
			networkMonitor,
			fairplayLicenseFetcher,
			featureFlagProvider,
			credentialsProvider,
			notificationsHandler
		)

		let playerEngine = Player.newPlayerEngine(
			sharedPlayerURLSession,
			configuration,
			offlineStorage,
			djProducer,
			fairplayLicenseFetcher,
			networkMonitor,
			playerEventSender,
			notificationsHandler,
			featureFlagProvider,
			externalPlayersSupplier,
			credentialsProvider,
			offlinePlaybackPrivilegeCheck
		)

		shared = Player(
			queue: OperationQueue.new(),
			urlSession: sharedPlayerURLSession,
			configuration: configuration,
			offlineStorage: offlineStorage,
			djProducer: djProducer,
			playerEventSender: playerEventSender,
			fairplayLicenseFetcher: fairplayLicenseFetcher,
			streamingPrivilegesHandler: streamingPrivilegesHandler,
			networkMonitor: networkMonitor,
			notificationsHandler: notificationsHandler,
			playerEngine: playerEngine,
			offlineEngine: offlineEngine,
			featureFlagProvider: featureFlagProvider,
			externalPlayersSupplier: externalPlayersSupplier,
			credentialsProvider: credentialsProvider,
			offlinePlaybackPrivilegeCheck: offlinePlaybackPrivilegeCheck
		)

		return shared
	}

	func shutdown() {
		reset()
	}

	func load(_ mediaProduct: MediaProduct) {
		let time = PlayerWorld.timeProvider.timestamp()
		queue.dispatch {
			self.playerEngine.notificationsHandler = nil
			self.playerEngine.resetOrUnload()

			self.playerEngine = self.instantiatedPlayerEngine(self.notificationsHandler)

			self.djProducer.delegate = self.playerEngine

			self.streamingPrivilegesHandler.delegate = self.playerEngine

			self.playerEngine.load(mediaProduct, timestamp: time, isPreload: false)
		}
	}

	func preload(_ mediaProduct: MediaProduct) -> PlayerLoaderHandle {
		let time = PlayerWorld.timeProvider.timestamp()

		// We don't want to notify the client about this player yet
		let player = instantiatedPlayerEngine(nil)

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
			self.playerEngine.resetOrUnload()

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

	/// Offlines a media product at first convenient time, using configured settings.
	/// Async and thread safe. If returns true, progress can be tracked via OfflineStartedMessage, OfflineProgressMessage,
	/// OfflineDoneMessage and OfflineFailedMessage.
	/// - Parameters:
	///   - mediaProduct: The media product to offline
	/// - Returns: True if an offline job is created, false otherwise.
	func offline(mediaProduct: MediaProduct) -> Bool {
		offlineEngine.offline(mediaProduct: mediaProduct)
	}

	/// Deletes an offlined media product. No difference is made between queued, executing or done offlines. Everything is removed
	/// for the media product.
	/// Async and thread safe. If returns true, progress can be tracked via OfflineDeletedMessage.
	/// - Parameters:
	///   - mediaProduct: Media product to delete offline for
	/// - Returns: True if a delete job is created, False otherwise.
	func deleteOffline(mediaProduct: MediaProduct) -> Bool {
		offlineEngine.deleteOffline(mediaProduct: mediaProduct)
	}

	/// All offlined media products will be deleted. All queued, executing and done offlines will be deleted.
	/// Async and thread safe. If returns true, progress can be tracked via AllOfflinesDeletedMessage.
	/// - Returns: True if a delete all offlines job is created, False otherwise.
	func deleteAllOfflines() -> Bool {
		offlineEngine.deleteAllOfflinedMediaProducts()
	}

	/// Returns offline state of a media product.
	/// Thread safe.
	/// - Parameters:
	///   - mediaProduct: Media product to gett offline state for.
	/// - Returns: The state mediaProduct is in.
	func getOfflineState(mediaProduct: MediaProduct) -> OfflineState {
		offlineEngine.getOfflineState(mediaProduct: mediaProduct)
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
	func instantiatedPlayerEngine(_ notificationsHandler: NotificationsHandler?) -> PlayerEngine {
		Player.newPlayerEngine(
			playerURLSession,
			configuration,
			offlineStorage,
			djProducer,
			fairplayLicenseFetcher,
			networkMonitor,
			playerEventSender,
			notificationsHandler,
			featureFlagProvider,
			externalPlayersSupplier,
			credentialsProvider,
			offlinePlaybackPrivilegeCheck
		)
	}

	static func newPlayerEngine(
		_ urlSession: URLSession,
		_ configuration: Configuration,
		_ offlineStorage: OfflineStorage?,
		_ djProducer: DJProducer,
		_ fairplayLicenseFetcher: FairPlayLicenseFetcher,
		_ networkMonitor: NetworkMonitor,
		_ playerEventSender: PlayerEventSender,
		_ notificationsHandler: NotificationsHandler?,
		_ featureFlagProvider: FeatureFlagProvider,
		_ externalPlayersSupplier: (() -> [GenericMediaPlayer.Type])?,
		_ credentialsProvider: CredentialsProvider,
		_ offlinePlaybackPrivilegeCheck: (() -> Bool)?
	) -> PlayerEngine {
		let internalPlayerLoader = InternalPlayerLoader(
			with: configuration,
			and: fairplayLicenseFetcher,
			featureFlagProvider: featureFlagProvider,
			credentialsProvider: credentialsProvider,
			mainPlayer: Player.mainPlayerType(featureFlagProvider),
			externalPlayers: externalPlayersSupplier?() ?? []
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
			offlineStorage,
			offlinePlaybackPrivilegeCheck,
			internalPlayerLoader,
			featureFlagProvider,
			notificationsHandler
		)

		return playerInstance
	}

	static func initializedOfflineStorage() -> OfflineStorage? {
		GRDBOfflineStorage.withDefaultDatabase()
	}

	static func newOfflineEngine(
		_ storage: OfflineStorage,
		_ configuration: Configuration,
		_ playerEventSender: PlayerEventSender,
		_ networkMonitor: NetworkMonitor,
		_ fairplayLicenseFetcher: FairPlayLicenseFetcher,
		_ featureFlagProvider: FeatureFlagProvider,
		_ credentialsProvider: CredentialsProvider,
		_ notificationsHandler: NotificationsHandler
	) -> OfflineEngine {
		let offlinerPlaybackInfoFetcher = PlaybackInfoFetcher(
			with: configuration,
			HttpClient(using: URLSession.new(with: TimeoutPolicy.standard)),
			credentialsProvider,
			networkMonitor,
			and: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)
		let downloader = Downloader(
			playbackInfoFetcher: offlinerPlaybackInfoFetcher,
			fairPlayLicenseFetcher: fairplayLicenseFetcher,
			networkMonitor: networkMonitor
		)
		return OfflineEngine(
			downloader: downloader,
			offlineStorage: storage,
			playerEventSender: playerEventSender,
			notificationsHandler: notificationsHandler
		)
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
