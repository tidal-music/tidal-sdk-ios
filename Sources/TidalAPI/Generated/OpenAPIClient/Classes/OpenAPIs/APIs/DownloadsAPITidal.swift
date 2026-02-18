import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `DownloadsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await DownloadsAPITidal.getResource()
/// ```
public enum DownloadsAPITidal {


	/**
     Get single download.
     
     - returns: DownloadsSingleResourceDataDocument
     */
	public static func downloadsIdGet(id: String, include: [String]? = nil) async throws -> DownloadsSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			DownloadsAPI.downloadsIdGetWithRequestBuilder(id: id, include: include)
		}
	}


	/**
     Get owners relationship (\&quot;to-many\&quot;).
     
     - returns: DownloadsMultiRelationshipDataDocument
     */
	public static func downloadsIdRelationshipsOwnersGet(id: String, include: [String]? = nil, pageCursor: String? = nil) async throws -> DownloadsMultiRelationshipDataDocument {
		return try await RequestHelper.createRequest {
			DownloadsAPI.downloadsIdRelationshipsOwnersGetWithRequestBuilder(id: id, include: include, pageCursor: pageCursor)
		}
	}
}
