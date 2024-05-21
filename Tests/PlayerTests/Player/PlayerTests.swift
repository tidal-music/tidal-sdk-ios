import Auth
@testable import Player
import XCTest

// MARK: - PlayerTests

final class PlayerTests: XCTestCase {
	private var player: Player!
	private var playerEventSender: PlayerEventSenderMock!

	override func setUp() {
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

		let accessTokenProvider = AuthTokenProviderMock()
		let credentialsProvider = CredentialsProviderMock()
		let dataWriter = DataWriterMock()
		let configuration = Configuration.mock()
		playerEventSender = PlayerEventSenderMock(
			configuration: configuration,
			httpClient: httpClient,
			accessTokenProvider: accessTokenProvider,
			dataWriter: dataWriter
		)

		let storage = Storage()
		let fairplayLicenseFetcher = FairPlayLicenseFetcher.mock()
		let networkMonitor = NetworkMonitorMock()

		let djProducer = DJProducer(
			httpClient: httpClient,
			with: accessTokenProvider,
			credentialsProvider: credentialsProvider,
			featureFlagProvider: .mock
		)
		let streamingPrivilegesHandler = StreamingPrivilegesHandler(
			configuration: Configuration.mock(),
			httpClient: httpClient,
			credentialsProvider: credentialsProvider
		)

		let notificationsHandler = NotificationsHandler.mock()
		let playerEngine = PlayerEngine.mock(httpClient: httpClient, accessTokenProvider: accessTokenProvider)

		player = Player(
			queue: OperationQueueMock(),
			urlSession: urlSession,
			configuration: configuration,
			storage: storage,
			accessTokenProvider: accessTokenProvider,
			djProducer: djProducer,
			playerEventSender: playerEventSender,
			fairplayLicenseFetcher: fairplayLicenseFetcher,
			streamingPrivilegesHandler: streamingPrivilegesHandler,
			networkMonitor: networkMonitor,
			notificationsHandler: notificationsHandler,
			playerEngine: playerEngine,
			offlineEngine: nil,
			featureFlagProvider: .mock,
			externalPlayers: [],
			credentialsProvider: CredentialsProviderMock()
		)
	}
}

extension PlayerTests {
	// MARK: - setUpUserConfiguration(_)

	func test_setUpUserConfiguration_calls_EventSender_updateuserConfiguration() {
		let userConfiguration = UserConfiguration.mock(userId: 100, userClientId: 200)
		player.setUpUserConfiguration(userConfiguration)

		XCTAssertEqual(playerEventSender.userConfigurations, [userConfiguration])
	}
}
