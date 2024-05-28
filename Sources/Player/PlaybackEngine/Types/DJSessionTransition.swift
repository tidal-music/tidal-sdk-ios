import Foundation

// MARK: - DJSessionTransition

public struct DJSessionTransition {
	public let status: DJSessionStatus
	public let mediaProduct: MediaProduct
}

// MARK: - DJSessionStatus

public enum DJSessionStatus: String {
	case PLAYING
	case PAUSED
	case INCOMPATIBLE
	case UNAVAILABLE
}
