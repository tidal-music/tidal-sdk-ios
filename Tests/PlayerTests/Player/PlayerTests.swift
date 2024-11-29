import Auth
import GRDB
@testable import Player
import XCTest

// MARK: - PlayerTests

final class PlayerTests: XCTestCase {
	private var player: Player!
	private var playerEventSender: PlayerEventSenderMock!
	private var offlineDbQueue: DatabaseQueue!
	private var cachedDbQueue: DatabaseQueue!

	override func setUpWithError() throws {
		PlayerWorld = PlayerWorldClient.mock(developmentFeatureFlagProvider: DevelopmentFeatureFlagProvider.mock)

		let sessionConfiguration = URLSessionConfiguration.default
		sessionConfiguration.protocolClasses = [JsonEncodedResponseURLProtocol.self]
		let urlSession = URLSession(configuration: sessionConfiguration)
		let errorManager = ErrorManagerMock()
		let httpClient = HttpClient.mock(
			urlSession: urlSession,
			responseErrorManager: errorManager,
			networkErrorManager: errorManager,
			timeoutErrorManager: errorManager
		)

		let credentialsProvider = CredentialsProviderMock()
		let dataWriter = DataWriterMock()
		let configuration = Configuration.mock()
		playerEventSender = PlayerEventSenderMock(
			configuration: configuration,
			httpClient: httpClient,
			dataWriter: dataWriter
		)

		offlineDbQueue = try DatabaseQueue()
		let offlineStorage = GRDBOfflineStorage(dbQueue: offlineDbQueue)

		cachedDbQueue = try DatabaseQueue()
		let cacheStorage = GRDBCacheStorage(dbQueue: cachedDbQueue)

		let fairplayLicenseFetcher = FairPlayLicenseFetcher.mock()
		let networkMonitor = NetworkMonitorMock()

		let djProducer = DJProducer(
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			featureFlagProvider: .mock
		)
		let streamingPrivilegesHandler = StreamingPrivilegesHandler(
			configuration: Configuration.mock(),
			httpClient: httpClient,
			credentialsProvider: credentialsProvider
		)

		let notificationsHandler = NotificationsHandler.mock()
		let offlineEngine = OfflineEngine.mock(
			storage: offlineStorage,
			playerEventSender: playerEventSender,
			notificationsHandler: notificationsHandler
		)
		let playerEngine = PlayerEngine.mock(httpClient: httpClient)

		player = Player(
			queue: OperationQueueMock(),
			urlSession: urlSession,
			configuration: configuration,
			offlineStorage: offlineStorage,
			cacheStorage: cacheStorage,
			djProducer: djProducer,
			playerEventSender: playerEventSender,
			fairplayLicenseFetcher: fairplayLicenseFetcher,
			streamingPrivilegesHandler: streamingPrivilegesHandler,
			networkMonitor: networkMonitor,
			notificationsHandler: notificationsHandler,
			playerEngine: playerEngine,
			offlineEngine: offlineEngine,
			featureFlagProvider: .mock,
			externalPlayersSupplier: nil,
			credentialsProvider: CredentialsProviderMock(),
			offlinePlaybackPrivilegeCheck: nil
		)
	}
}
