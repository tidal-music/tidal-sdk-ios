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
        if mode == .load { throw NSError(domain: "FailingFakeTokensStore", code: 1001) }
        return tokensList.last
    }

    func saveTokens(tokens: Tokens) throws {
        saves += 1
        if mode == .save { throw NSError(domain: "FailingFakeTokensStore", code: 1002) }
        tokensList.append(tokens)
    }

    func eraseTokens() throws {
        tokensList.removeAll()
    }
}

// MARK: - SequencedFakeTokenService

private final class SequencedFakeTokenService: TokenService {
    var calls = [FakeTokenService.CallType]()
    private var refreshThrowables: [Error]

    init(refreshThrowables: [Error]) {
        self.refreshThrowables = refreshThrowables
    }

    func getTokenFromRefreshToken(
        clientId: String,
        refreshToken: String,
        grantType: String,
        scope: String
    ) async throws -> RefreshResponse {
        calls.append(.refresh)
        if !refreshThrowables.isEmpty {
            let next = refreshThrowables.removeFirst()
            throw next
        }
        return RefreshResponse(
            accessToken: "accessToken",
            clientName: "clientName",
            expiresIn: 5000,
            tokenType: "tokenType",
            scopesString: "",
            userId: 123
        )
    }

    func getTokenFromClientSecret(
        clientId: String,
        clientSecret: String?,
        grantType: String,
        scope: String
    ) async throws -> RefreshResponse {
        calls.append(.secret)
        if !refreshThrowables.isEmpty {
            let next = refreshThrowables.removeFirst()
            throw next
        }
        return RefreshResponse(
            accessToken: "accessToken",
            clientName: "clientName",
            expiresIn: 5000,
            tokenType: "tokenType",
            scopesString: "",
            userId: 123
        )
    }

    func upgradeToken(
        refreshToken: String,
        clientUniqueKey: String?,
        clientId: String,
        clientSecret: String?,
        scopes: String,
        grantType: String
    ) async throws -> UpgradeResponse {
        calls.append(.upgrade)
        return UpgradeResponse(
            accessToken: "upgradeAccessToken",
            expiresIn: 5000,
            refreshToken: "upgradeRefreshToken",
            tokenType: "Bearer",
            userId: 123
        )
    }
}

// MARK: - TokenRepositoryEdgeCasesTest

final class TokenRepositoryResilienceTests: XCTestCase {
    private let testClientId = "12345"
    private let testClientUniqueKey = "testUniqueKey"

    private var authConfig: AuthConfig!

    // Tiny retry policy to keep tests fast and deterministic
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
        createAuthConfig()
        let tokensStore = FailingFakeTokensStore(credentialsKey: authConfig.credentialsKey, mode: .none)
        let tokenRepo = TokenRepository(
            authConfig: authConfig,
            tokensStore: tokensStore,
            tokenService: FakeTokenService(throwableToThrow: NetworkError(code: "429")),
            defaultBackoffPolicy: TinyRetryPolicy(),
            upgradeBackoffPolicy: UpgradeTokenRetryPolicy(),
            logger: nil
        )

        // when
        let result = try await tokenRepo.getCredentials(apiErrorSubStatus: nil)

        // then: no logout/downgrade applies (already logged out); repository returns basic credentials
        switch result {
        case let .success(creds):
            XCTAssertNil(creds.userId)
            XCTAssertNil(tokensStore.tokensList.last?.refreshToken)
        case .failure:
            XCTFail("Expected success with basic credentials when no tokens are stored")
        }
    }

    func testConcurrent_5xx_Coalesced_NoDowngrade() async throws {
        // given: expired token present
        createAuthConfig()
        let stored = Tokens(credentials: makeCredentials(isExpired: true), refreshToken: "rt")
        let tokensStore = FailingFakeTokensStore(credentialsKey: authConfig.credentialsKey, mode: .none)
        try tokensStore.saveTokens(tokens: stored)

        // Service throws 503 repeatedly. With coalescing, only one refresh operation runs
        // and will perform the expected number of retry attempts.
        let many503 = Array(repeating: NetworkError(code: "503"), count: 10)
        let service = SequencedFakeTokenService(refreshThrowables: many503)
        let tokenRepo = TokenRepository(
            authConfig: authConfig,
            tokensStore: tokensStore,
            tokenService: service,
            defaultBackoffPolicy: TinyRetryPolicy(),
            upgradeBackoffPolicy: UpgradeTokenRetryPolicy(),
            logger: nil
        )

        // when: two concurrent requests
        async let r1 = tokenRepo.getCredentials(apiErrorSubStatus: nil)
        async let r2 = tokenRepo.getCredentials(apiErrorSubStatus: nil)
        let result1 = try await r1
        let result2 = try await r2

        // then: coalesced into a single refresh operation with retries
        let expectedRetries = TinyRetryPolicy().numberOfRetries + 1
        XCTAssertEqual(service.calls.filter { $0 == .refresh }.count, expectedRetries, "Coalescing should ensure a single refresh operation with retries")
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

    func testTransientCooldown_ImplicitViaStoredCredentials() async throws {
        // given: expired stored token; service always returns 503
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
            logger: nil
        )

        // first attempt: triggers refresh, gets 503, returns stored credentials
        let result1 = try await tokenRepo.getCredentials(apiErrorSubStatus: nil)
        let firstAttempts = service.calls.filter { $0 == .refresh }.count

        // immediate second attempt: credentials not expired and no forced refresh, returns cached
        let result2 = try await tokenRepo.getCredentials(apiErrorSubStatus: nil)
        let secondAttempts = service.calls.filter { $0 == .refresh }.count

        // then: implicit cooldown via stored credentials - no additional refresh attempts
        XCTAssertEqual(secondAttempts, firstAttempts, "Second call should return cached credentials without additional refresh attempts")
        XCTAssertNotNil(result1.successData?.userId, "First call returns stored credentials on transient error")
        XCTAssertNotNil(result2.successData?.userId, "Second call returns cached credentials")
    }
}
