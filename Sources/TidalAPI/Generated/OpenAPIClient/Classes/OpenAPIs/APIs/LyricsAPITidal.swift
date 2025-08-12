import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `LyricsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await LyricsAPITidal.getResource()
/// ```
public enum LyricsAPITidal {

	/**
     Get single lyric.
     
     - returns: LyricsSingleResourceDataDocument
     */
	public static func lyricsIdGet(id: String, include: [String]? = nil) async throws -> LyricsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			LyricsAPI.lyricsIdGetWithRequestBuilder(id: id, include: include)
		}
	}

	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: LyricsMultiRelationshipDataDocument
     */
	public static func lyricsIdRelationshipsOwnersGet(id: String, countryCode: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> LyricsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			LyricsAPI.lyricsIdRelationshipsOwnersGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}

	/**
     Get track relationship (\&quot;to-one\&quot;).
     
     - returns: LyricsSingleRelationshipDataDocument
     */
	public static func lyricsIdRelationshipsTrackGet(id: String, countryCode: String, include: [String]? = nil) async throws -> LyricsSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			LyricsAPI.lyricsIdRelationshipsTrackGetWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}
}
