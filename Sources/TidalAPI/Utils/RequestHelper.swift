import Auth
import Common
import Foundation

enum RequestHelper {
	private static var retries: [String: Int?] = [:]

	static func createRequest<T>(
		requestBuilder: @escaping () async throws -> RequestBuilder<T>
	) async throws -> T {
		guard let credentialsProvider = OpenAPIClientAPI.credentialsProvider else {
			throw TidalAPIError(message: "NO_CREDENTIALS_PROVIDER", url: "Not available")
		}

		let credentials = try await credentialsProvider.getCredentials()
		let requestBuilder = try await requestBuilder()
		let requestURL = requestBuilder.URLString
		guard let token = credentials.token else {
			throw TidalAPIError(
				message: "NO_TOKEN",
				url: requestURL
			)
		}

		let request = requestBuilder
			.addHeader(name: "Authorization", value: "Bearer \(token)")

		do {
			let result = try await request.execute().body
			// Clear the retry count for the URL on success
			retries[requestURL] = nil
			return result
		} catch let error as ErrorResponse {
			return try await handleErrorResult(
				error,
				urlAttachedToError: requestURL,
				requestBuilder: { requestBuilder }
			)
		} catch {
			throw TidalError(code: error.localizedDescription)
		}
	}

	static func createRequest<T>(
		customHeaders: [String: String] = [:],
		requestBuilder: @escaping () async throws -> RequestBuilder<T>
	) async throws -> T {
		guard let credentialsProvider = OpenAPIClientAPI.credentialsProvider else {
			throw TidalAPIError(message: "NO_CREDENTIALS_PROVIDER", url: "Not available")
		}

		let credentials = try await credentialsProvider.getCredentials()
		let builder = try await requestBuilder()
		let requestURL = builder.URLString
		guard let token = credentials.token else {
			throw TidalAPIError(
				message: "NO_TOKEN",
				url: requestURL
			)
		}

		var request = builder
			.addHeader(name: "Authorization", value: "Bearer \(token)")

		// Add custom headers
		for (key, value) in customHeaders {
			request = request.addHeader(name: key, value: value)
		}

		do {
			let result = try await request.execute().body
			// Clear the retry count for the URL on success
			retries[requestURL] = nil
			return result
		} catch let error as ErrorResponse {
			return try await handleErrorResult(
				error,
				urlAttachedToError: requestURL,
				requestBuilder: {
					var builder = try await requestBuilder()
					for (key, value) in customHeaders {
						builder = builder.addHeader(name: key, value: value)
					}
					return builder
				}
			)
		} catch {
			throw TidalError(code: error.localizedDescription)
		}
	}

	static func handleErrorResult<T>(
		_ error: ErrorResponse,
		urlAttachedToError url: String,
		requestBuilder: @escaping () async throws -> RequestBuilder<T>
	) async throws -> T {
		func getHttpSubStatus(data: Data?) -> Int? {
			guard let data else {
				return nil
			}

			do {
				if let parsedObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
				   let subStatus = parsedObject["subStatus"] as? Int
				{
					return subStatus
				}
			} catch {
				return nil
			}
			return nil
		}

		func getErrorObject(data: Data?) -> ErrorObject? {
			guard let data else {
				return nil
			}

			do {
				let errorsDocument = try JSONDecoder().decode(ErrorsDocument.self, from: data)
				return errorsDocument.errors?.first
			} catch {
				return nil
			}
		}

		let currentRetryCount = retries[url] ?? 0 // Default to 0 if nil

		guard let provider = OpenAPIClientAPI.credentialsProvider else {
			throw TidalAPIError(message: "NO_CREDENTIALS_PROVIDER", url: url)
		}

		switch error {
		case let .error(statusCode, data, _, underlyingError):
			if isCancelled(underlyingError) {
				throw TidalAPIError(error: error, url: url, type: .cancelled)
			}
			if statusCode == 401 {
				let subStatus = getHttpSubStatus(data: data)
				let errorObject = getErrorObject(data: data)

				do {
					_ = try await provider.getCredentials(apiErrorSubStatus: subStatus.flatMap(String.init))
				} catch {
					if subStatus != nil {
						throw TidalAPIError(
							message: "Failed to get credentials",
							url: url,
							statusCode: statusCode,
							subStatus: subStatus,
							errorObject: errorObject
						)
					} else {
						throw TidalAPIError(error: error, url: url)
					}
				}

				if subStatus != nil, OpenAPIClientAPI.credentialsProvider?.isUserLoggedIn == false {
					throw TidalAPIError(
						message: "User is not logged in",
						url: url,
						statusCode: statusCode,
						subStatus: subStatus,
						errorObject: errorObject
					)
				}

				// Retry the async operation if the retry count is 0
				if currentRetryCount == 0 {
					retries[url] = 1 // Increment retry count to 1
					let result = try await createRequest(requestBuilder: requestBuilder)
					return result
				}
			}
		}

		let subStatus = getHttpSubStatus(data: error.data)
		let errorObject = getErrorObject(data: error.data)
		throw TidalAPIError(
			error: error,
			url: url,
			statusCode: error.statusCode,
			subStatus: subStatus,
			errorObject: errorObject
		) // Propagate the error if not handled or retried
	}

	private static func isCancelled(_ error: Error) -> Bool {
		if error is CancellationError || (error as? URLError)?.code == .cancelled {
			true
		} else {
			false
		}
	}
}

extension ErrorResponse {
	var statusCode: Int? {
		if case let .error(code, _, _, _) = self {
			return code
		}
		return nil
	}

	var data: Data? {
		if case let .error(_, responseData, _, _) = self {
			return responseData
		}
		return nil
	}
}
