import Foundation

/// Protocol representing a WebSocket connection interface.
protocol WebSocket {
	func open(_ response: ConnectResponse) -> WebSocketTask?
}
