import Auth
@testable import Player
import XCTest

// MARK: - Constants

private enum Constants {
	static let token = "token"
	static let bearerToken = "Bearer \(token)"
}

// MARK: - CredentialsProviderPlayerTests

final class CredentialsProviderPlayerTests: XCTestCase {
	private var credentialsProvider: CredentialsProviderMock!

	override func setUp() {
		super.setUp()

		PlayerWorld = PlayerWorldClient.mock

		credentialsProvider = CredentialsProviderMock()
	}
}

extension CredentialsProviderPlayerTests {
	// MARK: - getAuthBearerToken

	func test_getAuthBearerToken_when_getCredentialsSucceed_shouldReturnBearerToken() async throws {
		// GIVEN
		// Provide a successful token
		let credentials = Credentials.mock(userId: "userId", token: Constants.token)
		credentialsProvider.injectedAuthResult = .success(credentials)

		// WHEN
		let authBearerToken = try await credentialsProvider.getAuthBearerToken()

		// THEN
		XCTAssertEqual(authBearerToken, Constants.bearerToken)
	}

	func test_getAuthBearerToken_when_getCredentialsFail_shouldThrowErrorThrownByAuth() async throws {
		// GIVEN
		// Provide a failed token
		let tidalError = TidalErrorMock(code: "0")
		credentialsProvider.injectedAuthResult = .failure(tidalError)

		do {
			// WHEN
			_ = try await credentialsProvider.getAuthBearerToken()

			XCTFail("getAuthBearerToken should have returned an error when Auth getCredential fails")
		} catch {
			// THEN
			XCTAssertEqual(error as? TidalErrorMock, tidalError)
		}
	}
}
