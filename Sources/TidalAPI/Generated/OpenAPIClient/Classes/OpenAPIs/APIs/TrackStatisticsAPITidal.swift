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
     Get single trackStatistic.
     
     - returns: TrackStatisticsSingleDataDocument
     */
	public static func trackStatisticsIdGet(id: String, include: [String]? = nil) async throws -> TrackStatisticsSingleDataDocument {
		return try await RequestHelper.createRequest {
			TrackStatisticsAPI.trackStatisticsIdGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: TrackStatisticsMultiDataRelationshipDocument
     */
	public static func trackStatisticsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> TrackStatisticsMultiDataRelationshipDocument {
		return try await RequestHelper.createRequest {
			TrackStatisticsAPI.trackStatisticsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}
}
