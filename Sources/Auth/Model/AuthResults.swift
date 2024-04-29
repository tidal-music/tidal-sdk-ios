import Common
import Foundation

// TODO: Add TidalMessage interface to Common and use it instead
public typealias AuthResult<T> = Result<T, TidalError>

extension AuthResult {
	/// Convenience function to quickly check if this result is a [AuthResult.Success]
	var isSuccess: Bool {
		if case .success = self {
			return true
		}

		return false
	}

	/// Convenience function to quickly check if this result is a [AuthResult.Failure]
	var isFailure: Bool {
		!isSuccess
	}

	/// Helper property to directly access the data payload without having to
	/// safequard it in every call
	var successData: Success? {
		if case let .success(value) = self {
			return value
		}

		return nil
	}

	/// Helper property to directly access the error payload without having to
	/// safequard it in every call
	var failureData: TidalError? {
		if case let .failure(error) = self {
			return error as? TidalError
		}

		return nil
	}
}
