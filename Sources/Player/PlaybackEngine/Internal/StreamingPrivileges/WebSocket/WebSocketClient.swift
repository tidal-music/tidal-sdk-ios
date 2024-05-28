import Foundation

final class WebSocketClient: WebSocket {
	func open(_ response: ConnectResponse) -> WebSocketTask? {
		let task = URL(string: response.url).map { URLSession.shared.webSocketTask(with: $0) }
		task?.resume()
		return task
	}
}
