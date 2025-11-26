import Auth
import Common
import Foundation

enum RequestHelper {
	static func createRequest<T>(
		customHeaders: [String: String] = [:],
		requestBuilder: @escaping () async throws -> RequestBuilder<T>
	) async throws -> T {
		let builder = try await requestBuilder()
		let retryHandler = TidalAPIRetryHandler(
			httpMethod: builder.method,
			executionBlock: {
				try await executeRequestWithAuth(
					customHeaders: customHeaders,
					builder: builder
				)
			})

		return try await retryHandler.execute()
	}

	private static func executeRequestWithAuth<T>(
		customHeaders: [String: String],
		builder: RequestBuilder<T>
	) async throws -> T {
		guard let credentialsProvider = OpenAPIClientAPI.credentialsProvider else {
			throw TidalAPIError(message: "NO_CREDENTIALS_PROVIDER", url: "Not available")
		}

		let credentials = try await credentialsProvider.getCredentials()
		let requestURL = builder.URLString
		guard let token = credentials.token else {
			throw TidalAPIError(
				message: "NO_TOKEN",
				url: requestURL
			)
		}

		var request = builder
			.addHeader(name: "Authorization", value: "Bearer \(token)")

		for (key, value) in customHeaders {
			request = request.addHeader(name: key, value: value)
		}

		return try await request.execute().body
	}
}
