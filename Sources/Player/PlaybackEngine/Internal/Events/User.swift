struct User: Codable, Equatable {
	let id: Int
	let accessToken: String
	let clientId: Int?
}
