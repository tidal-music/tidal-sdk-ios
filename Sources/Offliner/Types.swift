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
	case userCollectionTracks
}

// MARK: - OfflineMediaItem

public struct OfflineMediaItem {
	public struct TrackMetadata: Codable {
		public let id: String
		public let title: String
		public let artists: [String]
		public let artistIds: [String]?
		public let duration: Int
		public let explicit: Bool?
		public let mediaTags: [String]?
		public let streamStartDate: Date?
	}

	public struct VideoMetadata: Codable {
		public let id: String
		public let title: String
		public let artists: [String]
		public let artistIds: [String]?
		public let duration: Int
	}

	public enum Metadata {
		case track(TrackMetadata)
		case video(VideoMetadata)

		public var id: String {
			switch self {
			case let .track(metadata): metadata.id
			case let .video(metadata): metadata.id
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
	public let artworkId: String?
}

// MARK: - OfflineCollection

public struct OfflineCollection {
	public struct AlbumMetadata: Codable {
		public let id: String
		public let title: String
		public let artists: [String]
		public let artistIds: [String]?
		public let copyright: String?
		public let releaseDate: Date?
		public let explicit: Bool
	}

	public struct PlaylistMetadata: Codable {
		public let id: String
		public let title: String
		public let description: String?
		public let createdAt: Date?
		public let lastModifiedAt: Date?
	}

	public enum Metadata {
		case album(AlbumMetadata)
		case playlist(PlaylistMetadata)
		case userCollectionTracks(id: String)

		public var id: String {
			switch self {
			case let .album(metadata): metadata.id
			case let .playlist(metadata): metadata.id
			case let .userCollectionTracks(id): id
			}
		}
	}

	public let catalogMetadata: Metadata
	public let artworkURL: URL?
	public let artworkId: String?
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
