struct CredentialsSuccessData: Codable {
	let clientId: Int

	private enum CodingKeys: String, CodingKey {
		case clientId = "cid"
	}
}
