import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `ResourceGrantsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ResourceGrantsAPITidal.getResource()
/// ```
public enum ResourceGrantsAPITidal {


	/**
	 * enum for parameter filterRole
	 */
	public enum FilterRole_resourceGrantsGet: String, CaseIterable {
		case viewer = "VIEWER"
		case collaborator = "COLLABORATOR"
		case owner = "OWNER"

		func toResourceGrantsAPIEnum() -> ResourceGrantsAPI.FilterRole_resourceGrantsGet {
			switch self {
			case .viewer: return .viewer
			case .collaborator: return .collaborator
			case .owner: return .owner
			}
		}
	}

	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_resourceGrantsGet: String, CaseIterable {
		case grantee = "grantee"
		case subject = "subject"

		func toResourceGrantsAPIEnum() -> ResourceGrantsAPI.IncludeLinkage_resourceGrantsGet {
			switch self {
			case .grantee: return .grantee
			case .subject: return .subject
			}
		}
	}

	/**
     Get multiple resourceGrants.
     
     - returns: ResourceGrantsMultiResourceDataDocument
     */
	public static func resourceGrantsGet(filterGrantee: String? = nil, filterRole: ResourceGrantsAPITidal.FilterRole_resourceGrantsGet? = nil, filterSubject: String? = nil, include: [String]? = nil, includeLinkage: [ResourceGrantsAPITidal.IncludeLinkage_resourceGrantsGet]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> ResourceGrantsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ResourceGrantsAPI.resourceGrantsGetWithRequestBuilder(filterGrantee: filterGrantee, filterRole: filterRole?.toResourceGrantsAPIEnum(), filterSubject: filterSubject, include: include, includeLinkage: includeLinkage?.compactMap { $0.toResourceGrantsAPIEnum() }, pageCursor: pageCursor, replaceMedia: replaceMedia)
		}
	}


	/**
     Delete single resourceGrant.
     
     - returns: MutationResponseDocument
     */
	public static func resourceGrantsIdDelete(id: String, idempotencyKey: String? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			ResourceGrantsAPI.resourceGrantsIdDeleteWithRequestBuilder(id: id, idempotencyKey: idempotencyKey)
		}
	}


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_resourceGrantsIdGet: String, CaseIterable {
		case grantee = "grantee"
		case subject = "subject"

		func toResourceGrantsAPIEnum() -> ResourceGrantsAPI.IncludeLinkage_resourceGrantsIdGet {
			switch self {
			case .grantee: return .grantee
			case .subject: return .subject
			}
		}
	}

	/**
     Get single resourceGrant.
     
     - returns: ResourceGrantsSingleResourceDataDocument
     */
	public static func resourceGrantsIdGet(id: String, include: [String]? = nil, includeLinkage: [ResourceGrantsAPITidal.IncludeLinkage_resourceGrantsIdGet]? = nil, replaceMedia: String? = nil) async throws -> ResourceGrantsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ResourceGrantsAPI.resourceGrantsIdGetWithRequestBuilder(id: id, include: include, includeLinkage: includeLinkage?.compactMap { $0.toResourceGrantsAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


	/**
     Update single resourceGrant.
     
     - returns: ResourceGrantsUpdateSingleResourceDataDocument
     */
	public static func resourceGrantsIdPatch(id: String, idempotencyKey: String? = nil, resourceGrantsUpdateOperationPayload: ResourceGrantsUpdateOperationPayload? = nil) async throws -> ResourceGrantsUpdateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ResourceGrantsAPI.resourceGrantsIdPatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, resourceGrantsUpdateOperationPayload: resourceGrantsUpdateOperationPayload)
		}
	}


	/**
     Get grantee relationship (\&quot;to-one\&quot;).
     
     - returns: ResourceGrantsGranteeSingleRelationshipDataDocument
     */
	public static func resourceGrantsIdRelationshipsGranteeGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> ResourceGrantsGranteeSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ResourceGrantsAPI.resourceGrantsIdRelationshipsGranteeGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Get subject relationship (\&quot;to-one\&quot;).
     
     - returns: ResourceGrantsSubjectSingleRelationshipDataDocument
     */
	public static func resourceGrantsIdRelationshipsSubjectGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> ResourceGrantsSubjectSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ResourceGrantsAPI.resourceGrantsIdRelationshipsSubjectGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Create single resourceGrant.
     
     - returns: ResourceGrantsCreateSingleResourceDataDocument
     */
	public static func resourceGrantsPost(idempotencyKey: String? = nil, resourceGrantsCreateOperationPayload: ResourceGrantsCreateOperationPayload? = nil) async throws -> ResourceGrantsCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ResourceGrantsAPI.resourceGrantsPostWithRequestBuilder(idempotencyKey: idempotencyKey, resourceGrantsCreateOperationPayload: resourceGrantsCreateOperationPayload)
		}
	}
}
