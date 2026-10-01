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
	 * enum for parameter includeLinkage
	 */
	public enum IncludeLinkage_trackSourceFilesIdGet: String, CaseIterable {
		case owners = "owners"

		func toTrackSourceFilesAPIEnum() -> TrackSourceFilesAPI.IncludeLinkage_trackSourceFilesIdGet {
			switch self {
			case .owners: return .owners
			}
		}
	}

	/**
     Get single trackSourceFile.
     
     - returns: TrackSourceFilesSingleResourceDataDocument
     */
	public static func trackSourceFilesIdGet(id: String, include: [String]? = nil, includeLinkage: [TrackSourceFilesAPITidal.IncludeLinkage_trackSourceFilesIdGet]? = nil) async throws -> TrackSourceFilesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			TrackSourceFilesAPI.trackSourceFilesIdGetWithRequestBuilder(id: id, include: include, includeLinkage: includeLinkage?.compactMap { $0.toTrackSourceFilesAPIEnum() })
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: TrackSourceFilesOwnersMultiRelationshipDataDocument
     */
	public static func trackSourceFilesIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> TrackSourceFilesOwnersMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			TrackSourceFilesAPI.trackSourceFilesIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}


	/**
     Create single trackSourceFile.
     
     - returns: TrackSourceFilesCreateSingleResourceDataDocument
     */
	public static func trackSourceFilesPost(idempotencyKey: String? = nil, trackSourceFilesCreateOperationPayload: TrackSourceFilesCreateOperationPayload? = nil) async throws -> TrackSourceFilesCreateSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			TrackSourceFilesAPI.trackSourceFilesPostWithRequestBuilder(idempotencyKey: idempotencyKey, trackSourceFilesCreateOperationPayload: trackSourceFilesCreateOperationPayload)
		}
	}
}
