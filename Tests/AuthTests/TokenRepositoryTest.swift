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

// MARK: - BlockingTokenService

private final class BlockingTokenService: TokenService {
	private(set) var refreshCalls = 0
	private var continuation: CheckedContinuation<RefreshResponse, Error>?
	private let response: RefreshResponse
	private let onRefreshStarted: () -> Void

	init(
		response: RefreshResponse = RefreshResponse(
			accessToken: "accessToken",
			clientName: "clientName",
			expiresIn: 5000,
			tokenType: "tokenType",
			scopesString: "",
			userId: 123
		),
		onRefreshStarted: @escaping () -> Void = {}
	) {
		self.response = response
		self.onRefreshStarted = onRefreshStarted
	}

	func getTokenFromRefreshToken(
		clientId: String,
		refreshToken: String,
		grantType: String,
		scope: String
	) async throws -> RefreshResponse {
		refreshCalls += 1
		onRefreshStarted()
		return try await withCheckedThrowingContinuation { continuation in
			self.continuation = continuation
		}
	}

	func resumeRefresh() {
		continuation?.resume(returning: response)
		continuation = nil
	}

	func getTokenFromClientSecret(
		clientId: String,
		clientSecret: String?,
		grantType: String,
		scope: String
	) async throws -> RefreshResponse {
		fatalError("Not implemented")
	}

	func upgradeToken(
		refreshToken: String,
		clientUniqueKey: String?,
		clientId: String,
		clientSecret: String?,
		scopes: String,
		grantType: String
	) async throws -> UpgradeResponse {
		fatalError("Not implemented")
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
		tokenService: TokenService,
		tokensStore: FakeTokensStore? = nil,
		defaultBackoffPolicy: RetryPolicy? = nil,
		upgradeBackoffPolicy: RetryPolicy? = nil
	) throws {
		fakeTokenService = tokenService as? FakeTokenService
		fakeTokensStore = tokensStore ?? FakeTokensStore(credentialsKey: authConfig!.credentialsKey)
		tokenRepository = TokenRepository(
			authConfig: authConfig,
			tokensStore: fakeTokensStore,
			tokenService: tokenService,
			defaultBackoffPolicy: defaultBackoffPolicy ?? MockDefaultRetryPolicy(),
			upgradeBackoffPolicy: upgradeBackoffPolicy ?? MockUpgradeRetryPolicy(),
			logger: nil
		)
	}

	private func createAuthConfig(
		clientId: String? = nil,
		clientUniqueKey: String? = nil,
		scopes: Set<String> = .init(),
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
		scopes: Set<String> = .init(),
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
			grantedScopes: .init(),
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
		case let .success(returnedCredentials):
			// When refresh fails with a server error (5xx), return the stored credentials
			// to allow the app to continue and retry on the next API call
			XCTAssertEqual(returnedCredentials, credentials, "Should return the stored credentials when refresh fails with server error")
		case .failure:
			XCTFail("Should return stored credentials instead of failing when backend has server error")
		}
	}

	func testGetAccessTokenReturnsStoredCredentialsOnNetworkFailure() async throws {
		// given
		let credentials = makeCredentials(isExpired: true, userId: "valid")
		let tokens = Tokens(credentials: credentials, refreshToken: "refreshToken")

		// Simulate a pure network/connectivity error (non-HTTP), which maps to NetworkError
		let service = FakeTokenService(throwableToThrow: NetworkError(code: "1"))

		createAuthConfig()
		try createTokenRepository(tokenService: service)
		try fakeTokensStore.saveTokens(tokens: tokens)

		// when
		let result = try await tokenRepository.getCredentials(apiErrorSubStatus: nil)

		// then: no retries on pure network error path
		XCTAssertEqual(
			fakeTokenService.calls.filter { $0 == .refresh }.count,
			1,
			"On network errors, refresh should not be retried by default policy"
		)

		switch result {
		case let .success(returnedCredentials):
			// On network/connectivity errors, return stored credentials to avoid forced logout
			XCTAssertEqual(returnedCredentials, credentials, "Should return stored credentials on network errors")
		case .failure:
			XCTFail("Should return stored credentials instead of failing on network errors")
		}
	}

	func testGetAccessTokenFailsOnBackend400WithoutAuthSubstatus() async throws {
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

		// Should not downgrade/logout; expect a failure without altering stored tokens
		XCTAssertTrue(result.isFailure, "400 without auth substatus should not cause logout but fail the call")
		XCTAssertEqual(fakeTokensStore.last?.credentials, credentials, "Stored credentials should remain unchanged")
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

	func testConcurrentRefreshCallsAreCoalesced() async throws {
		// given: expired token with refreshToken present
		let credentials = makeCredentials(isExpired: true, userId: "valid")
		let tokens = Tokens(credentials: credentials, refreshToken: "refreshToken")

		createAuthConfig()
		try createTokenRepository(tokenService: FakeTokenService())
		try fakeTokensStore.saveTokens(tokens: tokens)

		// when: fire two concurrent getCredentials calls
		async let r1 = tokenRepository.getCredentials(apiErrorSubStatus: nil)
		async let r2 = tokenRepository.getCredentials(apiErrorSubStatus: nil)
		let result1 = try await r1
		let result2 = try await r2

		// then: only one refresh call should be performed
		XCTAssertEqual(
			fakeTokenService.calls.filter { $0 == .refresh }.count,
			1,
			"Concurrent refresh calls must be coalesced into a single network request"
		)

		XCTAssertEqual(result1.successData?.token, "accessToken")
		XCTAssertEqual(result2.successData?.token, "accessToken")
	}

	func testCancellingCallerDoesNotCancelSharedRefreshTask() async throws {
		// given: expired token with refreshToken present and a blocking token service
		let credentials = makeCredentials(isExpired: true, userId: "valid")
		let tokens = Tokens(credentials: credentials, refreshToken: "refreshToken")
		let refreshStarted = expectation(description: "Refresh call started")

		createAuthConfig()
		let blockingService = BlockingTokenService {
			refreshStarted.fulfill()
		}
		try createTokenRepository(tokenService: blockingService)
		try fakeTokensStore.saveTokens(tokens: tokens)

		// when: trigger first refresh and wait until network call begins
		let firstTask = Task {
			try await tokenRepository.getCredentials(apiErrorSubStatus: nil)
		}

		await fulfillment(of: [refreshStarted], timeout: 1)
		firstTask.cancel()

		async let secondResult = tokenRepository.getCredentials(apiErrorSubStatus: nil)
		await Task.yield()

		blockingService.resumeRefresh()

		let result2 = try await secondResult
		let firstResult = await firstTask.result

		// then: shared refresh continues and only one refresh call is performed
		XCTAssertEqual(blockingService.refreshCalls, 1, "The coalesced refresh should run only once")
		switch firstResult {
		case .failure(let error):
			XCTAssertTrue(error is CancellationError, "Unexpected error type: \(error)")
		case .success:
			break
		}

		XCTAssertEqual(result2.successData?.token, "accessToken")
	}

	func testRefreshOperationsWithDifferentCredentialsKeysRunConcurrently() async throws {
		// given: two separate TokenRepository instances with different credentialsKeys
		let credentials1 = makeCredentials(isExpired: true, userId: "user1")
		let tokens1 = Tokens(credentials: credentials1, refreshToken: "refreshToken1")

		let credentials2 = makeCredentials(isExpired: true, userId: "user2")
		let tokens2 = Tokens(credentials: credentials2, refreshToken: "refreshToken2")

		// Create first repository with credentialsKey "key1"
		let authConfig1 = AuthConfig(
			clientId: testClientId,
			clientUniqueKey: testClientUniqueKey,
			clientSecret: nil,
			credentialsKey: "key1",
			scopes: .init(),
			enableCertificatePinning: false
		)
		let tokensStore1 = FakeTokensStore(credentialsKey: "key1")
		let tokenService1 = FakeTokenService()
		let tokenRepository1 = TokenRepository(
			authConfig: authConfig1,
			tokensStore: tokensStore1,
			tokenService: tokenService1,
			defaultBackoffPolicy: MockDefaultRetryPolicy(),
			upgradeBackoffPolicy: MockUpgradeRetryPolicy(),
			logger: nil
		)
		try tokensStore1.saveTokens(tokens: tokens1)

		// Create second repository with credentialsKey "key2"
		let authConfig2 = AuthConfig(
			clientId: testClientId,
			clientUniqueKey: testClientUniqueKey,
			clientSecret: nil,
			credentialsKey: "key2",
			scopes: .init(),
			enableCertificatePinning: false
		)
		let tokensStore2 = FakeTokensStore(credentialsKey: "key2")
		let tokenService2 = FakeTokenService()
		let tokenRepository2 = TokenRepository(
			authConfig: authConfig2,
			tokensStore: tokensStore2,
			tokenService: tokenService2,
			defaultBackoffPolicy: MockDefaultRetryPolicy(),
			upgradeBackoffPolicy: MockUpgradeRetryPolicy(),
			logger: nil
		)
		try tokensStore2.saveTokens(tokens: tokens2)

		// when: fire concurrent getCredentials calls for both repositories
		async let result1 = tokenRepository1.getCredentials(apiErrorSubStatus: nil)
		async let result2 = tokenRepository2.getCredentials(apiErrorSubStatus: nil)

		let r1 = try await result1
		let r2 = try await result2

		// then: both refresh calls should succeed with separate token service calls
		// (not coalesced because they have different credentialsKeys)
		XCTAssertEqual(
			tokenService1.calls.filter { $0 == .refresh }.count,
			1,
			"First repository should perform its own refresh call"
		)
		XCTAssertEqual(
			tokenService2.calls.filter { $0 == .refresh }.count,
			1,
			"Second repository should perform its own refresh call independently"
		)

		XCTAssertEqual(r1.successData?.token, "accessToken")
		XCTAssertEqual(r2.successData?.token, "accessToken")
	}

	func testGetAccessTokenReturnsStoredCredentialsOnRedirect302() async throws {
		// given
		let credentials = makeCredentials(isExpired: true, userId: "valid")
		let tokens = Tokens(credentials: credentials, refreshToken: "refreshToken")

		let service = FakeTokenService(throwableToThrow: NetworkError(code: "302"))

		createAuthConfig()
		try createTokenRepository(tokenService: service)
		try fakeTokensStore.saveTokens(tokens: tokens)

		// when
		let result = try await tokenRepository.getCredentials(apiErrorSubStatus: nil)

		// then: 3xx should be treated as network/connectivity class (transient) and return stored creds
		switch result {
		case let .success(returnedCredentials):
			XCTAssertEqual(returnedCredentials, credentials, "Should return stored credentials on 3xx redirects")
		case .failure:
			XCTFail("Should return stored credentials instead of failing on 3xx redirects")
		}
	}

	func testGetAccessTokenDoesNotLogoutOnRateLimit429() async throws {
		// given
		let credentials = makeCredentials(isExpired: true, userId: "valid")
		let tokens = Tokens(credentials: credentials, refreshToken: "refreshToken")

		let service = FakeTokenService(throwableToThrow: NetworkError(code: "429"))

		createAuthConfig()
		try createTokenRepository(tokenService: service)
		try fakeTokensStore.saveTokens(tokens: tokens)

		// when
		let result = try await tokenRepository.getCredentials(apiErrorSubStatus: nil)

		// then: should not downgrade/logout; expect failure and unchanged stored creds
		XCTAssertTrue(result.isFailure, "429 should fail without causing logout")
		XCTAssertEqual(fakeTokensStore.last?.credentials, credentials, "Stored credentials should remain unchanged on 429")
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
