import Common
import Foundation

public enum AuthLoggable: Loggable {
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
}
