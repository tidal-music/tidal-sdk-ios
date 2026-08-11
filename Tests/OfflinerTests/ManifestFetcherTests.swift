@testable import Offliner
import TidalAPI
import XCTest

final class ManifestFetcherTests: XCTestCase {
	func testFullTrackPresentationIsAccepted() throws {
		XCTAssertNoThrow(try validateFullTrackPresentation(.full))
	}

	func testPreviewTrackPresentationIsRejected() {
		XCTAssertThrowsError(try validateFullTrackPresentation(.preview))
	}

	func testMissingTrackPresentationIsRejected() {
		XCTAssertThrowsError(try validateFullTrackPresentation(nil))
	}
}
