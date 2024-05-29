@testable import Auth
import Common
import KeychainAccess
import XCTest

final class ScopesTests: XCTestCase {
	func testToString() throws {
		// given
		let scopeSet = Set(["abc", "def", "ghi", "jkl"])
		let scopes = Scopes(scopes: scopeSet)

		// when
		let convertedString = scopes.toString()
			.components(separatedBy: " ")
			.sorted()
			.joined(separator: " ")

		// then
		XCTAssertEqual(convertedString, "abc def ghi jkl")
	}

	func testScopesFromString() throws {
		// given
		let scopesString = "abc def ghi"

		// when
		let scopes = try Scopes.fromString(scopesString)

		// then
		XCTAssertEqual(scopes.scopes.count, 3)
	}

	func testScopesFromEmptyString() throws {
		// given
		let scopesString = ""

		// when
		let scopes = try Scopes.fromString(scopesString)

		// then
		XCTAssertTrue(scopes.scopes.isEmpty)
	}
}
