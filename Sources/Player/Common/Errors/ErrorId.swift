import Foundation

public enum ErrorId: String {
	case EUnexpected
	case PEContentNotAvailableInLocation
	case PEContentNotAvailableForSubscription
	case PEMonthlyStreamQuotaExceeded
	case PENotAllowed
	case PERetryable
	case PENetwork
	case PENotSupported
	case PENotAllowedInOfflineMode
	case OEContentNotAvailableInLocation
	case OEContentNotAvailableForSubscription
	case OEOffliningNotAllowedOnDevice
	case OENotAllowed
	case OERetryable
	case OENetwork

	/// Maps TIDAL API error codes (from new OpenAPI endpoints) to Player error IDs
	/// Error codes like "GEO_RESTRICTED", "CLIENT_NOT_ENTITLED" come from ErrorObject.code
	static func playbackErrorId(from errorCode: String) -> ErrorId {
		switch errorCode {
		case "GEO_RESTRICTED":
			return .PEContentNotAvailableInLocation
		case "PURCHASE_REQUIRED":
			return .PEContentNotAvailableForSubscription
		case "CLIENT_NOT_ENTITLED", "CONTENT_NOT_FOUND", "PREREQUISITE_MISSING", "CONCURRENCY_LIMIT", "CONCURRENT_PLAYBACK":
			return .PENotAllowed
		case "TEMPORARY_ERROR", "INTERNAL_ERROR":
			return .PERetryable
		default:
			return .EUnexpected
		}
	}

	/// Maps legacy numeric subStatus codes to Player error IDs
	/// Legacy subStatus codes come from responses with subStatus field instead of ErrorObject
	static func playbackErrorId(from subStatus: Int) -> ErrorId {
		switch subStatus {
		case 4010:
			return .PEMonthlyStreamQuotaExceeded
		case 4032, 4035:
			return .PEContentNotAvailableInLocation
		case 4033:
			return .PEContentNotAvailableForSubscription
		default:
			PlayerWorld.logger?.log(loggable: PlayerLoggable.playbackErrorIdFromSubstatus(substatus: subStatus))
			return .PENotAllowed
		}
	}
}
