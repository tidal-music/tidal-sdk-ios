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
	public static func userCollectionsIdGet(id: String, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil) async throws -> UserCollectionsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, include: include)
		}
	}


	/**
     Delete from albums relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsAlbumsDelete(id: String, userCollectionsAlbumsRelationshipRemoveOperationPayload: UserCollectionsAlbumsRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsAlbumsDeleteWithRequestBuilder(id: id, userCollectionsAlbumsRelationshipRemoveOperationPayload: userCollectionsAlbumsRelationshipRemoveOperationPayload)
		}
	}


	/**
	 * enum for parameter sort
	 */
	public enum Sort_userCollectionsIdRelationshipsAlbumsGet: String, CaseIterable {
		case AddedAtAsc = "addedAt"
		case AddedAtDesc = "-addedAt"
		case ArtistsNameAsc = "artists.name"
		case ArtistsNameDesc = "-artists.name"
		case ReleaseDateAsc = "releaseDate"
		case ReleaseDateDesc = "-releaseDate"
		case TitleAsc = "title"
		case TitleDesc = "-title"

		func toUserCollectionsAPIEnum() -> UserCollectionsAPI.Sort_userCollectionsIdRelationshipsAlbumsGet {
			switch self {
			case .AddedAtAsc: return .AddedAtAsc
			case .AddedAtDesc: return .AddedAtDesc
			case .ArtistsNameAsc: return .ArtistsNameAsc
			case .ArtistsNameDesc: return .ArtistsNameDesc
			case .ReleaseDateAsc: return .ReleaseDateAsc
			case .ReleaseDateDesc: return .ReleaseDateDesc
			case .TitleAsc: return .TitleAsc
			case .TitleDesc: return .TitleDesc
			}
		}
	}

	/**
     Get albums relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionsAlbumsMultiRelationshipDataDocument
     */
	public static func userCollectionsIdRelationshipsAlbumsGet(id: String, pageCursor: String? = nil, sort: [UserCollectionsAPITidal.Sort_userCollectionsIdRelationshipsAlbumsGet]? = nil, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil) async throws -> UserCollectionsAlbumsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsAlbumsGetWithRequestBuilder(id: id, pageCursor: pageCursor, sort: sort?.compactMap { $0.toUserCollectionsAPIEnum() }, countryCode: countryCode, locale: locale, include: include)
		}
	}


	/**
     Add to albums relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsAlbumsPost(id: String, countryCode: String? = nil, userCollectionsAlbumsRelationshipAddOperationPayload: UserCollectionsAlbumsRelationshipAddOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsAlbumsPostWithRequestBuilder(id: id, countryCode: countryCode, userCollectionsAlbumsRelationshipAddOperationPayload: userCollectionsAlbumsRelationshipAddOperationPayload)
		}
	}


	/**
     Delete from artists relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsArtistsDelete(id: String, userCollectionsArtistsRelationshipRemoveOperationPayload: UserCollectionsArtistsRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsArtistsDeleteWithRequestBuilder(id: id, userCollectionsArtistsRelationshipRemoveOperationPayload: userCollectionsArtistsRelationshipRemoveOperationPayload)
		}
	}


	/**
	 * enum for parameter sort
	 */
	public enum Sort_userCollectionsIdRelationshipsArtistsGet: String, CaseIterable {
		case AddedAtAsc = "addedAt"
		case AddedAtDesc = "-addedAt"
		case NameAsc = "name"
		case NameDesc = "-name"

		func toUserCollectionsAPIEnum() -> UserCollectionsAPI.Sort_userCollectionsIdRelationshipsArtistsGet {
			switch self {
			case .AddedAtAsc: return .AddedAtAsc
			case .AddedAtDesc: return .AddedAtDesc
			case .NameAsc: return .NameAsc
			case .NameDesc: return .NameDesc
			}
		}
	}

	/**
     Get artists relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionsArtistsMultiRelationshipDataDocument
     */
	public static func userCollectionsIdRelationshipsArtistsGet(id: String, pageCursor: String? = nil, sort: [UserCollectionsAPITidal.Sort_userCollectionsIdRelationshipsArtistsGet]? = nil, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil) async throws -> UserCollectionsArtistsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsArtistsGetWithRequestBuilder(id: id, pageCursor: pageCursor, sort: sort?.compactMap { $0.toUserCollectionsAPIEnum() }, countryCode: countryCode, locale: locale, include: include)
		}
	}


	/**
     Add to artists relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsArtistsPost(id: String, countryCode: String? = nil, userCollectionsArtistsRelationshipAddOperationPayload: UserCollectionsArtistsRelationshipAddOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsArtistsPostWithRequestBuilder(id: id, countryCode: countryCode, userCollectionsArtistsRelationshipAddOperationPayload: userCollectionsArtistsRelationshipAddOperationPayload)
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
	public static func userCollectionsIdRelationshipsPlaylistsDelete(id: String, userCollectionsPlaylistsRelationshipRemoveOperationPayload: UserCollectionsPlaylistsRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsPlaylistsDeleteWithRequestBuilder(id: id, userCollectionsPlaylistsRelationshipRemoveOperationPayload: userCollectionsPlaylistsRelationshipRemoveOperationPayload)
		}
	}


	/**
	 * enum for parameter collectionView
	 */
	public enum CollectionView_userCollectionsIdRelationshipsPlaylistsGet: String, CaseIterable {
		case folders = "FOLDERS"

		func toUserCollectionsAPIEnum() -> UserCollectionsAPI.CollectionView_userCollectionsIdRelationshipsPlaylistsGet {
			switch self {
			case .folders: return .folders
			}
		}
	}

	/**
	 * enum for parameter sort
	 */
	public enum Sort_userCollectionsIdRelationshipsPlaylistsGet: String, CaseIterable {
		case AddedAtAsc = "addedAt"
		case AddedAtDesc = "-addedAt"
		case LastModifiedAtAsc = "lastModifiedAt"
		case LastModifiedAtDesc = "-lastModifiedAt"
		case NameAsc = "name"
		case NameDesc = "-name"

		func toUserCollectionsAPIEnum() -> UserCollectionsAPI.Sort_userCollectionsIdRelationshipsPlaylistsGet {
			switch self {
			case .AddedAtAsc: return .AddedAtAsc
			case .AddedAtDesc: return .AddedAtDesc
			case .LastModifiedAtAsc: return .LastModifiedAtAsc
			case .LastModifiedAtDesc: return .LastModifiedAtDesc
			case .NameAsc: return .NameAsc
			case .NameDesc: return .NameDesc
			}
		}
	}

	/**
     Get playlists relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionsPlaylistsMultiRelationshipDataDocument
     */
	public static func userCollectionsIdRelationshipsPlaylistsGet(id: String, collectionView: UserCollectionsAPITidal.CollectionView_userCollectionsIdRelationshipsPlaylistsGet? = nil, pageCursor: String? = nil, sort: [UserCollectionsAPITidal.Sort_userCollectionsIdRelationshipsPlaylistsGet]? = nil, include: [String]? = nil) async throws -> UserCollectionsPlaylistsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsPlaylistsGetWithRequestBuilder(id: id, collectionView: collectionView?.toUserCollectionsAPIEnum(), pageCursor: pageCursor, sort: sort?.compactMap { $0.toUserCollectionsAPIEnum() }, include: include)
		}
	}


	/**
     Add to playlists relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsPlaylistsPost(id: String, userCollectionsPlaylistsRelationshipAddOperationPayload: UserCollectionsPlaylistsRelationshipAddOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsPlaylistsPostWithRequestBuilder(id: id, userCollectionsPlaylistsRelationshipAddOperationPayload: userCollectionsPlaylistsRelationshipAddOperationPayload)
		}
	}


	/**
     Delete from tracks relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsTracksDelete(id: String, userCollectionsTracksRelationshipRemoveOperationPayload: UserCollectionsTracksRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsTracksDeleteWithRequestBuilder(id: id, userCollectionsTracksRelationshipRemoveOperationPayload: userCollectionsTracksRelationshipRemoveOperationPayload)
		}
	}


	/**
	 * enum for parameter sort
	 */
	public enum Sort_userCollectionsIdRelationshipsTracksGet: String, CaseIterable {
		case AddedAtAsc = "addedAt"
		case AddedAtDesc = "-addedAt"
		case AlbumsTitleAsc = "albums.title"
		case AlbumsTitleDesc = "-albums.title"
		case ArtistsNameAsc = "artists.name"
		case ArtistsNameDesc = "-artists.name"
		case DurationAsc = "duration"
		case DurationDesc = "-duration"
		case TitleAsc = "title"
		case TitleDesc = "-title"

		func toUserCollectionsAPIEnum() -> UserCollectionsAPI.Sort_userCollectionsIdRelationshipsTracksGet {
			switch self {
			case .AddedAtAsc: return .AddedAtAsc
			case .AddedAtDesc: return .AddedAtDesc
			case .AlbumsTitleAsc: return .AlbumsTitleAsc
			case .AlbumsTitleDesc: return .AlbumsTitleDesc
			case .ArtistsNameAsc: return .ArtistsNameAsc
			case .ArtistsNameDesc: return .ArtistsNameDesc
			case .DurationAsc: return .DurationAsc
			case .DurationDesc: return .DurationDesc
			case .TitleAsc: return .TitleAsc
			case .TitleDesc: return .TitleDesc
			}
		}
	}

	/**
     Get tracks relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionsTracksMultiRelationshipDataDocument
     */
	public static func userCollectionsIdRelationshipsTracksGet(id: String, pageCursor: String? = nil, sort: [UserCollectionsAPITidal.Sort_userCollectionsIdRelationshipsTracksGet]? = nil, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil) async throws -> UserCollectionsTracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsTracksGetWithRequestBuilder(id: id, pageCursor: pageCursor, sort: sort?.compactMap { $0.toUserCollectionsAPIEnum() }, countryCode: countryCode, locale: locale, include: include)
		}
	}


	/**
     Add to tracks relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsTracksPost(id: String, countryCode: String? = nil, userCollectionsTracksRelationshipAddOperationPayload: UserCollectionsTracksRelationshipAddOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsTracksPostWithRequestBuilder(id: id, countryCode: countryCode, userCollectionsTracksRelationshipAddOperationPayload: userCollectionsTracksRelationshipAddOperationPayload)
		}
	}


	/**
     Delete from videos relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsVideosDelete(id: String, userCollectionsVideosRelationshipRemoveOperationPayload: UserCollectionsVideosRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsVideosDeleteWithRequestBuilder(id: id, userCollectionsVideosRelationshipRemoveOperationPayload: userCollectionsVideosRelationshipRemoveOperationPayload)
		}
	}


	/**
	 * enum for parameter sort
	 */
	public enum Sort_userCollectionsIdRelationshipsVideosGet: String, CaseIterable {
		case AddedAtAsc = "addedAt"
		case AddedAtDesc = "-addedAt"
		case ArtistsNameAsc = "artists.name"
		case ArtistsNameDesc = "-artists.name"
		case DurationAsc = "duration"
		case DurationDesc = "-duration"
		case TitleAsc = "title"
		case TitleDesc = "-title"

		func toUserCollectionsAPIEnum() -> UserCollectionsAPI.Sort_userCollectionsIdRelationshipsVideosGet {
			switch self {
			case .AddedAtAsc: return .AddedAtAsc
			case .AddedAtDesc: return .AddedAtDesc
			case .ArtistsNameAsc: return .ArtistsNameAsc
			case .ArtistsNameDesc: return .ArtistsNameDesc
			case .DurationAsc: return .DurationAsc
			case .DurationDesc: return .DurationDesc
			case .TitleAsc: return .TitleAsc
			case .TitleDesc: return .TitleDesc
			}
		}
	}

	/**
     Get videos relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionsVideosMultiRelationshipDataDocument
     */
	public static func userCollectionsIdRelationshipsVideosGet(id: String, pageCursor: String? = nil, sort: [UserCollectionsAPITidal.Sort_userCollectionsIdRelationshipsVideosGet]? = nil, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil) async throws -> UserCollectionsVideosMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsVideosGetWithRequestBuilder(id: id, pageCursor: pageCursor, sort: sort?.compactMap { $0.toUserCollectionsAPIEnum() }, countryCode: countryCode, locale: locale, include: include)
		}
	}


	/**
     Add to videos relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionsIdRelationshipsVideosPost(id: String, countryCode: String? = nil, userCollectionsVideosRelationshipAddOperationPayload: UserCollectionsVideosRelationshipAddOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsVideosPostWithRequestBuilder(id: id, countryCode: countryCode, userCollectionsVideosRelationshipAddOperationPayload: userCollectionsVideosRelationshipAddOperationPayload)
		}
	}
}
