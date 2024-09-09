import Auth
import Foundation

extension CredentialsProvider {
	/// Convenience function which get credentials and internally handle success(token) and failure (either when fetching credentials
	/// failed or if token received is nil), which finally throws an error.
	/// - Throws: Error thrown from failure in the Auth module, or ``PlayerInternalError`` if it's successful but a token is not
	/// returned.
	/// - Returns: Token if credentials was successfully fetched with a non-nil token.
	func getAuthBearerToken() async throws -> String {
		let credentials: Credentials

		do {
			credentials = try await getCredentials()
		} catch {
			throw error
		}

		guard let token = credentials.toBearerToken() else {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.getAuthBearerToken)
			// TODO: What error should we throw?
			throw PlayerInternalError(errorId: .EUnexpected, errorType: .authError, code: 0)
		}

		return token
	}
}

extension Credentials {
	func toBearerToken() -> String? {
		if let token {
			"Bearer \(token)"
		} else {
			nil
		}
	}
}
