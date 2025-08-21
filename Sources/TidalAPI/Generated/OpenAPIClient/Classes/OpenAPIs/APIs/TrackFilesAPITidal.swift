import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `TrackFilesAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await TrackFilesAPITidal.getResource()
/// ```
public enum TrackFilesAPITidal {


	/**
     Get single trackFile.
     
     - returns: TrackFilesSingleResourceDataDocument
     */
	public static func trackFilesIdGet(id: String, formats: String, usage: String) async throws -> TrackFilesSingleResourceDataDocument {
		return try await RequestHelper.createRequest {
			TrackFilesAPI.trackFilesIdGetWithRequestBuilder(id: id, formats: formats, usage: usage)
		}
	}
}
