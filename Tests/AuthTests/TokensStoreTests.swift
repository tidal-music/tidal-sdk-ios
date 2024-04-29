@testable import Auth
import KeychainAccess
import XCTest

final class TokensStoreTests: XCTestCase {
	override func setUp() async throws {
		let testStorage = Keychain(service: "test_tidal_auth_prefs")
		try testStorage.removeAll()
	}

	func testDefaultTokensStore() throws {
		var store = DefaultTokensStore(credentialsKey: "test")
		XCTAssertNil(try store.getLatestTokens())

		let credentials = try Tokens(
			credentials: Credentials(
				clientId: "TIDAL",
				requestedScopes: Scopes(scopes: ["r_klogi"]),
				clientUniqueKey: "42",
				grantedScopes: Scopes(scopes: ["w_klogi"]),
				userId: "279808",
				expires: nil,
				token: "abc"
			),
			refreshToken: "xyz"
		)
		try store.saveTokens(tokens: credentials)
		XCTAssertEqual(try store.getLatestTokens(), credentials)
		store = DefaultTokensStore(credentialsKey: "test2")
		XCTAssertNil(try store.getLatestTokens())
	}

	func testLatestTokensAreNilAfterErasing() throws {
		var store = DefaultTokensStore(credentialsKey: "test")
		let credentials = try Tokens(
			credentials: Credentials(
				clientId: "TIDAL",
				requestedScopes: Scopes(scopes: ["r_klogi"]),
				clientUniqueKey: "42",
				grantedScopes: Scopes(scopes: ["w_klogi"]),
				userId: "279808",
				expires: nil,
				token: "abc"
			),
			refreshToken: "xyz"
		)
		try store.saveTokens(tokens: credentials)
		XCTAssertEqual(try store.getLatestTokens(), credentials)

		try store.eraseTokens()
		XCTAssertNil(try store.getLatestTokens())
	}
}
