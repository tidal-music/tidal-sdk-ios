import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `SharesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await SharesAPITidal.getResource()
/// ```
public enum SharesAPITidal {


	/**
     Get multiple shares.
     
     - returns: SharesMultiResourceDataDocument
     */
	public static func sharesGet(include: [String]? = nil, filterCode: [String]? = nil, filterId: [String]? = nil) async throws -> SharesMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			SharesAPI.sharesGetWithRequestBuilder(include: include, filterCode: filterCode, filterId: filterId)
		}
	}


	/**
     Get single share.
     
     - returns: SharesSingleResourceDataDocument
     */
	public static func sharesIdGet(id: String, include: [String]? = nil) async throws -> SharesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			SharesAPI.sharesIdGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: SharesMultiRelationshipDataDocument
     */
	public static func sharesIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> SharesMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SharesAPI.sharesIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get sharedResources relationship (\&quot;to-many\&quot;).
     
     - returns: SharesMultiRelationshipDataDocument
     */
	public static func sharesIdRelationshipsSharedResourcesGet(id: String, pageCursor: String? = nil, include: [String]? = nil) async throws -> SharesMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SharesAPI.sharesIdRelationshipsSharedResourcesGetWithRequestBuilder(id: id, pageCursor: pageCursor, include: include)
		}
	}


	/**
     Create single share.
     
     - returns: SharesSingleResourceDataDocument
     */
	public static func sharesPost(sharesCreateOperationPayload: SharesCreateOperationPayload? = nil) async throws -> SharesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			SharesAPI.sharesPostWithRequestBuilder(sharesCreateOperationPayload: sharesCreateOperationPayload)
		}
	}
}
