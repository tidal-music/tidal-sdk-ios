import Foundation
#if canImport(FoundationNetworking)
	import FoundationNetworking
#endif

// MARK: - OpenAPIClientAPI

open class OpenAPIClientAPI {
	public static var basePath = "https://openapi.tidal.com/v2"
	public static var customHeaders: [String: String] = [:]
	public static var credential: URLCredential?
	public static var requestBuilderFactory: RequestBuilderFactory = URLSessionRequestBuilderFactory()
	public static var apiResponseQueue: DispatchQueue = .main
}

// MARK: - RequestBuilder

open class RequestBuilder<T> {
	var credential: URLCredential?
	var headers: [String: String]
	public let parameters: [String: Any]?
	public let method: String
	public let URLString: String
	public let requestTask: RequestTask = RequestTask()
	public let requiresAuthentication: Bool

	/// Optional block to obtain a reference to the request's progress instance when available.
	public var onProgressReady: ((Progress) -> Void)?

	public required init(
		method: String,
		URLString: String,
		parameters: [String: Any]?,
		headers: [String: String] = [:],
		requiresAuthentication: Bool
	) {
		self.method = method
		self.URLString = URLString
		self.parameters = parameters
		self.headers = headers
		self.requiresAuthentication = requiresAuthentication

		addHeaders(OpenAPIClientAPI.customHeaders)
	}

	open func addHeaders(_ aHeaders: [String: String]) {
		for (header, value) in aHeaders {
			headers[header] = value
		}
	}

	@discardableResult
	open func execute(
		_ apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue,
		_ completion: @escaping (_ result: Swift.Result<Response<T>, ErrorResponse>) -> Void
	) -> RequestTask {
		requestTask
	}

	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	@discardableResult
	open func execute() async throws -> Response<T> {
		try await withTaskCancellationHandler {
			try Task.checkCancellation()
			return try await withCheckedThrowingContinuation { continuation in
				guard !Task.isCancelled else {
					continuation.resume(throwing: CancellationError())
					return
				}

				self.execute { result in
					switch result {
					case let .success(response):
						continuation.resume(returning: response)
					case let .failure(error):
						continuation.resume(throwing: error)
					}
				}
			}
		} onCancel: {
			self.requestTask.cancel()
		}
	}

	public func addHeader(name: String, value: String) -> Self {
		if !value.isEmpty {
			headers[name] = value
		}
		return self
	}

	open func addCredential() -> Self {
		credential = OpenAPIClientAPI.credential
		return self
	}
}

// MARK: - RequestBuilderFactory

public protocol RequestBuilderFactory {
	func getNonDecodableBuilder<T>() -> RequestBuilder<T>.Type
	func getBuilder<T: Decodable>() -> RequestBuilder<T>.Type
}
