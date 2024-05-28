import Foundation
@testable import Player

// MARK: - WebSocketMock

final class WebSocketMock {
	private(set) var responses = [ConnectResponse]()
	var taskToReturn: WebSocketTask?
}

// MARK: WebSocket

extension WebSocketMock: WebSocket {
	func open(_ response: ConnectResponse) -> WebSocketTask? {
		responses.append(response)
		return taskToReturn
	}
}
