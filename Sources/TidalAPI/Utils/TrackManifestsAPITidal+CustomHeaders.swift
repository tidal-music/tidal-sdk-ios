import Foundation

public extension TrackManifestsAPITidal {
	/**
     Get single trackManifest with custom headers using type-safe parameters.
     
     - parameter customHeaders: Custom headers to add to the request
     - returns: TrackManifestsSingleResourceDataDocument
     */
	static func trackManifestsIdGet(
		id: String,
		manifestType: TrackManifestParameters.ManifestType,
		formats: String,
		uriScheme: TrackManifestParameters.UriScheme,
		usage: TrackManifestParameters.Usage,
		adaptive: TrackManifestParameters.Adaptive,
		customHeaders: [String: String]
	) async throws -> TrackManifestsSingleResourceDataDocument {
		return try await RequestHelper.createRequest(customHeaders: customHeaders) {
			TrackManifestsAPI.trackManifestsIdGetWithRequestBuilder(
				id: id,
				manifestType: manifestType.rawValue,
				formats: formats,
				uriScheme: uriScheme.rawValue,
				usage: usage.rawValue,
				adaptive: adaptive.rawValue
			)
		}
	}
	
	/**
     Get single trackManifest with custom headers (legacy string parameters).
     
     - parameter customHeaders: Custom headers to add to the request  
     - returns: TrackManifestsSingleResourceDataDocument
     */
	static func trackManifestsIdGet(
		id: String,
		manifestType: String,
		formats: String,
		uriScheme: String,
		usage: String,
		adaptive: String,
		customHeaders: [String: String]
	) async throws -> TrackManifestsSingleResourceDataDocument {
		return try await RequestHelper.createRequest(customHeaders: customHeaders) {
			TrackManifestsAPI.trackManifestsIdGetWithRequestBuilder(
				id: id,
				manifestType: manifestType,
				formats: formats,
				uriScheme: uriScheme,
				usage: usage,
				adaptive: adaptive
			)
		}
	}
}