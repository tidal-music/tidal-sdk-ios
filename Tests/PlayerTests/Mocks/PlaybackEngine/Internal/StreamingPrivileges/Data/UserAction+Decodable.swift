import Foundation
@testable import Player

extension UserAction: Decodable {
	public init(from decoder: Decoder) throws {
		self.init()
	}
}
