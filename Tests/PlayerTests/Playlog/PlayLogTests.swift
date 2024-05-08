import Auth
import CoreMedia
@testable import Player
import XCTest

// MARK: - Constants

private enum Constants {
	/// For these tests, we use 2 files which consist of silence.
	enum AudioFileName {
		static let short = "test_5sec"
		static let long = "test_1min"
	}

	enum PlayLogSource {
		static let short = Source(sourceType: "TEST_1", sourceId: "456")
		static let long = Source(sourceType: "TEST_2", sourceId: "789")
	}

	static let encoder = JSONEncoder()

	static let acceptableAssetPositionTimeRange: TimeInterval = 0.05
	static let expectationExtraTime: TimeInterval = 1
}

// MARK: - PlayLogTests

/// This set of tests actually uses the actual player to play tracks.
/// That is in order to simulate a more realistic scenario and make sure the metrics are correct and don't get broken by any
/// changes.
final class PlayLogTests: XCTestCase {
	private var player: Player!
	private var playerEventSender: PlayerEventSenderMock!
	private var credentialsProvider: CredentialsProviderMock!
	private var timestamp: UInt64 = 1

	lazy var shortAudioFile: AudioFile = {
		let url = PlayLogTestsHelper.url(from: Constants.AudioFileName.short)
		return AudioFile(
			name: Constants.AudioFileName.short,
			id: "1",
			mediaProduct: MediaProduct.mock(
				productType: .TRACK,
				productId: "1",
				progressSource: nil,
				playLogSource: Constants.PlayLogSource.short,
				productURL: url
			),
			url: url,
			duration: 5.055
		)
	}()

	lazy var longAudioFile: AudioFile = {
		let url = PlayLogTestsHelper.url(from: Constants.AudioFileName.long)
		return AudioFile(
			name: Constants.AudioFileName.long,
			id: "2",
			mediaProduct: MediaProduct.mock(
				productType: .TRACK,
				productId: "2",
				progressSource: nil,
				playLogSource: Constants.PlayLogSource.long,
				productURL: url
			),
			url: url,
			duration: 60.61
		)
	}()

	override func setUp() {
		var developmentFeatureFlagProvider = DevelopmentFeatureFlagProvider.mock
		developmentFeatureFlagProvider.shouldSendEventsInDeinit = false

		let timeProvider = TimeProvider.mock(
			timestamp: {
				self.timestamp
			}
		)
		PlayerWorld = PlayerWorldClient.mock(timeProvider: timeProvider, developmentFeatureFlagProvider: developmentFeatureFlagProvider)

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
		credentialsProvider = CredentialsProviderMock()
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
			legacyStreamingPrivilegesHandler: nil,
			streamingPrivilegesHandler: nil,
			networkMonitor: networkMonitor,
			notificationsHandler: notificationsHandler,
			playerEngine: playerEngine,
			offlineEngine: nil,
			featureFlagProvider: .mock,
			externalPlayers: [],
			credentialsProvider: credentialsProvider
		)
	}
}

// MARK: - Helpers

private extension PlayLogTests {
	func setAudioFileResponseToURLProtocol(audioFile: AudioFile) {
		let mediaProduct = audioFile.mediaProduct

		guard let fileURLString = audioFile.url?.absoluteString else {
			XCTFail("Failed to get URL from the audioFile: \(audioFile.name)")
			return
		}
		let encodableEmuManifest = EncodableEmuManifest(urls: [fileURLString])

		do {
			let manifestData = try Constants.encoder.encode(encodableEmuManifest)
			let manifest: String = Data(manifestData).base64EncodedString()
			let trackPlaybackInfo = TrackPlaybackInfo.mock(
				trackId: Int(mediaProduct.productId)!,
				manifest: manifest,
				albumReplayGain: 11,
				albumPeakAmplitude: 22,
				sampleRate: 33,
				bitDepth: 44
			)
			JsonEncodedResponseURLProtocol.succeed(with: trackPlaybackInfo)
		} catch {
			XCTFail("Failed to encode data: \(error)")
		}
	}
}
