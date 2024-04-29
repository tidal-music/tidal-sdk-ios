@testable import Common
import XCTest

final class CommonTests: XCTestCase {
	func testCommon() throws {
		// This is an example of a functional test case.
		// Use XCTAssert and related functions to verify your tests produce the correct
		// results.
		let common = Common()

		XCTAssertEqual(common.sayHello(), "Hello, World!")
	}
}
