import Common
import Foundation

// MARK: - TidalAuth

public class TidalAuth: Auth & CredentialsProvider {
	public static let shared = TidalAuth()

	private var loginRepository: LoginRepository!
	private var tokenRepository: TokenRepository!
	private(set) var config: AuthConfig?

	public func config(
		config: AuthConfig
	) {
		self.config = config

		let tokensStore = DefaultTokensStore(credentialsKey: config.credentialsKey, credentialsAccessGroup: config.credentialsAccessGroup)

		let authLogger: TidalLogger?
		if config.enableLogging {
			authLogger = TidalLogger(label: "Auth", level: .trace)
		} else {
			authLogger = nil
		}
		loginRepository = provideLoginRepository(config, tokensStore: tokensStore, logger: authLogger)
		tokenRepository = provideTokenRepository(config, tokensStore: tokensStore, logger: authLogger)
	}
	
	private func provideLoginRepository(_ config: AuthConfig, tokensStore: TokensStore, logger: TidalLogger?) -> LoginRepository {
		LoginRepository(
			authConfig: config,
			tokensStore: tokensStore,
			loginUriBuilder: LoginUriBuilder(
				clientId: config.clientId,
				clientUniqueKey: config.clientUniqueKey,
				loginBaseUrl: config.tidalLoginServiceBaseUri,
				scopes: config.scopes
			),
			loginService: DefaultLoginService(authBaseUrl: config.tidalAuthServiceBaseUri),
			logger: logger
		)
	}

	private func provideTokenRepository(_ config: AuthConfig, tokensStore: TokensStore, logger: TidalLogger?) -> TokenRepository {
		TokenRepository(
			authConfig: config,
			tokensStore: tokensStore,
			tokenService: DefaultTokenService(authBaseUrl: config.tidalAuthServiceBaseUri),
			defaultBackoffPolicy: DefaultRetryPolicy(),
			upgradeBackoffPolicy: DefaultRetryPolicy(), 
			logger: logger
		)
	}

	public var isUserLoggedIn: Bool {
		loginRepository.isLoggedIn
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
