@testable import Player

extension CreateBroadcastResponse: Encodable {
	enum CodingKeys: String, CodingKey {
		case broadcastId
		case curationUrl
		case sharingUrl
		case reactions
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(broadcastId, forKey: .broadcastId)
		try container.encode(curationUrl, forKey: .curationUrl)
		try container.encode(sharingUrl, forKey: .sharingUrl)
		try container.encode(reactions, forKey: .reactions)
	}
}
