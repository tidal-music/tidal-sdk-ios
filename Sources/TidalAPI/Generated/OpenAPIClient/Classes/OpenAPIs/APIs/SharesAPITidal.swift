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
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_sharesGet: String, CaseIterable {
		case owners = "owners"
		case sharedresources = "sharedResources"

		func toSharesAPIEnum() -> SharesAPI.IncludeLinkage_sharesGet {
			switch self {
			case .owners: return .owners
			case .sharedresources: return .sharedresources
			}
		}
	}

	/**
     Get multiple shares.
     
     - returns: SharesMultiResourceDataDocument
     */
	public static func sharesGet(filterCode: [String], include: [String]? = nil, includeLinkage: [SharesAPITidal.IncludeLinkage_sharesGet]? = nil, replaceMedia: String? = nil) async throws -> SharesMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			SharesAPI.sharesGetWithRequestBuilder(filterCode: filterCode, include: include, includeLinkage: includeLinkage?.compactMap { $0.toSharesAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_sharesIdGet: String, CaseIterable {
		case owners = "owners"
		case sharedresources = "sharedResources"

		func toSharesAPIEnum() -> SharesAPI.IncludeLinkage_sharesIdGet {
			switch self {
			case .owners: return .owners
			case .sharedresources: return .sharedresources
			}
		}
	}

	/**
     Get single share.
     
     - returns: SharesSingleResourceDataDocument
     */
	public static func sharesIdGet(id: String, include: [String]? = nil, includeLinkage: [SharesAPITidal.IncludeLinkage_sharesIdGet]? = nil, replaceMedia: String? = nil) async throws -> SharesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			SharesAPI.sharesIdGetWithRequestBuilder(id: id, include: include, includeLinkage: includeLinkage?.compactMap { $0.toSharesAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: SharesOwnersMultiRelationshipDataDocument
     */
	public static func sharesIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> SharesOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SharesAPI.sharesIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get sharedResources relationship (\&quot;to-many\&quot;).
     
     - returns: SharesSharedResourcesMultiRelationshipDataDocument
     */
	public static func sharesIdRelationshipsSharedResourcesGet(id: String, pageCursor: String? = nil, include: [String]? = nil, replaceMedia: String? = nil) async throws -> SharesSharedResourcesMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			SharesAPI.sharesIdRelationshipsSharedResourcesGetWithRequestBuilder(id: id, pageCursor: pageCursor, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Create single share.
     
     - returns: SharesCreateSingleResourceDataDocument
     */
	public static func sharesPost(idempotencyKey: String? = nil, sharesCreateOperationPayload: SharesCreateOperationPayload? = nil) async throws -> SharesCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			SharesAPI.sharesPostWithRequestBuilder(idempotencyKey: idempotencyKey, sharesCreateOperationPayload: sharesCreateOperationPayload)
		}
	}
}
