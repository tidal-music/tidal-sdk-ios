import Auth
import AVFoundation
@testable import Player
import XCTest

// MARK: - Constants

// swiftlint:disable file_length
private enum Constants {
	static let webSocketConnectResponse = ConnectResponse(url: "tidalWebSocket")
	static let sleepingTime: TimeInterval = WebSocketTaskMock.Constants.sleepingTime
	static let sleepingTimeForErrors: TimeInterval = 0.2
}

// MARK: - StreamingPrivilegesHandlerTests

final class StreamingPrivilegesHandlerTests: XCTestCase {
	private let date = Date(timeIntervalSince1970: 1)
	private var httpClient: HttpClient!
	private var credentialsProvider: CredentialsProviderMock!
	private var streamingPrivilegesHandler: StreamingPrivilegesHandler!
	private var streamingPrivilegesHandlerDelegate: StreamingPrivilegesHandlerDelegateMock!
	private var webSocket: WebSocketMock!
	private var errorManager: WebSocketErrorManager!
	private var backoffPolicy: BackoffPolicyMock!
	private let decoder = JSONDecoder()
	private var configuration: Configuration!

	override func setUp() {
		super.setUp()

		let timeProvider = TimeProvider.mock(
			date: {
				self.date
			}
		)
		PlayerWorld = PlayerWorldClient.mock(timeProvider: timeProvider)

		let sessionConfiguration = URLSessionConfiguration.default
		sessionConfiguration.protocolClasses = [JsonEncodedResponseURLProtocol.self]
		let urlSession = URLSession(configuration: sessionConfiguration)
		httpClient = HttpClient.mock(
			urlSession: urlSession,
			responseErrorManager: ResponseErrorManager(backoffPolicy: BackoffPolicyMock()),
			networkErrorManager: NetworkErrorManager(backoffPolicy: BackoffPolicyMock()),
			timeoutErrorManager: TimeoutErrorManager(backoffPolicy: BackoffPolicyMock())
		)
		credentialsProvider = CredentialsProviderMock()
		streamingPrivilegesHandlerDelegate = StreamingPrivilegesHandlerDelegateMock()

		JsonEncodedResponseURLProtocol.reset()

		webSocket = WebSocketMock()

		backoffPolicy = BackoffPolicyMock()
		errorManager = WebSocketErrorManager(backoffPolicy: backoffPolicy)

		configuration = Configuration.mock()
		streamingPrivilegesHandler = StreamingPrivilegesHandler(
			configuration: configuration,
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			webSocket: webSocket,
			errorManager: errorManager
		)
		streamingPrivilegesHandler.delegate = streamingPrivilegesHandlerDelegate
	}
}

// MARK: - Tests

extension StreamingPrivilegesHandlerTests {
	// MARK: - notify

	func test_notify_whenAuthorized_and_webSocketReturns_PRIVILEGED_SESSION_NOTIFICATION_should_sendUserActionAsMessage_and_call_streamingPrivilegesLost_fromDelegate(
	) async throws {
		// GIVEN

		// Provide successful user level credentials
		credentialsProvider.injectSuccessfulUserLevelCredentials()

		// Inject web socket connection response
		injectConnectResponse()

		// Provide a mock task to be returned by the web socket
		let task = WebSocketTaskMock()
		webSocket.taskToReturn = task

		let messageToReceive: URLSessionWebSocketTask
			.Message = .string(WebSocketTaskMock.Constants.privilegedSessionNotificationIncomingMessageString)
		var isFirstCallToReceiveFunc = true

		let receiveBlock: (() async throws -> URLSessionWebSocketTask.Message) = {
			// Simulate receiving a message immediately
			if isFirstCallToReceiveFunc {
				isFirstCallToReceiveFunc = false
				return messageToReceive
			} else {
				// Simulate a long-running receive that will be cancelled by the test
				while !task.isCancelled {
					try await Task.sleep(seconds: Constants.sleepingTime)
				}
				throw CancellationError()
			}
		}
		task.receiveBlock = receiveBlock

		// Inject mocked message with string PRIVILEGED_SESSION_NOTIFICATION to be received by the task
		task.messageToReceive = .string(WebSocketTaskMock.Constants.privilegedSessionNotificationIncomingMessageString)

		// WHEN
		let notifyTask = Task {
			await self.streamingPrivilegesHandler.notify()
		}

		await asyncOptimizedWait {
			task.sendMessages.count == 1
		}

		// THEN

		// The web socket is opened (one message is sent)
		XCTAssertEqual(task.sendMessages.count, 1)

		// The message sent should be a string and properly decoded to `UserAction`.
		assertUserActionMessage(of: task)

		// Opens the web socket with given connect response.
		XCTAssertEqual(webSocket.responses, [Constants.webSocketConnectResponse])

		// Cancel is not called
		XCTAssertEqual(task.isCancelled, false)
		XCTAssertEqual(task.cancelCallCount, 0)

		// PRIVILEGED_SESSION_NOTIFICATION is received from the web socket and the func ``streamingPrivilegesLost(to:)`` of delegate is
		// called.
		XCTAssertEqual(streamingPrivilegesHandlerDelegate.streamingPrivilegesLostClientNames, ["web"])

		notifyTask.cancel()
	}

	func test_when_offlineMode_isChanged_it_disconnects_from_webSocket() async throws {
		// GIVEN

		// Provide successful user level credentials
		credentialsProvider.injectSuccessfulUserLevelCredentials()

		// Inject web socket connection response
		injectConnectResponse()

		// Provide a mock task to be returned by the web socket
		let task = WebSocketTaskMock()
		webSocket.taskToReturn = task

		let receiveBlock: (() async throws -> URLSessionWebSocketTask.Message) = {
			// Simulate a long-running receive that will be cancelled by the test
			while !task.isCancelled {
				try await Task.sleep(seconds: Constants.sleepingTime)
			}
			throw CancellationError()
		}
		task.receiveBlock = receiveBlock

		// WHEN
		let notifyTask = Task {
			await self.streamingPrivilegesHandler.notify()
		}

		await asyncOptimizedWait {
			task.sendMessages.count == 1
		}

		configuration.offlineMode = true
		streamingPrivilegesHandler.updateConfiguration(configuration)

		await asyncOptimizedWait {
			task.sendMessages.count == 1 &&
				self.webSocket.responses.count == 1
		}

		// THEN

		// The web socket is opened (one message is sent)
		XCTAssertEqual(task.sendMessages.count, 1)

		// Opens the web socket with given connect response.
		XCTAssertEqual(webSocket.responses, [Constants.webSocketConnectResponse])

		// Cancel is called with proper cancel code.
		XCTAssertEqual(task.isCancelled, true)
		XCTAssertEqual(task.cancelCallCount, 1)
		XCTAssertEqual(task.cancelCloseCodes, [.normalClosure])

		notifyTask.cancel()
	}

	func test_notify_whenAuthorized_and_webSocketReturns_RECONNECT_should_reconnect() async throws {
		// GIVEN

		// Provide successful user level credentials
		credentialsProvider.injectSuccessfulUserLevelCredentials()

		// Inject web socket connection response
		injectConnectResponse()

		// Provide a mock task to be returned by the web socket
		let task = WebSocketTaskMock()
		webSocket.taskToReturn = task

		// Inject mocked message with string RECONNECT to be received by the task
		let messageToReceive: URLSessionWebSocketTask
			.Message = .string(WebSocketTaskMock.Constants.reconnectIncomingMessageString)
		var isFirstCallToReceiveFunc = true

		let receiveBlock: (() async throws -> URLSessionWebSocketTask.Message) = {
			// Simulate receiving a message immediately
			if isFirstCallToReceiveFunc {
				isFirstCallToReceiveFunc = false
				return messageToReceive
			} else {
				// Simulate a long-running receive that will be cancelled by the test
				while !task.isCancelled {
					try await Task.sleep(seconds: Constants.sleepingTime)
				}
				throw CancellationError()
			}
		}
		task.receiveBlock = receiveBlock

		// WHEN
		let notifyTask = Task {
			await self.streamingPrivilegesHandler.notify()
		}

		await asyncOptimizedWait {
			task.sendMessages.count == 1
		}

		// THEN

		// The web socket is opened (one message is sent)
		XCTAssertEqual(task.sendMessages.count, 1)

		// The message sent should be a string and properly decoded to `UserAction`.
		assertUserActionMessage(of: task)

		// Opens the web socket with given connect response twice: first from the notify flow, and then from the reconnecting attempts.
		XCTAssertEqual(webSocket.responses, [Constants.webSocketConnectResponse, Constants.webSocketConnectResponse])

		// Cancel is not called
		XCTAssertEqual(task.isCancelled, false)
		XCTAssertEqual(task.cancelCallCount, 0)

		notifyTask.cancel()
	}

	func test_notify_whenNotAuthorized_should_notConnect() async throws {
		// GIVEN

		// Provide a failed token
		credentialsProvider.injectFailedCredentials()

		// Provide a mock task to be returned by the web socket
		let task = WebSocketTaskMock()
		webSocket.taskToReturn = task

		// WHEN
		await streamingPrivilegesHandler.notify()

		// THEN
		// The web socket is not opened and cancel is not called
		XCTAssertEqual(task.isCancelled, false)
		XCTAssertEqual(task.cancelCallCount, 0)

		// It doesn't open the web socket.
		XCTAssertEqual(webSocket.responses, [])
	}

	func test_notify_whenAuthorized_and_throwsErrors_shouldConsiderBackoffPolicy() async {
		// GIVEN

		// Provide successful user level credentials
		credentialsProvider.injectSuccessfulUserLevelCredentials()

		// Inject web socket connection response
		injectConnectResponse()

		// Provide a mock task to be returned by the web socket
		let task = WebSocketTaskMock()
		webSocket.taskToReturn = task

		// Fail 6 times (as given in `WebSocketErrorManager`), sleeping in between.
		let maxErrorReconnectAttempts = errorManager.maxErrorRetryAttempts
		var numberFailuresBeforeSuccess = maxErrorReconnectAttempts

		let receiveBlock: (() async throws -> URLSessionWebSocketTask.Message) = {
			// When numberFailuresBeforeSuccess is different from zero, it throws error, then we decrease the number and throw an error.
			guard numberFailuresBeforeSuccess == 0 else {
				numberFailuresBeforeSuccess -= 1
				let error = HttpError.httpServerError(statusCode: 500)
				throw error
			}

			// Simulate a long-running receive that will be cancelled by the test
			while !task.isCancelled {
				try await Task.sleep(seconds: Constants.sleepingTime)
			}
			throw CancellationError()
		}
		task.receiveBlock = receiveBlock

		// WHEN
		let notifyTask = Task {
			await self.streamingPrivilegesHandler.notify()
		}

		await asyncOptimizedWait {
			task.sendMessages.count == 1
		}

		// THEN

		// The web socket is opened (one message is sent)
		XCTAssertEqual(task.sendMessages.count, 1)

		// The message sent should be a string and properly decoded to `UserAction`.
		assertUserActionMessage(of: task)

		// Opens the web socket with given connect response: 1 from the notify and then 6 from the max number of attempts.
		XCTAssertEqual(
			webSocket.responses,
			[
				Constants.webSocketConnectResponse,
				Constants.webSocketConnectResponse,
				Constants.webSocketConnectResponse,
				Constants.webSocketConnectResponse,
				Constants.webSocketConnectResponse,
				Constants.webSocketConnectResponse,
				Constants.webSocketConnectResponse,
			]
		)

		// Cancel is not called
		XCTAssertEqual(task.isCancelled, false)
		XCTAssertEqual(task.cancelCallCount, 0)

		// Make sure it called `onFailedAttempt` the max number of attempts.
		XCTAssertEqual(backoffPolicy.counter, maxErrorReconnectAttempts)

		notifyTask.cancel()
	}

//	func test_notify_whenAuthorized_and_throwsErrors_shouldConsiderBackoffPolicy_andAfterwards_webSocketReturns_PRIVILEGED_SESSION_NOTIFICATION_should_call_streamingPrivilegesLost_fromDelegate(
//	) async {
//		// GIVEN
//
//		// Provide successful user level credentials
//		credentialsProvider.injectSuccessfulUserLevelCredentials()
//
//		// Inject web socket connection response
//		injectConnectResponse()
//
//		// Provide a mock task to be returned by the web socket
//		let task = WebSocketTaskMock()
//		webSocket.taskToReturn = task
//
//		var shouldReturnMessageAfterFailure = true
//
//		// Fail 6 times (as given in `WebSocketErrorManager`), sleeping in between. Then return a message and finally sleep.
//		let maxErrorReconnectAttempts = errorManager.maxErrorRetryAttempts
//		var numberFailuresBeforeSuccess = maxErrorReconnectAttempts
//		let messageToReceive: URLSessionWebSocketTask
//			.Message = .string(WebSocketTaskMock.Constants.privilegedSessionNotificationIncomingMessageString)
//
//		let receiveBlock: (() async throws -> URLSessionWebSocketTask.Message) = {
//			// When numberFailuresBeforeSuccess is different from zero, it throws error, then we decrease the number and throw an error.
//			guard numberFailuresBeforeSuccess == 0 else {
//				numberFailuresBeforeSuccess -= 1
//				let error = HttpError.httpServerError(statusCode: 500)
//				throw error
//			}
//
//			if shouldReturnMessageAfterFailure {
//				shouldReturnMessageAfterFailure = false
//				return messageToReceive
//			}
//
//			// Simulate a long-running receive that will be cancelled by the test
//			while !task.isCancelled {
//				try await Task.sleep(seconds: Constants.sleepingTime)
//			}
//			throw CancellationError()
//		}
//		task.receiveBlock = receiveBlock
//
//		// WHEN
//		let notifyTask = Task {
//			await self.streamingPrivilegesHandler.notify()
//		}
//
//		await asyncOptimizedWait {
//			task.sendMessages.count == 1
//		}
//
//		// THEN
//
//		// The web socket is opened (one message is sent)
//		XCTAssertEqual(task.sendMessages.count, 1)
//
//		// The message sent should be a string and properly decoded to `UserAction`.
//		assertUserActionMessage(of: task)
//
//		// Opens the web socket with given connect response: 1 from the notify and then 6 from the max number of attempts.
//		XCTAssertEqual(
//			webSocket.responses,
//			[
//				Constants.webSocketConnectResponse,
//				Constants.webSocketConnectResponse,
//				Constants.webSocketConnectResponse,
//				Constants.webSocketConnectResponse,
//				Constants.webSocketConnectResponse,
//				Constants.webSocketConnectResponse,
//				Constants.webSocketConnectResponse,
//			]
//		)
//
//		// Cancel is not called
//		XCTAssertEqual(task.isCancelled, false)
//		XCTAssertEqual(task.cancelCallCount, 0)
//
//		// Make sure it called `onFailedAttempt` the max number of attempts.
//		XCTAssertEqual(backoffPolicy.counter, maxErrorReconnectAttempts)
//
//		// PRIVILEGED_SESSION_NOTIFICATION is received from the web socket and the func ``streamingPrivilegesLost(to:)`` of delegate
//		//is called.
//		XCTAssertEqual(streamingPrivilegesHandlerDelegate.streamingPrivilegesLostClientNames, ["web"])
//
//		notifyTask.cancel()
//	}

//	func test_notify_whenAuthorized_and_throwsErrors_shouldConsiderBackoffPolicy_andAfterwards_webSocketReturns_RECONNECT_should_reconnect(
//	) async {
//		// GIVEN
//
//		// Provide successful user level credentials
//		credentialsProvider.injectSuccessfulUserLevelCredentials()
//
//		// Inject web socket connection response
//		injectConnectResponse()
//
//		// Provide a mock task to be returned by the web socket
//		let task = WebSocketTaskMock()
//		webSocket.taskToReturn = task
//
//		var shouldReturnMessageAfterFailure = true
//
//		// Fail 6 times (as given in `WebSocketErrorManager`), sleeping in between. Then return a message and finally sleep.
//		let maxErrorReconnectAttempts = errorManager.maxErrorRetryAttempts
//		var numberFailuresBeforeSuccess = maxErrorReconnectAttempts
//		let messageToReceive: URLSessionWebSocketTask
//			.Message = .string(WebSocketTaskMock.Constants.reconnectIncomingMessageString)
//
//		let receiveBlock: (() async throws -> URLSessionWebSocketTask.Message) = {
//			// When numberFailuresBeforeSuccess is different from zero, it throws error, then we decrease the number and throw an error.
//			guard numberFailuresBeforeSuccess == 0 else {
//				numberFailuresBeforeSuccess -= 1
//				let error = HttpError.httpServerError(statusCode: 500)
//				throw error
//			}
//
//			if shouldReturnMessageAfterFailure {
//				shouldReturnMessageAfterFailure = false
//				return messageToReceive
//			}
//
//			// Simulate a long-running receive that will be cancelled by the test
//			while !task.isCancelled {
//				try await Task.sleep(seconds: Constants.sleepingTime)
//			}
//			throw CancellationError()
//		}
//		task.receiveBlock = receiveBlock
//
//		// WHEN
//		let notifyTask = Task {
//			await self.streamingPrivilegesHandler.notify()
//		}
//
//		await asyncOptimizedWait {
//			task.sendMessages.count == 1
//		}
//
//		// THEN
//
//		// The web socket is opened (one message is sent)
//		XCTAssertEqual(task.sendMessages.count, 1)
//
//		// The message sent should be a string and properly decoded to `UserAction`.
//		assertUserActionMessage(of: task)
//
//		// Opens the web socket with given connect response: 1 from the notify, 6 from the max number of attempts, and one more from
//		// the reconnect.
//		XCTAssertEqual(
//			webSocket.responses,
//			[
//				Constants.webSocketConnectResponse,
//				Constants.webSocketConnectResponse,
//				Constants.webSocketConnectResponse,
//				Constants.webSocketConnectResponse,
//				Constants.webSocketConnectResponse,
//				Constants.webSocketConnectResponse,
//				Constants.webSocketConnectResponse,
//				Constants.webSocketConnectResponse,
//			]
//		)
//
//		// Cancel is not called
//		XCTAssertEqual(task.isCancelled, false)
//		XCTAssertEqual(task.cancelCallCount, 0)
//
//		// Make sure it called `onFailedAttempt` the max number of attempts.
//		XCTAssertEqual(backoffPolicy.counter, maxErrorReconnectAttempts)
//
//		notifyTask.cancel()
//	}

	func assertUserActionMessage(of task: WebSocketTaskMock) {
		let message = task.sendMessages.first
		switch message {
		case let .string(text):
			let data = text.data(using: .utf8)!
			let userAction = try? decoder.decode(UserAction.self, from: data)

			// An UserAction is sent
			XCTAssertEqual(userAction, UserAction())

		default:
			XCTFail("Expected task to have received a message.string")
		}
	}
}

// MARK: - Helpers

private extension StreamingPrivilegesHandlerTests {
	func injectConnectResponse() {
		let response = Constants.webSocketConnectResponse
		JsonEncodedResponseURLProtocol.succeed(with: response)
	}
}
