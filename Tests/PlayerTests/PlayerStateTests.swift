import Auth

// swiftlint:disable file_length type_body_length
import Foundation
@testable import Player
import XCTest

final class PlayerStateTests: XCTestCase {
	private var urlSession: URLSession!

	private var httpClient: HttpClient!
	private var playerEventSender: PlayerEventSenderMock!
	private var listener: PlayerListenerMock!
	private var listenerQueue: DispatchQueue!
	private var credentialsProvider: CredentialsProviderMock!
	private var featureFlagProvider: FeatureFlagProvider!
	private var notificationsHandler: NotificationsHandler!
	private var networkMonitor: NetworkMonitorMock!
	private var playbackInfoFetcher: PlaybackInfoFetcher!
	private var fairplayLicenseFetcher: FairPlayLicenseFetcher!
	private var playerLoader: PlayerLoaderMock!

	private var timestamp: UInt64 = 1

	override func setUp() {
		let timeProvider = TimeProvider.mock(
			timestamp: {
				self.timestamp
			}
		)
		PlayerWorld = PlayerWorldClient.mock(timeProvider: timeProvider)

		let sessionConfiguration = URLSessionConfiguration.default
		sessionConfiguration.protocolClasses = [JsonEncodedResponseURLProtocol.self]
		urlSession = URLSession(configuration: sessionConfiguration)

		httpClient = HttpClient(
			using: urlSession,
			responseErrorManager: ResponseErrorManager(backoffPolicy: BackoffPolicyMock()),
			networkErrorManager: NetworkErrorManager(backoffPolicy: BackoffPolicyMock()),
			timeoutErrorManager: TimeoutErrorManager(backoffPolicy: BackoffPolicyMock())
		)

		playerEventSender = PlayerEventSenderMock()

		listener = PlayerListenerMock()
		listenerQueue = DispatchQueue(label: "com.tidal.queue.for.testing")
		notificationsHandler = .mock(listener: listener, queue: listenerQueue)

		credentialsProvider = CredentialsProviderMock()
		featureFlagProvider = FeatureFlagProvider.mock

		fairplayLicenseFetcher = FairPlayLicenseFetcher(
			with: HttpClient(using: urlSession),
			credentialsProvider: credentialsProvider,
			and: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)

		networkMonitor = NetworkMonitorMock()

		let configuration = Configuration.mock()
		playerLoader = PlayerLoaderMock(
			with: configuration,
			and: fairplayLicenseFetcher
		)

		playbackInfoFetcher = PlaybackInfoFetcher(
			with: configuration,
			httpClient,
			credentialsProvider,
			networkMonitor,
			and: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)

		credentialsProvider.injectSuccessfulUserLevelCredentials()
	}

	override func tearDown() {
		JsonEncodedResponseURLProtocol.reset()
		playerLoader.reset()
	}

	func testInitialStateIsIdle() {
		let playerEngine = PlayerEngine.mock(
			httpClient: httpClient,
			fairplayLicenseFetcher: fairplayLicenseFetcher,
			playerEventSender: playerEventSender,
			networkMonitor: networkMonitor,
			playerLoader: playerLoader,
			notificationsHandler: notificationsHandler
		)

		listenerQueue.sync {}
		XCTAssertEqual(playerEngine.getState(), .IDLE)
		XCTAssertEqual(listener.state, nil)
	}

	func testStateIsNotPlayingAfterFailedPlaybackInfoFetch() {
		JsonEncodedResponseURLProtocol.fail()

		let playerEngine = PlayerEngine.mock(
			httpClient: httpClient,
			fairplayLicenseFetcher: fairplayLicenseFetcher,
			playerLoader: playerLoader,
			notificationsHandler: notificationsHandler
		)

		playerEngine.load(MediaProduct.mock(), timestamp: 1)

		listenerQueue.sync {}
		XCTAssertEqual(playerEngine.getState(), .NOT_PLAYING)
		XCTAssertEqual(listener.state, .NOT_PLAYING)
		XCTAssertEqual(listener.numErrors, 1)
	}

	func testStateIsPlaying() {
		JsonEncodedResponseURLProtocol.succeed(with: TrackPlaybackInfo.mock())

		let playerEngine = PlayerEngine.mock(
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			fairplayLicenseFetcher: fairplayLicenseFetcher,
			playerEventSender: playerEventSender,
			networkMonitor: networkMonitor,
			playerLoader: playerLoader,
			notificationsHandler: notificationsHandler
		)

		let player = playerLoader.player

		playerEngine.load(MediaProduct.mock(), timestamp: 1)
		player.loaded()

		listenerQueue.sync {}
		XCTAssertEqual(listener.numErrors, 0)
		XCTAssertEqual(listener.numTransitions, 1)

		playerEngine.play(timestamp: 2)
		player.playing()

		// Set timestamp equal/higher than current media product, since events are sent afterwards, so to fake time has passed.
		timestamp = 5

		listenerQueue.sync {}
		XCTAssertEqual(playerEngine.getState(), .PLAYING)
		XCTAssertEqual(listener.state, .PLAYING)
		XCTAssertEqual(listener.numTransitions, 1)
	}

	func testStateIsIdleAfterReset() {
		JsonEncodedResponseURLProtocol.succeed(with: TrackPlaybackInfo.mock())

		let playerEngine = PlayerEngine.mock(
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			fairplayLicenseFetcher: fairplayLicenseFetcher,
			playerEventSender: playerEventSender,
			networkMonitor: networkMonitor,
			playerLoader: playerLoader,
			notificationsHandler: notificationsHandler
		)

		let player = playerLoader.player

		playerEngine.load(MediaProduct.mock(), timestamp: 1)
		player.loaded()

		listenerQueue.sync {}
		XCTAssertEqual(listener.numErrors, 0)
		XCTAssertEqual(listener.numTransitions, 1)

		playerEngine.play(timestamp: 2)
		player.playing()

		listenerQueue.sync {}
		XCTAssertEqual(playerEngine.getState(), .PLAYING)
		XCTAssertEqual(listener.state, .PLAYING)

		// Set timestamp equal/higher than current media product, since events are sent afterwards, so to fake time has passed.
		timestamp = 5

		playerEngine.reset()

		listenerQueue.sync {}
		XCTAssertEqual(playerEngine.getState(), .IDLE)
		XCTAssertEqual(listener.state, .IDLE)
		XCTAssertEqual(listener.numEnds, 0)
		XCTAssertEqual(listener.numTransitions, 1)
	}

	func testStateIsStalled() {
		JsonEncodedResponseURLProtocol.succeed(with: TrackPlaybackInfo.mock())

		let playerEngine = PlayerEngine.mock(
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			fairplayLicenseFetcher: fairplayLicenseFetcher,
			playerEventSender: playerEventSender,
			networkMonitor: networkMonitor,
			playerLoader: playerLoader,
			notificationsHandler: notificationsHandler
		)

		let player = playerLoader.player

		playerEngine.load(MediaProduct.mock(), timestamp: 1)
		player.loaded()

		listenerQueue.sync {}

		playerEngine.play(timestamp: 2)
		player.playing()

		listenerQueue.sync {}
		XCTAssertEqual(playerEngine.getState(), .PLAYING)
		XCTAssertEqual(listener.state, .PLAYING)

		player.stalled()

		listenerQueue.sync {}
		XCTAssertEqual(playerEngine.getState(), .STALLED)
		XCTAssertEqual(listener.state, .STALLED)

		player.playing()

		listenerQueue.sync {}

		// Set timestamp equal/higher than current media product, since events are sent afterwards, so to fake time has passed.
		timestamp = 5

		XCTAssertEqual(playerEngine.getState(), .PLAYING)
		XCTAssertEqual(listener.state, .PLAYING)
	}

	func testStateIsNotPlayingDueToPause() {
		JsonEncodedResponseURLProtocol.succeed(with: TrackPlaybackInfo.mock())

		let playerEngine = PlayerEngine.mock(
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			fairplayLicenseFetcher: fairplayLicenseFetcher,
			playerEventSender: playerEventSender,
			networkMonitor: networkMonitor,
			playerLoader: playerLoader,
			notificationsHandler: notificationsHandler
		)

		let player = playerLoader.player

		playerEngine.load(MediaProduct.mock(), timestamp: 1)
		player.loaded()

		playerEngine.play(timestamp: 2)
		player.playing()

		listenerQueue.sync {}
		XCTAssertEqual(playerEngine.getState(), .PLAYING)
		XCTAssertEqual(listener.state, .PLAYING)

		playerEngine.pause()
		player.paused()

		listenerQueue.sync {}
		XCTAssertEqual(playerEngine.getState(), .NOT_PLAYING)
		XCTAssertEqual(listener.state, .NOT_PLAYING)

		playerEngine.play(timestamp: 3)
		player.playing()

		// Set timestamp equal/higher than current media product, since events are sent afterwards, so to fake time has passed.
		timestamp = 5

		listenerQueue.sync {}
		XCTAssertEqual(playerEngine.getState(), .PLAYING)
		XCTAssertEqual(listener.state, .PLAYING)
	}

	func testStateIsPlayingAfterTransition() {
		JsonEncodedResponseURLProtocol.succeed(with: TrackPlaybackInfo.mock())

		let playerEngine = PlayerEngine.mock(
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			fairplayLicenseFetcher: fairplayLicenseFetcher,
			playerEventSender: playerEventSender,
			networkMonitor: networkMonitor,
			playerLoader: playerLoader,
			notificationsHandler: notificationsHandler
		)

		let player = playerLoader.player

		playerEngine.load(MediaProduct.mock(), timestamp: 1)
		player.loaded()

		listenerQueue.sync {}
		XCTAssertEqual(listener.numTransitions, 1)

		playerEngine.play(timestamp: 2)
		player.playing()

		listenerQueue.sync {}
		XCTAssertEqual(playerEngine.getState(), .PLAYING)
		XCTAssertEqual(listener.state, .PLAYING)

		player.downloaded()
		playerEngine.setNext(MediaProduct.mock(), timestamp: 3)
		player.loaded()
		player.completed()

		listenerQueue.sync {}
		XCTAssertEqual(listener.numEnds, 1)
		XCTAssertEqual(listener.numTransitions, 2)
		XCTAssertEqual(playerEngine.getState(), .PLAYING)
		XCTAssertEqual(listener.state, .PLAYING)

		player.completed()

		listenerQueue.sync {}
		XCTAssertEqual(playerEngine.getState(), .IDLE)
		XCTAssertEqual(listener.state, .IDLE)
		XCTAssertEqual(listener.numTransitions, 2)
		XCTAssertEqual(listener.numEnds, 2)
	}

	func testStateIsNotPlayingAfterTransitionWhenNextWasUnloaded() {
		JsonEncodedResponseURLProtocol.succeed(with: TrackPlaybackInfo.mock())

		let playerEngine = PlayerEngine.mock(
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			fairplayLicenseFetcher: fairplayLicenseFetcher,
			playerEventSender: playerEventSender,
			networkMonitor: networkMonitor,
			playerLoader: playerLoader,
			notificationsHandler: notificationsHandler
		)

		let player = playerLoader.player

		playerEngine.load(MediaProduct.mock(), timestamp: 1)
		player.loaded()

		listenerQueue.sync {}
		XCTAssertEqual(listener.numTransitions, 1)

		playerEngine.play(timestamp: 2)
		player.playing()

		listenerQueue.sync {}
		XCTAssertEqual(playerEngine.getState(), .PLAYING)
		XCTAssertEqual(listener.state, .PLAYING)

		player.downloaded()

		playerEngine.setNext(MediaProduct.mock(), timestamp: 3)
		player.loaded()

		listenerQueue.sync {}
		XCTAssertEqual(playerEngine.getState(), .PLAYING)
		XCTAssertEqual(listener.state, .PLAYING)

		playerEngine.setNext(nil, timestamp: 4)
		listenerQueue.sync {}
		XCTAssertEqual(player.assets.count, 1)
		player.completed()

		listenerQueue.sync {}
		XCTAssertEqual(playerEngine.getState(), .IDLE)
		XCTAssertEqual(listener.state, .IDLE)
		XCTAssertEqual(listener.numTransitions, 1)
		XCTAssertEqual(listener.numEnds, 1)
	}

	func testStateIsNotPlayingDueToPlaybackFailure() {
		JsonEncodedResponseURLProtocol.succeed(with: TrackPlaybackInfo.mock())

		let playerEngine = PlayerEngine.mock(
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			fairplayLicenseFetcher: fairplayLicenseFetcher,
			playerEventSender: playerEventSender,
			networkMonitor: networkMonitor,
			playerLoader: playerLoader,
			notificationsHandler: notificationsHandler
		)

		let player = playerLoader.player

		playerEngine.load(MediaProduct.mock(), timestamp: 1)
		player.loaded()

		playerEngine.play(timestamp: 2)
		player.playing()

		listenerQueue.sync {}
		XCTAssertEqual(playerEngine.getState(), .PLAYING)
		XCTAssertEqual(listener.state, .PLAYING)

		player.failed(with: NSError(domain: "mockDomain", code: 1, userInfo: nil))

		listenerQueue.sync {}
		XCTAssertEqual(playerEngine.getState(), .NOT_PLAYING)
		XCTAssertEqual(listener.state, .NOT_PLAYING)
		XCTAssertEqual(listener.numErrors, 1)

		playerEngine.play(timestamp: 3)

		XCTAssertEqual(playerEngine.getState(), .NOT_PLAYING)
		XCTAssertEqual(listener.state, .NOT_PLAYING)
	}

	func testNextAssetFailsOnTransitionDueToPlaybackInfoError() {
		JsonEncodedResponseURLProtocol.succeed(with: TrackPlaybackInfo.mock())

		let playerEngine = PlayerEngine.mock(
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			fairplayLicenseFetcher: fairplayLicenseFetcher,
			playerEventSender: playerEventSender,
			networkMonitor: networkMonitor,
			playerLoader: playerLoader,
			notificationsHandler: notificationsHandler
		)

		let player = playerLoader.player

		playerEngine.load(MediaProduct.mock(), timestamp: 1)
		player.loaded()

		playerEngine.play(timestamp: 2)
		player.playing()

		listenerQueue.sync {}
		XCTAssertEqual(playerEngine.getState(), .PLAYING)
		XCTAssertEqual(listener.state, .PLAYING)

		player.downloaded()

		JsonEncodedResponseURLProtocol.fail()
		playerEngine.setNext(MediaProduct.mock(), timestamp: 3)

		listenerQueue.sync {}
		XCTAssertEqual(playerEngine.getState(), .PLAYING)
		XCTAssertEqual(listener.state, .PLAYING)
		XCTAssertEqual(listener.numErrors, 0)

		player.completed()

		listenerQueue.sync {}
		XCTAssertEqual(playerEngine.getState(), .NOT_PLAYING)
		XCTAssertEqual(listener.state, .NOT_PLAYING)
		XCTAssertEqual(listener.numErrors, 1)
		XCTAssertEqual(listener.numEnds, 1)
	}

	func testNextAssetFailsOnTransitionDueToAssetError() {
		JsonEncodedResponseURLProtocol.succeed(with: TrackPlaybackInfo.mock())

		let playerEngine = PlayerEngine.mock(
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			fairplayLicenseFetcher: fairplayLicenseFetcher,
			playerEventSender: playerEventSender,
			networkMonitor: networkMonitor,
			playerLoader: playerLoader,
			notificationsHandler: notificationsHandler
		)

		let player = playerLoader.player

		playerEngine.load(MediaProduct.mock(), timestamp: 1)
		player.loaded()

		playerEngine.play(timestamp: 2)
		player.playing()

		player.downloaded()

		listenerQueue.sync {}
		XCTAssertEqual(playerEngine.getState(), .PLAYING)
		XCTAssertEqual(listener.state, .PLAYING)
		XCTAssertEqual(listener.numErrors, 0)

		playerEngine.setNext(MediaProduct.mock(), timestamp: 3)
		player.loaded()

		player.failed(asset: player.assets.last!, with: NSError(domain: "mockDomain", code: 1, userInfo: nil))

		listenerQueue.sync {}
		XCTAssertEqual(playerEngine.getState(), .PLAYING)
		XCTAssertEqual(listener.state, .PLAYING)
		XCTAssertEqual(listener.numErrors, 0)

		player.completed()

		listenerQueue.sync {}
		XCTAssertEqual(playerEngine.getState(), .NOT_PLAYING)
		XCTAssertEqual(listener.state, .NOT_PLAYING)
		XCTAssertEqual(listener.numErrors, 1)
		XCTAssertEqual(listener.numEnds, 1)
	}
}

// swiftlint:enable file_length type_body_length
