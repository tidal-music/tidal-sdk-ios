import Auth
import EventProducer
@testable import Player
import XCTest

final class FeatureFlagProviderTests: XCTestCase {
	private var featureFlagProvider: FeatureFlagProvider!
	private var shouldUseOfflineEngine: Bool = false

	override func setUp() {
		Player.shared = nil

		featureFlagProvider = FeatureFlagProvider.mock
		featureFlagProvider.isOfflineEngineEnabled = {
			self.shouldUseOfflineEngine
		}
	}

	func testOffliningIsNotInitialized() throws {
		shouldUseOfflineEngine = false

		let playerInstance = Player.bootstrap(
			listener: PlayerListenerMock(),
			offlineEngineListener: OfflineEngineListenerMock(),
			listenerQueue: DispatchQueue(label: "com.tidal.queue.for.testing"),
			featureFlagProvider: featureFlagProvider,
			credentialsProvider: CredentialsProviderMock(),
			eventSender: EventSenderMock()
		)

		let player = try XCTUnwrap(playerInstance)
		XCTAssertNotNil(player.playerEngine)
		XCTAssertNil(player.offlineStorage)
		XCTAssertNil(player.offlineEngine)
	}

	func testOffliningIsInitialized() throws {
		shouldUseOfflineEngine = true

		let playerInstance = Player.bootstrap(
			listener: PlayerListenerMock(),
			offlineEngineListener: OfflineEngineListenerMock(),
			listenerQueue: DispatchQueue(label: "com.tidal.queue.for.testing"),
			featureFlagProvider: featureFlagProvider,
			credentialsProvider: CredentialsProviderMock(),
			eventSender: EventSenderMock()
		)

		let player = try XCTUnwrap(playerInstance)
		XCTAssertNotNil(player.playerEngine)
		XCTAssertNotNil(player.offlineStorage)
		XCTAssertNotNil(player.offlineEngine)
	}

	func testOffliningIsInitializedAfterBootstrap() throws {
		shouldUseOfflineEngine = false

		let playerInstance = Player.bootstrap(
			listener: PlayerListenerMock(),
			offlineEngineListener: OfflineEngineListenerMock(),
			listenerQueue: DispatchQueue(label: "com.tidal.queue.for.testing"),
			featureFlagProvider: featureFlagProvider,
			credentialsProvider: CredentialsProviderMock(),
			eventSender: EventSenderMock()
		)

		let player = try XCTUnwrap(playerInstance)

		shouldUseOfflineEngine = true
		_ = player.offline(mediaProduct: .mock())

		XCTAssertNotNil(player.playerEngine)
		XCTAssertNotNil(player.offlineStorage)
		XCTAssertNotNil(player.offlineEngine)
	}
}
