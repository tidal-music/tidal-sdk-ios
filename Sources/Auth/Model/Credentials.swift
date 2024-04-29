import Foundation

private let EXPIRY_LIMIT_SECONDS = 60

// MARK: - Credentials

public struct Credentials: Codable, Hashable {
	public enum Level {
		case basic, client, user
	}

	public let clientId: String
	public let requestedScopes: Scopes
	public let clientUniqueKey: String?
	public let grantedScopes: Scopes
	public let userId: String?
	public let expires: Date? // TODO: Verify that Android's Instant == iOS's Date
	public let token: String?

	public init(
		clientId: String,
		requestedScopes: Scopes,
		clientUniqueKey: String?,
		grantedScopes: Scopes,
		userId: String?,
		expires: Date?,
		token: String?
	) {
		self.clientId = clientId
		self.requestedScopes = requestedScopes
		self.clientUniqueKey = clientUniqueKey
		self.grantedScopes = grantedScopes
		self.userId = userId
		self.expires = expires
		self.token = token
	}

	init(authConfig: AuthConfig) {
		self.init(
			clientId: authConfig.clientId,
			requestedScopes: authConfig.scopes,
			clientUniqueKey: authConfig.clientUniqueKey,
			grantedScopes: Scopes(),
			userId: nil,
			expires: nil,
			token: nil
		)
	}

	init(
		authConfig: AuthConfig,
		response: RefreshResponse
	) throws {
		try self.init(
			authConfig: authConfig,
			grantedScopes: Scopes.fromString(response.scopesString),
			userId: response.userId.map { "\($0)" },
			expiresIn: response.expiresIn,
			token: response.accessToken
		)
	}

	init(
		authConfig: AuthConfig,
		grantedScopes: Scopes? = nil,
		userId: String? = nil,
		expiresIn: Int? = nil,
		token: String? = nil
	) {
		clientId = authConfig.clientId
		requestedScopes = authConfig.scopes
		clientUniqueKey = authConfig.clientUniqueKey
		self.grantedScopes = grantedScopes ?? Scopes()
		self.userId = userId
		var expires: Date?
		if let expiresIn {
			expires = Date().addingTimeInterval(TimeInterval(expiresIn))
		}

		self.expires = expires
		self.token = token
	}

	var isExpired: Bool {
		guard let expires else {
			return true
		}
		return Date() > expires.addingTimeInterval(-TimeInterval(EXPIRY_LIMIT_SECONDS))
	}

	public var level: Level {
		if !userId.isNilOrBlank, !token.isNilOrBlank {
			return .user
		}

		if userId.isNilOrBlank, !token.isNilOrBlank {
			return .client
		}

		return .basic
	}
}

private extension String? {
	var isNilOrBlank: Bool {
		guard let self else {
			return true
		}
		return self.isEmpty
	}
}
