import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `CollaborationInvitesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await CollaborationInvitesAPITidal.getResource()
/// ```
public enum CollaborationInvitesAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_collaborationInvitesGet: String, CaseIterable {
		case owners = "owners"
		case subject = "subject"

		func toCollaborationInvitesAPIEnum() -> CollaborationInvitesAPI.IncludeLinkage_collaborationInvitesGet {
			switch self {
			case .owners: return .owners
			case .subject: return .subject
			}
		}
	}

	/**
     Get multiple collaborationInvites.
     
     - returns: CollaborationInvitesMultiResourceDataDocument
     */
	public static func collaborationInvitesGet(filterCode: [String], include: [String]? = nil, includeLinkage: [CollaborationInvitesAPITidal.IncludeLinkage_collaborationInvitesGet]? = nil, replaceMedia: String? = nil) async throws -> CollaborationInvitesMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			CollaborationInvitesAPI.collaborationInvitesGetWithRequestBuilder(filterCode: filterCode, include: include, includeLinkage: includeLinkage?.compactMap { $0.toCollaborationInvitesAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


	/**
     Delete single collaborationInvite.
     
     - returns: MutationResponseDocument
     */
	public static func collaborationInvitesIdDelete(id: String, idempotencyKey: String? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			CollaborationInvitesAPI.collaborationInvitesIdDeleteWithRequestBuilder(id: id, idempotencyKey: idempotencyKey)
		}
	}


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_collaborationInvitesIdGet: String, CaseIterable {
		case owners = "owners"
		case subject = "subject"

		func toCollaborationInvitesAPIEnum() -> CollaborationInvitesAPI.IncludeLinkage_collaborationInvitesIdGet {
			switch self {
			case .owners: return .owners
			case .subject: return .subject
			}
		}
	}

	/**
     Get single collaborationInvite.
     
     - returns: CollaborationInvitesSingleResourceDataDocument
     */
	public static func collaborationInvitesIdGet(id: String, include: [String]? = nil, includeLinkage: [CollaborationInvitesAPITidal.IncludeLinkage_collaborationInvitesIdGet]? = nil, replaceMedia: String? = nil) async throws -> CollaborationInvitesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			CollaborationInvitesAPI.collaborationInvitesIdGetWithRequestBuilder(id: id, include: include, includeLinkage: includeLinkage?.compactMap { $0.toCollaborationInvitesAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: CollaborationInvitesOwnersMultiRelationshipDataDocument
     */
	public static func collaborationInvitesIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> CollaborationInvitesOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			CollaborationInvitesAPI.collaborationInvitesIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get subject relationship (\&quot;to-one\&quot;).
     
     - returns: CollaborationInvitesSubjectSingleRelationshipDataDocument
     */
	public static func collaborationInvitesIdRelationshipsSubjectGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> CollaborationInvitesSubjectSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			CollaborationInvitesAPI.collaborationInvitesIdRelationshipsSubjectGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Create single collaborationInvite.
     
     - returns: CollaborationInvitesCreateSingleResourceDataDocument
     */
	public static func collaborationInvitesPost(idempotencyKey: String? = nil, collaborationInvitesCreateOperationPayload: CollaborationInvitesCreateOperationPayload? = nil) async throws -> CollaborationInvitesCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			CollaborationInvitesAPI.collaborationInvitesPostWithRequestBuilder(idempotencyKey: idempotencyKey, collaborationInvitesCreateOperationPayload: collaborationInvitesCreateOperationPayload)
		}
	}
}
