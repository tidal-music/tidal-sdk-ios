@testable import Auth
@testable import Common
import XCTest

// MARK: - FailingFakeTokensStore

private final class FailingFakeTokensStore: TokensStore {
	enum FailureMode {
		case none
		case load
		case save
	}

	var mode: FailureMode = .none
	var saves = 0
	var loads = 0
	var tokensList = [Tokens]()
	let credentialsKey: String

	init(credentialsKey: String, mode: FailureMode) {
		self.credentialsKey = credentialsKey
		self.mode = mode
	}

	func getLatestTokens() throws -> Tokens? {
		loads += 1
		if mode == .load {
			throw NSError(domain: "FailingFakeTokensStore", code: 1001)
		}
		return tokensList.last
	}

	func saveTokens(tokens: Tokens) throws {
		saves += 1
		if mode == .save {
			throw NSError(domain: "FailingFakeTokensStore", code: 1002)
		}
		tokensList.append(tokens)
	}

	func eraseTokens() throws {
		tokensList.removeAll()
	}
}

// MARK: - BlockingFailingTokenService

private final class BlockingFailingTokenService: TokenService {
	private(set) var refreshCalls = 0
	private var continuation: CheckedContinuation<RefreshResponse, Error>?
	private let error: Error
	private let onRefreshStarted: () -> Void

	init(error: Error, onRefreshStarted: @escaping () -> Void) {
		self.error = error
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
		continuation?.resume(throwing: error)
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

// MARK: - PassthroughRefreshCoordinator

private struct PassthroughRefreshCoordinator: RefreshCoalescing {
	func runOrJoinCredentials(
		key: String,
		requiresRefresh: Bool,
		operation: @Sendable @escaping () async throws -> AuthResult<Credentials>
	) async throws -> AuthResult<Credentials> {
		try await operation()
	}

	func upgradeRefreshIntent(for key: String) async {}
}

// MARK: - TokenRepositoryResilienceTests

final class TokenRepositoryResilienceTests: XCTestCase {
	private let testClientId = "12345"
	private let testClientUniqueKey = "testUniqueKey"

	private var authConfig: AuthConfig!

	/// Tiny retry policy to keep tests fast and deterministic
	private struct TinyRetryPolicy: RetryPolicy {
		var numberOfRetries: Int { 0 }
		var delayMillis: Int { 1 }
		var delayFactor: Int { 1 }
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
			credentialsKey: "edgecases.credentialsKey",
			scopes: scopes,
			enableCertificatePinning: false
		)
	}

	private func makeCredentials(isExpired: Bool, userId: String? = "userId", token: String = "token") -> Credentials {
		let expiry = isExpired
			? Date().addingTimeInterval(TimeInterval(-5 * 60))
			: Date().addingTimeInterval(TimeInterval(5 * 60))
		return .init(
			clientId: testClientId,
			requestedScopes: .init(),
			clientUniqueKey: testClientUniqueKey,
			grantedScopes: .init(),
			userId: userId,
			expires: expiry,
			token: token
		)
	}

	func testRateLimit429_NoLogout_NoDowngrade_WhenNoStoredTokens() async throws {
		// given
		createAuthConfig(secret: "secret")
		let tokensStore = FailingFakeTokensStore(credentialsKey: authConfig.credentialsKey, mode: .none)
		let service = FakeTokenService(throwableToThrow: NetworkError(code: "429"))
		let tokenRepo = TokenRepository(
			authConfig: authConfig,
			tokensStore: tokensStore,
			tokenService: service,
			defaultBackoffPolicy: TinyRetryPolicy(),
			upgradeBackoffPolicy: UpgradeTokenRetryPolicy(),
			logger: nil
		)

		// when
		let result = try await tokenRepo.getCredentials(apiErrorSubStatus: nil)

		// then: no logout/downgrade applies because no user credentials are stored
		XCTAssertTrue(result.isFailure, "429 should surface as a failure")
		XCTAssertNil(tokensStore.tokensList.last)
		XCTAssertEqual(service.calls.filter { $0 == .secret }.count, 1)
	}

	func testConcurrent_5xx_Coalesced_NoDowngrade() async throws {
		// given: expired token present
		createAuthConfig()
		let stored = Tokens(credentials: makeCredentials(isExpired: true), refreshToken: "rt")
		let tokensStore = FailingFakeTokensStore(credentialsKey: authConfig.credentialsKey, mode: .none)
		try tokensStore.saveTokens(tokens: stored)

		let refreshStarted = expectation(description: "Refresh call started")
		let service = BlockingFailingTokenService(error: NetworkError(code: "503")) {
			refreshStarted.fulfill()
		}
		let tokenRepo = TokenRepository(
			authConfig: authConfig,
			tokensStore: tokensStore,
			tokenService: service,
			defaultBackoffPolicy: TinyRetryPolicy(),
			upgradeBackoffPolicy: UpgradeTokenRetryPolicy(),
			logger: nil
		)

		let firstTask = Task {
			try await tokenRepo.getCredentials(apiErrorSubStatus: nil)
		}
		await fulfillment(of: [refreshStarted], timeout: 1)

		async let secondResult = tokenRepo.getCredentials(apiErrorSubStatus: nil)
		await Task.yield()
		service.resumeRefresh()

		let result1 = try await firstTask.value
		let result2 = try await secondResult

		XCTAssertEqual(service.refreshCalls, 1, "Coalescing should ensure a single refresh operation")
		XCTAssertEqual(result1.successData, stored.credentials)
		XCTAssertEqual(result2.successData, stored.credentials)
	}

	func testLoadTokensFailure_CurrentlyThrows() async throws {
		// given
		createAuthConfig()
		let tokensStore = FailingFakeTokensStore(credentialsKey: authConfig.credentialsKey, mode: .load)
		let tokenRepo = TokenRepository(
			authConfig: authConfig,
			tokensStore: tokensStore,
			tokenService: FakeTokenService(),
			defaultBackoffPolicy: TinyRetryPolicy(),
			upgradeBackoffPolicy: UpgradeTokenRetryPolicy(),
			logger: nil
		)

		// when/then: currently throws
		do {
			_ = try await tokenRepo.getCredentials(apiErrorSubStatus: nil)
			XCTFail("Expected throw on load failure")
		} catch {
			// ok
		}
	}

	func testSaveTokensFailure_CurrentlyThrows() async throws {
		// given: expired token present, refresh succeeds but save fails
		createAuthConfig()
		let tokensStore = FailingFakeTokensStore(credentialsKey: authConfig.credentialsKey, mode: .none)
		try tokensStore.saveTokens(tokens: Tokens(credentials: makeCredentials(isExpired: true), refreshToken: "rt"))
		tokensStore.mode = .save
		let tokenRepo = TokenRepository(
			authConfig: authConfig,
			tokensStore: tokensStore,
			tokenService: FakeTokenService(),
			defaultBackoffPolicy: TinyRetryPolicy(),
			upgradeBackoffPolicy: UpgradeTokenRetryPolicy(),
			logger: nil
		)

		// when/then: currently throws on save
		do {
			_ = try await tokenRepo.getCredentials(apiErrorSubStatus: nil)
			XCTFail("Expected throw on save failure")
		} catch {
			// ok
		}
	}

	func testRepeatedTransientFailure_RefreshesAgainWithoutCooldown() async throws {
		createAuthConfig()
		let tokensStore = FailingFakeTokensStore(credentialsKey: authConfig.credentialsKey, mode: .none)
		try tokensStore.saveTokens(tokens: Tokens(credentials: makeCredentials(isExpired: true), refreshToken: "rt"))
		let service = FakeTokenService(throwableToThrow: NetworkError(code: "503"))
		let tokenRepo = TokenRepository(
			authConfig: authConfig,
			tokensStore: tokensStore,
			tokenService: service,
			defaultBackoffPolicy: TinyRetryPolicy(),
			upgradeBackoffPolicy: UpgradeTokenRetryPolicy(),
			logger: nil,
			refreshCoordinator: PassthroughRefreshCoordinator()
		)

		let result1 = try await tokenRepo.getCredentials(apiErrorSubStatus: nil)
		let result2 = try await tokenRepo.getCredentials(apiErrorSubStatus: nil)

		XCTAssertEqual(
			service.calls.filter { $0 == .refresh }.count,
			2,
			"Each independent call should retry the expired credentials"
		)
		XCTAssertNotNil(result1.successData?.userId, "First call returns stored credentials on transient error")
		XCTAssertNotNil(result2.successData?.userId, "Second call returns stored credentials on transient error")
	}
}
