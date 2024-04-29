import Foundation

private let CODE_PARAMETER_KEY = "code"
private let ERROR_MESSAGE_PARAMETER_KEY = "error_description"
private let ERROR_PARAMETER_KEY = "error"

private extension String {
	var hasError: Bool {
		// It's intentional that we don't add "^" & "$" as we're looking for a `containsMatchIn`, and not `matches` (ref Android
		// codebase)
		range(of: "(&|\\?)\(ERROR_PARAMETER_KEY)=(.+)", options: .regularExpression) != nil
	}

	var withRemovedQuery: String {
		components(separatedBy: "?")
			.first ?? self
	}

	var code: String {
		if let codeIndex = range(of: "\(CODE_PARAMETER_KEY)=")?.upperBound {
			let restOfString = self[codeIndex ..< endIndex]
			let codeIndexEnd = restOfString.range(of: "&")?.lowerBound ?? endIndex
			return String(self[codeIndex ..< codeIndexEnd])
		}

		return ""
	}

	var errorMessage: String {
		if let errorIndex = range(of: "\(ERROR_MESSAGE_PARAMETER_KEY)=")?.upperBound {
			let restOfString = self[errorIndex ..< endIndex]
			let errorIndexEnd = restOfString.range(of: "&")?.lowerBound ?? endIndex
			return String(self[errorIndex ..< errorIndexEnd])
		}

		return ""
	}
}

// MARK: - RedirectUri

enum RedirectUri: Hashable {
	case success(url: String, code: String)
	case failure(errorMessage: String)

	static func fromUriString(uri: String) -> RedirectUri {
		if uri.hasError || uri.code.isEmpty {
			.failure(errorMessage: uri.errorMessage)
		} else {
			.success(url: uri.withRemovedQuery, code: uri.code)
		}
	}
}
