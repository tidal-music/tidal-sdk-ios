import Foundation

public typealias PlayerProductType = ProductType

// MARK: - ProductType

public enum ProductType: Codable, Equatable {
	case TRACK
	case VIDEO
	case UC(url: URL)
	/// A specific source file (version) of a track, played through ``TrackSourceFileMediaProduct``.
	case TRACK_SOURCE_FILE

	func quality(given playbackContext: PlaybackContext) -> String {
		switch self {
		case .TRACK, .UC, .TRACK_SOURCE_FILE:
			playbackContext.audioQuality?.rawValue ?? "AQ N/A"
		case .VIDEO:
			playbackContext.videoQuality?.rawValue ?? "VQ N/A"
		}
	}

	func quality(given metadata: Metadata) -> String {
		switch self {
		case .TRACK, .UC, .TRACK_SOURCE_FILE:
			metadata.audioQuality?.rawValue ?? "AQ N/A"
		case .VIDEO:
			metadata.videoQuality?.rawValue ?? "VQ N/A"
		}
	}

	public var rawValue: String {
		switch self {
		case .TRACK: "TRACK"
		case .VIDEO: "VIDEO"
		case .UC: "UC"
		case .TRACK_SOURCE_FILE: "TRACK_SOURCE_FILE"
		}
	}
}

// MARK: CustomStringConvertible

extension ProductType: CustomStringConvertible {
	public var description: String {
		switch self {
		case .TRACK, .VIDEO, .TRACK_SOURCE_FILE: rawValue
		case let .UC(url): "\(rawValue) (\(url))"
		}
	}
}
