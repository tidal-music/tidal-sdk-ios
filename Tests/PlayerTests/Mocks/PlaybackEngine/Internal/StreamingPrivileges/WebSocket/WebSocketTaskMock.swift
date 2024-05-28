import Foundation
@testable import Player

final class WebSocketTaskMock: WebSocketTask {
	var closeCode: URLSessionWebSocketTask.CloseCode { .invalid }

	enum Constants {
		// swiftlint:disable:next identifier_name
		static let privilegedSessionNotificationIncomingMessageString =
			"{\"payload\":{\"clientDisplayName\":\"web\"},\"type\":\"PRIVILEGED_SESSION_NOTIFICATION\"}"
		static let reconnectIncomingMessageString = "{\"type\":\"RECONNECT\"}"
		static let sleepingTime: TimeInterval = 0.5
	}

	private(set) var isCancelled = false
	private(set) var cancelCallCount = 0
	private(set) var cancelCloseCodes = [URLSessionWebSocketTask.CloseCode]()
	private(set) var resumeCallCount = 0

	private(set) var sendMessages = [URLSessionWebSocketTask.Message]()
	var messageToReceive: URLSessionWebSocketTask.Message = .string(Constants.privilegedSessionNotificationIncomingMessageString)

	/// Give a value to this in order to customize how the web socket interacts (error, messages, sleeping) as desired by the test.
	/// If kept nil, the ``receive()`` func will return immediately ``messageToReceive``.
	var receiveBlock: (() async throws -> URLSessionWebSocketTask.Message)?

	func resume() {
		resumeCallCount += 1
	}

	func cancel() {
		cancelCallCount += 1
		isCancelled = true
	}

	func cancel(with closeCode: URLSessionWebSocketTask.CloseCode) {
		cancelCallCount += 1
		cancelCloseCodes.append(closeCode)
		isCancelled = true
	}

	func send(_ message: URLSessionWebSocketTask.Message) async throws {
		sendMessages.append(message)
	}

	func receive() async throws -> URLSessionWebSocketTask.Message {
		if let receiveBlock {
			try await receiveBlock()
		} else {
			messageToReceive
		}
	}
}
