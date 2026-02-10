import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `UserCollectionVideosAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UserCollectionVideosAPITidal.getResource()
/// ```
public enum UserCollectionVideosAPITidal {


	/**
     Get single userCollectionVideo.
     
     - returns: UserCollectionVideosSingleResourceDataDocument
     */
	public static func userCollectionVideosIdGet(id: String, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil) async throws -> UserCollectionVideosSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionVideosAPI.userCollectionVideosIdGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, include: include)
		}
	}


	/**
     Delete from items relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionVideosIdRelationshipsItemsDelete(id: String, userCollectionVideosItemsRelationshipRemoveOperationPayload: UserCollectionVideosItemsRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionVideosAPI.userCollectionVideosIdRelationshipsItemsDeleteWithRequestBuilder(id: id, userCollectionVideosItemsRelationshipRemoveOperationPayload: userCollectionVideosItemsRelationshipRemoveOperationPayload)
		}
	}


	/**
	 * enum for parameter sort
	 */
	public enum Sort_userCollectionVideosIdRelationshipsItemsGet: String, CaseIterable {
		case AddedAtAsc = "addedAt"
		case AddedAtDesc = "-addedAt"
		case ArtistsNameAsc = "artists.name"
		case ArtistsNameDesc = "-artists.name"
		case DurationAsc = "duration"
		case DurationDesc = "-duration"
		case TitleAsc = "title"
		case TitleDesc = "-title"

		func toUserCollectionVideosAPIEnum() -> UserCollectionVideosAPI.Sort_userCollectionVideosIdRelationshipsItemsGet {
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
     Get items relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionVideosItemsMultiRelationshipDataDocument
     */
	public static func userCollectionVideosIdRelationshipsItemsGet(id: String, pageCursor: String? = nil, sort: [UserCollectionVideosAPITidal.Sort_userCollectionVideosIdRelationshipsItemsGet]? = nil, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil) async throws -> UserCollectionVideosItemsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionVideosAPI.userCollectionVideosIdRelationshipsItemsGetWithRequestBuilder(id: id, pageCursor: pageCursor, sort: sort?.compactMap { $0.toUserCollectionVideosAPIEnum() }, countryCode: countryCode, locale: locale, include: include)
		}
	}


	/**
     Add to items relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionVideosIdRelationshipsItemsPost(id: String, countryCode: String? = nil, userCollectionVideosItemsRelationshipAddOperationPayload: UserCollectionVideosItemsRelationshipAddOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionVideosAPI.userCollectionVideosIdRelationshipsItemsPostWithRequestBuilder(id: id, countryCode: countryCode, userCollectionVideosItemsRelationshipAddOperationPayload: userCollectionVideosItemsRelationshipAddOperationPayload)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionVideosMultiRelationshipDataDocument
     */
	public static func userCollectionVideosIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UserCollectionVideosMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionVideosAPI.userCollectionVideosIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}
}
