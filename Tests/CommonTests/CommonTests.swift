import AnyCodable
@testable import Common
import Foundation
import XCTest

// MARK: - CommonTests

final class CommonTests: XCTestCase {
	func test_asAnyCodableDictionary_convertsToAnyCodableDictionary() throws {
		let codableFixture = CodableFixture.anyCodableFixture

		let codableDictionary = try codableFixture.asAnyCodableDictionary()
		let encodedDictionary = try JSONEncoder().encode(codableDictionary)
		let decodedDictionary = try JSONDecoder().decode(CodableFixture.self, from: encodedDictionary)

		XCTAssertEqual(codableFixture, decodedDictionary)
	}
}

// MARK: - CodableFixture

private struct CodableFixture: AnyCodableDictionaryConvertible, Equatable {
	let optional: String?
	let optionalString: String?
	let string: String
	let int: Int
	let bool: Bool
	let double: Double
	let array: [String]
	let dictionary: [String: String]
	let innerStruct: InnerCodableStruct

	struct InnerCodableStruct: Codable, Equatable {
		let name: String
	}

	static let anyCodableFixture = CodableFixture(
		optional: nil,
		optionalString: "optionalStringValue",
		string: "stringValue",
		int: 1,
		bool: true,
		double: 1.2,
		array: ["a", "b"],
		dictionary: ["key": "value"],
		innerStruct: .init(name: "Some-name")
	)
}
