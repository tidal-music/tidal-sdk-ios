import Auth
import EventProducer
@testable import Player
import XCTest

final class FeatureFlagProviderTests: XCTestCase {
	private var featureFlagProvider: FeatureFlagProvider!

	override func setUp() {
		Player.shared = nil
		featureFlagProvider = FeatureFlagProvider.mock
	}

	func testOffliningIsInitialized() throws {
		let playerInstance = Player.bootstrap(
			playerListener: PlayerListenerMock(),
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
}
