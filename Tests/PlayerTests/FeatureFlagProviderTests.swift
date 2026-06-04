import Auth
import EventProducer
import Foundation
@testable import Player
import Testing

final class FeatureFlagProviderTests {
	private var featureFlagProvider: FeatureFlagProvider!

	init() {
		Player.shared = nil
		featureFlagProvider = FeatureFlagProvider.mock
	}

	@Test
	func testOffliningIsInitialized() throws {
		let playerInstance = Player.bootstrap(
			playerListener: PlayerListenerMock(),
			offlineEngineListener: OfflineEngineListenerMock(),
			listenerQueue: DispatchQueue(label: "com.tidal.queue.for.testing"),
			featureFlagProvider: featureFlagProvider,
			credentialsProvider: CredentialsProviderMock(),
			eventSender: EventSenderMock()
		)

		let player = try #require(playerInstance)
		#expect(player.playerEngine != nil)
		#expect(player.offlineStorage != nil)
		#expect(player.offlineEngine != nil)
	}
}
