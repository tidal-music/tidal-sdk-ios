import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `AlbumStatisticsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await AlbumStatisticsAPITidal.getResource()
/// ```
public enum AlbumStatisticsAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_albumStatisticsIdGet: String, CaseIterable {
		case owners = "owners"

		func toAlbumStatisticsAPIEnum() -> AlbumStatisticsAPI.IncludeLinkage_albumStatisticsIdGet {
			switch self {
			case .owners: return .owners
			}
		}
	}

	/**
     Get single albumStatistic.
     
     - returns: AlbumStatisticsSingleResourceDataDocument
     */
	public static func albumStatisticsIdGet(id: String, countryCode: String? = nil, include: [String]? = nil, includeLinkage: [AlbumStatisticsAPITidal.IncludeLinkage_albumStatisticsIdGet]? = nil) async throws -> AlbumStatisticsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			AlbumStatisticsAPI.albumStatisticsIdGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, includeLinkage: includeLinkage?.compactMap { $0.toAlbumStatisticsAPIEnum() })
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: AlbumStatisticsOwnersMultiRelationshipDataDocument
     */
	public static func albumStatisticsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> AlbumStatisticsOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			AlbumStatisticsAPI.albumStatisticsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}
}
