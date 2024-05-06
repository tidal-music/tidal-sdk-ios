import Foundation

public typealias AuthProvider = Auth & CredentialsProvider

// MARK: - Auth

public protocol Auth {
	func initializeLogin(redirectUri: String, loginConfig: LoginConfig?) -> URL?
	func finalizeLogin(loginResponseUri: String) async throws
	func initializeDeviceLogin() async throws -> DeviceAuthorizationResponse
	func finalizeDeviceLogin(deviceCode: String) async throws
	func logout() throws
	func setCredentials(_ credentials: Credentials, refreshToken: String?) throws
}

// MARK: - TidalAuth

public class TidalAuth: AuthProvider {
	public static let shared = TidalAuth()

	private var loginRepository: LoginRepository!
	private var tokenRepository: TokenRepository!
	private(set) var config: AuthConfig?

	public func config(
		config: AuthConfig
	) {
		self.config = config
		let tokensStore = DefaultTokensStore(credentialsKey: config.credentialsKey, credentialsAccessGroup: config.credentialsAccessGroup)
		loginRepository = provideLoginRepository(config, tokensStore: tokensStore)
		tokenRepository = provideTokenRepository(config, tokensStore: tokensStore)
	}

	private func provideLoginRepository(_ config: AuthConfig, tokensStore: TokensStore) -> LoginRepository {
		LoginRepository(
			authConfig: config,
			tokensStore: tokensStore,
			loginUriBuilder: LoginUriBuilder(
				clientId: config.clientId,
				clientUniqueKey: config.clientUniqueKey
			),
			loginService: DefaultLoginService()
		)
	}

	private func provideTokenRepository(_ config: AuthConfig, tokensStore: TokensStore) -> TokenRepository {
		TokenRepository(
			authConfig: config,
			tokensStore: tokensStore,
			tokenService: DefaultTokenService(),
			defaultBackoffPolicy: DefaultRetryPolicy(),
			upgradeBackoffPolicy: DefaultRetryPolicy()
		)
	}

	public var isUserLoggedIn: Bool {
		loginRepository.isLoggedIn
	}

	public var isDeviceClientLoggedIn: Bool {
		loginRepository.isDeviceClientLoggedIn
	}

	public func getCredentials(apiErrorSubStatus: String?) async throws -> Credentials {
		try await tokenRepository.getCredentials(apiErrorSubStatus: apiErrorSubStatus).get()
	}

	public func setCredentials(_ credentials: Credentials, refreshToken: String?) throws {
		try tokenRepository.saveTokens(credentials: credentials, refreshToken: refreshToken)
	}

	public func initializeLogin(redirectUri: String, loginConfig: LoginConfig?) -> URL? {
		guard let uriString = loginRepository?.getLoginUri(redirectUri: redirectUri, loginConfig: loginConfig) else {
			return nil
		}
		return URL(string: uriString)
	}

	public func finalizeLogin(loginResponseUri: String) async throws {
		_ = try await loginRepository?.getTokenFromLoginCode(uri: loginResponseUri).get()
	}

	/// Initializes a device authorization login flow by generating DeviceAuthorizationResponse
	/// and updating internal state (device code etc).
	///
	/// @return A DeviceAuthorizationResponse.
	public func initializeDeviceLogin() async throws -> DeviceAuthorizationResponse {
		guard let loginRepository else {
			fatalError("Auth.shared.config() must be called before use of the Auth module")
		}
		return try await loginRepository
			.initializeDeviceLogin()
			.get()
	}

	/// Finalizes the device login flow. Polls until either a valid access token is received,
	/// or an unrecoverable error occurs.
	///
	/// @throws TokenResponseError Operation failed due to an unrecoverable error occurring when
	/// requesting the access token.
	public func finalizeDeviceLogin(deviceCode: String) async throws {
		guard let loginRepository else {
			fatalError("Auth.shared.config() must be called before use of the Auth module")
		}
		_ = try await loginRepository.pollForDeviceLoginResponse(deviceCode: deviceCode).get()
	}

	public func explicitLogin(credentials: Credentials, refreshToken: String?) {}

	public func logout() throws {
		try loginRepository?.logout()
	}

	/// Executes a throwing closure returnig AuthResult. In case of catching an error, wraps it into TidalError
	///
	/// - parameter throwingBlock: Closure to execute. Should throw and return AuthResult
	///
	/// - returns: The same AuthResult in case of .success or .failure with TidalError after executing the closure. In case of
	/// catching an Error, returns .failure with TidalError containing catched Error inside
	private func wrapToTidalError<T>(throwingBlock: () async throws -> AuthResult<T>) async -> AuthResult<T> {
		do {
			return try await throwingBlock()
		} catch {
			return .failure(error.toTidalError)
		}
	}
}
