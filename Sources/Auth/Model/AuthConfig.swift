import Foundation

public struct AuthConfig {
	public let clientId: String
	public let clientUniqueKey: String?
	public let clientSecret: String?
	public let credentialsKey: String
	public let credentialsAccessGroup: String?
	public let scopes: Scopes
	public let tidalLoginServiceBaseUri: String
	public let tidalAuthServiceBaseUri: String
	public let enableCertificatePinning: Bool
	
	public init(
		clientId: String,
		clientUniqueKey: String? = nil,
		clientSecret: String? = nil,
		credentialsKey: String,
		credentialsAccessGroup: String? = nil,
		scopes: Scopes = Scopes(),
		tidalLoginServiceBaseUri: String = "https://login.tidal.com",
		tidalAuthServiceBaseUri: String = "https://auth.tidal.com",
		enableCertificatePinning: Bool = true
	) {
		self.clientId = clientId
		self.clientUniqueKey = clientUniqueKey
		self.clientSecret = clientSecret
		self.credentialsKey = credentialsKey
		self.credentialsAccessGroup = credentialsAccessGroup
		self.scopes = scopes
		self.tidalLoginServiceBaseUri = tidalLoginServiceBaseUri
		self.tidalAuthServiceBaseUri = tidalAuthServiceBaseUri
		self.enableCertificatePinning = enableCertificatePinning
	}
}
