@testable import Player
import XCTest

final class WebSocketClientTests: XCTestCase {
	func test_open() {
		let webSocketClient = WebSocketClient()
		let connectResponse = ConnectResponse(url: "wss://www.tidal.com")
		let task = webSocketClient.open(connectResponse)

		if let webSocketTask = task as? URLSessionWebSocketTask {
			XCTAssertEqual(webSocketTask.state, .running)
		} else {
			XCTFail("WebSocketClient.open(_) should have returned a URLSessionWebSocketTask")
		}
	}
}
