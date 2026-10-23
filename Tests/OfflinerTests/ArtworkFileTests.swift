@testable import Offliner
import TidalAPI
import XCTest

final class ArtworkFileTests: XCTestCase {
	func testKnownDimensionsRankAheadOfFilesWithoutMetadata() {
		let unknown = ArtworkFile(href: "https://example.com/unknown.jpg")
		let small = ArtworkFile(href: "https://example.com/small.jpg", meta: .init(height: 80, width: 80))
		let large = ArtworkFile(href: "https://example.com/large.jpg", meta: .init(height: 640, width: 640))
		XCTAssertEqual(unknown.area, 0)
		XCTAssertEqual([unknown, large, small].max { $0.area < $1.area }, large)
	}
}
