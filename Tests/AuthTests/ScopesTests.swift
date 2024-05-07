@testable import Auth
import Common
import KeychainAccess
import XCTest

final class ScopesTests: XCTestCase {
	func testToString() throws {
		// given
		let scopeSet = Set(["r_usr", "w_usr", "w_sub", "r_k"])
		let scopes = Scopes(scopes: scopeSet)

		// when
		let convertedString = scopes.toString()
			.components(separatedBy: " ")
			.sorted()
			.joined(separator: " ")

		// then
		XCTAssertEqual(convertedString, "r_k r_usr w_sub w_usr")
	}

	func testScopesFromString() throws {
		// given
		let scopesString = "r_usr w_usr w_sub"

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
