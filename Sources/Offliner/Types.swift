import Foundation
import Player

// MARK: - OfflineMediaItemType

public enum OfflineMediaItemType: String {
	case tracks
	case videos
}

// MARK: - OfflineCollectionType

public enum OfflineCollectionType: String {
	case albums
	case playlists
}

// MARK: - OfflineMediaItem

public struct OfflineMediaItem {
	public struct TrackMetadata: Codable {
		public let id: String
		public let title: String
		public let artists: [String]
		public let duration: String
	}

	public struct VideoMetadata: Codable {
		public let id: String
		public let title: String
		public let artists: [String]
		public let duration: String
	}

	public enum Metadata {
		case track(TrackMetadata)
		case video(VideoMetadata)

		public var id: String {
			switch self {
			case .track(let metadata): return metadata.id
			case .video(let metadata): return metadata.id
			}
		}
	}

	public struct NormalizationData: Codable {
		public let peakAmplitude: Float?
		public let replayGain: Float?
	}

	public struct PlaybackMetadata: Codable {
		public let format: AudioFormat
		public let albumNormalizationData: NormalizationData?
		public let trackNormalizationData: NormalizationData?
	}

	public let catalogMetadata: Metadata
	public let playbackMetadata: PlaybackMetadata?
	public let mediaURL: URL
	public let licenseURL: URL?
	public let artworkURL: URL?
}

// MARK: - OfflineCollection

public struct OfflineCollection {
	public struct AlbumMetadata: Codable {
		public let id: String
		public let title: String
		public let artists: [String]
		public let copyright: String?
		public let releaseDate: Date?
		public let explicit: Bool
	}

	public struct PlaylistMetadata: Codable {
		public let id: String
		public let title: String
	}

	public enum Metadata {
		case album(AlbumMetadata)
		case playlist(PlaylistMetadata)

		public var id: String {
			switch self {
			case .album(let metadata): return metadata.id
			case .playlist(let metadata): return metadata.id
			}
		}
	}

	public let catalogMetadata: Metadata
	public let artworkURL: URL?
}

// MARK: - OfflineCollectionItem

public struct OfflineCollectionItem {
	public let item: OfflineMediaItem
	public let volume: Int
	public let position: Int
}

// MARK: - OfflineCollectionItemsPage

public struct OfflineCollectionItemsPage {
	public let items: [OfflineCollectionItem]
	public let cursor: Int64?
}
