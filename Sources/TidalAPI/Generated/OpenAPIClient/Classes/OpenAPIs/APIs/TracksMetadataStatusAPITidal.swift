import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `TracksMetadataStatusAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await TracksMetadataStatusAPITidal.getResource()
/// ```
public enum TracksMetadataStatusAPITidal {


	/**
     Get single tracksMetadataStatu.
     
     - returns: TracksMetadataStatusSingleResourceDataDocument
     */
	public static func tracksMetadataStatusIdGet(id: String) async throws -> TracksMetadataStatusSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			TracksMetadataStatusAPI.tracksMetadataStatusIdGetWithRequestBuilder(id: id)
		}
	}
}
