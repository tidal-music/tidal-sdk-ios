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
