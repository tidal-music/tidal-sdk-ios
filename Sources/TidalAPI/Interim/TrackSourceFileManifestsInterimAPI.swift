import Foundation

/// Hand-written client for `GET /trackSourceFileManifests/{id}` until the generated API includes it; delete it then.
/// The response has the same attributes as `/trackManifests/{id}`, so it decodes into the same document.
/// SPI, so it adds no public TidalAPI surface.
@_spi(TrackSourceFilePlayback)
public enum TrackSourceFileManifestsInterimAPI {
	public static func trackSourceFileManifestsIdGet(
		id: String,
		manifestType: TrackManifestsAPITidal.ManifestType_trackManifestsIdGet,
		formats: [TrackManifestsAPITidal.Formats_trackManifestsIdGet],
		uriScheme: TrackManifestsAPITidal.UriScheme_trackManifestsIdGet,
		usage: TrackManifestsAPITidal.Usage_trackManifestsIdGet,
		adaptive: Bool
	) async throws -> TrackManifestsSingleResourceDataDocument {
		try await RequestHelper.createRequest {
			trackSourceFileManifestsIdGetWithRequestBuilder(
				id: id,
				manifestType: manifestType,
				formats: formats,
				uriScheme: uriScheme,
				usage: usage,
				adaptive: adaptive
			)
		}
	}

	static func trackSourceFileManifestsIdGetWithRequestBuilder(
		id: String,
		manifestType: TrackManifestsAPITidal.ManifestType_trackManifestsIdGet,
		formats: [TrackManifestsAPITidal.Formats_trackManifestsIdGet],
		uriScheme: TrackManifestsAPITidal.UriScheme_trackManifestsIdGet,
		usage: TrackManifestsAPITidal.Usage_trackManifestsIdGet,
		adaptive: Bool
	) -> RequestBuilder<TrackManifestsSingleResourceDataDocument> {
		let escapedId = id.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
		let urlString = OpenAPIClientAPI.basePath + "/trackSourceFileManifests/" + escapedId

		var urlComponents = URLComponents(string: urlString)
		urlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
			"manifestType": (wrappedValue: manifestType.rawValue, isExplode: true),
			"formats": (wrappedValue: formats.map(\.rawValue), isExplode: true),
			"uriScheme": (wrappedValue: uriScheme.rawValue, isExplode: true),
			"usage": (wrappedValue: usage.rawValue, isExplode: true),
			"adaptive": (wrappedValue: adaptive, isExplode: true),
		])

		let requestBuilderType: RequestBuilder<TrackManifestsSingleResourceDataDocument>.Type =
			OpenAPIClientAPI.requestBuilderFactory.getBuilder()

		return requestBuilderType.init(
			method: "GET",
			URLString: urlComponents?.string ?? urlString,
			parameters: nil,
			headers: [:],
			requiresAuthentication: true
		)
	}
}
