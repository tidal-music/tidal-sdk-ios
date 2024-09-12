import Foundation

public enum OfflineState {
	case NOT_OFFLINED
	case OFFLINED_AND_VALID
	case OFFLINED_BUT_NOT_VALID
	case OFFLINED_BUT_NO_LICENSE
	case OFFLINED_BUT_EXPIRED
}
