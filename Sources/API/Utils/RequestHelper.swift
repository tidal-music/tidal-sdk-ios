import Auth
import Common
import Foundation

enum RequestHelper {
	private static var retries: [String: Int?] = [:]
	
	static func createRequest<T>(
		requestBuilder: @escaping () async throws -> RequestBuilder<T>
	) async throws -> T {
		guard let credentialsProvider = OpenAPIClientAPI.credentialsProvider else {
			throw APIError(message: "NO_CREDENTIALS_PROVIDER", url: "Not available")
		}
		
		let credentials = try await credentialsProvider.getCredentials()
		let requestBuilder = try await requestBuilder()
		let requestURL = requestBuilder.URLString
		guard
			let token = credentials.token,
			OpenAPIClientAPI.credentialsProvider?.isUserLoggedIn == true
		else {
			throw APIError(
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
	
	static func handleErrorResult<T>(
		_ error: ErrorResponse,
		urlAttachedToError url: String,
		requestBuilder: @escaping () async throws -> RequestBuilder<T>
	) async throws -> T {
		func getHttpSubStatus(data: Data?) -> Int? {
			guard let data = data else {
				return nil
			}
			
			do {
				if let parsedObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
					 let subStatus = parsedObject["subStatus"] as? Int {
					return subStatus
				}
			} catch {
				return nil
			}
			return nil
		}
		
		let currentRetryCount = retries[url] ?? 0 // Default to 0 if nil
		
		guard let provider = OpenAPIClientAPI.credentialsProvider else {
			throw APIError(message: "NO_CREDENTIALS_PROVIDER", url: url)
		}
		
		switch error {
		case .error(let statusCode, let data, _, _):
			if statusCode == 401 {
				let subStatus = getHttpSubStatus(data: data)
				
				do {
					_ = try await provider.getCredentials(apiErrorSubStatus: subStatus.flatMap(String.init))
				} catch {
					if subStatus != nil {
						throw APIError(
							message: "Failed to get credentials",
							url: url,
							statusCode: statusCode,
							subStatus: subStatus
						)
					} else {
						throw APIError(error: error, url: url)
					}
				}
				
				if subStatus != nil, OpenAPIClientAPI.credentialsProvider?.isUserLoggedIn == false {
					throw APIError(
						message: "User is not logged in",
						url: url,
						statusCode: statusCode,
						subStatus: subStatus
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
		
		throw APIError(error: error, url: url) // Propagate the error if not handled or retried
	}
}
