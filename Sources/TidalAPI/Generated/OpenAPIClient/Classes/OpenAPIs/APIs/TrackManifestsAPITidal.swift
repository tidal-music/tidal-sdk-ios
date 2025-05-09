import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/// This is a wrapper around `TrackManifestsAPI` that uses the injected credentialsprovider
/// from `OpenAPIClientAPI.credentialsProvider` to provide a convenience API.
///
/// Usage example:
/// ```swift
/// OpenAPIClientAPI.credentialsProvider = TidalAuth.shared
/// let dataDocument = try await TrackManifestsAPITidal.getResource()
/// ```
public enum TrackManifestsAPITidal {


	/**
     Get single trackManifest.
     
     - returns: TrackManifestsSingleDataDocument
     */
	public static func trackManifestsIdGet(id: String, manifestType: String, formats: String, uriScheme: String, usage: String, adaptive: String) async throws -> TrackManifestsSingleDataDocument {
		return try await RequestHelper.createRequest {
			TrackManifestsAPI.trackManifestsIdGetWithRequestBuilder(id: id, manifestType: manifestType, formats: formats, uriScheme: uriScheme, usage: usage, adaptive: adaptive)
		}
	}
}
