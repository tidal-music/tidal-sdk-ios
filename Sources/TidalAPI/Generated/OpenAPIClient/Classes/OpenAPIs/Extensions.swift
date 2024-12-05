import Foundation
#if canImport(FoundationNetworking)
	import FoundationNetworking
#endif
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - Bool + JSONEncodable

extension Bool: JSONEncodable {
	func encodeToJSON() -> Any { self }
}

// MARK: - Float + JSONEncodable

extension Float: JSONEncodable {
	func encodeToJSON() -> Any { self }
}

// MARK: - Int + JSONEncodable

extension Int: JSONEncodable {
	func encodeToJSON() -> Any { self }
}

// MARK: - Int32 + JSONEncodable

extension Int32: JSONEncodable {
	func encodeToJSON() -> Any { self }
}

// MARK: - Int64 + JSONEncodable

extension Int64: JSONEncodable {
	func encodeToJSON() -> Any { self }
}

// MARK: - Double + JSONEncodable

extension Double: JSONEncodable {
	func encodeToJSON() -> Any { self }
}

// MARK: - Decimal + JSONEncodable

extension Decimal: JSONEncodable {
	func encodeToJSON() -> Any { self }
}

// MARK: - String + JSONEncodable

extension String: JSONEncodable {
	func encodeToJSON() -> Any { self }
}

// MARK: - URL + JSONEncodable

extension URL: JSONEncodable {
	func encodeToJSON() -> Any { self }
}

// MARK: - UUID + JSONEncodable

extension UUID: JSONEncodable {
	func encodeToJSON() -> Any { self }
}

extension RawRepresentable where RawValue: JSONEncodable {
	func encodeToJSON() -> Any { rawValue }
}

private func encodeIfPossible<T>(_ object: T) -> Any {
	if let encodableObject = object as? JSONEncodable {
		encodableObject.encodeToJSON()
	} else {
		object
	}
}

// MARK: - Array + JSONEncodable

extension Array: JSONEncodable {
	func encodeToJSON() -> Any {
		map(encodeIfPossible)
	}
}

// MARK: - Set + JSONEncodable

extension Set: JSONEncodable {
	func encodeToJSON() -> Any {
		Array(self).encodeToJSON()
	}
}

// MARK: - Dictionary + JSONEncodable

extension Dictionary: JSONEncodable {
	func encodeToJSON() -> Any {
		var dictionary = [AnyHashable: Any]()
		for (key, value) in self {
			dictionary[key] = encodeIfPossible(value)
		}
		return dictionary
	}
}

// MARK: - Data + JSONEncodable

extension Data: JSONEncodable {
	func encodeToJSON() -> Any {
		base64EncodedString(options: Data.Base64EncodingOptions())
	}
}

// MARK: - Date + JSONEncodable

extension Date: JSONEncodable {
	func encodeToJSON() -> Any {
		CodableHelper.dateFormatter.string(from: self)
	}
}

extension JSONEncodable where Self: Encodable {
	func encodeToJSON() -> Any {
		guard let data = try? CodableHelper.jsonEncoder.encode(self) else {
			fatalError("Could not encode to json: \(self)")
		}
		return data.encodeToJSON()
	}
}

// MARK: - String + CodingKey

extension String: CodingKey {
	public var stringValue: String {
		self
	}

	public init?(stringValue: String) {
		self.init(stringLiteral: stringValue)
	}

	public var intValue: Int? {
		nil
	}

	public init?(intValue: Int) {
		nil
	}
}

public extension KeyedEncodingContainerProtocol {
	mutating func encodeArray<T>(_ values: [T], forKey key: Self.Key) throws where T: Encodable {
		var arrayContainer = nestedUnkeyedContainer(forKey: key)
		try arrayContainer.encode(contentsOf: values)
	}

	mutating func encodeArrayIfPresent<T>(_ values: [T]?, forKey key: Self.Key) throws where T: Encodable {
		if let values {
			try encodeArray(values, forKey: key)
		}
	}

	mutating func encodeMap<T>(_ pairs: [Self.Key: T]) throws where T: Encodable {
		for (key, value) in pairs {
			try encode(value, forKey: key)
		}
	}

	mutating func encodeMapIfPresent<T>(_ pairs: [Self.Key: T]?) throws where T: Encodable {
		if let pairs {
			try encodeMap(pairs)
		}
	}

	mutating func encode(_ value: Decimal, forKey key: Self.Key) throws {
		let decimalNumber = NSDecimalNumber(decimal: value)
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .decimal
		numberFormatter.locale = Locale(identifier: "en_US")
		let formattedString = numberFormatter.string(from: decimalNumber) ?? "\(value)"
		try encode(formattedString, forKey: key)
	}

	mutating func encodeIfPresent(_ value: Decimal?, forKey key: Self.Key) throws {
		if let value {
			try encode(value, forKey: key)
		}
	}
}

public extension KeyedDecodingContainerProtocol {
	func decodeArray<T>(_ type: T.Type, forKey key: Self.Key) throws -> [T] where T: Decodable {
		var tmpArray = [T]()

		var nestedContainer = try nestedUnkeyedContainer(forKey: key)
		while !nestedContainer.isAtEnd {
			let arrayValue = try nestedContainer.decode(T.self)
			tmpArray.append(arrayValue)
		}

		return tmpArray
	}

	func decodeArrayIfPresent<T>(_ type: T.Type, forKey key: Self.Key) throws -> [T]? where T: Decodable {
		var tmpArray: [T]?

		if contains(key) {
			tmpArray = try decodeArray(T.self, forKey: key)
		}

		return tmpArray
	}

	func decodeMap<T>(_ type: T.Type, excludedKeys: Set<Self.Key>) throws -> [Self.Key: T] where T: Decodable {
		var map: [Self.Key: T] = [:]

		for key in allKeys {
			if !excludedKeys.contains(key) {
				let value = try decode(T.self, forKey: key)
				map[key] = value
			}
		}

		return map
	}

	func decode(_ type: Decimal.Type, forKey key: Self.Key) throws -> Decimal {
		let stringValue = try decode(String.self, forKey: key)
		guard let decimalValue = Decimal(string: stringValue) else {
			let context = DecodingError.Context(
				codingPath: [key],
				debugDescription: "The key \(key) couldn't be converted to a Decimal value"
			)
			throw DecodingError.typeMismatch(type, context)
		}

		return decimalValue
	}

	func decodeIfPresent(_ type: Decimal.Type, forKey key: Self.Key) throws -> Decimal? {
		guard let stringValue = try decodeIfPresent(String.self, forKey: key) else {
			return nil
		}
		guard let decimalValue = Decimal(string: stringValue) else {
			let context = DecodingError.Context(
				codingPath: [key],
				debugDescription: "The key \(key) couldn't be converted to a Decimal value"
			)
			throw DecodingError.typeMismatch(type, context)
		}

		return decimalValue
	}
}

extension HTTPURLResponse {
	var isStatusCodeSuccessful: Bool {
		Configuration.successfulStatusCodeRange.contains(statusCode)
	}
}
