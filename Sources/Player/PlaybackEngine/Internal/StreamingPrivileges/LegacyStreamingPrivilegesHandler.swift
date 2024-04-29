import Auth
import Foundation

private let CONNECT_URL = URL(string: "https://api.tidal.com/v1/rt/connect")!

// MARK: - LegacyStreamingPrivilegesHandler

final class LegacyStreamingPrivilegesHandler {
	private let encoder: JSONEncoder = JSONEncoder()
	private let decoder: JSONDecoder = JSONDecoder()

	@Atomic private var task: URLSessionWebSocketTask?
	weak var delegate: StreamingPrivilegesHandlerDelegate?

	private let queue: OperationQueue
	private let httpClient: HttpClient
	private let accessTokenProvider: AccessTokenProvider

	init(
		_ httpClient: HttpClient,
		and accessTokenProvider: AccessTokenProvider
	) {
		queue = OperationQueue()
		queue.qualityOfService = .utility
		queue.maxConcurrentOperationCount = 1

		self.httpClient = httpClient
		self.accessTokenProvider = accessTokenProvider
	}

	func notify() {
		queue.dispatch {
			if self.task == nil {
				await self.connect()
			}

			if let task = self.task, let message = try? self.createMessage() {
				task.send(
					URLSessionWebSocketTask.Message.string(message),
					completionHandler: { _ in self.task = nil }
				)
			}
		}
	}

	func reset() {
		queue.dispatch {
			self.task?.cancel()
			self.task = nil
		}
	}
}

private extension LegacyStreamingPrivilegesHandler {
	func connect() async {
		guard let token = accessTokenProvider.accessToken else {
			return
		}

		let headers = ["Authorization": token]
		if let response: ConnectResponse = try? await httpClient.postJson(url: CONNECT_URL, headers: headers) {
			task = openWebSocket(response)
		}
	}

	func openWebSocket(_ response: ConnectResponse) -> URLSessionWebSocketTask? {
		let task = URL(string: response.url).map { URLSession.shared.webSocketTask(with: $0) }
		task?.receive(completionHandler: receiveAfterConnect)
		task?.resume()

		return task
	}

	/// The URLSessionWebSocket task listen for messages between the receive(completionHandler:) is called and a message is received.
	/// Which means that every time
	/// a message is successfully received we need to call receive(completionHandler:) again. Use "receiveAfterConnect" as the
	/// completion handler the first time
	/// receive(completionHandler:) is called. After a message has been received we switch the completion handler to the
	/// StreamingPrivilegesHandler's "receive" function.
	/// This avoids situations where a problem connecting to the websocket immediately triggers a reconnect. It does however
	/// reconnect if something fails and the
	/// websocket has received a message.
	/// If an error is encountered while connecting to the websocket, no attempt will be made to reconnect until an actual user
	/// action is encountered.
	func receiveAfterConnect(_ result: Result<URLSessionWebSocketTask.Message, Error>) {
		queue.dispatch {
			switch result {
			case let .success(message):
				await self.handle(message)
				self.task?.receive(completionHandler: self.receive)
			default:
				self.task = nil
				return
			}
		}
	}

	func receive(_ result: Result<URLSessionWebSocketTask.Message, Error>) {
		queue.dispatch {
			switch result {
			case let .success(message):
				await self.handle(message)
				self.task?.receive(completionHandler: self.receive)
			case .failure:
				self.task = nil
				await self.connect()
			}
		}
	}

	func handle(_ message: URLSessionWebSocketTask.Message) async {
		switch message {
		case let .string(text):
			await interpret(text)
			return
		default:
			return
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
			return
		case .RECONNECT:
			await connect()
			return
		}
	}

	func createMessage() throws -> String? {
		let data = try encoder.encode(UserAction())
		return String(data: data, encoding: .utf8)
	}
}
