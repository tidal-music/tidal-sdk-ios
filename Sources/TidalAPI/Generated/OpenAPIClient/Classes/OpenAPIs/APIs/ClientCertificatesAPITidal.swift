import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `ClientCertificatesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ClientCertificatesAPITidal.getResource()
/// ```
public enum ClientCertificatesAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_clientCertificatesIdGet: String, CaseIterable {
		case owners = "owners"

		func toClientCertificatesAPIEnum() -> ClientCertificatesAPI.IncludeLinkage_clientCertificatesIdGet {
			switch self {
			case .owners: return .owners
			}
		}
	}

	/**
     Get single clientCertificate.
     
     - returns: ClientCertificatesSingleResourceDataDocument
     */
	public static func clientCertificatesIdGet(id: String, include: [String]? = nil, includeLinkage: [ClientCertificatesAPITidal.IncludeLinkage_clientCertificatesIdGet]? = nil) async throws -> ClientCertificatesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ClientCertificatesAPI.clientCertificatesIdGetWithRequestBuilder(id: id, include: include, includeLinkage: includeLinkage?.compactMap { $0.toClientCertificatesAPIEnum() })
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: ClientCertificatesOwnersMultiRelationshipDataDocument
     */
	public static func clientCertificatesIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ClientCertificatesOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ClientCertificatesAPI.clientCertificatesIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Create single clientCertificate.
     
     - returns: ClientCertificatesCreateSingleResourceDataDocument
     */
	public static func clientCertificatesPost(idempotencyKey: String? = nil, clientCertificatesCreateOperationPayload: ClientCertificatesCreateOperationPayload? = nil) async throws -> ClientCertificatesCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ClientCertificatesAPI.clientCertificatesPostWithRequestBuilder(idempotencyKey: idempotencyKey, clientCertificatesCreateOperationPayload: clientCertificatesCreateOperationPayload)
		}
	}
}
