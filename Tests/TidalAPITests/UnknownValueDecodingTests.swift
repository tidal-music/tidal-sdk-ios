import Foundation
import Testing
@testable import TidalAPI

// MARK: - UnknownValueDecodingTests

/// The TIDAL API may add enum values and resource types at any time without a major version bump.
/// Unknown values must decode to `unknownDefaultOpenApi` instead of failing the whole response.
struct UnknownValueDecodingTests {
	@Test
	func unknownEnumValuesAndResourceTypesDecode() throws {
		let json = """
		{
			"data": [
				{"id": "a1", "type": "artworks", "attributes": {"mediaType": "HOLOGRAM", "files": []}}
			],
			"included": [
				{"id": "x1", "type": "futureResource", "attributes": {"anything": true}},
				{"id": "ar1", "type": "artists", "attributes": {"name": "Artist", "popularity": 0.5, "ownerType": "ROBOT"}}
			],
			"links": {"self": "/artworks"}
		}
		"""

		let document = try CodableHelper.jsonDecoder.decode(
			ArtworksMultiResourceDataDocument.self,
			from: Data(json.utf8)
		)

		#expect(document.data.first?.attributes?.mediaType == .unknownDefaultOpenApi)
		#expect(document.included?.first == .unknownDefaultOpenApi)
		guard case let .artistsResourceObject(artist) = document.included?.last else {
			Issue.record("Expected the known artist to survive next to an unknown resource")
			return
		}
		#expect(artist.attributes?.name == "Artist")
		#expect(artist.attributes?.ownerType == .unknownDefaultOpenApi)
	}

	@Test
	func knownEnumValuesStillDecode() throws {
		let json = #"{"mediaType": "VIDEO", "files": []}"#

		let attributes = try CodableHelper.jsonDecoder.decode(ArtworksAttributes.self, from: Data(json.utf8))

		#expect(attributes.mediaType == .video)
	}
}
