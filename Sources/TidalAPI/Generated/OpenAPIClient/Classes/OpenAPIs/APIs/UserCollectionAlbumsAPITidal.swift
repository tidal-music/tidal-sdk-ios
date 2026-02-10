import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `UserCollectionAlbumsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UserCollectionAlbumsAPITidal.getResource()
/// ```
public enum UserCollectionAlbumsAPITidal {


	/**
     Get single userCollectionAlbum.
     
     - returns: UserCollectionAlbumsSingleResourceDataDocument
     */
	public static func userCollectionAlbumsIdGet(id: String, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil) async throws -> UserCollectionAlbumsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionAlbumsAPI.userCollectionAlbumsIdGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, include: include)
		}
	}


	/**
     Delete from items relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionAlbumsIdRelationshipsItemsDelete(id: String, userCollectionAlbumsItemsRelationshipRemoveOperationPayload: UserCollectionAlbumsItemsRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionAlbumsAPI.userCollectionAlbumsIdRelationshipsItemsDeleteWithRequestBuilder(id: id, userCollectionAlbumsItemsRelationshipRemoveOperationPayload: userCollectionAlbumsItemsRelationshipRemoveOperationPayload)
		}
	}


	/**
	 * enum for parameter sort
	 */
	public enum Sort_userCollectionAlbumsIdRelationshipsItemsGet: String, CaseIterable {
		case AddedAtAsc = "addedAt"
		case AddedAtDesc = "-addedAt"
		case ArtistsNameAsc = "artists.name"
		case ArtistsNameDesc = "-artists.name"
		case ReleaseDateAsc = "releaseDate"
		case ReleaseDateDesc = "-releaseDate"
		case TitleAsc = "title"
		case TitleDesc = "-title"

		func toUserCollectionAlbumsAPIEnum() -> UserCollectionAlbumsAPI.Sort_userCollectionAlbumsIdRelationshipsItemsGet {
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
     Get items relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionAlbumsItemsMultiRelationshipDataDocument
     */
	public static func userCollectionAlbumsIdRelationshipsItemsGet(id: String, pageCursor: String? = nil, sort: [UserCollectionAlbumsAPITidal.Sort_userCollectionAlbumsIdRelationshipsItemsGet]? = nil, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil) async throws -> UserCollectionAlbumsItemsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionAlbumsAPI.userCollectionAlbumsIdRelationshipsItemsGetWithRequestBuilder(id: id, pageCursor: pageCursor, sort: sort?.compactMap { $0.toUserCollectionAlbumsAPIEnum() }, countryCode: countryCode, locale: locale, include: include)
		}
	}


	/**
     Add to items relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionAlbumsIdRelationshipsItemsPost(id: String, countryCode: String? = nil, userCollectionAlbumsItemsRelationshipAddOperationPayload: UserCollectionAlbumsItemsRelationshipAddOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionAlbumsAPI.userCollectionAlbumsIdRelationshipsItemsPostWithRequestBuilder(id: id, countryCode: countryCode, userCollectionAlbumsItemsRelationshipAddOperationPayload: userCollectionAlbumsItemsRelationshipAddOperationPayload)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionAlbumsMultiRelationshipDataDocument
     */
	public static func userCollectionAlbumsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UserCollectionAlbumsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionAlbumsAPI.userCollectionAlbumsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}
}
