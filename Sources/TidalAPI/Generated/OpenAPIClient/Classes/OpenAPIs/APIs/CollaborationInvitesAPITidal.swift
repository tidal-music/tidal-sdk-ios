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
     Get multiple collaborationInvites.
     
     - returns: CollaborationInvitesMultiResourceDataDocument
     */
	public static func collaborationInvitesGet(include: [String]? = nil, filterCode: [String]? = nil) async throws -> CollaborationInvitesMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			CollaborationInvitesAPI.collaborationInvitesGetWithRequestBuilder(include: include, filterCode: filterCode)
		}
	}


	/**
     Delete single collaborationInvite.
     
     - returns: 
     */
	public static func collaborationInvitesIdDelete(id: String, idempotencyKey: String? = nil) async throws {
		return try await RequestHelper.createRequest {
			CollaborationInvitesAPI.collaborationInvitesIdDeleteWithRequestBuilder(id: id, idempotencyKey: idempotencyKey)
		}
	}


	/**
     Get single collaborationInvite.
     
     - returns: CollaborationInvitesSingleResourceDataDocument
     */
	public static func collaborationInvitesIdGet(id: String, include: [String]? = nil) async throws -> CollaborationInvitesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			CollaborationInvitesAPI.collaborationInvitesIdGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: CollaborationInvitesMultiRelationshipDataDocument
     */
	public static func collaborationInvitesIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> CollaborationInvitesMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			CollaborationInvitesAPI.collaborationInvitesIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get subject relationship (\&quot;to-one\&quot;).
     
     - returns: CollaborationInvitesSingleRelationshipDataDocument
     */
	public static func collaborationInvitesIdRelationshipsSubjectGet(id: String, include: [String]? = nil) async throws -> CollaborationInvitesSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			CollaborationInvitesAPI.collaborationInvitesIdRelationshipsSubjectGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Create single collaborationInvite.
     
     - returns: CollaborationInvitesSingleResourceDataDocument
     */
	public static func collaborationInvitesPost(idempotencyKey: String? = nil, collaborationInvitesCreateOperationPayload: CollaborationInvitesCreateOperationPayload? = nil) async throws -> CollaborationInvitesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			CollaborationInvitesAPI.collaborationInvitesPostWithRequestBuilder(idempotencyKey: idempotencyKey, collaborationInvitesCreateOperationPayload: collaborationInvitesCreateOperationPayload)
		}
	}
}
