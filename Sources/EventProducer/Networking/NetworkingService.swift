import Foundation

// MARK: - HTTPTransport

protocol HTTPTransport: Sendable {
	func send(_ request: URLRequest) async throws -> (Data, URLResponse)
}

// MARK: - URLSession + HTTPTransport

extension URLSession: HTTPTransport {
	func send(_ request: URLRequest) async throws -> (Data, URLResponse) {
		try await data(for: request)
	}
}

// MARK: - NetworkingService

struct NetworkingService {
	var consumerUri: String?
	var transport: any HTTPTransport = URLSession.shared

	func sendEventBatch(endpoint: Endpoint) async throws -> Data {
		guard let consumerUri,
		      let request = endpoint.request(to: consumerUri)
		else {
			throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
		}

		let (data, response) = try await transport.send(request)

		guard let httpResponse = response as? HTTPURLResponse else {
			throw NSError(domain: "Request Failed", code: 0, userInfo: nil)
		}

		let statusCode = httpResponse.statusCode

		switch statusCode {
		case 200 ... 299:
			return data
		case 401:
			throw EventProducerError.unauthorized(statusCode)
		default:
			throw NSError(domain: "Request Failed", code: 0, userInfo: nil)
		}
	}

	func getRequestBodyData(parameters: [String: String]) throws -> Data? {
		let body = parameters.map { key, value in
			"\(key)=\(value.isEmpty ? " " : value)"
		}.compactMap { $0 }.joined(separator: "&")
		return body.data(using: .utf8)
	}
}
