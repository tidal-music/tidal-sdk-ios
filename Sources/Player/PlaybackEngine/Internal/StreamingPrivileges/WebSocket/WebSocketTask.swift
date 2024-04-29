import Foundation

// MARK: - WebSocketTask

/// Protocol representing a web socket task.
protocol WebSocketTask: AnyObject {
	var isCancelled: Bool { get }
	var closeCode: URLSessionWebSocketTask.CloseCode { get }

	func resume()
	func cancel()
	func cancel(with closeCode: URLSessionWebSocketTask.CloseCode)
	func send(_ message: URLSessionWebSocketTask.Message) async throws
	func receive() async throws -> URLSessionWebSocketTask.Message
}

// MARK: - URLSessionWebSocketTask + WebSocketTask

extension URLSessionWebSocketTask: WebSocketTask {
	var isCancelled: Bool { state == .canceling }

	func cancel(with closeCode: CloseCode) {
		cancel(with: closeCode, reason: nil)
	}
}
