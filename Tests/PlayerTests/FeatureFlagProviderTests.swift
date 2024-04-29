import Auth
import EventProducer
@testable import Player
import XCTest

final class FeatureFlagProviderTests: XCTestCase {
	override func setUpWithError() throws {
		PlayerWorld = PlayerWorldClient.mock
		Player.shared = nil
	}

	func testOffliningIsNotInitialized() throws {
		PlayerWorld.developmentFeatureFlagProvider.isOffliningEnabled = false

		let playerInstance = Player.bootstrap(
			accessTokenProvider: AuthTokenProviderMock(),
			clientToken: "",
			clientVersion: "",
			listener: PlayerListenerMock(),
			listenerQueue: DispatchQueue(label: "com.tidal.queue.for.testing"),
			featureFlagProvider: .mock,
			credentialsProvider: CredentialsProviderMock(),
			eventSender: EventSenderMock()
		)

		let player = try XCTUnwrap(playerInstance)
		XCTAssertNotNil(player.playerEngine)
		XCTAssertNil(player.offlineEngine)
	}

	func testOffliningIsInitialized() throws {
		PlayerWorld.developmentFeatureFlagProvider.isOffliningEnabled = true

		let playerInstance = Player.bootstrap(
			accessTokenProvider: AuthTokenProviderMock(),
			clientToken: "",
			clientVersion: "",
			listener: PlayerListenerMock(),
			listenerQueue: DispatchQueue(label: "com.tidal.queue.for.testing"),
			featureFlagProvider: .mock,
			credentialsProvider: CredentialsProviderMock(),
			eventSender: EventSenderMock()
		)

		let player = try XCTUnwrap(playerInstance)
		XCTAssertNotNil(player.playerEngine)
		XCTAssertNotNil(player.offlineEngine)
	}
}
