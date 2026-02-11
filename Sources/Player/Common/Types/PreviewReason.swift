import Foundation

public enum PreviewReason: String, Codable {
	case FULL_REQUIRES_SUBSCRIPTION
	case FULL_REQUIRES_PURCHASE
	case FULL_REQUIRES_HIGHER_ACCESS_TIER
}
