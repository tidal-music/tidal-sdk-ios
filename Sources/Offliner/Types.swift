import Foundation
import Player

// MARK: - OfflineMediaItemType

public enum OfflineMediaItemType: String, Sendable {
	case tracks
	case videos
}

// MARK: - OfflineCollectionType

public enum OfflineCollectionType: String, Sendable {
	case albums
	case playlists
	case userCollectionTracks
}

// MARK: - ResourceId

public enum ResourceId: Sendable {
	case identifier(String)
	case me

	var stringValue: String {
		switch self {
		case let .identifier(value): value
		case .me: "me"
		}
	}
}

// MARK: - OfflineMediaItem

public struct OfflineMediaItem {
	public struct TrackMetadata: Codable {
		public let id: String
		public let title: String
		public let artists: [String]
		public let duration: Int
		public let explicit: Bool
		public let backgroundColorHex: String?
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

// MARK: - OfflineCollectionState

public enum OfflineCollectionState: Hashable {
	case pending
	case stored
}

// MARK: - OfflineCollectionDownloadState

/// Collection-level offline availability for albums, playlists, and user collection tracks.
///
/// This state describes whether collection media is available offline or known by this SDK instance to be acquired. It
/// does not model generic offliner task activity: collection removal is represented as `notDownloaded`, not
/// `downloading`.
public enum OfflineCollectionDownloadState: Sendable, Hashable {
	/// The collection is not locally downloaded, or it is being removed.
	case notDownloaded

	/// The collection or one of its members has active download/acquisition work known by this SDK instance.
	case downloading

	/// The collection is locally stored and there is no locally known pending download/acquisition work.
	case downloaded
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
	public let state: OfflineCollectionState
	public let addedAt: Date

	public init(
		catalogMetadata: Metadata,
		artworkURL: URL?,
		state: OfflineCollectionState = .stored,
		addedAt: Date
	) {
		self.catalogMetadata = catalogMetadata
		self.artworkURL = artworkURL
		self.state = state
		self.addedAt = addedAt
	}

	public static func == (lhs: OfflineCollection, rhs: OfflineCollection) -> Bool {
		lhs.catalogMetadata == rhs.catalogMetadata
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(catalogMetadata)
	}
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
