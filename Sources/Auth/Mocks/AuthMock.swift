import Common
import Foundation

public final class AuthMock: Auth {
	var setTokensData = [Tokens]()
	public var initializeDeviceLoginResult = AuthResult.success(DeviceAuthorizationResponse.mock())
	public var finalizeDeviceLoginError: Error?
	public var initializeLoginUrl: URL? = URL(string: "https://login.tidal.com/authorize")
	public var finalizeLoginError: Error?
	public var logoutError: Error?

	public var isLoggedIn: Bool = true

	public private(set) var logoutCallCount = 0

	public init() {}

	public func initializeLogin(redirectUri: String, loginConfig: LoginConfig?) -> URL? {
		initializeLoginUrl
	}

	public func finalizeLogin(loginResponseUri: String) async throws {
		if let finalizeLoginError {
			throw finalizeLoginError
		}
	}

	public func initializeDeviceLogin() async throws -> DeviceAuthorizationResponse {
		try initializeDeviceLoginResult.get()
	}

	public func finalizeDeviceLogin(deviceCode: String) async throws {
		if let finalizeDeviceLoginError {
			throw finalizeDeviceLoginError
		}
	}

	public func logout() throws {
		logoutCallCount += 1
		if let logoutError {
			throw logoutError
		}
	}

	public func setCredentials(_ credentials: Credentials, refreshToken: String?) throws {
		let tokens = Tokens(credentials: credentials, refreshToken: refreshToken)
		setTokensData.append(tokens)
	}
}
