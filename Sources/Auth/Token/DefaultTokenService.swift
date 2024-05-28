import Common
import Foundation

struct DefaultTokenService: TokenService, HTTPService {
	private let AUTH_PATH = "/v1/oauth2/token"
	private let authBaseUrl: String
    
	init(authBaseUrl: String) {
		self.authBaseUrl = authBaseUrl
	}

	func getTokenFromRefreshToken(
		clientId: String,
		refreshToken: String,
		grantType: String,
		scope: String
	) async throws -> RefreshResponse {
		let queryItems = [
			URLQueryItem(name: "client_id", value: clientId),
			URLQueryItem(name: "grant_type", value: grantType),
			URLQueryItem(name: "refresh_token", value: refreshToken),
			URLQueryItem(name: "scope", value: scope),
		]
		guard let request = request(url: authBaseUrl, path: AUTH_PATH, queryItems: queryItems) else {
			throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
		}

		return try await executeRequest(request)
	}

	func getTokenFromClientSecret(
		clientId: String,
		clientSecret: String?,
		grantType: String,
		scope: String
	) async throws -> RefreshResponse {
		let queryItems = [
			URLQueryItem(name: "client_id", value: clientId),
			URLQueryItem(name: "grant_type", value: grantType),
			URLQueryItem(name: "client_secret", value: clientSecret),
			URLQueryItem(name: "scope", value: scope),
		]
		guard let request = request(url: authBaseUrl, path: AUTH_PATH, queryItems: queryItems) else {
			throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
		}

		return try await executeRequest(request)
	}

	func upgradeToken(
		refreshToken: String,
		clientUniqueKey: String?,
		clientId: String,
		clientSecret: String?,
		scopes: String,
		grantType: String
	) async throws -> UpgradeResponse {
		let queryItems = [
			URLQueryItem(name: "client_id", value: clientId),
			URLQueryItem(name: "grant_type", value: grantType),
			URLQueryItem(name: "client_secret", value: clientSecret),
			URLQueryItem(name: "client_unique_key", value: clientUniqueKey),
			URLQueryItem(name: "refresh_token", value: refreshToken),
			URLQueryItem(name: "scope", value: scopes),
		]
		guard let request = request(url: authBaseUrl, path: AUTH_PATH, queryItems: queryItems) else {
			throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
		}

		return try await executeRequest(request)
	}
}
