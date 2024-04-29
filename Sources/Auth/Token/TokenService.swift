import Foundation

protocol TokenService {
	func getTokenFromRefreshToken(
		clientId: String,
		refreshToken: String,
		grantType: String,
		scope: String
	) async throws -> RefreshResponse

	func getTokenFromClientSecret(
		clientId: String,
		clientSecret: String?,
		grantType: String,
		scope: String
	) async throws -> RefreshResponse

	func upgradeToken(
		refreshToken: String,
		clientUniqueKey: String?,
		clientId: String,
		clientSecret: String?,
		scopes: String,
		grantType: String
	) async throws -> UpgradeResponse
}
