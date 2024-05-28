@testable import Auth
import Common
import Foundation

final class FakeTokenService: TokenService {
	var calls = [CallType]()
	var throwableToThrow: Error?

	private let userId: Int? = 123

	init(throwableToThrow: Error? = nil) {
		self.throwableToThrow = throwableToThrow
	}

	func getTokenFromRefreshToken(
		clientId: String,
		refreshToken: String,
		grantType: String,
		scope: String
	) async throws -> RefreshResponse {
		calls.append(.refresh)
		if let throwableToThrow {
			throw throwableToThrow
		}

		return RefreshResponse(
			accessToken: "accessToken",
			clientName: "clientName",
			expiresIn: 5000,
			tokenType: "tokenType",
			scopesString: "",
			userId: userId
		)
	}

	func getTokenFromClientSecret(
		clientId: String,
		clientSecret: String?,
		grantType: String,
		scope: String
	) async throws -> RefreshResponse {
		calls.append(.secret)
		if let throwableToThrow {
			throw throwableToThrow
		}

		return RefreshResponse(
			accessToken: "accessToken",
			clientName: "clientName",
			expiresIn: 5000,
			tokenType: "tokenType",
			scopesString: "",

			userId: userId
		)
	}

	func upgradeToken(
		refreshToken: String,
		clientUniqueKey: String?,
		clientId: String,
		clientSecret: String?,
		scopes: String,
		grantType: String
	) async throws -> UpgradeResponse {
		calls.append(.upgrade)
		if let throwableToThrow {
			throw throwableToThrow
		}

		return UpgradeResponse(
			accessToken: "upgradeAccessToken",
			expiresIn: 5000,
			refreshToken: "upgradeRefreshToken",
			tokenType: "Bearer",

			userId: userId
		)
	}

	enum CallType {
		case refresh, secret, upgrade
	}
}
