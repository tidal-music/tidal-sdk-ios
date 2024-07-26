import Common
import Foundation

public enum AuthLoggable: Loggable {
	// swiftlint:disable identifier_name
	case initializeDeviceLoginNetworkError(error: Error)
	case finalizeLoginNetworkError(error: Error)
	case finalizeDeviceLoginNetworkError(error: Error)
	case finalizeDevicePollingLimitReached
	case getCredentialsUpgradeTokenNetworkError(error: Error)
	case getCredentialsScopeIsNotGranted
	case getCredentialsClientUniqueKeyIsDifferent
	case getCredentialsUpgradeTokenNoTokenInResponse
	case getCredentialsRefreshTokenNetworkError(error: Error)
	case getCredentialsRefreshTokenWithClientCredentialsNetworkError(error: Error)
	case authLogout(reason: String, error: Error? = nil)
	// swiftlint:enable identifier_name
	
	public var message: String {
		let associatedValuesPart = switch self {
		case .initializeDeviceLoginNetworkError(let error),
				.finalizeLoginNetworkError(let error),
				.finalizeDeviceLoginNetworkError(let error),
				.getCredentialsUpgradeTokenNetworkError(let error),
				.getCredentialsRefreshTokenNetworkError(let error),
				.getCredentialsRefreshTokenWithClientCredentialsNetworkError(let error):
			errorMessagePart(error: error)
		case .authLogout(let reason, let error):
			", reason: \(reason)\(errorMessagePart(error: error))"
		default:
			""
		}
		
		return "\(self)\(associatedValuesPart)"
	}
	
	private func errorMessagePart(error: Error?) -> String {
		guard let error = error else { return "" }
		return ", error: \(error.localizedDescription)"
	}
}
