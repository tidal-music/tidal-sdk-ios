import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `ArtistStreamsStatisticsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await ArtistStreamsStatisticsAPITidal.getResource()
/// ```
public enum ArtistStreamsStatisticsAPITidal {


	/**
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_artistStreamsStatisticsGet: String, CaseIterable {
		case artist = "artist"
		case toptracks = "topTracks"

		func toArtistStreamsStatisticsAPIEnum() -> ArtistStreamsStatisticsAPI.IncludeLinkage_artistStreamsStatisticsGet {
			switch self {
			case .artist: return .artist
			case .toptracks: return .toptracks
			}
		}
	}

	/**
     Get multiple artistStreamsStatistics.
     
     - returns: ArtistStreamsStatisticsMultiResourceDataDocument
     */
	public static func artistStreamsStatisticsGet(filterArtistId: [String], include: [String]? = nil, includeLinkage: [ArtistStreamsStatisticsAPITidal.IncludeLinkage_artistStreamsStatisticsGet]? = nil, replaceMedia: String? = nil) async throws -> ArtistStreamsStatisticsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			ArtistStreamsStatisticsAPI.artistStreamsStatisticsGetWithRequestBuilder(filterArtistId: filterArtistId, include: include, includeLinkage: includeLinkage?.compactMap { $0.toArtistStreamsStatisticsAPIEnum() }, replaceMedia: replaceMedia)
		}
	}


	/**
     Get artist relationship (\&quot;to-one\&quot;).
     
     - returns: ArtistStreamsStatisticsArtistSingleRelationshipDataDocument
     */
	public static func artistStreamsStatisticsIdRelationshipsArtistGet(id: String, include: [String]? = nil, replaceMedia: String? = nil) async throws -> ArtistStreamsStatisticsArtistSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtistStreamsStatisticsAPI.artistStreamsStatisticsIdRelationshipsArtistGetWithRequestBuilder(id: id, include: include, replaceMedia: replaceMedia)
		}
	}


	/**
     Get topTracks relationship (\&quot;to-many\&quot;).
     
     - returns: ArtistStreamsStatisticsTopTracksMultiRelationshipDataDocument
     */
	public static func artistStreamsStatisticsIdRelationshipsTopTracksGet(id: String, include: [String]? = nil, pageCursor: String? = nil, replaceMedia: String? = nil) async throws -> ArtistStreamsStatisticsTopTracksMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			ArtistStreamsStatisticsAPI.artistStreamsStatisticsIdRelationshipsTopTracksGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor, replaceMedia: replaceMedia)
		}
	}
}
