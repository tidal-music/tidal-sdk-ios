import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `ArtworksAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ArtworksAPITidal.getResource()
/// ```
public enum ArtworksAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_artworksGet: String, CaseIterable {
		case owners = "owners"

		func toArtworksAPIEnum() -> ArtworksAPI.IncludeLinkage_artworksGet {
			switch self {
			case .owners: return .owners
			}
		}
	}

	/**
     Get multiple artworks.
     
     - returns: ArtworksMultiResourceDataDocument
     */
	public static func artworksGet(filterId: [String], countryCode: String? = nil, include: [String]? = nil, includeLinkage: [ArtworksAPITidal.IncludeLinkage_artworksGet]? = nil) async throws -> ArtworksMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ArtworksAPI.artworksGetWithRequestBuilder(filterId: filterId, countryCode: countryCode, include: include, includeLinkage: includeLinkage?.compactMap { $0.toArtworksAPIEnum() })
		}
	}


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_artworksIdGet: String, CaseIterable {
		case owners = "owners"

		func toArtworksAPIEnum() -> ArtworksAPI.IncludeLinkage_artworksIdGet {
			switch self {
			case .owners: return .owners
			}
		}
	}

	/**
     Get single artwork.
     
     - returns: ArtworksSingleResourceDataDocument
     */
	public static func artworksIdGet(id: String, countryCode: String? = nil, include: [String]? = nil, includeLinkage: [ArtworksAPITidal.IncludeLinkage_artworksIdGet]? = nil) async throws -> ArtworksSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ArtworksAPI.artworksIdGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, includeLinkage: includeLinkage?.compactMap { $0.toArtworksAPIEnum() })
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: ArtworksOwnersMultiRelationshipDataDocument
     */
	public static func artworksIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> ArtworksOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtworksAPI.artworksIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Create single artwork.
     
     - returns: ArtworksCreateSingleResourceDataDocument
     */
	public static func artworksPost(idempotencyKey: String? = nil, artworksCreateOperationPayload: ArtworksCreateOperationPayload? = nil) async throws -> ArtworksCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			ArtworksAPI.artworksPostWithRequestBuilder(idempotencyKey: idempotencyKey, artworksCreateOperationPayload: artworksCreateOperationPayload)
		}
	}
}
