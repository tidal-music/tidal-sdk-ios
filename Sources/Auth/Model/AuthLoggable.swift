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
	case getCredentialsUserCredentialsDowngradedToClientCredentials
	// swiftlint:enable identifier_name
	
	public var message: String {
		let errorDescription: String = associatedErrorDescription.map {", error: \($0)" } ?? ""
		return "\(self)\(errorDescription)"
	}
	
	private var associatedErrorDescription: String? {
		switch self {
		case .initializeDeviceLoginNetworkError(let error),
				.finalizeLoginNetworkError(let error),
				.finalizeDeviceLoginNetworkError(let error),
				.getCredentialsUpgradeTokenNetworkError(let error),
				.getCredentialsRefreshTokenNetworkError(let error),
				.getCredentialsRefreshTokenWithClientCredentialsNetworkError(let error):
			return error.localizedDescription
		default:
			return nil
		}
	}
}
