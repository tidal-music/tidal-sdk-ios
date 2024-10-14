import AnyCodable
import Foundation

public typealias AnyCodableDictionary = [String: AnyCodable?]

// MARK: - AnyCodableDictionaryConvertible

public protocol AnyCodableDictionaryConvertible: Codable {
	func asAnyCodableDictionary() throws -> AnyCodableDictionary
}

public extension AnyCodableDictionaryConvertible {
	func asAnyCodableDictionary() throws -> AnyCodableDictionary {
		let dictionary = try JSONEncoder().encode(self)
		return try JSONDecoder().decode(AnyCodableDictionary.self, from: dictionary)
	}
}
