import Foundation

struct Tokens: Codable, Hashable {
	let credentials: Credentials
	let refreshToken: String?

	init(credentials: Credentials, refreshToken: String? = nil) {
		self.credentials = credentials
		self.refreshToken = refreshToken
	}
}
