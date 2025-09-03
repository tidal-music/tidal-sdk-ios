import Foundation

public extension TrackManifestsAPITidal {
	/**
     Get single trackManifest with custom headers.
     
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