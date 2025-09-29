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
        httpClient = HttpClient()
        credentialsProvider = CredentialsProviderMock()
        playerEventSender = PlayerEventSenderMock()
        networkMonitor = NetworkMonitorMock()
        featureFlagProvider = .mock
        playerLoader = PlayerLoaderMock()
        notificationsHandler = .mock(queue: DispatchQueue(label: "route-change-tests"))

        playerEngine = PlayerEngine.mock(
            queue: OperationQueueMock(),
            httpClient: httpClient,
            credentialsProvider: credentialsProvider,
            fairplayLicenseFetcher: FairPlayLicenseFetcher.mock(),
            djProducer: DJProducer(
                httpClient: httpClient,
                credentialsProvider: credentialsProvider,
                featureFlagProvider: featureFlagProvider
            ),
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
        player.playing() // transitions engine state to PLAYING
        XCTAssertEqual(player.playCallCount, 0)

        // WHEN: simulate BT route loss
        postRouteChange(reason: .oldDeviceUnavailable)
        XCTAssertEqual(player.pauseCallCount, 1)

        // AND: BT returns quickly (within 10s)
        timestamp += 5_000
        postRouteChange(reason: .newDeviceAvailable)

        // THEN: playback resumes automatically
        XCTAssertEqual(player.playCallCount, 1)
    }

    func test_doesNotResumeAfterLongBluetoothDropout() {
        // GIVEN: a loaded and playing item
        JsonEncodedResponseURLProtocol.succeed(with: TrackPlaybackInfo.mock())
        playerEngine.load(MediaProduct.mock(), timestamp: timestamp)
        player.loaded()
        player.playing()

        // WHEN: simulate BT route loss
        postRouteChange(reason: .oldDeviceUnavailable)
        XCTAssertEqual(player.pauseCallCount, 1)

        // AND: BT returns after the window (greater than 10s)
        timestamp += 15_000
        postRouteChange(reason: .newDeviceAvailable)

        // THEN: no auto-resume
        XCTAssertEqual(player.playCallCount, 0)
    }

    // Helpers
    private func postRouteChange(reason: AVAudioSession.RouteChangeReason) {
        let userInfo: [AnyHashable: Any] = [AVAudioSessionRouteChangeReasonKey: reason.rawValue]
        NotificationCenter.default.post(
            name: AVAudioSession.routeChangeNotification,
            object: AVAudioSession.sharedInstance(),
            userInfo: userInfo
        )
        // Allow notifications/queues to process quickly
        RunLoop.current.run(until: Date().addingTimeInterval(0.01))
    }
}
#endif
