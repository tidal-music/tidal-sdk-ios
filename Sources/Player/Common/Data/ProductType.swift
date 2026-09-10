import Foundation

public typealias PlayerProductType = ProductType

// MARK: - ProductType

public enum ProductType: Codable, Equatable {
	case TRACK
	case VIDEO
	/// A file already on the device, played straight off disk with no playback info fetched for it.
	///
	/// The URL must be a `file://` URL. Its only caller today is user-uploaded content the backend
	/// has not finished processing: there is no product to look up yet, so the uploader plays the
	/// copy they still hold.
	case LOCAL(url: URL)

	func quality(given playbackContext: PlaybackContext) -> String {
		switch self {
		case .TRACK, .LOCAL:
			playbackContext.audioQuality?.rawValue ?? "AQ N/A"
		case .VIDEO:
			playbackContext.videoQuality?.rawValue ?? "VQ N/A"
		}
	}

	func quality(given metadata: Metadata) -> String {
		switch self {
		case .TRACK, .LOCAL:
			metadata.audioQuality?.rawValue ?? "AQ N/A"
		case .VIDEO:
			metadata.videoQuality?.rawValue ?? "VQ N/A"
		}
	}

	public var rawValue: String {
		switch self {
		case .TRACK: "TRACK"
		case .VIDEO: "VIDEO"
		case .LOCAL: "LOCAL"
		}
	}
}

// MARK: CustomStringConvertible

extension ProductType: CustomStringConvertible {
	public var description: String {
		switch self {
		case .TRACK, .VIDEO: rawValue
		case let .LOCAL(url): "\(rawValue) (\(url))"
		}
	}
}
