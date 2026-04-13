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
		public let duration: Int
		public let explicit: Bool
	}

	public struct VideoMetadata: Codable {
		public let id: String
		public let title: String
		public let artists: [String]
		public let duration: Int
		public let explicit: Bool
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
}

// MARK: - OfflineCollection

public struct OfflineCollection: Hashable {
	public struct AlbumMetadata: Codable {
		public let id: String
		public let title: String
		public let artists: [String]
		public let copyright: String?
		public let releaseDate: Date?
		public let explicit: Bool
		/// Hex color string (e.g. "#A34F2B") extracted from artwork visual metadata at download time.
		public let backgroundColorHex: String?
	}

	public struct PlaylistMetadata: Codable {
		public let id: String
		public let title: String
		/// Hex color string (e.g. "#A34F2B") extracted from artwork visual metadata at download time.
		public let backgroundColorHex: String?
	}

	public enum Metadata: Hashable {
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

		public static func == (lhs: Metadata, rhs: Metadata) -> Bool {
			switch (lhs, rhs) {
			case let (.album(l), .album(r)): l.id == r.id
			case let (.playlist(l), .playlist(r)): l.id == r.id
			case let (.userCollectionTracks(l), .userCollectionTracks(r)): l == r
			default: false
			}
		}

		public func hash(into hasher: inout Hasher) {
			switch self {
			case let .album(metadata):
				hasher.combine(0)
				hasher.combine(metadata.id)
			case let .playlist(metadata):
				hasher.combine(1)
				hasher.combine(metadata.id)
			case let .userCollectionTracks(id):
				hasher.combine(2)
				hasher.combine(id)
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
