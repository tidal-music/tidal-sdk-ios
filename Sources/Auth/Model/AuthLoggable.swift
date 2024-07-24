import Common
import Foundation

public enum AuthLoggable: Loggable {
	// swiftlint:disable identifier_name
	case initializeDeviceLoginBackendError(error: Error)
	case finalizeLoginBackendError(error: Error)
	case finalizeDeviceLoginBackendError(error: Error)
	case finalizeDevicePollingLimitReached
	case getCredentialsUpgradeTokenBackendError(error: Error)
	case getCredentialsScopeIsNotGranted
	case getCredentialsClientUniqueKeyIsDifferent
	case getCredentialsUpgradeTokenNoTokenInResponse
	case getCredentialsRefreshTokenBackendError(error: Error)
	case getCredentialsRefreshTokenWithClientCredentialsBackendError(error: Error)
	case getCredentialsUserCredentialsDowngradedToClientCredentials
	// swiftlint:enable identifier_name
	
	public var message: String {
		let errorDescription: String = associatedErrorDescription.map {", error: \($0)" } ?? ""
		return "\(self)\(errorDescription)"
	}
	
	private var associatedErrorDescription: String? {
		switch self {
		case .initializeDeviceLoginBackendError(let error),
				.finalizeLoginBackendError(let error),
				.finalizeDeviceLoginBackendError(let error),
				.getCredentialsUpgradeTokenBackendError(let error),
				.getCredentialsRefreshTokenBackendError(let error),
				.getCredentialsRefreshTokenWithClientCredentialsBackendError(let error):
			return error.localizedDescription
		default:
			return nil
		}
	}
}
