import Foundation

// MARK: - Auth

public protocol Auth {
	func initializeLogin(redirectUri: String, loginConfig: LoginConfig?) -> URL?
	func finalizeLogin(loginResponseUri: String) async throws
	func initializeDeviceLogin() async throws -> DeviceAuthorizationResponse
	func finalizeDeviceLogin(deviceCode: String) async throws
	func logout() throws
	func setCredentials(_ credentials: Credentials, refreshToken: String?) throws
}
