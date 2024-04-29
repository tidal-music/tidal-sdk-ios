import Foundation

public struct AuthConfig {
	public let clientId: String
	public let clientUniqueKey: String?
	public let clientSecret: String?
	public let credentialsKey: String
	public let scopes: Scopes
	public let enableCertificatePinning: Bool
	public init(
		clientId: String,
		clientUniqueKey: String? = nil,
		clientSecret: String? = nil,
		credentialsKey: String,
		scopes: Scopes = Scopes(),
		enableCertificatePinning: Bool = true
	) {
		self.clientId = clientId
		self.clientUniqueKey = clientUniqueKey
		self.clientSecret = clientSecret
		self.credentialsKey = credentialsKey
		self.scopes = scopes
		self.enableCertificatePinning = enableCertificatePinning
	}
}
