import Foundation
import Testing
@testable @_spi(TrackSourceFilePlayback) import TidalAPI

// MARK: - TrackSourceFileManifestsInterimAPITests

struct TrackSourceFileManifestsInterimAPITests {
	@Test
	func test_interimRequest_pathAndQuery() throws {
		let builder = TrackSourceFileManifestsInterimAPI.trackSourceFileManifestsIdGetWithRequestBuilder(
			id: "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11",
			manifestType: .hls,
			formats: [.heaacv1, .flac],
			uriScheme: .data,
			usage: .playback,
			adaptive: true
		)

		let components = try #require(URLComponents(string: builder.URLString))
		#expect(builder.method == "GET")
		#expect(builder.requiresAuthentication)
		#expect(components.host == "openapi.tidal.com")
		#expect(components.path == "/v2/trackSourceFileManifests/a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11")
		#expect(components.queryItems == [
			URLQueryItem(name: "adaptive", value: "true"),
			URLQueryItem(name: "formats", value: "HEAACV1"),
			URLQueryItem(name: "formats", value: "FLAC"),
			URLQueryItem(name: "manifestType", value: "HLS"),
			URLQueryItem(name: "uriScheme", value: "DATA"),
			URLQueryItem(name: "usage", value: "PLAYBACK"),
		])
	}

	@Test
	func test_trackManifestAttributes_decodeOptionalSourceFileId() throws {
		let withId = try JSONDecoder().decode(TrackManifestsAttributes.self, from: Data(#"{"sourceFileId":"id"}"#.utf8))
		let withoutId = try JSONDecoder().decode(TrackManifestsAttributes.self, from: Data(#"{"sourceFileId":null}"#.utf8))

		#expect(withId.sourceFileId == "id")
		#expect(withoutId.sourceFileId == nil)
	}
}
