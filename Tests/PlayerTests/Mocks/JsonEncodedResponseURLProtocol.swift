import Foundation
@testable import Player

// MARK: - AnError

struct AnError: Error {}

// MARK: - JsonEncodedResponseURLProtocol

final class JsonEncodedResponseURLProtocol: URLProtocol {
	struct Response {
		var httpStatus: Int?
		var data: Data?
		var error: Error?

		init(httpStatus: Int? = nil, data: Data? = nil, error: Error? = nil) {
			self.httpStatus = httpStatus
			self.data = data
			self.error = error
		}
	}

	private static var responses: [Response]?
	private static var requestCount: Int = 0
	private static var isMultiResponse: Bool = false
	private(set) static var requests = [URLRequest]()

	// swiftlint:disable force_try
	static func succeed<T: Encodable>(with result: T) {
		responses = [Response(data: try! JSONEncoder().encode(result))]
		isMultiResponse = false
	}

	// swiftlint:enable force_try

	static func fail(with error: Error? = AnError()) {
		responses = [Response(error: error)]
		isMultiResponse = false
	}

	static func fail(with httpStatus: Int? = nil, data: Data? = nil) {
		responses = [Response(httpStatus: httpStatus, data: data)]
		isMultiResponse = false
	}

	static func replay(_ responses: [Response]) {
		self.responses = responses
		isMultiResponse = true
	}

	static func reset() {
		responses = nil
		isMultiResponse = false
		requestCount = 0
	}

	override class func canInit(with request: URLRequest) -> Bool {
		true
	}

	override class func canonicalRequest(for request: URLRequest) -> URLRequest {
		requests.append(request)
		return request
	}

	override func startLoading() {
		defer { client?.urlProtocolDidFinishLoading(self) }

		guard let responses = JsonEncodedResponseURLProtocol.responses,
		      JsonEncodedResponseURLProtocol.requestCount < responses.count,
		      let response = JsonEncodedResponseURLProtocol.responses?[JsonEncodedResponseURLProtocol.requestCount]
		else {
			client?.urlProtocol(self, didFailWithError: AnError())
			return
		}

		if JsonEncodedResponseURLProtocol.isMultiResponse {
			JsonEncodedResponseURLProtocol.requestCount += 1
		}

		if let customError = response.error {
			client?.urlProtocol(self, didFailWithError: customError)
			return
		}

		let httpResponse: HTTPURLResponse = if let customHTTPStatus = response.httpStatus {
			HTTPURLResponse(url: request.url!, statusCode: customHTTPStatus, httpVersion: nil, headerFields: nil)!
		} else {
			HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
		}

		client?.urlProtocol(self, didReceive: httpResponse, cacheStoragePolicy: .notAllowed)

		if let data = response.data {
			client?.urlProtocol(self, didLoad: data)
		}
	}

	override func stopLoading() {}
}
