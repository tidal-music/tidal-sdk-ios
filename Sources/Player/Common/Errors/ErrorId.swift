import Foundation

public enum ErrorId: String {
	case EUnexpected
	case PEContentNotAvailableInLocation
	case PEContentNotAvailableForSubscription
	case PEMonthlyStreamQuotaExceeded
	case PENotAllowed
	case PERetryable
	case PENetwork
	case OEContentNotAvailableInLocation
	case OEContentNotAvailableForSubscription
	case OEOffliningNotAllowedOnDevice
	case OENotAllowed
	case OERetryable
	case OENetwork

	static func playbackErrorId(from subStatus: Int) -> ErrorId {
		switch subStatus {
		case 4010:
			.PEMonthlyStreamQuotaExceeded
		case 4032, 4035:
			.PEContentNotAvailableInLocation
		case 4033:
			.PEContentNotAvailableForSubscription
		default:
			.PENotAllowed
		}
	}
}
