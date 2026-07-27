import Foundation
@testable import Player
import Testing

struct WebSocketClientTests {
	@Test
	func test_open() {
		let webSocketClient = WebSocketClient()
		let connectResponse = ConnectResponse(url: "wss://www.tidal.com")
		let task = webSocketClient.open(connectResponse)

		if let webSocketTask = task as? URLSessionWebSocketTask {
			#expect(webSocketTask.state == .running)
		} else {
			Issue.record("WebSocketClient.open(_) should have returned a URLSessionWebSocketTask")
		}
	}
}
