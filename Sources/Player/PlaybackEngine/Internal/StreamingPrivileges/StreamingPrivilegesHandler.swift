import Auth
import Foundation

// MARK: - Constants

private enum Constants {
	static let webSocketURL = URL(string: "https://api.tidal.com/v1/rt/connect")!
}

// MARK: - StreamingPrivilegesHandler

final class StreamingPrivilegesHandler {
	private var configuration: Configuration {
		didSet {
			if configuration.offlineMode {
				disconnect()
			}
		}
	}

	private let httpClient: HttpClient
	private let credentialsProvider: CredentialsProvider
	private let webSocket: WebSocket
	private let errorManager: ErrorManager

	private let encoder: JSONEncoder = JSONEncoder()
	private let decoder: JSONDecoder = JSONDecoder()

	@Atomic private var webSocketTask: WebSocketTask?
	private var reconnectAttemptCount = 0

	weak var delegate: StreamingPrivilegesHandlerDelegate?

	init(
		configuration: Configuration,
		httpClient: HttpClient,
		credentialsProvider: CredentialsProvider,
		webSocket: WebSocket = WebSocketClient(),
		errorManager: ErrorManager = WebSocketErrorManager(backoffPolicy: JitteredBackoffPolicy.webSocketBackoffPolicy)
	) {
		self.configuration = configuration
		self.httpClient = httpClient
		self.credentialsProvider = credentialsProvider
		self.webSocket = webSocket
		self.errorManager = errorManager
	}
}

extension StreamingPrivilegesHandler {
	func notify() async {
		do {
			// If user is not authenticated with user level, there's no need to even attempt to connect to the web socket.
			if try await !credentialsProvider.getCredentials().isAuthorized {
				return
			}
		} catch {
			PlayerWorld.logger()?.log(loggable: PlayerLoggable.streamingNotifyNotAuthorized(error: error))
			print("StreamingPrivilegesHandler failed to get credentials")
			return
		}

		// If the task is nil, it means it's the first time we are attempting to connect. So we should connect and send the message
		// afterwards.
		// Otherwise, we are already connected and only need to send the message.
		if webSocketTask == nil {
			await connect()
			await sendMessage(shouldReceive: true)
		} else {
			await sendMessage(shouldReceive: false)
		}
	}

	func disconnect() {
		webSocketTask?.cancel(with: .normalClosure)
		webSocketTask = nil
		resetReconnectAttemptCount()
	}

	func updateConfiguration(_ configuration: Configuration) {
		self.configuration = configuration
	}
}

private extension StreamingPrivilegesHandler {
	// MARK: - Send message

	/// Sends message to the web socket, notifying BE that the user is playing. Afterwards, in message is successfully sent, it calls
	/// ``receive`` func is ``shouldReceive`` is true.
	/// - Parameter shouldReceive: Flag whether ``receive`` func should be called after the message is sent.
	func sendMessage(shouldReceive: Bool) async {
		guard let webSocketTask, webSocketTask.closeCode == .invalid, let message = try? createMessage() else {
			return
		}

		let taskMessage = URLSessionWebSocketTask.Message.string(message)
		do {
			try await webSocketTask.send(taskMessage)

			if shouldReceive {
				await receive()
			}
		} catch {
			PlayerWorld.logger()?.log(loggable: PlayerLoggable.webSocketSendMessageFailed(error: error))
			self.webSocketTask = nil
		}
	}

	// MARK: - Connect

	/// Opens the connection with the web socket.
	func connect() async {
		if configuration.offlineMode {
			return
		}

		var token: String?

		do {
			let authToken = try await credentialsProvider.getCredentials()
			token = authToken.toBearerToken()
		} catch {
			PlayerWorld.logger()?.log(loggable: PlayerLoggable.streamingConnectNotAuthorized(error: error))
			print("StreamingPrivilegesHandler failed to get credentials")
		}

		guard let token else {
			return
		}

		let headers = ["Authorization": token]
		if let response: ConnectResponse = try? await httpClient.postJson(url: Constants.webSocketURL, headers: headers) {
			webSocketTask = webSocket.open(response)
		}
	}

	// MARK: - Receive

	func receive() async {
		guard let webSocketTask, webSocketTask.closeCode == .invalid else {
			return
		}
		do {
			let message = try await webSocketTask.receive()

			resetReconnectAttemptCount()

			await handle(message)
			await receive()
		} catch {
			PlayerWorld.logger()?.log(loggable: PlayerLoggable.webSocketReceiveMessageFailed(error: error))
			await handleError(error: error)
		}
	}

	// MARK: - Error handling

	func handleError(error: Error) async {
		let retryStrategy = errorManager.onError(error, attemptCount: reconnectAttemptCount)

		switch retryStrategy {
		case let .BACKOFF(duration):
			reconnectAttemptCount += 1
			do {
				try await Task.sleep(seconds: duration)
				await reconnectAfterFailures()
			} catch {
				PlayerWorld.logger()?.log(loggable: PlayerLoggable.webSocketHandleErrorSleepAndReconnectionFailed(error: error))
				print(
					"Sleep for \(duration)s when reconnecting (attempt count \(reconnectAttemptCount)) got cancelled, stopping. Error: \(error)"
				)
			}
		case .NONE:
			print("Tried to reconnect max number of attempts, giving up. Error: \(error)")
		}
	}

	// MARK: - Reconnect

	/// Reconnects to the web socket.
	func reconnect() async {
		webSocketTask = nil
		await connect()
	}

	/// After failures on connection have occurred, this reconnects to the web socket and calls ``receive`` func afterwards.
	func reconnectAfterFailures() async {
		await reconnect()
		await receive()
	}

	func resetReconnectAttemptCount() {
		reconnectAttemptCount = 0
	}

	// MARK: - Message

	func createMessage() throws -> String? {
		let data = try encoder.encode(UserAction())
		return String(data: data, encoding: .utf8)
	}

	func handle(_ message: URLSessionWebSocketTask.Message) async {
		switch message {
		case let .string(text):
			await interpret(text)
		default:
			break
		}
	}

	func interpret(_ text: String) async {
		guard let data = text.data(using: .utf8),
		      let message = try? decoder.decode(IncomingMessage.self, from: data)
		else {
			return
		}

		switch message.type {
		case .PRIVILEGED_SESSION_NOTIFICATION:
			delegate?.streamingPrivilegesLost(to: message.payload?["clientDisplayName"])
		case .RECONNECT:
			await reconnect()
		}
	}
}
