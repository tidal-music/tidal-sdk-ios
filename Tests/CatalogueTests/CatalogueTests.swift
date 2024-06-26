@testable import Catalogue
import XCTest

final class CatalogueTests: XCTestCase {
	func testCatalogue() throws {
		// This is an example of a functional test case.
		// Use XCTAssert and related functions to verify your tests produce the correct
		// results.
		let template = Catalogue()

		XCTAssertEqual(template.sayHello(), "Hello, World!")
	}
}
