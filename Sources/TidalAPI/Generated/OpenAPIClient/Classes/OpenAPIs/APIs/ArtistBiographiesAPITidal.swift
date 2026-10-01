import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `ArtistBiographiesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ArtistBiographiesAPITidal.getResource()
/// ```
public enum ArtistBiographiesAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_artistBiographiesIdGet: String, CaseIterable {
		case owners = "owners"

		func toArtistBiographiesAPIEnum() -> ArtistBiographiesAPI.IncludeLinkage_artistBiographiesIdGet {
			switch self {
			case .owners: return .owners
			}
		}
	}

	/**
     Get single artistBiographie.
     
     - returns: ArtistBiographiesSingleResourceDataDocument
     */
	public static func artistBiographiesIdGet(id: String, countryCode: String? = nil, include: [String]? = nil, includeLinkage: [ArtistBiographiesAPITidal.IncludeLinkage_artistBiographiesIdGet]? = nil) async throws -> ArtistBiographiesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ArtistBiographiesAPI.artistBiographiesIdGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, includeLinkage: includeLinkage?.compactMap { $0.toArtistBiographiesAPIEnum() })
		}
	}


	/**
     Update single artistBiographie.
     
     - returns: MutationResponseDocument
     */
	public static func artistBiographiesIdPatch(id: String, idempotencyKey: String? = nil, artistBiographiesUpdateOperationPayload: ArtistBiographiesUpdateOperationPayload? = nil) async throws -> MutationResponseDocument {
		return try await RequestHelper.createRequest {
			ArtistBiographiesAPI.artistBiographiesIdPatchWithRequestBuilder(id: id, idempotencyKey: idempotencyKey, artistBiographiesUpdateOperationPayload: artistBiographiesUpdateOperationPayload)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistBiographiesOwnersMultiRelationshipDataDocument
     */
	public static func artistBiographiesIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtistBiographiesOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtistBiographiesAPI.artistBiographiesIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}
}
