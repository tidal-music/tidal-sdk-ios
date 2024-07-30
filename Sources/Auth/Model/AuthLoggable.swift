import Logging
import Foundation

public enum AuthLoggable {
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

extension AuthLoggable {
	private static let metadataErrorKey = "error"
	private static let metadataReasonKey = "reason"
	
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
			 .getCredentialsUpgradeTokenNetworkError(let error),
			 .getCredentialsRefreshTokenNetworkError(let error),
			 .getCredentialsRefreshTokenWithClientCredentialsNetworkError(let error):
			metadata[Self.metadataErrorKey] = .string(error.localizedDescription)
		case .authLogout(let reason, let error):
			metadata[Self.metadataReasonKey] = .string(reason)
			if let error = error {
				metadata[Self.metadataErrorKey] = .string(error.localizedDescription)
			}
			return metadata
		default:
			return [:]
		}
		
		return metadata
	}
	
	func log() {
		var logger = Logger(label: "auth_logger")
		logger.logLevel = .trace
		logger.log(level: .error, loggingMessage, metadata: loggingMetadata)
	}
}
