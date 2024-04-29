import Foundation

final class LoginRepository {
	private let GRANT_TYPE_AUTHORIZATION_CODE = "authorization_code"
	private let GRANT_TYPE_DEVICE_CODE = "urn:ietf:params:oauth:grant-type:device_code"

	private let authConfig: AuthConfig
	private let codeChallengeBuilder: CodeChallengeBuilder
	private let loginUriBuilder: LoginUriBuilder
	private let loginService: LoginService
	private let tokensStore: TokensStore
	private let exponentialBackoffPolicy: RetryPolicy

	private var codeVerifier: String?

	init(
		authConfig: AuthConfig,
		codeChallengeBuilder: CodeChallengeBuilder = .shared,
		tokensStore: TokensStore,
		loginUriBuilder: LoginUriBuilder,
		loginService: LoginService,
		exponentialBackoffPolicy: RetryPolicy = DefaultRetryPolicy()
	) {
		self.authConfig = authConfig
		self.codeChallengeBuilder = codeChallengeBuilder
		self.tokensStore = tokensStore
		self.loginUriBuilder = loginUriBuilder
		self.loginService = loginService
		self.exponentialBackoffPolicy = exponentialBackoffPolicy
	}

	private lazy var deviceLoginPollHelper: DeviceLoginPollHelper = DeviceLoginPollHelper(loginService: loginService)

	var isLoggedIn: Bool {
		let tokens = try? tokensStore.getLatestTokens()
		return tokens?.credentials.level == .user
	}

	var isDeviceClientLoggedIn: Bool {
		let tokens = try? tokensStore.getLatestTokens()
		return tokens?.credentials.level == .client
	}

	func getLoginUri(redirectUri: String, loginConfig: LoginConfig?) -> String? {
		let newCodeVerifier = codeChallengeBuilder.createCodeVerifier()
		codeVerifier = newCodeVerifier
		let codeChallenge = codeChallengeBuilder.createCodeChallenge(codeVerifier: newCodeVerifier)
		return loginUriBuilder.getLoginUri(
			redirectUri: redirectUri,
			loginConfig: loginConfig,
			codeChallenge: codeChallenge
		)
	}

	func getTokenFromLoginCode(uri: String) async throws -> AuthResult<LoginResponse> {
		let redirectUri = RedirectUri.fromUriString(uri: uri)
		if case let .success(url, code) = redirectUri, let codeVerifier {
			let response = await retryWithPolicy(exponentialBackoffPolicy) {
				try await loginService.getTokenWithCodeVerifier(
					code: code,
					clientId: authConfig.clientId,
					grantType: GRANT_TYPE_AUTHORIZATION_CODE,
					redirectUri: url,
					scopes: authConfig.scopes.toString(),
					codeVerifier: codeVerifier,
					clientUniqueKey: authConfig.clientUniqueKey
				)
			}

			if let successData = response.successData {
				try saveTokens(response: successData)
			}

			return response
		}

		return .failure(AuthorizationError(code: "0", message: ""))
	}

	private func saveTokens(response: LoginResponse) throws {
		let tokens = try Tokens(
			credentials: Credentials(
				clientId: authConfig.clientId,
				requestedScopes: authConfig.scopes,
				clientUniqueKey: authConfig.clientUniqueKey,
				grantedScopes: Scopes.fromString(response.scopesString),
				userId: response.userId.map { "\($0)" },
				expires: Date()
					.addingTimeInterval(TimeInterval(response.expiresIn)),
				token: response.accessToken
			),
			refreshToken: response.refreshToken
		)
		try tokensStore.saveTokens(tokens: tokens)
	}

	func logout() throws {
		try tokensStore.eraseTokens()
	}

	func initializeDeviceLogin() async throws -> AuthResult<DeviceAuthorizationResponse> {
		await retryWithPolicy(exponentialBackoffPolicy) {
			let response = try await loginService.getDeviceAuthorization(
				clientId: authConfig.clientId,
				scope: authConfig.scopes.toString()
			)
			deviceLoginPollHelper.prepareForPoll(interval: response.interval, maxDuration: response.expiresIn)
			return response
		}
	}

	func pollForDeviceLoginResponse(deviceCode: String) async throws -> AuthResult<LoginResponse> {
		let response = await deviceLoginPollHelper.poll(
			authConfig: authConfig,
			deviceCode: deviceCode,
			grantType: GRANT_TYPE_DEVICE_CODE,
			retryPolicy: exponentialBackoffPolicy
		)
		if let data = response.successData {
			try saveTokens(response: data)
		}

		return response
	}
}
