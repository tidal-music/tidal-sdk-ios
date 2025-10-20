import Foundation

public typealias PlayerProductType = ProductType

// MARK: - ProductType

public enum ProductType: Codable, Equatable {
	case TRACK
	case VIDEO
	case BROADCAST

	func quality(given playbackContext: PlaybackContext) -> String {
		switch self {
		case .TRACK, .BROADCAST:
			playbackContext.audioQuality?.rawValue ?? "AQ N/A"
		case .VIDEO:
			playbackContext.videoQuality?.rawValue ?? "VQ N/A"
		}
	}

	func quality(given metadata: Metadata) -> String {
		switch self {
		case .TRACK, .BROADCAST:
			metadata.audioQuality?.rawValue ?? "AQ N/A"
		case .VIDEO:
			metadata.videoQuality?.rawValue ?? "VQ N/A"
		}
	}

	public var rawValue: String {
		switch self {
		case .TRACK: "TRACK"
		case .VIDEO: "VIDEO"
		case .BROADCAST: "BROADCAST"
		}
	}
}

// MARK: CustomStringConvertible

extension ProductType: CustomStringConvertible {
	public var description: String {
		rawValue
	}
}
