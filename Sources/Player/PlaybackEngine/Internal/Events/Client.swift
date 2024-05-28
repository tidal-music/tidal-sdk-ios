struct Client: Codable, Equatable {
	let token: String
	let version: String
	private(set) var platform: String = "iOS"
	var deviceType: String
}
