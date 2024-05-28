import Foundation

struct LoginResponse: Codable {
	let accessToken: String
	let clientName: String?
	let expiresIn: Int
	let refreshToken: String
	let tokenType: String
	let scopesString: String
	let userId: Int?

	private enum CodingKeys: String, CodingKey {
		case accessToken = "access_token"
		case clientName
		case expiresIn = "expires_in"
		case refreshToken = "refresh_token"
		case tokenType = "token_type"
		case scopesString = "scope"
		case userId = "user_id"
	}
}
