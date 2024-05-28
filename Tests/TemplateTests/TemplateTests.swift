@testable import Template
import XCTest

final class TemplateTests: XCTestCase {
	func testTemplate() throws {
		// This is an example of a functional test case.
		// Use XCTAssert and related functions to verify your tests produce the correct
		// results.
		let template = Template()

		XCTAssertEqual(template.sayHello(), "Hello, World!")
	}
}
