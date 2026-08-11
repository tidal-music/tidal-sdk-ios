import Foundation

// MARK: - OfflineMediaItemType

public enum OfflineMediaItemType: String, Sendable, Hashable {
	case tracks
	case videos
}

// MARK: - OfflineCollectionType

public enum OfflineCollectionType: String, Sendable, Hashable {
	case albums
	case playlists
	case userCollectionTracks
}

// MARK: - ResourceId

public enum ResourceId: Sendable, Hashable {
	case identifier(String)
	case me

	var stringValue: String {
		switch self {
		case let .identifier(value): value
		case .me: "me"
		}
	}
}

// MARK: - OfflineResource

/// A stable identity for a resource managed by Offliner.
public enum OfflineResource: Sendable, Hashable {
	case media(type: OfflineMediaItemType, resourceId: String)
	case collection(type: OfflineCollectionType, resourceId: String)
}

/// The operation requested for an offline resource.
public enum OfflineResourceAction: String, Sendable, Hashable {
	case download
	case remove
}

// MARK: - OfflineResourceState

/// The normalized local operation and availability state of an offline resource.
public enum OfflineResourceState: Sendable, Hashable {
	case notDownloaded
	case queued
	case downloading
	case downloaded
	case removing
	/// The operation failed. The associated action is the stable retry direction.
	case failed(action: OfflineResourceAction)
}

// MARK: - OfflineResourceOperationError

public enum OfflineResourceOperationError: Error, Sendable, Equatable {
	/// The requested action conflicts with an operation already in progress for this resource.
	case conflictingOperationInProgress(currentState: OfflineResourceState)
}

// MARK: - OfflineDownloadQueueEntry

/// One top-level download operation in the active Offliner queue.
///
/// Collection metadata and member tasks are aggregated into one collection entry when their relationship is known.
/// A directly requested media item remains a media entry and exposes its related collection separately.
public struct OfflineDownloadQueueEntry: Sendable, Hashable {
	public enum State: Sendable, Hashable {
		case queued
		case downloading
		/// A terminal failure. Download queues only expose the `.download` action.
		case failed(action: OfflineResourceAction)
	}

	/// The stable top-level resource identity to pass back to `download(...)` when retrying.
	public let resource: OfflineResource
	/// The related collection for a directly requested media item, when supplied by the backend task.
	public let parentCollection: OfflineResource?
	public let state: State
	/// Aggregate transfer progress in `0 ... 1`, or `nil` until progress is known.
	public let progress: Double?

	public init(
		resource: OfflineResource,
		parentCollection: OfflineResource?,
		state: State,
		progress: Double?
	) {
		self.resource = resource
		self.parentCollection = parentCollection
		self.state = state
		self.progress = progress
	}
}

// MARK: - OfflineMediaItem

public struct OfflineMediaItem {
	public struct TrackMetadata: Codable {
		public let id: String
		public let title: String
		public let artists: [String]
		public let albumTitle: String?
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
	public let artworkURL: URL?
}

// MARK: - OfflinePlaybackAsset

public struct OfflinePlaybackAsset {
	public let playbackMetadata: OfflineMediaItem.PlaybackMetadata?
	public let mediaURL: URL
	public let licenseURL: URL?

	public init(
		playbackMetadata: OfflineMediaItem.PlaybackMetadata?,
		mediaURL: URL,
		licenseURL: URL?
	) {
		self.playbackMetadata = playbackMetadata
		self.mediaURL = mediaURL
		self.licenseURL = licenseURL
	}
}

// MARK: - OfflineCollectionState

public enum OfflineCollectionState: Hashable {
	case pending
	case stored
}

// MARK: - OfflineCollectionDownloadState

/// Compatibility collection availability for albums, playlists, and user collection tracks.
///
/// Use `OfflineResourceState` when queued, removal, and failure states are needed.
public enum OfflineCollectionDownloadState: Sendable, Hashable {
	/// The collection is not locally downloaded, is being removed, or its download failed.
	case notDownloaded

	/// The collection or one of its members has active download/acquisition work known by this SDK instance.
	case downloading

	/// The collection is locally stored, including after a failed removal.
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

public enum SortDirection: Hashable {
	case ascending
	case descending
}

public enum OfflineCollectionItemSort: Hashable {
	case title(direction: SortDirection)
	case album(direction: SortDirection)
	case artist(direction: SortDirection)
	case dateAdded(direction: SortDirection)
}

/// An error produced when an operation is attempted on an Offliner instance after it has been reset.
public enum OfflinerLifecycleError: Error {
	case reset
}

// MARK: - OfflineCollectionItem

public struct OfflineCollectionItem {
	public let item: OfflineMediaItem
	public let volume: Int
	public let position: Int
	public let addedAt: Date?

	public init(
		item: OfflineMediaItem,
		volume: Int,
		position: Int,
		addedAt: Date? = nil
	) {
		self.item = item
		self.volume = volume
		self.position = position
		self.addedAt = addedAt
	}
}

// MARK: - OfflineCollectionSearchHit

public struct OfflineCollectionSearchHit {
	public let item: OfflineCollectionItem
	public let cursor: String

	public init(item: OfflineCollectionItem, cursor: String) {
		self.item = item
		self.cursor = cursor
	}
}

// MARK: - OfflineCollectionSearchPage

public struct OfflineCollectionSearchPage {
	public let hits: [OfflineCollectionSearchHit]
	public let cursor: String?

	public init(hits: [OfflineCollectionSearchHit], cursor: String?) {
		self.hits = hits
		self.cursor = cursor
	}
}

// MARK: - OfflineCollectionItemsPage

public struct OfflineCollectionItemsPage {
	public let items: [OfflineCollectionItem]
	public let cursor: String?

	public init(items: [OfflineCollectionItem], cursor: String?) {
		self.items = items
		self.cursor = cursor
	}
}
