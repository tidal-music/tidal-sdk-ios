import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `TrackSourceFilesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await TrackSourceFilesAPITidal.getResource()
/// ```
public enum TrackSourceFilesAPITidal {


	/**
     Get multiple trackSourceFiles.
     
     - returns: TrackSourceFilesMultiResourceDataDocument
     */
	public static func trackSourceFilesGet(include: [String]? = nil, filterId: [String]? = nil) async throws -> TrackSourceFilesMultiResourceDataDocument {
		return try await RequestHelper.createRequest {
			TrackSourceFilesAPI.trackSourceFilesGetWithRequestBuilder(include: include, filterId: filterId)
		}
	}


	/**
     Get single trackSourceFile.
     
     - returns: TrackSourceFilesSingleResourceDataDocument
     */
	public static func trackSourceFilesIdGet(id: String, include: [String]? = nil) async throws -> TrackSourceFilesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			TrackSourceFilesAPI.trackSourceFilesIdGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: TrackSourceFilesMultiRelationshipDataDocument
     */
	public static func trackSourceFilesIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> TrackSourceFilesMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TrackSourceFilesAPI.trackSourceFilesIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Create single trackSourceFile.
     
     - returns: TrackSourceFilesSingleResourceDataDocument
     */
	public static func trackSourceFilesPost(trackSourceFilesCreateOperationPayload: TrackSourceFilesCreateOperationPayload? = nil) async throws -> TrackSourceFilesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			TrackSourceFilesAPI.trackSourceFilesPostWithRequestBuilder(trackSourceFilesCreateOperationPayload: trackSourceFilesCreateOperationPayload)
		}
	}
}
