@testable import Auth
import XCTest

final class AuthTokenTests: XCTestCase {
	func testAccessTokenWithUserIdAndTokenIsLevelUser() {
		// given
		let credentials = Credentials(
			clientId: "",
			requestedScopes: Scopes(),
			clientUniqueKey: "",
			grantedScopes: Scopes(),
			userId: "userId",
			expires: nil,
			token: "token"
		)

		// when
		let level = credentials.level

		// then
		XCTAssertEqual(level, .user, "The token should be Level.USER")
	}

	func testAccessTokenWithoutUserIdButWithTokenIsLevelClient() {
		// given
		let credentials = Credentials(
			clientId: "",
			requestedScopes: Scopes(),
			clientUniqueKey: "",
			grantedScopes: Scopes(),
			userId: nil,
			expires: nil,
			token: "token"
		)

		// when
		let level = credentials.level

		// then
		XCTAssertEqual(level, .client, "The token should be Level.CLIENT")
	}

	func testAccessTokenWithoutUserIdAndWithoutTokenIsLevelBasic() {
		// given
		let credentials = Credentials(
			clientId: "",
			requestedScopes: Scopes(),
			clientUniqueKey: "",
			grantedScopes: Scopes(),
			userId: nil,
			expires: nil,
			token: nil
		)

		// when
		let level = credentials.level

		// then
		XCTAssertEqual(level, .basic, "The token should be Level.BASIC")
	}
}
