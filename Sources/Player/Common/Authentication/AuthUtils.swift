import Foundation

extension AccessTokenProvider {
	func authenticate<T>(andRun function: (String) async throws -> T) async throws -> T {
		guard let accessToken else {
			try await renew(with: nil)
			return try await authenticate(andRun: function)
		}

		do {
			return try await function(accessToken)
		} catch let HttpError.httpClientError(statusCode: s, message: m) where s == 401 {
			let status = extractSubStatus(message: m)
			try await renew(with: status)
			return try await authenticate(andRun: function)
		} catch {
			throw error
		}
	}
}

// MARK: - TokenRenewalFailed

struct TokenRenewalFailed: Error {}

private extension AccessTokenProvider {
	func renew(with status: Int?) async throws {
		do {
			try await renewAccessToken(status: status)
		} catch {
			throw TokenRenewalFailed()
		}
	}
}

func extractSubStatus(message: Data?) -> Int? {
	guard let data = message else {
		return nil
	}

	guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
		return nil
	}

	guard let deserialized = json as? [String: Any] else {
		return nil
	}

	guard let subStatus = deserialized["subStatus"] else {
		return nil
	}

	return subStatus as? Int
}
