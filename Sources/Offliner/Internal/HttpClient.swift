import Foundation

// MARK: - HttpClient

final class HttpClient {
	private let urlSession: URLSession

	init(urlSession: URLSession = .shared) {
		self.urlSession = urlSession
	}

	func get(url: URL, headers: [String: String]) async throws -> Data {
		let request = createRequest(method: "GET", url: url, headers: headers)
		return try await perform(request)
	}

	func post(url: URL, headers: [String: String], body: Data?) async throws -> Data {
		var request = createRequest(method: "POST", url: url, headers: headers)
		request.httpBody = body
		return try await perform(request)
	}

	private func createRequest(method: String, url: URL, headers: [String: String]) -> URLRequest {
		var request = URLRequest(url: url)
		request.httpMethod = method
		headers.forEach { name, value in
			request.addValue(value, forHTTPHeaderField: name)
		}
		return request
	}

	private func perform(_ request: URLRequest) async throws -> Data {
		let (data, response) = try await urlSession.data(for: request)

		guard let httpResponse = response as? HTTPURLResponse else {
			throw HttpClientError.noResponse
		}

		guard (200 ... 299).contains(httpResponse.statusCode) else {
			if (400 ... 499).contains(httpResponse.statusCode) {
				throw HttpClientError.clientError(statusCode: httpResponse.statusCode)
			} else {
				throw HttpClientError.serverError(statusCode: httpResponse.statusCode)
			}
		}

		guard !data.isEmpty else {
			throw HttpClientError.emptyResponse
		}

		return data
	}
}

// MARK: - HttpClientError

private enum HttpClientError: Error {
	case noResponse
	case emptyResponse
	case clientError(statusCode: Int)
	case serverError(statusCode: Int)
}
