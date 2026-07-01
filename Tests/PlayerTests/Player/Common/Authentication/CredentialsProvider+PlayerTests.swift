import Auth
@testable import Player
import Testing

// MARK: - Constants

private enum Constants {
	static let token = "token"
	static let bearerToken = "Bearer \(token)"
}

// MARK: - CredentialsProviderPlayerTests

@Suite(.serialized)
final class CredentialsProviderPlayerTests {
	private var credentialsProvider: CredentialsProviderMock!

	init() {
		PlayerWorld = PlayerWorldClient.mock

		credentialsProvider = CredentialsProviderMock()
	}
}

extension CredentialsProviderPlayerTests {
	// MARK: - getAuthBearerToken

	@Test
	func test_getAuthBearerToken_when_getCredentialsSucceed_shouldReturnBearerToken() async throws {
		// GIVEN
		// Provide a successful token
		let credentials = Credentials.mock(userId: "userId", token: Constants.token)
		credentialsProvider.injectedAuthResult = .success(credentials)

		// WHEN
		let authBearerToken = try await credentialsProvider.getAuthBearerToken()

		// THEN
		#expect(authBearerToken == Constants.bearerToken)
	}

	@Test
	func test_getAuthBearerToken_when_getCredentialsFail_shouldThrowErrorThrownByAuth() async throws {
		// GIVEN
		// Provide a failed token
		let tidalError = TidalErrorMock(code: "0")
		credentialsProvider.injectedAuthResult = .failure(tidalError)

		do {
			// WHEN
			_ = try await credentialsProvider.getAuthBearerToken()

			Issue.record("getAuthBearerToken should have returned an error when Auth getCredential fails")
		} catch {
			// THEN
			#expect(error as? TidalErrorMock == tidalError)
		}
	}
}
