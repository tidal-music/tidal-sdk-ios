import Foundation

struct LegacyTokens: Codable, Hashable {
	let credentials: LegacyCredentials
	let refreshToken: String?

	init(credentials: LegacyCredentials, refreshToken: String? = nil) {
		self.credentials = credentials
		self.refreshToken = refreshToken
	}

	func toTokens() -> Tokens {
		.init(credentials: credentials.toCredentials(), refreshToken: refreshToken)
	}
}

