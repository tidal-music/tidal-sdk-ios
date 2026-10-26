import Foundation
@testable import Offliner
import Testing
import TidalAPI

@Suite
struct ArtworkSelectionTests {
	@Test
	func usesArtworkDecodedWithoutMetadata() throws {
		let data = Data("""
		{"id":"artwork","type":"artworks","attributes":{
		    "mediaType":"IMAGE","files":[{"href":"https://example.com/artwork.jpg"}]
		}}
		""".utf8)
		let artwork = try JSONDecoder().decode(ArtworksResourceObject.self, from: data)

		#expect(artwork.largestFileURL?.absoluteString == "https://example.com/artwork.jpg")
	}

	@Test(arguments: [false, true])
	func prefersLargestKnownAreaRegardlessOfFileOrder(reversed: Bool) {
		let files = [
			ArtworkFile(href: "https://example.com/unknown.jpg"),
			ArtworkFile(href: "https://example.com/wide.jpg", meta: .init(height: 100, width: 1000)),
			ArtworkFile(href: "https://example.com/largest.jpg", meta: .init(height: 500, width: 500)),
			ArtworkFile(href: "https://example.com/another-unknown.jpg"),
		]
		let artwork = makeArtwork(files: reversed ? Array(files.reversed()) : files)

		#expect(artwork.largestFileURL?.absoluteString == "https://example.com/largest.jpg")
	}

	@Test
	func usesFirstFileWhenAllDimensionsAreMissing() {
		let artwork = makeArtwork(files: [
			ArtworkFile(href: "https://example.com/first.jpg"),
			ArtworkFile(href: "https://example.com/second.jpg"),
		])

		#expect(artwork.largestFileURL?.absoluteString == "https://example.com/first.jpg")
	}

	@Test
	func returnsNoURLForEmptyFiles() {
		#expect(makeArtwork(files: []).largestFileURL == nil)
	}

	@Test
	func returnsNoURLWithoutAttributes() {
		let artwork = ArtworksResourceObject(id: "artwork", type: "artworks")

		#expect(artwork.largestFileURL == nil)
	}

	private func makeArtwork(files: [ArtworkFile]) -> ArtworksResourceObject {
		ArtworksResourceObject(attributes: .init(files: files, mediaType: .image), id: "artwork", type: "artworks")
	}
}
