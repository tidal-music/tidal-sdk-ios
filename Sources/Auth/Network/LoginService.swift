import Foundation

protocol LoginService {
	func getTokenWithCodeVerifier(
		code: String,
		clientId: String,
		grantType: String,
		redirectUri: String,
		scopes: String,
		codeVerifier: String,
		clientUniqueKey: String?
	) async throws -> LoginResponse

	func getDeviceAuthorization(clientId: String, scope: String) async throws -> DeviceAuthorizationResponse

	func getTokenFromDeviceCode(
		clientId: String,
		clientSecret: String?,
		deviceCode: String,
		grantType: String,
		scopes: String,
		clientUniqueKey: String?
	) async throws -> LoginResponse
}
