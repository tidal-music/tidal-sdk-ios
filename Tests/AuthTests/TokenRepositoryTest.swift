@testable import Auth
@testable import Common
import XCTest

// MARK: - MockDefaultRetryPolicy

private struct MockDefaultRetryPolicy: RetryPolicy {
	var numberOfRetries: Int { 1 }
	var delayMillis: Int { 1 }
	var delayFactor: Int { 1 }
}

// MARK: - MockUpgradeRetryPolicy

private struct MockUpgradeRetryPolicy: RetryPolicy {
	var numberOfRetries: Int { 1 }
	var delayMillis: Int { 1 }
	var delayFactor: Int { 1 }

	func shouldRetryOnException(throwable: Error) -> Bool {
		true
	}
}

// MARK: - TokenRepositoryTest

// swiftlint:disable type_body_length
// swiftlint:disable file_length
final class TokenRepositoryTest: XCTestCase {
	private let testClientId = "12345"
	private let testClientUniqueKey = "testUniqueKey"

	private var authConfig: AuthConfig!
	private var fakeTokensStore: FakeTokensStore!
	private var fakeTokenService: FakeTokenService!
	private var tokenRepository: TokenRepository!

	private func createTokenRepository(
		tokenService: FakeTokenService,
		tokensStore: FakeTokensStore? = nil,
		defaultBackoffPolicy: RetryPolicy? = nil,
		upgradeBackoffPolicy: RetryPolicy? = nil
	) throws {
		fakeTokenService = tokenService
		fakeTokensStore = tokensStore ?? FakeTokensStore(credentialsKey: authConfig!.credentialsKey)
		tokenRepository = TokenRepository(
			authConfig: authConfig,
			tokensStore: fakeTokensStore,
			tokenService: tokenService,
			defaultBackoffPolicy: defaultBackoffPolicy ?? MockDefaultRetryPolicy(),
			upgradeBackoffPolicy: upgradeBackoffPolicy ?? MockUpgradeRetryPolicy()
		)
	}

	private func createAuthConfig(
		clientId: String? = nil,
		clientUniqueKey: String? = nil,
		scopes: Scopes = Scopes(),
		secret: String? = nil
	) {
		authConfig = AuthConfig(
			clientId: clientId ?? testClientId,
			clientUniqueKey: clientUniqueKey ?? testClientUniqueKey,
			clientSecret: secret,
			credentialsKey: "credentialsKey",
			scopes: scopes,
			enableCertificatePinning: false
		)
	}

	private func makeCredentials(
		clientId: String? = nil,
		clientUniqueKey: String? = nil,
		scopes: Scopes = Scopes(),
		isExpired: Bool,
		userId: String? = "userId",
		token: String = "token"
	) -> Credentials {
		let expiry = isExpired ? Date().addingTimeInterval(TimeInterval(-5 * 60)) : Date()
			.addingTimeInterval(TimeInterval(5 * 60))
		return .init(
			clientId: clientId ?? testClientId,
			requestedScopes: scopes,
			clientUniqueKey: clientUniqueKey ?? testClientUniqueKey,
			grantedScopes: Scopes(),
			userId: userId,
			expires: expiry,
			token: token
		)
	}

	func testGetAccessTokenReturnsStoredTokenIfNotExpired() async throws {
		let credentials = makeCredentials(isExpired: false, userId: "valid")
		let tokens = Tokens(credentials: credentials, refreshToken: "refreshToken")

		createAuthConfig()
		try createTokenRepository(tokenService: FakeTokenService())
		try fakeTokensStore.saveTokens(tokens: tokens)

		// when
		let result = try await tokenRepository.getCredentials(apiErrorSubStatus: nil)

		// then

		XCTAssertEqual(fakeTokensStore.loads, 2, "There should have been two calls to the TokensStore")
		XCTAssertEqual(
			result.successData,
			tokens.credentials,
			"Returned AccessToken should be the same that was last stored via Tokens"
		)
	}

	func testGetAccessTokenReturnsAccessTokenWithoutTokenIfCalledWhenLoggedOutAndNoClientSecretSet() async throws {
		// given
		createAuthConfig()
		try createTokenRepository(tokenService: FakeTokenService())

		// when
		let result = try await tokenRepository.getCredentials(apiErrorSubStatus: nil)

		// then
		XCTAssertNil(
			result.successData?.token,
			"If logged out, calling getCredentials() should return an AccessToken with token = null"
		)
	}

	func testGetAccessTokenGetsNewOneFromBackendAndReturnsItIfStoredTokenExpired() async throws {
		// given
		let credentials = makeCredentials(isExpired: true, userId: "invalid")
		let tokens = Tokens(credentials: credentials, refreshToken: "refreshToken")

		createAuthConfig()
		try createTokenRepository(tokenService: FakeTokenService())
		try fakeTokensStore.saveTokens(tokens: tokens)

		// when
		let result = try await tokenRepository.getCredentials(apiErrorSubStatus: nil)

		// then
		XCTAssertTrue(
			fakeTokenService.calls.contains(where: { $0 == .refresh }),
			"If the stored token is about to expire, a call to TokenService should be made"
		)

		XCTAssertFalse(result.successData!.isExpired, "The returned token should be the one retrieved from the service")
	}

	func testGetAccessTokenReturnsRetryableErrorIfRefreshingFails() async throws {
		// given
		let credentials = makeCredentials(isExpired: true, userId: "valid")
		let tokens = Tokens(credentials: credentials, refreshToken: "refreshToken")

		let service = FakeTokenService(throwableToThrow: NetworkError(code: "503"))
		let defaultRetryPolicy = MockDefaultRetryPolicy()
		let expectedCalls = defaultRetryPolicy.numberOfRetries + 1

		createAuthConfig()
		try createTokenRepository(tokenService: service, defaultBackoffPolicy: defaultRetryPolicy)
		try fakeTokensStore.saveTokens(tokens: tokens)

		// when
		let result = try await tokenRepository.getCredentials(apiErrorSubStatus: nil)

		// then
		XCTAssertEqual(
			fakeTokenService.calls.filter { $0 == .refresh }.count,
			expectedCalls,
			"If the stored token is invalid, the correct number of call attempts to TokenService should be made"
		)

		switch result {
		case .success:
			XCTFail("The returned token should be the one retrieved from the service")
		case let .failure(error):
			XCTAssertTrue(result.isFailure, "The returned token should be the one retrieved from the service")
			XCTAssertTrue(error is RetryableError, "If the backend call fails, a RetryableError should be returned")
		}
	}

	func testGetAccessTokenReturnsLowerlevelTokenIfBackendFailsWith400() async throws {
		// given
		let credentials = makeCredentials(isExpired: true, userId: "valid")
		let tokens = Tokens(credentials: credentials, refreshToken: "refreshToken")

		let service = FakeTokenService(throwableToThrow: NetworkError(code: "400"))

		createAuthConfig()
		try createTokenRepository(tokenService: service)
		try fakeTokensStore.saveTokens(tokens: tokens)

		// when
		let result = try await tokenRepository.getCredentials(apiErrorSubStatus: nil)

		// then
		XCTAssertEqual(fakeTokenService.calls.filter { $0 == .refresh }.count, 1, "On 400 errors, no retries should be made")

		switch result {
		case let .success(data):
			XCTAssertNil(
				data.userId,
				"When a 400 error is received the lower privileges token should have been saved in the store"
			)
			XCTAssertEqual(fakeTokensStore.last?.credentials, data)
		case .failure:
			XCTFail("The result supposed to be successful")
		}
	}

	func testGetAccessTokenReturnsLowerlevelTokenIfBackendFailsWith401() async throws {
		// given
		let credentials = makeCredentials(isExpired: true, userId: "valid")
		let tokens = Tokens(credentials: credentials, refreshToken: "refreshToken")

		let service = FakeTokenService(throwableToThrow: NetworkError(code: "401"))

		createAuthConfig()
		try createTokenRepository(tokenService: service)
		try fakeTokensStore.saveTokens(tokens: tokens)

		// when
		let result = try await tokenRepository.getCredentials(apiErrorSubStatus: nil)

		// then
		XCTAssertEqual(fakeTokenService.calls.filter { $0 == .refresh }.count, 1, "On 401 errors, no retries should be made")

		switch result {
		case let .success(data):
			XCTAssertNil(
				data.userId,
				"When a 401 error is received the lower privileges token should have been saved in the store"
			)
			XCTAssertEqual(fakeTokensStore.last?.credentials, data)
		case .failure:
			XCTFail("The result supposed to be successful")
		}
	}

	func testGetAccessTokenStoresFreshlyRetrievedTokenInTokensStore() async throws {
		// given
		let credentials = makeCredentials(isExpired: true, userId: "valid")
		let tokens = Tokens(credentials: credentials, refreshToken: "refreshToken")

		createAuthConfig()
		try createTokenRepository(tokenService: FakeTokenService())
		try fakeTokensStore.saveTokens(tokens: tokens)

		// when
		_ = try await tokenRepository.getCredentials(apiErrorSubStatus: nil)

		// then
		XCTAssertEqual(fakeTokensStore.saves, 2, "The freshly retrieved token should have benn saved")
	}

	func testWhenNoRefreshTokenIsPresentAndAccessTokenIsExpiredGetAccessTokenGetsTokenUsingClientSecretWhenPresent() async throws {
		// given
		let credentials = makeCredentials(isExpired: true, userId: "valid")
		let tokens = Tokens(credentials: credentials, refreshToken: nil)
		let secret = "myLittleSecret"
		createAuthConfig(secret: secret)
		try createTokenRepository(tokenService: FakeTokenService())
		try fakeTokensStore.saveTokens(tokens: tokens)

		// when
		_ = try await tokenRepository.getCredentials(apiErrorSubStatus: nil)
		let result = fakeTokensStore.last

		// then
		XCTAssertTrue(
			fakeTokenService.calls.contains(where: { $0 == .secret }),
			"If the stored token is expired, a call to TokenService.getTokenFromClientSecret should be made"
		)

		XCTAssertEqual(fakeTokensStore.saves, 2, "If a new token is retrieved, it is stored")

		XCTAssertNil(result?.refreshToken, "Retrieved tokens should have no refreshToken")
	}

	func testGetAccessTokenReturnsClientAccessTokenWhenSecretAvailableButNoTokensStored() async throws {
		// given
		let secret = "myLittleSecret"
		createAuthConfig(secret: secret)
		try createTokenRepository(tokenService: FakeTokenService())

		// when
		_ = try await tokenRepository.getCredentials(apiErrorSubStatus: nil)
		let result = fakeTokensStore.last

		// then
		XCTAssertTrue(
			fakeTokenService.calls.contains(where: { $0 == .secret }),
			"If the stored token is about to expire, a call to TokenService.getTokenFromClientSecret should be made"
		)

		XCTAssertEqual(fakeTokensStore.saves, 1, "If a new token is retrieved, it is stored")

		XCTAssertNil(result?.refreshToken, "Retrieved tokens should have no refreshToken")
	}

	func testGetAccessTokenReturnsUserAccessTokenWhenSecretAvailableButRefreshTokenPresent() async throws {
		// given
		let credentials = makeCredentials(isExpired: true, userId: "valid")
		let tokens = Tokens(credentials: credentials, refreshToken: "refreshToken is present")
		let secret = "myLittleSecret"

		createAuthConfig(secret: secret)
		try createTokenRepository(tokenService: FakeTokenService())
		try fakeTokensStore.saveTokens(tokens: tokens)

		// when
		_ = try await tokenRepository.getCredentials(apiErrorSubStatus: nil)
		let result = fakeTokensStore.last

		// then
		XCTAssertEqual(fakeTokenService.calls.count, 1, "A call to the service should have been made")
		XCTAssertEqual(fakeTokensStore.saves, 2, "If a new token is retrieved, it is stored")
		XCTAssertNotNil(result?.refreshToken, "Retrieved tokens should have a refreshToken")
	}

	func testIfRefreshTokenAvailableItStillStoreAfterRefresh() async throws {
		// given
		let credentials = makeCredentials(isExpired: true, userId: "valid")
		let refreshToken = "refreshToken is present"
		let tokens = Tokens(credentials: credentials, refreshToken: refreshToken)
		let secret = "myLittleSecret"

		createAuthConfig(secret: secret)
		try createTokenRepository(tokenService: FakeTokenService())
		try fakeTokensStore.saveTokens(tokens: tokens)

		// when
		_ = try await tokenRepository.getCredentials(apiErrorSubStatus: nil)

		// then
		XCTAssertEqual(fakeTokensStore.saves, 2, "A refreshed token should have been saved")
		XCTAssertEqual(
			fakeTokensStore.last?.refreshToken,
			refreshToken,
			"An existing refreshToken should not disappear during refresh"
		)

		// when
		_ = try await tokenRepository.getCredentials(apiErrorSubStatus: nil)

		// then
		XCTAssertEqual(fakeTokensStore.saves, 2, "No further token should have been saved since the current one is still valid")
		XCTAssertEqual(
			fakeTokensStore.last?.refreshToken,
			refreshToken,
			"An existing refreshToken should not disappear during refresh"
		)
	}

	func testOnGetAccessTokenCallUpgradeRequestIssuedIfClientIdChanged() async throws {
		// given
		let credentials = makeCredentials(isExpired: true, userId: "userId")
		let refreshToken = "refreshToken"

		let tokens = Tokens(credentials: credentials, refreshToken: refreshToken)
		let secret = "myLittleSecret"
		createAuthConfig(clientId: "someClientId", secret: secret)

		fakeTokensStore = FakeTokensStore(credentialsKey: authConfig.credentialsKey)
		try fakeTokensStore.saveTokens(tokens: tokens)

		// when
		createAuthConfig(clientId: "anotherClientId", secret: secret)
		try createTokenRepository(tokenService: FakeTokenService(), tokensStore: fakeTokensStore)
		let result = try await tokenRepository.getCredentials(apiErrorSubStatus: nil)

		// then
		XCTAssertEqual(fakeTokenService.calls.filter { $0 == .upgrade }.count, 1, "TokenService should have been called once")
		XCTAssertEqual(
			result.successData?.token,
			"upgradeAccessToken",
			"The returned result should contain the token received in the upgrade resonse"
		)

		XCTAssertEqual(
			fakeTokensStore.last?.refreshToken,
			"upgradeRefreshToken",
			"The new tokens saved in the store should contain the upgraded refreshToken"
		)
	}

	func testUpgradeTokenCallsShouldBeRetriedAccordingToUpgradePolicy() async throws {
		// given
		let credentials = makeCredentials(isExpired: true, userId: "userId")
		let refreshToken = "refreshToken"

		let tokens = Tokens(credentials: credentials, refreshToken: refreshToken)
		let secret = "myLittleSecret"

		let upgradeRetryPolicy = MockUpgradeRetryPolicy()
		let expectedRetries = upgradeRetryPolicy.numberOfRetries + 1

		createAuthConfig(clientId: "someClientId", secret: secret)

		fakeTokensStore = FakeTokensStore(credentialsKey: authConfig.credentialsKey)
		try fakeTokensStore.saveTokens(tokens: tokens)

		// when
		createAuthConfig(clientId: "anotherClientId", secret: secret)
		try createTokenRepository(
			tokenService: FakeTokenService(throwableToThrow: NetworkError(code: "503")),
			tokensStore: fakeTokensStore,
			upgradeBackoffPolicy: upgradeRetryPolicy
		)

		_ = try await tokenRepository.getCredentials(apiErrorSubStatus: nil)

		// then
		XCTAssertEqual(
			fakeTokenService.calls.filter { $0 == .upgrade }.count,
			expectedRetries,
			"TokenService should have been called \(expectedRetries) times"
		)

		// when
		fakeTokenService.calls.removeAll()
		createAuthConfig(clientId: "anotherClientId", secret: secret)
		try createTokenRepository(
			tokenService: FakeTokenService(throwableToThrow: NetworkError(code: "401")),
			tokensStore: fakeTokensStore,
			upgradeBackoffPolicy: upgradeRetryPolicy
		)
		_ = try await tokenRepository.getCredentials(apiErrorSubStatus: nil)

		// then
		XCTAssertEqual(
			fakeTokenService.calls.filter { $0 == .upgrade }.count,
			expectedRetries,
			"TokenService should have been called \(expectedRetries) times"
		)

		// when
		fakeTokenService.calls.removeAll()
		createAuthConfig(clientId: "anotherClientId", secret: secret)

		try createTokenRepository(
			tokenService: FakeTokenService(throwableToThrow: UnexpectedError(code: "999")),
			tokensStore: fakeTokensStore,
			upgradeBackoffPolicy: upgradeRetryPolicy
		)
		_ = try await tokenRepository.getCredentials(apiErrorSubStatus: nil)

		// then
		XCTAssertEqual(
			fakeTokenService.calls.filter { $0 == .upgrade }.count,
			expectedRetries,
			"TokenService should have been called \(expectedRetries) times"
		)
	}

	func testFailedUpgradeTokenCallsShouldReturnRetryableError() async throws {
		// given
		let credentials = makeCredentials(isExpired: true, userId: "valid")
		let refreshToken = "refreshToken is present"
		let tokens = Tokens(credentials: credentials, refreshToken: refreshToken)
		let secret = "myLittleSecret"

		createAuthConfig(secret: secret)
		try createTokenRepository(tokenService: FakeTokenService())
		try fakeTokensStore.saveTokens(tokens: tokens)

		// when
		createAuthConfig(clientId: "anotherClientId", secret: secret)
		try createTokenRepository(
			tokenService: FakeTokenService(throwableToThrow: NetworkError(code: "503")),
			tokensStore: fakeTokensStore
		)

		let result1 = try await tokenRepository.getCredentials(apiErrorSubStatus: nil)

		// when
		try createTokenRepository(
			tokenService: FakeTokenService(throwableToThrow: NetworkError(code: "503")),
			tokensStore: fakeTokensStore
		)
		fakeTokenService.throwableToThrow = NetworkError(code: "401")
		let result2 = try await tokenRepository.getCredentials(apiErrorSubStatus: nil)

		// when
		try createTokenRepository(
			tokenService: FakeTokenService(throwableToThrow: NetworkError(code: "503")),
			tokensStore: fakeTokensStore
		)
		fakeTokenService.throwableToThrow = NetworkError(code: "503")
		let result3 = try await tokenRepository.getCredentials(apiErrorSubStatus: nil)

		// then
		[result1, result2, result3].forEach { result in
			XCTAssertTrue(result.isFailure, "Every fauled token upgrade should result in a RetryableError")
			XCTAssertTrue(result.failureData is RetryableError, "Every fauled token upgrade should result in a RetryableError")
		}
	}
}

// swiftlint:enable type_body_length
