import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `ResourceGrantInvitationsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ResourceGrantInvitationsAPITidal.getResource()
/// ```
public enum ResourceGrantInvitationsAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_resourceGrantInvitationsGet: String, CaseIterable {
		case owners = "owners"
		case previewgrant = "previewGrant"
		case subject = "subject"

		func toResourceGrantInvitationsAPIEnum() -> ResourceGrantInvitationsAPI.IncludeLinkage_resourceGrantInvitationsGet {
			switch self {
			case .owners: return .owners
			case .previewgrant: return .previewgrant
			case .subject: return .subject
			}
		}
	}

	/**
     Get multiple resourceGrantInvitations.
     
     - returns: ResourceGrantInvitationsMultiResourceDataDocument
     */
	public static func resourceGrantInvitationsGet(filterCode: String? = nil, filterSelfAppliesTo: String? = nil, include: [String]? = nil, includeLinkage: [ResourceGrantInvitationsAPITidal.IncludeLinkage_resourceGrantInvitationsGet]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> ResourceGrantInvitationsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ResourceGrantInvitationsAPI.resourceGrantInvitationsGetWithRequestBuilder(filterCode: filterCode, filterSelfAppliesTo: filterSelfAppliesTo, include: include, includeLinkage: includeLinkage?.compactMap { $0.toResourceGrantInvitationsAPIEnum() }, pageCursor: pageCursor, replaceMedia: replaceMedia)
		}
	}


	/**
     Delete single resourceGrantInvitation.
     
     - returns: MutationResponseDocument
     */
	public static func resourceGrantInvitationsIdDelete(id: String, idempotencyKey: String? = nil, revokeGrants: Bool? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			ResourceGrantInvitationsAPI.resourceGrantInvitationsIdDeleteWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, revokeGrants: revokeGrants)
		}
	}


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_resourceGrantInvitationsIdGet: String, CaseIterable {
		case owners = "owners"
		case previewgrant = "previewGrant"
		case subject = "subject"

		func toResourceGrantInvitationsAPIEnum() -> ResourceGrantInvitationsAPI.IncludeLinkage_resourceGrantInvitationsIdGet {
			switch self {
			case .owners: return .owners
			case .previewgrant: return .previewgrant
			case .subject: return .subject
			}
		}
	}

	/**
     Get single resourceGrantInvitation.
     
     - returns: ResourceGrantInvitationsSingleResourceDataDocument
     */
	public static func resourceGrantInvitationsIdGet(id: String, include: [String]? = nil, includeLinkage: [ResourceGrantInvitationsAPITidal.IncludeLinkage_resourceGrantInvitationsIdGet]? = nil, replaceMedia: String? = nil) async throws -> ResourceGrantInvitationsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ResourceGrantInvitationsAPI.resourceGrantInvitationsIdGetWithRequestBuilder(id: id, include: include, includeLinkage: includeLinkage?.compactMap { $0.toResourceGrantInvitationsAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


	/**
     Update single resourceGrantInvitation.
     
     - returns: ResourceGrantInvitationsUpdateSingleResourceDataDocument
     */
	public static func resourceGrantInvitationsIdPatch(id: String, idempotencyKey: String? = nil, resourceGrantInvitationsUpdateOperationPayload: ResourceGrantInvitationsUpdateOperationPayload? = nil) async throws -> ResourceGrantInvitationsUpdateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ResourceGrantInvitationsAPI.resourceGrantInvitationsIdPatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, resourceGrantInvitationsUpdateOperationPayload: resourceGrantInvitationsUpdateOperationPayload)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: ResourceGrantInvitationsOwnersMultiRelationshipDataDocument
     */
	public static func resourceGrantInvitationsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ResourceGrantInvitationsOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ResourceGrantInvitationsAPI.resourceGrantInvitationsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get previewGrant relationship (\&quot;to-one\&quot;).
     
     - returns: ResourceGrantInvitationsPreviewGrantSingleRelationshipDataDocument
     */
	public static func resourceGrantInvitationsIdRelationshipsPreviewGrantGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> ResourceGrantInvitationsPreviewGrantSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ResourceGrantInvitationsAPI.resourceGrantInvitationsIdRelationshipsPreviewGrantGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Get subject relationship (\&quot;to-one\&quot;).
     
     - returns: ResourceGrantInvitationsSubjectSingleRelationshipDataDocument
     */
	public static func resourceGrantInvitationsIdRelationshipsSubjectGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> ResourceGrantInvitationsSubjectSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ResourceGrantInvitationsAPI.resourceGrantInvitationsIdRelationshipsSubjectGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Create single resourceGrantInvitation.
     
     - returns: ResourceGrantInvitationsCreateSingleResourceDataDocument
     */
	public static func resourceGrantInvitationsPost(idempotencyKey: String? = nil, resourceGrantInvitationsCreateOperationPayload: ResourceGrantInvitationsCreateOperationPayload? = nil) async throws -> ResourceGrantInvitationsCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ResourceGrantInvitationsAPI.resourceGrantInvitationsPostWithRequestBuilder(idempotencyKey: idempotencyKey, resourceGrantInvitationsCreateOperationPayload: resourceGrantInvitationsCreateOperationPayload)
		}
	}
}
