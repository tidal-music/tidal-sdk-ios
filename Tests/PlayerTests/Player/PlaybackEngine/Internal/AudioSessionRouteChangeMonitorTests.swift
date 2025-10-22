import Auth
@testable import Player
import XCTest
import AVFoundation

#if !os(macOS)
final class AudioSessionRouteChangeMonitorTests: XCTestCase {
    private var timestamp: UInt64 = 1_000

    private var configuration: Configuration!
    private var httpClient: HttpClient!
    private var credentialsProvider: CredentialsProviderMock!
    private var playerEventSender: PlayerEventSenderMock!
    private var networkMonitor: NetworkMonitorMock!
    private var featureFlagProvider: FeatureFlagProvider!
    private var playerLoader: PlayerLoaderMock!
    private var listenerQueue: DispatchQueue!
    private var notificationsHandler: NotificationsHandler!
    private var playerEngine: PlayerEngine!
    private var player: PlayerMock! { playerLoader.player }

    override func setUp() {
        // TimeProvider mock (ms)
        let timeProvider = TimeProvider.mock(timestamp: { self.timestamp })
        // Force Bluetooth route via AudioInfoProvider
        let audioInfoProvider = AudioInfoProvider(
            isBluetoothOutputRoute: { true },
            isAirPlayOutputRoute: { false },
            isCarPlayOutputRoute: { false },
            currentOutputPortName: { "output" }
        )
        PlayerWorld = PlayerWorldClient.mock(
            audioInfoProvider: audioInfoProvider,
            timeProvider: timeProvider
        )

        configuration = Configuration.mock()
        // Configure URLSession to use our stub URLProtocol so loads complete synchronously
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.protocolClasses = [JsonEncodedResponseURLProtocol.self]
        let urlSession = URLSession(configuration: sessionConfiguration)
        httpClient = HttpClient.mock(urlSession: urlSession)
        credentialsProvider = CredentialsProviderMock()
        credentialsProvider.injectSuccessfulUserLevelCredentials()
        playerEventSender = PlayerEventSenderMock()
        networkMonitor = NetworkMonitorMock()
        featureFlagProvider = .mock
        playerLoader = PlayerLoaderMock()
        listenerQueue = DispatchQueue(label: "route-change-tests")
        notificationsHandler = .mock(queue: listenerQueue)

		playerEngine = PlayerEngine.mock(
			queue: OperationQueueMock(),
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			fairplayLicenseFetcher: FairPlayLicenseFetcher.mock(),
			configuration: configuration,
			playerEventSender: playerEventSender,
			networkMonitor: networkMonitor,
			playerLoader: playerLoader,
			featureFlagProvider: featureFlagProvider,
			notificationsHandler: notificationsHandler
		)
    }

    func test_autoResumesAfterShortBluetoothDropout() {
        // GIVEN: a loaded and playing item
        JsonEncodedResponseURLProtocol.succeed(with: TrackPlaybackInfo.mock())
        playerEngine.load(MediaProduct.mock(), timestamp: timestamp)
        player.loaded()
        XCTAssertEqual(playerEngine.getState(), .NOT_PLAYING)
		
        playerEngine.play(timestamp: timestamp)
        player.playing()
        listenerQueue.sync {}
        XCTAssertEqual(playerEngine.getState(), .PLAYING)
        XCTAssertEqual(player.playCallCount, 1)

        // WHEN: simulate BT route loss
        postRouteChange(reason: .oldDeviceUnavailable)
        XCTAssertEqual(player.pauseCallCount, 1)

        // AND: BT returns quickly (within 10s)
        timestamp += 5_000
        postRouteChange(reason: .newDeviceAvailable)

        // THEN: playback resumes automatically
        XCTAssertEqual(player.playCallCount, 2)
    }

    func test_doesNotResumeAfterLongBluetoothDropout() {
        // GIVEN: a loaded and playing item
        JsonEncodedResponseURLProtocol.succeed(with: TrackPlaybackInfo.mock())
        playerEngine.load(MediaProduct.mock(), timestamp: timestamp)
        player.loaded()
		XCTAssertEqual(playerEngine.getState(), .NOT_PLAYING)

        playerEngine.play(timestamp: timestamp)
        player.playing()
        listenerQueue.sync {}
		XCTAssertEqual(playerEngine.getState(), .PLAYING)
        XCTAssertEqual(player.playCallCount, 1)
		
        // WHEN: simulate BT route loss
        postRouteChange(reason: .oldDeviceUnavailable)
        XCTAssertEqual(player.pauseCallCount, 1)

        // AND: BT returns after the window (greater than 10s)
        timestamp += 15_000
        postRouteChange(reason: .newDeviceAvailable)

        // THEN: no auto-resume
        XCTAssertEqual(player.playCallCount, 1)
    }

    // Helpers
    private func postRouteChange(reason: AVAudioSession.RouteChangeReason) {
        let userInfo: [AnyHashable: Any] = [AVAudioSessionRouteChangeReasonKey: reason.rawValue]
        NotificationCenter.default.post(
            name: AVAudioSession.routeChangeNotification,
            object: AVAudioSession.sharedInstance(),
            userInfo: userInfo
        )
        listenerQueue.sync {}
    }
}
#endif
