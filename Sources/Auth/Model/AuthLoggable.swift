import Logging
import Foundation
import Common

enum AuthLoggable {
	// swiftlint:disable identifier_name
	case initializeDeviceLoginNetworkError(error: Error)
	case finalizeLoginNetworkError(error: Error)
	case finalizeDeviceLoginNetworkError(error: Error)
	case finalizeDevicePollingLimitReached
	case getCredentialsUpgradeTokenNetworkError(error: Error)
	case getCredentialsScopeIsNotGranted
	case getCredentialsClientUniqueKeyIsDifferent
	case getCredentialsUpgradeTokenNoTokenInResponse
	case getCredentialsRefreshTokenNetworkError(error: Error, previousSubstatus: String? = nil)
	case getCredentialsRefreshTokenWithClientCredentialsNetworkError(error: Error, previousSubstatus: String? = nil)
	case authLogout(reason: String, error: Error? = nil, previousSubstatus: String? = nil)
	case getCredentialsRefreshTokenIsNotAvailable
	// swiftlint:enable identifier_name
}

// MARK: - Logging

extension AuthLoggable: TidalLoggable {
	private static let metadataErrorKey = "error"
	private static let metadataReasonKey = "reason"
	private static let metadataPreviousSubstatusKey = "previous_substatus"
	
	var loggingMessage: Logger.Message {
		return switch self {
		case .initializeDeviceLoginNetworkError:
			"InitializeDeviceLoginNetworkError"
		case .finalizeLoginNetworkError:
			"FinalizeLoginNetworkError"
		case .finalizeDeviceLoginNetworkError:
			"FinalizeDeviceLoginNetworkError"
		case .finalizeDevicePollingLimitReached:
			"FinalizeDevicePollingLimitReached"
		case .getCredentialsUpgradeTokenNetworkError:
			"GetCredentialsUpgradeTokenNetworkError"
		case .getCredentialsScopeIsNotGranted:
			"GetCredentialsScopeIsNotGranted"
		case .getCredentialsClientUniqueKeyIsDifferent:
			"GetCredentialsClientUniqueKeyIsDifferent"
		case .getCredentialsUpgradeTokenNoTokenInResponse:
			"GetCredentialsUpgradeTokenNoTokenIn"
		case .getCredentialsRefreshTokenNetworkError:
			"GetCredentialsRefreshTokenNetworkError"
		case .getCredentialsRefreshTokenWithClientCredentialsNetworkError:
			"GetCredentialsRefreshTokenWithClientCredentialsNetworkError"
		case .getCredentialsRefreshTokenIsNotAvailable:
			"getCredentialsRefreshTokenIsNotAvailable"
		case .authLogout:
			"AuthLogout"
		}
	}
	
	var loggingMetadata: Logger.Metadata {
		var metadata = [String: Logger.MetadataValue]()

		switch self {
		case .initializeDeviceLoginNetworkError(let error),
			 .finalizeLoginNetworkError(let error),
			 .finalizeDeviceLoginNetworkError(let error),
			 .getCredentialsUpgradeTokenNetworkError(let error):
			metadata[Self.metadataErrorKey] = "\(error.localizedDescription)"
		case .getCredentialsRefreshTokenNetworkError(let error, let previousSubstatus),
			 .getCredentialsRefreshTokenWithClientCredentialsNetworkError(let error, let previousSubstatus):
			metadata[Self.metadataErrorKey] = "\(error.localizedDescription)"
			metadata[Self.metadataPreviousSubstatusKey] = "\(previousSubstatus ?? "nil")"
		case .authLogout(let reason, let error, let previousSubstatus):
			metadata[Self.metadataReasonKey] = "\(reason)"
			if let error = error {
				metadata[Self.metadataErrorKey] = "\(error.localizedDescription)"
			}
			metadata[Self.metadataPreviousSubstatusKey] = "\(previousSubstatus ?? "nil")"
			return metadata
		default:
			return [:]
		}
		
		return metadata
	}
	
	var logLevel: Logger.Level {
		switch self {
		case .getCredentialsRefreshTokenIsNotAvailable, .finalizeDevicePollingLimitReached:
			return .notice
		default:
			return .error
		}
	}
	
	var source: String {
		"Auth"
	}
}
