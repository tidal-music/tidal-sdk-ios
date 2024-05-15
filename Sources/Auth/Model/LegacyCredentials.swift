import Foundation

struct LegacyCredentials: Codable, Hashable {
	public let clientId: String
	public let requestedScopes: Scopes
	public let clientUniqueKey: String?
	public let grantedScopes: Scopes
	public let userId: String?
	public let expires: Date?
	public let token: String?
}
