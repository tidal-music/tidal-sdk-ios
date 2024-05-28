import Common
import Foundation

// MARK: - AuthorizationError

final class AuthorizationError: TidalError {}

// MARK: - UnexpectedError

final class UnexpectedError: TidalError {}

// MARK: - TokenResponseError

final class TokenResponseError: TidalError {}

public extension Error {
	var toTidalError: TidalError {
		if let tidalError = self as? TidalError {
			tidalError
		} else {
			UnexpectedError(code: "-1", throwable: self)
		}
	}
}
