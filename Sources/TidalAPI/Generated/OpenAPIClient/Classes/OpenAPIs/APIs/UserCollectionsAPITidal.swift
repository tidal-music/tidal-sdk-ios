import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `UserCollectionsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UserCollectionsAPITidal.getResource()
/// ```
public enum UserCollectionsAPITidal {


	/**
     Get single userCollection.
     
     - returns: UserCollectionsSingleResourceDataDocument
     */
	public static func userCollectionsIdGet(id: String, locale: String, countryCode: String, include: [String]? = nil) async throws -> UserCollectionsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdGetWithRequestBuilder(id: id, locale: locale, countryCode: countryCode, include: include)
		}
	}


	/**
     Delete from albums relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsAlbumsDelete(id: String, userCollectionAlbumsRelationshipRemoveOperationPayload: UserCollectionAlbumsRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsAlbumsDeleteWithRequestBuilder(id: id, userCollectionAlbumsRelationshipRemoveOperationPayload: userCollectionAlbumsRelationshipRemoveOperationPayload)
		}
	}


	/**
	 * enum for parameter sort
	 */
	public enum Sort_userCollectionsIdRelationshipsAlbumsGet: String, CaseIterable {
		case AlbumsAddedAtAsc = "albums.addedAt"
		case AlbumsAddedAtDesc = "-albums.addedAt"
		case AlbumsArtistsNameAsc = "albums.artists.name"
		case AlbumsArtistsNameDesc = "-albums.artists.name"
		case AlbumsReleaseDateAsc = "albums.releaseDate"
		case AlbumsReleaseDateDesc = "-albums.releaseDate"
		case AlbumsTitleAsc = "albums.title"
		case AlbumsTitleDesc = "-albums.title"

		func toUserCollectionsAPIEnum() -> UserCollectionsAPI.Sort_userCollectionsIdRelationshipsAlbumsGet {
			switch self {
			case .AlbumsAddedAtAsc: return .AlbumsAddedAtAsc
			case .AlbumsAddedAtDesc: return .AlbumsAddedAtDesc
			case .AlbumsArtistsNameAsc: return .AlbumsArtistsNameAsc
			case .AlbumsArtistsNameDesc: return .AlbumsArtistsNameDesc
			case .AlbumsReleaseDateAsc: return .AlbumsReleaseDateAsc
			case .AlbumsReleaseDateDesc: return .AlbumsReleaseDateDesc
			case .AlbumsTitleAsc: return .AlbumsTitleAsc
			case .AlbumsTitleDesc: return .AlbumsTitleDesc
			}
		}
	}

	/**
     Get albums relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionsAlbumsMultiRelationshipDataDocument
     */
	public static func userCollectionsIdRelationshipsAlbumsGet(id: String, countryCode: String, locale: String, pageCursor: String? = nil, sort: [UserCollectionsAPITidal.Sort_userCollectionsIdRelationshipsAlbumsGet]? = nil, include: [String]? = nil) async throws -> UserCollectionsAlbumsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsAlbumsGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, pageCursor: pageCursor, sort: sort?.compactMap { $0.toUserCollectionsAPIEnum() }, include: include)
		}
	}


	/**
     Add to albums relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsAlbumsPost(id: String, countryCode: String, userCollectionAlbumsRelationshipAddOperationPayload: UserCollectionAlbumsRelationshipAddOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsAlbumsPostWithRequestBuilder(id: id, countryCode: countryCode, userCollectionAlbumsRelationshipAddOperationPayload: userCollectionAlbumsRelationshipAddOperationPayload)
		}
	}


	/**
     Delete from artists relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsArtistsDelete(id: String, userCollectionArtistsRelationshipRemoveOperationPayload: UserCollectionArtistsRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsArtistsDeleteWithRequestBuilder(id: id, userCollectionArtistsRelationshipRemoveOperationPayload: userCollectionArtistsRelationshipRemoveOperationPayload)
		}
	}


	/**
	 * enum for parameter sort
	 */
	public enum Sort_userCollectionsIdRelationshipsArtistsGet: String, CaseIterable {
		case ArtistsAddedAtAsc = "artists.addedAt"
		case ArtistsAddedAtDesc = "-artists.addedAt"
		case ArtistsNameAsc = "artists.name"
		case ArtistsNameDesc = "-artists.name"

		func toUserCollectionsAPIEnum() -> UserCollectionsAPI.Sort_userCollectionsIdRelationshipsArtistsGet {
			switch self {
			case .ArtistsAddedAtAsc: return .ArtistsAddedAtAsc
			case .ArtistsAddedAtDesc: return .ArtistsAddedAtDesc
			case .ArtistsNameAsc: return .ArtistsNameAsc
			case .ArtistsNameDesc: return .ArtistsNameDesc
			}
		}
	}

	/**
     Get artists relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionsArtistsMultiRelationshipDataDocument
     */
	public static func userCollectionsIdRelationshipsArtistsGet(id: String, countryCode: String, locale: String, pageCursor: String? = nil, sort: [UserCollectionsAPITidal.Sort_userCollectionsIdRelationshipsArtistsGet]? = nil, include: [String]? = nil) async throws -> UserCollectionsArtistsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsArtistsGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, pageCursor: pageCursor, sort: sort?.compactMap { $0.toUserCollectionsAPIEnum() }, include: include)
		}
	}


	/**
     Add to artists relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsArtistsPost(id: String, countryCode: String, userCollectionArtistsRelationshipAddOperationPayload: UserCollectionArtistsRelationshipAddOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsArtistsPostWithRequestBuilder(id: id, countryCode: countryCode, userCollectionArtistsRelationshipAddOperationPayload: userCollectionArtistsRelationshipAddOperationPayload)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionsMultiRelationshipDataDocument
     */
	public static func userCollectionsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UserCollectionsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Delete from playlists relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsPlaylistsDelete(id: String, userCollectionPlaylistsRelationshipRemoveOperationPayload: UserCollectionPlaylistsRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsPlaylistsDeleteWithRequestBuilder(id: id, userCollectionPlaylistsRelationshipRemoveOperationPayload: userCollectionPlaylistsRelationshipRemoveOperationPayload)
		}
	}


	/**
	 * enum for parameter sort
	 */
	public enum Sort_userCollectionsIdRelationshipsPlaylistsGet: String, CaseIterable {
		case PlaylistsAddedAtAsc = "playlists.addedAt"
		case PlaylistsAddedAtDesc = "-playlists.addedAt"
		case PlaylistsLastUpdatedAtAsc = "playlists.lastUpdatedAt"
		case PlaylistsLastUpdatedAtDesc = "-playlists.lastUpdatedAt"
		case PlaylistsNameAsc = "playlists.name"
		case PlaylistsNameDesc = "-playlists.name"

		func toUserCollectionsAPIEnum() -> UserCollectionsAPI.Sort_userCollectionsIdRelationshipsPlaylistsGet {
			switch self {
			case .PlaylistsAddedAtAsc: return .PlaylistsAddedAtAsc
			case .PlaylistsAddedAtDesc: return .PlaylistsAddedAtDesc
			case .PlaylistsLastUpdatedAtAsc: return .PlaylistsLastUpdatedAtAsc
			case .PlaylistsLastUpdatedAtDesc: return .PlaylistsLastUpdatedAtDesc
			case .PlaylistsNameAsc: return .PlaylistsNameAsc
			case .PlaylistsNameDesc: return .PlaylistsNameDesc
			}
		}
	}

	/**
     Get playlists relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionsPlaylistsMultiRelationshipDataDocument
     */
	public static func userCollectionsIdRelationshipsPlaylistsGet(id: String, pageCursor: String? = nil, sort: [UserCollectionsAPITidal.Sort_userCollectionsIdRelationshipsPlaylistsGet]? = nil, include: [String]? = nil) async throws -> UserCollectionsPlaylistsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsPlaylistsGetWithRequestBuilder(id: id, pageCursor: pageCursor, sort: sort?.compactMap { $0.toUserCollectionsAPIEnum() }, include: include)
		}
	}


	/**
     Add to playlists relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsPlaylistsPost(id: String, userCollectionPlaylistsRelationshipRemoveOperationPayload: UserCollectionPlaylistsRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsPlaylistsPostWithRequestBuilder(id: id, userCollectionPlaylistsRelationshipRemoveOperationPayload: userCollectionPlaylistsRelationshipRemoveOperationPayload)
		}
	}


	/**
     Delete from tracks relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsTracksDelete(id: String, userCollectionTracksRelationshipRemoveOperationPayload: UserCollectionTracksRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsTracksDeleteWithRequestBuilder(id: id, userCollectionTracksRelationshipRemoveOperationPayload: userCollectionTracksRelationshipRemoveOperationPayload)
		}
	}


	/**
	 * enum for parameter sort
	 */
	public enum Sort_userCollectionsIdRelationshipsTracksGet: String, CaseIterable {
		case TracksAddedAtAsc = "tracks.addedAt"
		case TracksAddedAtDesc = "-tracks.addedAt"
		case TracksAlbumsTitleAsc = "tracks.albums.title"
		case TracksAlbumsTitleDesc = "-tracks.albums.title"
		case TracksArtistsNameAsc = "tracks.artists.name"
		case TracksArtistsNameDesc = "-tracks.artists.name"
		case TracksDurationAsc = "tracks.duration"
		case TracksDurationDesc = "-tracks.duration"
		case TracksTitleAsc = "tracks.title"
		case TracksTitleDesc = "-tracks.title"

		func toUserCollectionsAPIEnum() -> UserCollectionsAPI.Sort_userCollectionsIdRelationshipsTracksGet {
			switch self {
			case .TracksAddedAtAsc: return .TracksAddedAtAsc
			case .TracksAddedAtDesc: return .TracksAddedAtDesc
			case .TracksAlbumsTitleAsc: return .TracksAlbumsTitleAsc
			case .TracksAlbumsTitleDesc: return .TracksAlbumsTitleDesc
			case .TracksArtistsNameAsc: return .TracksArtistsNameAsc
			case .TracksArtistsNameDesc: return .TracksArtistsNameDesc
			case .TracksDurationAsc: return .TracksDurationAsc
			case .TracksDurationDesc: return .TracksDurationDesc
			case .TracksTitleAsc: return .TracksTitleAsc
			case .TracksTitleDesc: return .TracksTitleDesc
			}
		}
	}

	/**
     Get tracks relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionsTracksMultiRelationshipDataDocument
     */
	public static func userCollectionsIdRelationshipsTracksGet(id: String, countryCode: String, locale: String, pageCursor: String? = nil, sort: [UserCollectionsAPITidal.Sort_userCollectionsIdRelationshipsTracksGet]? = nil, include: [String]? = nil) async throws -> UserCollectionsTracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsTracksGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, pageCursor: pageCursor, sort: sort?.compactMap { $0.toUserCollectionsAPIEnum() }, include: include)
		}
	}


	/**
     Add to tracks relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsTracksPost(id: String, countryCode: String, userCollectionTracksRelationshipAddOperationPayload: UserCollectionTracksRelationshipAddOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsTracksPostWithRequestBuilder(id: id, countryCode: countryCode, userCollectionTracksRelationshipAddOperationPayload: userCollectionTracksRelationshipAddOperationPayload)
		}
	}


	/**
     Delete from videos relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsVideosDelete(id: String, userCollectionVideosRelationshipRemoveOperationPayload: UserCollectionVideosRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsVideosDeleteWithRequestBuilder(id: id, userCollectionVideosRelationshipRemoveOperationPayload: userCollectionVideosRelationshipRemoveOperationPayload)
		}
	}


	/**
	 * enum for parameter sort
	 */
	public enum Sort_userCollectionsIdRelationshipsVideosGet: String, CaseIterable {
		case VideosAddedAtAsc = "videos.addedAt"
		case VideosAddedAtDesc = "-videos.addedAt"
		case VideosArtistsNameAsc = "videos.artists.name"
		case VideosArtistsNameDesc = "-videos.artists.name"
		case VideosDurationAsc = "videos.duration"
		case VideosDurationDesc = "-videos.duration"
		case VideosTitleAsc = "videos.title"
		case VideosTitleDesc = "-videos.title"

		func toUserCollectionsAPIEnum() -> UserCollectionsAPI.Sort_userCollectionsIdRelationshipsVideosGet {
			switch self {
			case .VideosAddedAtAsc: return .VideosAddedAtAsc
			case .VideosAddedAtDesc: return .VideosAddedAtDesc
			case .VideosArtistsNameAsc: return .VideosArtistsNameAsc
			case .VideosArtistsNameDesc: return .VideosArtistsNameDesc
			case .VideosDurationAsc: return .VideosDurationAsc
			case .VideosDurationDesc: return .VideosDurationDesc
			case .VideosTitleAsc: return .VideosTitleAsc
			case .VideosTitleDesc: return .VideosTitleDesc
			}
		}
	}

	/**
     Get videos relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionsVideosMultiRelationshipDataDocument
     */
	public static func userCollectionsIdRelationshipsVideosGet(id: String, countryCode: String, locale: String, pageCursor: String? = nil, sort: [UserCollectionsAPITidal.Sort_userCollectionsIdRelationshipsVideosGet]? = nil, include: [String]? = nil) async throws -> UserCollectionsVideosMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsVideosGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, pageCursor: pageCursor, sort: sort?.compactMap { $0.toUserCollectionsAPIEnum() }, include: include)
		}
	}


	/**
     Add to videos relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsVideosPost(id: String, countryCode: String, userCollectionVideosRelationshipAddOperationPayload: UserCollectionVideosRelationshipAddOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsVideosPostWithRequestBuilder(id: id, countryCode: countryCode, userCollectionVideosRelationshipAddOperationPayload: userCollectionVideosRelationshipAddOperationPayload)
		}
	}
}
