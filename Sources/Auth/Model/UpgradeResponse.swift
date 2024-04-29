import Foundation

struct UpgradeResponse: Codable {
	let accessToken: String?
	var expiresIn: Int? = 0
	let refreshToken: String?
	let tokenType: String?
	let userId: Int?

	private enum CodingKeys: String, CodingKey {
		case accessToken = "access_token"
		case expiresIn = "expires_in"
		case refreshToken = "refresh_token"
		case tokenType = "token_type"
		case userId = "user_id"
	}
}
