import Common
import Foundation

public final class TidalAuthMock: Auth & CredentialsProvider {
	public struct CredentialData {
		public let credentials: Credentials
		public let refreshToken: String?

		public init(credentials: Credentials, refreshToken: String?) {
			self.credentials = credentials
			self.refreshToken = refreshToken
		}
	}

	public private(set) var saveCredentialData = [CredentialData]()
	public var injectedAuthResult = AuthResult.success(Credentials.mock())
	public var initializeDeviceLoginResult = AuthResult.success(DeviceAuthorizationResponse.mock())
	public var finalizeDeviceLoginError: Error?
	public var initializeLoginUrl: URL? = URL(string: "https://login.tidal.com/authorize")
	public var finalizeLoginError: Error?
	public var logoutError: Error?

	public var isUserLoggedIn: Bool = true

	public private(set) var getCredentialsCallCount = 0
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
		let credentialData = CredentialData(credentials: credentials, refreshToken: refreshToken)
		saveCredentialData.append(credentialData)
	}

	public func getCredentials(apiErrorSubStatus: String?) async throws -> Credentials {
		getCredentialsCallCount += 1
		return try injectedAuthResult.get()
	}
}
