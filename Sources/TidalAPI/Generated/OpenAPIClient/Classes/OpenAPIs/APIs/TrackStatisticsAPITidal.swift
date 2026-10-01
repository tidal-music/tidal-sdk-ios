import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `TrackStatisticsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await TrackStatisticsAPITidal.getResource()
/// ```
public enum TrackStatisticsAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_trackStatisticsIdGet: String, CaseIterable {
		case owners = "owners"

		func toTrackStatisticsAPIEnum() -> TrackStatisticsAPI.IncludeLinkage_trackStatisticsIdGet {
			switch self {
			case .owners: return .owners
			}
		}
	}

	/**
     Get single trackStatistic.
     
     - returns: TrackStatisticsSingleResourceDataDocument
     */
	public static func trackStatisticsIdGet(id: String, countryCode: String? = nil, include: [String]? = nil, includeLinkage: [TrackStatisticsAPITidal.IncludeLinkage_trackStatisticsIdGet]? = nil) async throws -> TrackStatisticsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			TrackStatisticsAPI.trackStatisticsIdGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, includeLinkage: includeLinkage?.compactMap { $0.toTrackStatisticsAPIEnum() })
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: TrackStatisticsOwnersMultiRelationshipDataDocument
     */
	public static func trackStatisticsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> TrackStatisticsOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TrackStatisticsAPI.trackStatisticsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}
}
