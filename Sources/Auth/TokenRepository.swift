import Common
import Foundation

struct TokenRepository {
	private let GRANT_TYPE_REFRESH_TOKEN = "refresh_token"
	private let GRANT_TYPE_CLIENT_CREDENTIALS = "client_credentials"
	private let GRANT_TYPE_UPGRADE = "update_client"

	private let authConfig: AuthConfig
	private let tokensStore: TokensStore
	private let tokenService: TokenService
	private let defaultBackoffPolicy: RetryPolicy
	private let upgradeBackoffPolicy: RetryPolicy

	init(
		authConfig: AuthConfig,
		tokensStore: TokensStore,
		tokenService: TokenService,
		defaultBackoffPolicy: RetryPolicy,
		upgradeBackoffPolicy: RetryPolicy
	) {
		self.authConfig = authConfig
		self.tokensStore = tokensStore
		self.tokenService = tokenService
		self.defaultBackoffPolicy = defaultBackoffPolicy
		self.upgradeBackoffPolicy = upgradeBackoffPolicy
	}

	private var needsCredentialsUpgrade: Bool {
		guard let storedCredentials = (try? loadTokensFromStore())?.credentials else {
			return false
		}

		// level USER indicates we have a refreshToken, a precondition for this flow
		return (storedCredentials.level == .user && authConfig.clientId != storedCredentials.clientId) || false
	}

	mutating func getCredentials(apiErrorSubStatus: String?) async throws -> AuthResult<Credentials> {
		var upgradedRefreshToken: String?
		let tokens = try loadTokensFromStore()
		
		let result: AuthResult<Credentials>
		if let tokens, needsCredentialsUpgrade {
			let upgradeCredentials = try await upgradeToken(storedTokens: tokens)

			result = upgradeCredentials.map { $0.credentials }
			upgradedRefreshToken = upgradeCredentials.successData?.refreshToken
		} else {
			result = try await updateToken(storedTokens: tokens, apiErrorSubStatus: apiErrorSubStatus)
		}

		if let credentials = result.successData {
			try saveTokens(credentials: credentials, refreshToken: upgradedRefreshToken, storedTokens: tokens)
		}

		return result
	}

	private func updateToken(storedTokens: Tokens?, apiErrorSubStatus: String?) async throws -> AuthResult<Credentials> {
		// if our current token isn't expired, we can return it and be done
		if let credentials = storedTokens?.credentials, !credentials.isExpired, apiErrorSubStatus?.shouldRefreshToken != true {
			return .success(credentials)
		}

		// if a refreshToken is available, we'll use it
		if let refreshToken = storedTokens?.refreshToken {
			return await refreshCredentials { await refreshUserAccessToken(refreshToken: refreshToken) }
		}

		// if nothing is stored, we will try and refresh using a client secret
		if let clientSecret = authConfig.clientSecret {
			return await refreshCredentials { await getClientAccessToken(clientSecret: clientSecret) }
		}

		authConfig.logger?.log(AuthLoggable.authLogout(reason: "no refresh token or client secret available"))
		return logout()
	}

	private func upgradeToken(storedTokens: Tokens) async throws -> AuthResult<Tokens> {
		let result = await retryWithPolicy(upgradeBackoffPolicy) {
			guard let refreshToken = storedTokens.refreshToken,
			      let clientUniqueKey = authConfig.clientUniqueKey
			else {
				fatalError("refreshToken & clientUniqueKey must be initialized")
			}

			return try await tokenService.upgradeToken(
				refreshToken: refreshToken,
				clientUniqueKey: clientUniqueKey,
				clientId: authConfig.clientId,
				clientSecret: authConfig.clientSecret,
				scopes: authConfig.scopes.toScopesString(),
				grantType: GRANT_TYPE_UPGRADE
			)
		}.map { successData in
			let credentials = Credentials(
				authConfig: authConfig,
				userId: successData.userId.map { "\($0)" },
				expiresIn: successData.expiresIn,
				token: successData.accessToken
			)
			
			return Tokens(
				credentials: credentials,
				refreshToken: successData.refreshToken
			)
		}.mapError { error in
			return RetryableError(code: "1", throwable: error) as TidalError
		}
		
		switch result {
		case .success(let tokens):
			if tokens.credentials.token == nil {
				authConfig.logger?.log(AuthLoggable.getCredentialsUpgradeTokenNoTokenInResponse)
			}
		case .failure(let error):
			authConfig.logger?.log(AuthLoggable.getCredentialsUpgradeTokenNetworkError(error: error))
		}
		
		return result
	}

	private func logout() -> AuthResult<Credentials> {
		.success(Credentials(
			authConfig: authConfig,
			grantedScopes: .init(),
			userId: nil,
			expiresIn: 0,
			token: nil
		))
	}

	private func refreshCredentials(apiCall: () async -> AuthResult<RefreshResponse>) async -> AuthResult<Credentials> {
		let result = await apiCall()
		switch result {
		case let .success(data):
			let credentials = Credentials(authConfig: authConfig, response: data)
			return .success(credentials)
		case let .failure(message):
			var refreshResult: AuthResult<Credentials> = .failure(message)
			if let errorCode = (message as? UnexpectedError)?.code, let code = Int(errorCode) {
				if code <= HTTP_UNAUTHORIZED {
					// if code 400, 401, the user is effectively logged out
					// and we return a lower level token
					refreshResult = .success(Credentials(authConfig: authConfig))
				}
			}

			return refreshResult
		}
	}

	mutating func saveTokens(
		credentials: Credentials,
		refreshToken: String? = nil,
		storedTokens: Tokens? = nil
	) throws {
		guard credentials != storedTokens?.credentials else {
			return
		}
		let tokensToSave = Tokens(
			credentials: credentials,
			refreshToken: refreshToken ?? storedTokens?.refreshToken
		)
		try tokensStore.saveTokens(tokens: tokensToSave)
	}

	private func loadTokensFromStore() throws -> Tokens? {
		try tokensStore.getLatestTokens()
	}

	private func refreshUserAccessToken(refreshToken: String) async -> AuthResult<RefreshResponse> {
		await retryWithPolicy(defaultBackoffPolicy) {
			try await tokenService.getTokenFromRefreshToken(
				clientId: authConfig.clientId,
				refreshToken: refreshToken,
				grantType: GRANT_TYPE_REFRESH_TOKEN,
				scope: authConfig.scopes.toScopesString()
			)
		}
	}

	private func getClientAccessToken(clientSecret: String) async -> AuthResult<RefreshResponse> {
		await retryWithPolicy(defaultBackoffPolicy) {
			try await tokenService.getTokenFromClientSecret(
				clientId: authConfig.clientId,
				clientSecret: clientSecret,
				grantType: GRANT_TYPE_CLIENT_CREDENTIALS,
				scope: authConfig.scopes.toScopesString()
			)
		}
	}
}
