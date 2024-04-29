import Foundation

public typealias PlayerProductType = ProductType

// MARK: - ProductType

public enum ProductType: Codable, Equatable {
	case TRACK
	case VIDEO
	case BROADCAST
	case UPLOADED_CONTENT(url: URL)

	func quality(given playbackContext: PlaybackContext) -> String {
		switch self {
		case .TRACK, .BROADCAST, .UPLOADED_CONTENT:
			playbackContext.audioQuality?.rawValue ?? "AQ N/A"
		case .VIDEO:
			playbackContext.videoQuality?.rawValue ?? "VQ N/A"
		}
	}

	func quality(given metadata: Metadata) -> String {
		switch self {
		case .TRACK, .BROADCAST, .UPLOADED_CONTENT:
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
		case .UPLOADED_CONTENT: "UPLOADED_CONTENT"
		}
	}
}

// MARK: CustomStringConvertible

extension ProductType: CustomStringConvertible {
	public var description: String {
		switch self {
		case .TRACK, .VIDEO, .BROADCAST: rawValue
		case let .UPLOADED_CONTENT(url): "\(rawValue) (\(url))"
		}
	}
}
