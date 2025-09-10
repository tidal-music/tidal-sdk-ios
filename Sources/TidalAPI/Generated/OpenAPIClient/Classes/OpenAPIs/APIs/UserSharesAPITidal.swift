import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `UserSharesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await UserSharesAPITidal.getResource()
/// ```
public enum UserSharesAPITidal {


	/**
     Get multiple userShares.
     
     - returns: UserSharesMultiResourceDataDocument
     */
	public static func userSharesGet(include: [String]? = nil, filterCode: [String]? = nil, filterId: [String]? = nil) async throws -> UserSharesMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserSharesAPI.userSharesGetWithRequestBuilder(include: include, filterCode: filterCode, filterId: filterId)
		}
	}


	/**
     Get single userShare.
     
     - returns: UserSharesSingleResourceDataDocument
     */
	public static func userSharesIdGet(id: String, include: [String]? = nil) async throws -> UserSharesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserSharesAPI.userSharesIdGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: UserSharesMultiRelationshipDataDocument
     */
	public static func userSharesIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> UserSharesMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserSharesAPI.userSharesIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get sharedResources relationship (\&quot;to-many\&quot;).
     
     - returns: UserSharesMultiRelationshipDataDocument
     */
	public static func userSharesIdRelationshipsSharedResourcesGet(id: String, pageCursor: String? = nil, include: [String]? = nil) async throws -> UserSharesMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			UserSharesAPI.userSharesIdRelationshipsSharedResourcesGetWithRequestBuilder(id: id, pageCursor: pageCursor, include: include)
		}
	}


	/**
     Create single userShare.
     
     - returns: UserSharesSingleResourceDataDocument
     */
	public static func userSharesPost(userSharesCreateOperationPayload: UserSharesCreateOperationPayload? = nil) async throws -> UserSharesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			UserSharesAPI.userSharesPostWithRequestBuilder(userSharesCreateOperationPayload: userSharesCreateOperationPayload)
		}
	}
}
