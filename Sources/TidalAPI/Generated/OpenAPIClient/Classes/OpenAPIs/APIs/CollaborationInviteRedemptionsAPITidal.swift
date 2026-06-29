import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `CollaborationInviteRedemptionsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await CollaborationInviteRedemptionsAPITidal.getResource()
/// ```
public enum CollaborationInviteRedemptionsAPITidal {


	/**
     Create single collaborationInviteRedemption.
     
     - returns: CollaborationInviteRedemptionsSingleResourceDataDocument
     */
	public static func collaborationInviteRedemptionsPost(idempotencyKey: String? = nil, collaborationInviteRedemptionsCreateOperationPayload: CollaborationInviteRedemptionsCreateOperationPayload? = nil) async throws -> CollaborationInviteRedemptionsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			CollaborationInviteRedemptionsAPI.collaborationInviteRedemptionsPostWithRequestBuilder(idempotencyKey: idempotencyKey, collaborationInviteRedemptionsCreateOperationPayload: collaborationInviteRedemptionsCreateOperationPayload)
		}
	}
}
