import Foundation

public extension Credentials {
	static func mock(
		clientId: String = "clientId",
		requestedScopes: Set<String> = .init(),
		clientUniqueKey: String? = nil,
		grantedScopes: Set<String> = .init(),
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
