import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `UserCollectionArtistsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UserCollectionArtistsAPITidal.getResource()
/// ```
public enum UserCollectionArtistsAPITidal {


	/**
     Get single userCollectionArtist.
     
     - returns: UserCollectionArtistsSingleResourceDataDocument
     */
	public static func userCollectionArtistsIdGet(id: String, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil) async throws -> UserCollectionArtistsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionArtistsAPI.userCollectionArtistsIdGetWithRequestBuilder(id: id, countryCode: countryCode, locale: locale, include: include)
		}
	}


	/**
     Delete from items relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionArtistsIdRelationshipsItemsDelete(id: String, userCollectionArtistsItemsRelationshipRemoveOperationPayload: UserCollectionArtistsItemsRelationshipRemoveOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionArtistsAPI.userCollectionArtistsIdRelationshipsItemsDeleteWithRequestBuilder(id: id, userCollectionArtistsItemsRelationshipRemoveOperationPayload: userCollectionArtistsItemsRelationshipRemoveOperationPayload)
		}
	}


	/**
	 * enum for parameter sort
	 */
	public enum Sort_userCollectionArtistsIdRelationshipsItemsGet: String, CaseIterable {
		case AddedAtAsc = "addedAt"
		case AddedAtDesc = "-addedAt"
		case NameAsc = "name"
		case NameDesc = "-name"

		func toUserCollectionArtistsAPIEnum() -> UserCollectionArtistsAPI.Sort_userCollectionArtistsIdRelationshipsItemsGet {
			switch self {
			case .AddedAtAsc: return .AddedAtAsc
			case .AddedAtDesc: return .AddedAtDesc
			case .NameAsc: return .NameAsc
			case .NameDesc: return .NameDesc
			}
		}
	}

	/**
     Get items relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionArtistsItemsMultiRelationshipDataDocument
     */
	public static func userCollectionArtistsIdRelationshipsItemsGet(id: String, pageCursor: String? = nil, sort: [UserCollectionArtistsAPITidal.Sort_userCollectionArtistsIdRelationshipsItemsGet]? = nil, countryCode: String? = nil, locale: String? = nil, include: [String]? = nil) async throws -> UserCollectionArtistsItemsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionArtistsAPI.userCollectionArtistsIdRelationshipsItemsGetWithRequestBuilder(id: id, pageCursor: pageCursor, sort: sort?.compactMap { $0.toUserCollectionArtistsAPIEnum() }, countryCode: countryCode, locale: locale, include: include)
		}
	}


	/**
     Add to items relationship (\&quot;to-many\&quot;).
     
     - returns: 
     */
	public static func userCollectionArtistsIdRelationshipsItemsPost(id: String, countryCode: String? = nil, userCollectionArtistsItemsRelationshipAddOperationPayload: UserCollectionArtistsItemsRelationshipAddOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			UserCollectionArtistsAPI.userCollectionArtistsIdRelationshipsItemsPostWithRequestBuilder(id: id, countryCode: countryCode, userCollectionArtistsItemsRelationshipAddOperationPayload: userCollectionArtistsItemsRelationshipAddOperationPayload)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: UserCollectionArtistsMultiRelationshipDataDocument
     */
	public static func userCollectionArtistsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UserCollectionArtistsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserCollectionArtistsAPI.userCollectionArtistsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}
}
