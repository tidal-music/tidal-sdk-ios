import AnyCodable
import Foundation

public typealias AnyCodableDictionary = [String: AnyCodable?]

public extension Encodable {
	func asAnyCodableDictionary() throws -> AnyCodableDictionary {
		let dictionary = try JSONEncoder().encode(self)
		return try JSONDecoder().decode(AnyCodableDictionary.self, from: dictionary)
	}
}
