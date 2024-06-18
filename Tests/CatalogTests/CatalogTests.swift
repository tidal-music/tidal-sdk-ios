@testable import Catalog
import XCTest

final class CatalogTests: XCTestCase {
	func testCatalog() throws {
		// This is an example of a functional test case.
		// Use XCTAssert and related functions to verify your tests produce the correct
		// results.
		let template = Catalog()

		XCTAssertEqual(template.sayHello(), "Hello, World!")
	}
}
