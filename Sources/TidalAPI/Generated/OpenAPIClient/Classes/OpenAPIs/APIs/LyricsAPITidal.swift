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
     Get multiple lyrics.
     
     - returns: LyricsMultiResourceDataDocument
     */
	public static func lyricsGet(include: [String]? = nil, filterId: [String]? = nil) async throws -> LyricsMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			LyricsAPI.lyricsGetWithRequestBuilder(include: include, filterId: filterId)
		}
	}


	/**
     Delete single lyric.
     
     - returns: 
     */
	public static func lyricsIdDelete(id: String) async throws {
		return try await RequestHelper.createRequest {
			LyricsAPI.lyricsIdDeleteWithRequestBuilder(id: id)
		}
	}


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
     Update single lyric.
     
     - returns: 
     */
	public static func lyricsIdPatch(id: String, lyricsUpdateOperationPayload: LyricsUpdateOperationPayload? = nil) async throws {
		return try await RequestHelper.createRequest {
			LyricsAPI.lyricsIdPatchWithRequestBuilder(id: id, lyricsUpdateOperationPayload: lyricsUpdateOperationPayload)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: LyricsMultiRelationshipDataDocument
     */
	public static func lyricsIdRelationshipsOwnersGet(id: String, countryCode: String? = nil, include: [String]? = nil, pageCursor: String? = nil) async throws -> LyricsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			LyricsAPI.lyricsIdRelationshipsOwnersGetWithRequestBuilder(id: id, countryCode: countryCode, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Get track relationship (\&quot;to-one\&quot;).
     
     - returns: LyricsSingleRelationshipDataDocument
     */
	public static func lyricsIdRelationshipsTrackGet(id: String, countryCode: String? = nil, include: [String]? = nil) async throws -> LyricsSingleRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			LyricsAPI.lyricsIdRelationshipsTrackGetWithRequestBuilder(id: id, countryCode: countryCode, include: include)
		}
	}


	/**
     Create single lyric.
     
     - returns: LyricsSingleResourceDataDocument
     */
	public static func lyricsPost(lyricsCreateOperationPayload: LyricsCreateOperationPayload? = nil) async throws -> LyricsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			LyricsAPI.lyricsPostWithRequestBuilder(lyricsCreateOperationPayload: lyricsCreateOperationPayload)
		}
	}
}
