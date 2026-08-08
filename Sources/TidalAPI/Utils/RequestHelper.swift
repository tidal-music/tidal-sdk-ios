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
			}
		)

		return try await retryHandler.execute()
	}

	static func createRequestIgnoringResponseBody<T>(
		customHeaders: [String: String] = [:],
		requestBuilder: @escaping () async throws -> RequestBuilder<T>
	) async throws {
		let builder = try await requestBuilder()
		try await createRequest(customHeaders: customHeaders) {
			requestBuilderIgnoringResponseBody(builder)
		}
	}

	static func requestBuilderIgnoringResponseBody<T>(_ builder: RequestBuilder<T>) -> RequestBuilder<Void> {
		let builderType: RequestBuilder<Void>.Type = OpenAPIClientAPI.requestBuilderFactory.getNonDecodableBuilder()
		return builderType.init(
			method: builder.method,
			URLString: builder.URLString,
			parameters: builder.parameters,
			headers: builder.headers,
			requiresAuthentication: builder.requiresAuthentication
		)
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
