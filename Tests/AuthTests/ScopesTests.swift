@testable import Auth
import Common
import KeychainAccess
import XCTest

final class ScopesTests: XCTestCase {
	func testToString() throws {
		// given
		let scopeSet = Set(["r_usr", "w_usr", "w_sub", "r_k"])
		let scopes = try Scopes(scopes: scopeSet)

		// when
		let convertedString = scopes.toString()

		// then
		XCTAssertNotNil(
			convertedString.range(of: Scopes.VALID_SCOPES_STRING_REGEX, options: .regularExpression),
			"Scopes.toString() should produce a usable string"
		)
	}

	func testScopesCreationFails() throws {
		do {
			// given
			let scopeSet = Set(["r_usr", "Hello, World!", "w_sub"])

			// when
			_ = try Scopes(scopes: scopeSet)
		} catch {
			XCTAssertTrue(error is TidalError)
			XCTAssertEqual((error as? TidalError)?.message, Scopes.ILLEGAL_SCOPES_MESSAGE)
		}
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

	func testScopesFromStringWithNotValidString() throws {
		// given
		let wrongString1 = "r_usrw_usr w_sub"
		let wrongString2 = "r_usr,w_usr,w_sub"
		let wrongString3 = "rw_usr,w_usr,w_sub"
		let wrongString4 = "Hello, world!"

		// when
		var expectedFailures = 0
		[wrongString1, wrongString2, wrongString3, wrongString4].forEach {
			do {
				_ = try Scopes.fromString($0)
			} catch {
				expectedFailures += 1
			}
		}

		// then
		XCTAssertEqual(expectedFailures, 4)
	}
}
