import Common
import Foundation

struct DefaultLoginService: LoginService, HTTPService {
	private let TOKEN_AUTH_PATH = "/v1/oauth2/token"
	private let DEVICE_AUTH_PATH = "/v1/oauth2/device_authorization"
	private let authBaseUrl: String
	
	init(authBaseUrl: String) {
		self.authBaseUrl = authBaseUrl
	}
	
	func getTokenWithCodeVerifier(
		code: String,
		clientId: String,
		grantType: String,
		redirectUri: String,
		scopes: String,
		codeVerifier: String,
		clientUniqueKey: String?
	) async throws -> LoginResponse {
		let queryItems = [
			URLQueryItem(name: "code", value: code),
			URLQueryItem(name: "client_id", value: clientId),
			URLQueryItem(name: "grant_type", value: grantType),
			URLQueryItem(name: "redirect_uri", value: redirectUri),
			URLQueryItem(name: "scope", value: scopes),
			URLQueryItem(name: "code_verifier", value: codeVerifier),
			URLQueryItem(name: "client_unique_key", value: clientUniqueKey),
		]
		guard let request = request(url: authBaseUrl, path: TOKEN_AUTH_PATH, queryItems: queryItems) else {
			throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
		}

		return try await executeRequest(request)
	}

	func getDeviceAuthorization(
		clientId: String,
		scope: String
	) async throws -> DeviceAuthorizationResponse {
		let queryItems = [
			URLQueryItem(name: "scope", value: scope),
			URLQueryItem(name: "client_id", value: clientId),
		]
		guard let request = request(url: authBaseUrl, path: DEVICE_AUTH_PATH, queryItems: queryItems) else {
			throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
		}

		return try await executeRequest(request)
	}

	func getTokenFromDeviceCode(
		clientId: String,
		clientSecret: String?,
		deviceCode: String,
		grantType: String,
		scopes: String,
		clientUniqueKey: String?
	) async throws -> LoginResponse {
		let queryItems = [
			URLQueryItem(name: "client_id", value: clientId),
			URLQueryItem(name: "client_secret", value: clientSecret),
			URLQueryItem(name: "device_code", value: deviceCode),
			URLQueryItem(name: "grant_type", value: grantType),
			URLQueryItem(name: "scope", value: scopes),
			URLQueryItem(name: "client_unique_key", value: clientUniqueKey),
		]
		guard let request = request(url: authBaseUrl, path: TOKEN_AUTH_PATH, queryItems: queryItems) else {
			throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
		}

		return try await executeRequest(request)
	}
}
