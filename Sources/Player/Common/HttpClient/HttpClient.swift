import Foundation

typealias RequestResponse = (urlResponse: HTTPURLResponse?, data: Data?)

// MARK: - ErrorCode

enum ErrorCode: Int {
	case noResponse = 0
	case noData
	case encodeFailed
	case decodeFailed
	case unsupportedHttpStatus
	case retriesExhausted

	func toPlayerInternalError(description: String? = nil) -> PlayerInternalError {
		PlayerInternalError(
			errorId: .EUnexpected,
			errorType: .httpClientError,
			code: rawValue,
			description: description
		)
	}
}

// MARK: - TaskCache

final class TaskCache {
	private var cache = [UUID: Task<Data?, Error>]()
	private let queue = DispatchQueue(label: "com.tidal.player.httpclient.taskcache")

	func add(_ task: Task<Data?, Error>, key: UUID) {
		queue.sync {
			cache[key] = task
		}
	}

	func remove(key: UUID) {
		queue.sync {
			_ = cache.removeValue(forKey: key)
		}
	}

	func cancelAll() {
		queue.sync {
			cache.values.forEach { $0.cancel() }
		}
	}

	func empty() {
		queue.sync {
			cache.removeAll()
		}
	}
}

// MARK: - HttpClient

final class HttpClient {
	private let urlSession: URLSession

	private let networkErrorManager: ErrorManager
	private let responseErrorManager: ErrorManager
	private let timeoutErrorManager: ErrorManager

	private let encoder: JSONEncoder
	private let decoder: JSONDecoder

	private var responseTasksCache = TaskCache()

	public init(
		using urlSession: URLSession = URLSession.shared,
		responseErrorManager: ErrorManager = ResponseErrorManager(),
		networkErrorManager: ErrorManager = NetworkErrorManager(),
		timeoutErrorManager: ErrorManager = TimeoutErrorManager()
	) {
		self.urlSession = urlSession
		self.responseErrorManager = responseErrorManager
		self.networkErrorManager = networkErrorManager
		self.timeoutErrorManager = timeoutErrorManager
		encoder = JSONEncoder()
		decoder = JSONDecoder()
	}

	func get(url: URL, headers: [String: String]) async throws -> Data {
		let request = HttpClient.createRequest(method: "GET", url: url, headers: headers)

		guard let data = try await perform(request) else {
			throw ErrorCode.noData.toPlayerInternalError()
		}

		return data
	}

	func getJson<T: Decodable>(url: URL, headers: [String: String]) async throws -> T {
		let data = try await get(url: url, headers: headers)

		return try decode(data)
	}

	func post(url: URL, headers: [String: String], payload: Data?) async throws -> Data? {
		var request = HttpClient.createRequest(method: "POST", url: url, headers: headers)
		request.httpBody = payload

		return try await perform(request)
	}

	func postJson<T: Decodable>(url: URL, headers: [String: String], payload: Data? = nil) async throws -> T {
		guard let data = try await post(url: url, headers: headers, payload: payload) else {
			throw ErrorCode.noData.toPlayerInternalError()
		}

		return try decode(data)
	}

	func put(url: URL, headers: [String: String], payload: Data?) async throws -> Data? {
		var request = HttpClient.createRequest(method: "PUT", url: url, headers: headers)
		request.httpBody = payload

		return try await perform(request)
	}

	func putJsonReceiveData<T: Encodable>(url: URL, headers: [String: String], payload: T) async throws -> Data? {
		let headers = ["content-type": "application/json", "accept": "application/json"].merging(headers) { key, _ in key }

		return try await put(url: url, headers: headers, payload: encode(payload))
	}

	func delete(url: URL, headers: [String: String]) async throws -> Data? {
		let request = HttpClient.createRequest(method: "DELETE", url: url, headers: headers)

		return try await perform(request)
	}

	func cancelAllRequests() {
		responseTasksCache.cancelAll()
		responseTasksCache.empty()
	}
}

private extension HttpClient {
	func perform(_ request: URLRequest) async throws -> Data? {
		let task: Task<Data?, Error>
		let uuid = UUID()

		defer { responseTasksCache.remove(key: uuid) }

		task = Task<Data?, Error> { () -> Data? in
			let responseHandler = ResponseHandler(
				request: request,
				executionBlock: urlSession.execute,
				responseErrorManager: responseErrorManager,
				networkErrorManager: networkErrorManager,
				timeoutErrorManager: timeoutErrorManager
			)
			let responseData = try await responseHandler.handle()
			return responseData
		}

		responseTasksCache.add(task, key: uuid)

		return try await task.value
	}

	func encode<T: Encodable>(_ data: T) throws -> Data {
		do {
			return try encoder.encode(data)
		} catch {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.payloadEncodingFailed(error: error))
			throw ErrorCode.encodeFailed.toPlayerInternalError(description: String(describing: error))
		}
	}

	func decode<T: Decodable>(_ data: Data) throws -> T {
		do {
			return try decoder.decode(T.self, from: data)
		} catch {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.payloadDecodingFailed(error: error))
			throw ErrorCode.decodeFailed.toPlayerInternalError(description: String(describing: error))
		}
	}
}

extension HttpClient {
	static func mapURLError(_ error: Error) -> Error {
		guard let urlError = error as? URLError else {
			return error
		}

		switch urlError.code {
		case .cancelled:
			return CancellationError()
		case .timedOut:
			return PlayerInternalError(
				errorId: .PENetwork,
				errorType: .timeOutError,
				code: urlError.code.rawValue,
				description: String(describing: urlError)
			)
		case .networkConnectionLost, .notConnectedToInternet, .cannotFindHost, .cannotConnectToHost, .dnsLookupFailed:
			return PlayerInternalError(
				errorId: .PENetwork,
				errorType: .networkError,
				code: urlError.code.rawValue,
				description: String(describing: urlError)
			)

		default:
			return PlayerInternalError(
				errorId: .PERetryable,
				errorType: .urlSessionError,
				code: urlError.code.rawValue,
				description: String(describing: urlError)
			)
		}
	}
}

private extension HttpClient {
	private static func createRequest(method: String, url: URL, headers: [String: String]?) -> URLRequest {
		var request = URLRequest(url: url)
		request.assumesHTTP3Capable = true
		request.httpMethod = method
		headers?.forEach { name, value in
			request.addValue(value, forHTTPHeaderField: name)
		}
		return request
	}
}

extension URLSession {
	func execute(_ request: URLRequest) async throws -> RequestResponse {
		do {
			let (data, response) = try await self.data(for: request)
			return (response as? HTTPURLResponse, data)
		} catch {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.loadDataForRequestFailed(error: error))
			throw HttpClient.mapURLError(error)
		}
	}
}
