import Foundation

// MARK: - ApiErrorSubValue

struct ApiErrorSubValue {
	let value: String
	let shouldTriggerRefresh: Bool
}

// MARK: - ApiErrorSubStatus

enum ApiErrorSubStatus: String, CaseIterable {
	case authorizationPending = "1002"
	case sessionDoesNotExist = "6001"
	case temporaryAuthServerError = "11001"
	case invalidAccessToken = "11002"
	case expiredAccessToken = "11003"

	var shouldTriggerRefresh: Bool {
		switch self {
		case .authorizationPending:
			false
		case .sessionDoesNotExist:
			true
		case .temporaryAuthServerError:
			true
		case .invalidAccessToken:
			true
		case .expiredAccessToken:
			true
		}
	}
}

extension String {
	var shouldRefreshToken: Bool {
		ApiErrorSubStatus(rawValue: self)?.shouldTriggerRefresh == true
	}

	func isSubStatus(status: ApiErrorSubStatus) -> Bool {
		self == status.rawValue
	}
}
