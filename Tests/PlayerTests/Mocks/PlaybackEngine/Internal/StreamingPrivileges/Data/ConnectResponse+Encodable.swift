import Foundation
@testable import Player

extension ConnectResponse: Encodable {
	enum CodingKeys: String, CodingKey {
		case url
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(url, forKey: .url)
	}
}
