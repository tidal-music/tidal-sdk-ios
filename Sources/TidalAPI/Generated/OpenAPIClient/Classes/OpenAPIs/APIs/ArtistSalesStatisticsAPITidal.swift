import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `ArtistSalesStatisticsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ArtistSalesStatisticsAPITidal.getResource()
/// ```
public enum ArtistSalesStatisticsAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_artistSalesStatisticsGet: String, CaseIterable {
		case artist = "artist"
		case topsellers = "topSellers"

		func toArtistSalesStatisticsAPIEnum() -> ArtistSalesStatisticsAPI.IncludeLinkage_artistSalesStatisticsGet {
			switch self {
			case .artist: return .artist
			case .topsellers: return .topsellers
			}
		}
	}

	/**
     Get multiple artistSalesStatistics.
     
     - returns: ArtistSalesStatisticsMultiResourceDataDocument
     */
	public static func artistSalesStatisticsGet(filterArtistId: [String], include: [String]? = nil, includeLinkage: [ArtistSalesStatisticsAPITidal.IncludeLinkage_artistSalesStatisticsGet]? = nil, replaceMedia: String? = nil) async throws -> ArtistSalesStatisticsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ArtistSalesStatisticsAPI.artistSalesStatisticsGetWithRequestBuilder(filterArtistId: filterArtistId, include: include, includeLinkage: includeLinkage?.compactMap { $0.toArtistSalesStatisticsAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


	/**
     Get artist relationship (\&quot;to-one\&quot;).
     
     - returns: ArtistSalesStatisticsArtistSingleRelationshipDataDocument
     */
	public static func artistSalesStatisticsIdRelationshipsArtistGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> ArtistSalesStatisticsArtistSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtistSalesStatisticsAPI.artistSalesStatisticsIdRelationshipsArtistGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Get topSellers relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistSalesStatisticsTopSellersMultiRelationshipDataDocument
     */
	public static func artistSalesStatisticsIdRelationshipsTopSellersGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> ArtistSalesStatisticsTopSellersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtistSalesStatisticsAPI.artistSalesStatisticsIdRelationshipsTopSellersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
		}
	}
}
