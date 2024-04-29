import Foundation

public extension Credentials {
	static func mock(
		clientId: String = "clientId",
		requestedScopes: Scopes = Scopes(),
		clientUniqueKey: String? = nil,
		grantedScopes: Scopes = Scopes(),
		userId: String? = nil,
		expires: Date? = nil,
		token: String? = nil
	) -> Self {
		.init(
			clientId: clientId,
			requestedScopes: requestedScopes,
			clientUniqueKey: clientUniqueKey,
			grantedScopes: grantedScopes,
			userId: userId,
			expires: expires,
			token: token
		)
	}
}
