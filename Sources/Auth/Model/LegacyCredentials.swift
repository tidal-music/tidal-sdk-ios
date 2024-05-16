import Foundation

struct LegacyCredentials: Codable, Hashable {
	public let clientId: String
	public let requestedScopes: Scopes
	public let clientUniqueKey: String?
	public let grantedScopes: Scopes
	public let userId: String?
	public let expires: Date?
	public let token: String?

	func toCredentials() -> Credentials {
		.init(
			clientId: clientId,
			requestedScopes: requestedScopes.scopes,
			clientUniqueKey: clientUniqueKey,
			grantedScopes: grantedScopes.scopes,
			userId: userId,
			expires: expires,
			token: token
		)
	}
}
