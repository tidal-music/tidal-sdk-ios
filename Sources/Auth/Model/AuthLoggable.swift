import Foundation
import Logging

// MARK: - AuthLoggable

enum AuthLoggable: TidalLoggable {
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
	case loadTokensFromStoreError(error: Error)
	// swiftlint:enable identifier_name
}

// MARK: - Logging

extension AuthLoggable {
	static var enableLogging: Bool = false
	private static let metadataPreviousSubstatusKey = "previous_substatus"

	var loggingMessage: Logger.Message {
		switch self {
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
		case .loadTokensFromStoreError:
			"LoadTokensFromStoreError"
		}
	}

	var loggingMetadata: Logger.Metadata {
		var metadata = [String: Logger.MetadataValue]()

		switch self {
		case let .initializeDeviceLoginNetworkError(error),
			let .finalizeLoginNetworkError(error),
			let .finalizeDeviceLoginNetworkError(error),
			let .getCredentialsUpgradeTokenNetworkError(error),
			let .loadTokensFromStoreError(error):
			metadata[Logger.Metadata.errorKey] = .string(.init(describing: error))
		case let .getCredentialsRefreshTokenNetworkError(error, previousSubstatus),
			let .getCredentialsRefreshTokenWithClientCredentialsNetworkError(error, previousSubstatus):
			metadata[Logger.Metadata.errorKey] = .string(.init(describing: error))
			metadata[Self.metadataPreviousSubstatusKey] = "\(previousSubstatus ?? "nil")"
		case let .authLogout(reason, error, previousSubstatus):
			metadata[Logger.Metadata.reasonKey] = "\(reason)"
			if let error = error {
				metadata[Logger.Metadata.errorKey] = .string(.init(describing: error))
			}
			metadata[Self.metadataPreviousSubstatusKey] = "\(previousSubstatus ?? "nil")"
			return metadata
		default:
			return [:]
		}
		
		metadata[Logger.Metadata.codeKey] = .string(eventCode)

		return metadata
	}

	var logLevel: Logger.Level {
		switch self {
		case .getCredentialsRefreshTokenIsNotAvailable, .finalizeDevicePollingLimitReached:
			.notice
		default:
			.error
		}
	}
	
	var source: String? {
		"Auth"
	}
	
	private var eventCode: String {
		let intCode = switch self {
		case .initializeDeviceLoginNetworkError:
			1
		case .finalizeLoginNetworkError:
			2
		case .finalizeDeviceLoginNetworkError:
			3
		case .finalizeDevicePollingLimitReached:
			4
		case .getCredentialsUpgradeTokenNetworkError:
			5
		case .getCredentialsScopeIsNotGranted:
			6
		case .getCredentialsClientUniqueKeyIsDifferent:
			7
		case .getCredentialsUpgradeTokenNoTokenInResponse:
			8
		case .getCredentialsRefreshTokenNetworkError:
			9
		case .getCredentialsRefreshTokenWithClientCredentialsNetworkError:
			10
		case .authLogout:
			11
		case .getCredentialsRefreshTokenIsNotAvailable:
			12
		case .loadTokensFromStoreError:
			13
		}
		
		return intCode.description
	}
}
