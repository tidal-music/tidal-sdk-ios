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
		case albumsPeriodAddedat = "albums.addedAt"
		case albumsPeriodAddedat2 = "-albums.addedAt"
		case albumsPeriodArtistsPeriodName = "albums.artists.name"
		case albumsPeriodArtistsPeriodName2 = "-albums.artists.name"
		case albumsPeriodReleasedate = "albums.releaseDate"
		case albumsPeriodReleasedate2 = "-albums.releaseDate"
		case albumsPeriodTitle = "albums.title"
		case albumsPeriodTitle2 = "-albums.title"

		func toUserCollectionsAPIEnum() -> UserCollectionsAPI.Sort_userCollectionsIdRelationshipsAlbumsGet {
			switch self {
			case .albumsPeriodAddedat: return .albumsPeriodAddedat
			case .albumsPeriodAddedat2: return .albumsPeriodAddedat2
			case .albumsPeriodArtistsPeriodName: return .albumsPeriodArtistsPeriodName
			case .albumsPeriodArtistsPeriodName2: return .albumsPeriodArtistsPeriodName2
			case .albumsPeriodReleasedate: return .albumsPeriodReleasedate
			case .albumsPeriodReleasedate2: return .albumsPeriodReleasedate2
			case .albumsPeriodTitle: return .albumsPeriodTitle
			case .albumsPeriodTitle2: return .albumsPeriodTitle2
			}
		}
	}

	/**
     Get albums relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionsAlbumsMultiRelationshipDataDocument
     */
	public static func userCollectionsIdRelationshipsAlbumsGet(id: String, countryCode: String, locale: String, pageCursor: String? = nil, sort: [UserCollectionsAPITidal.Sort_userCollectionsIdRelationshipsAlbumsGet]? = nil, include: [String]? = nil) async throws -> UserCollectionsAlbumsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsAlbumsGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, pageCursor: pageCursor, sort: sort?.toUserCollectionsAPIEnum(), include: include)
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
		case artistsPeriodAddedat = "artists.addedAt"
		case artistsPeriodAddedat2 = "-artists.addedAt"
		case artistsPeriodName = "artists.name"
		case artistsPeriodName2 = "-artists.name"

		func toUserCollectionsAPIEnum() -> UserCollectionsAPI.Sort_userCollectionsIdRelationshipsArtistsGet {
			switch self {
			case .artistsPeriodAddedat: return .artistsPeriodAddedat
			case .artistsPeriodAddedat2: return .artistsPeriodAddedat2
			case .artistsPeriodName: return .artistsPeriodName
			case .artistsPeriodName2: return .artistsPeriodName2
			}
		}
	}

	/**
     Get artists relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionsArtistsMultiRelationshipDataDocument
     */
	public static func userCollectionsIdRelationshipsArtistsGet(id: String, countryCode: String, locale: String, pageCursor: String? = nil, sort: [UserCollectionsAPITidal.Sort_userCollectionsIdRelationshipsArtistsGet]? = nil, include: [String]? = nil) async throws -> UserCollectionsArtistsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsArtistsGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, pageCursor: pageCursor, sort: sort?.toUserCollectionsAPIEnum(), include: include)
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
		case playlistsPeriodAddedat = "playlists.addedAt"
		case playlistsPeriodAddedat2 = "-playlists.addedAt"
		case playlistsPeriodLastupdatedat = "playlists.lastUpdatedAt"
		case playlistsPeriodLastupdatedat2 = "-playlists.lastUpdatedAt"
		case playlistsPeriodName = "playlists.name"
		case playlistsPeriodName2 = "-playlists.name"

		func toUserCollectionsAPIEnum() -> UserCollectionsAPI.Sort_userCollectionsIdRelationshipsPlaylistsGet {
			switch self {
			case .playlistsPeriodAddedat: return .playlistsPeriodAddedat
			case .playlistsPeriodAddedat2: return .playlistsPeriodAddedat2
			case .playlistsPeriodLastupdatedat: return .playlistsPeriodLastupdatedat
			case .playlistsPeriodLastupdatedat2: return .playlistsPeriodLastupdatedat2
			case .playlistsPeriodName: return .playlistsPeriodName
			case .playlistsPeriodName2: return .playlistsPeriodName2
			}
		}
	}

	/**
     Get playlists relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionsPlaylistsMultiRelationshipDataDocument
     */
	public static func userCollectionsIdRelationshipsPlaylistsGet(id: String, pageCursor: String? = nil, sort: [UserCollectionsAPITidal.Sort_userCollectionsIdRelationshipsPlaylistsGet]? = nil, include: [String]? = nil) async throws -> UserCollectionsPlaylistsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsPlaylistsGetWithRequestBuilder(id: id, pageCursor: pageCursor, sort: sort?.toUserCollectionsAPIEnum(), include: include)
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
		case tracksPeriodAddedat = "tracks.addedAt"
		case tracksPeriodAddedat2 = "-tracks.addedAt"
		case tracksPeriodAlbumsPeriodTitle = "tracks.albums.title"
		case tracksPeriodAlbumsPeriodTitle2 = "-tracks.albums.title"
		case tracksPeriodArtistsPeriodName = "tracks.artists.name"
		case tracksPeriodArtistsPeriodName2 = "-tracks.artists.name"
		case tracksPeriodDuration = "tracks.duration"
		case tracksPeriodDuration2 = "-tracks.duration"
		case tracksPeriodTitle = "tracks.title"
		case tracksPeriodTitle2 = "-tracks.title"

		func toUserCollectionsAPIEnum() -> UserCollectionsAPI.Sort_userCollectionsIdRelationshipsTracksGet {
			switch self {
			case .tracksPeriodAddedat: return .tracksPeriodAddedat
			case .tracksPeriodAddedat2: return .tracksPeriodAddedat2
			case .tracksPeriodAlbumsPeriodTitle: return .tracksPeriodAlbumsPeriodTitle
			case .tracksPeriodAlbumsPeriodTitle2: return .tracksPeriodAlbumsPeriodTitle2
			case .tracksPeriodArtistsPeriodName: return .tracksPeriodArtistsPeriodName
			case .tracksPeriodArtistsPeriodName2: return .tracksPeriodArtistsPeriodName2
			case .tracksPeriodDuration: return .tracksPeriodDuration
			case .tracksPeriodDuration2: return .tracksPeriodDuration2
			case .tracksPeriodTitle: return .tracksPeriodTitle
			case .tracksPeriodTitle2: return .tracksPeriodTitle2
			}
		}
	}

	/**
     Get tracks relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionsTracksMultiRelationshipDataDocument
     */
	public static func userCollectionsIdRelationshipsTracksGet(id: String, countryCode: String, locale: String, pageCursor: String? = nil, sort: [UserCollectionsAPITidal.Sort_userCollectionsIdRelationshipsTracksGet]? = nil, include: [String]? = nil) async throws -> UserCollectionsTracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsTracksGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, pageCursor: pageCursor, sort: sort?.toUserCollectionsAPIEnum(), include: include)
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
		case videosPeriodAddedat = "videos.addedAt"
		case videosPeriodAddedat2 = "-videos.addedAt"
		case videosPeriodArtistsPeriodName = "videos.artists.name"
		case videosPeriodArtistsPeriodName2 = "-videos.artists.name"
		case videosPeriodDuration = "videos.duration"
		case videosPeriodDuration2 = "-videos.duration"
		case videosPeriodTitle = "videos.title"
		case videosPeriodTitle2 = "-videos.title"

		func toUserCollectionsAPIEnum() -> UserCollectionsAPI.Sort_userCollectionsIdRelationshipsVideosGet {
			switch self {
			case .videosPeriodAddedat: return .videosPeriodAddedat
			case .videosPeriodAddedat2: return .videosPeriodAddedat2
			case .videosPeriodArtistsPeriodName: return .videosPeriodArtistsPeriodName
			case .videosPeriodArtistsPeriodName2: return .videosPeriodArtistsPeriodName2
			case .videosPeriodDuration: return .videosPeriodDuration
			case .videosPeriodDuration2: return .videosPeriodDuration2
			case .videosPeriodTitle: return .videosPeriodTitle
			case .videosPeriodTitle2: return .videosPeriodTitle2
			}
		}
	}

	/**
     Get videos relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionsVideosMultiRelationshipDataDocument
     */
	public static func userCollectionsIdRelationshipsVideosGet(id: String, countryCode: String, locale: String, pageCursor: String? = nil, sort: [UserCollectionsAPITidal.Sort_userCollectionsIdRelationshipsVideosGet]? = nil, include: [String]? = nil) async throws -> UserCollectionsVideosMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionsAPI.userCollectionsIdRelationshipsVideosGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, pageCursor: pageCursor, sort: sort?.toUserCollectionsAPIEnum(), include: include)
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
