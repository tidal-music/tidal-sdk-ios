import Foundation
#if canImport(AnyCodable)
	import AnyCodable
#endif

// MARK: - ErrorObjectSource

/// object containing references to the primary source of the error
public struct ErrorObjectSource: Codable, Hashable {
	/// a JSON Pointer [RFC6901] to the value in the request document that caused the error
	public var pointer: String?
	/// string indicating which URI query parameter caused the error.
	public var parameter: String?
	/// string indicating the name of a single request header which caused the error
	public var header: String?

	public init(pointer: String? = nil, parameter: String? = nil, header: String? = nil) {
		self.pointer = pointer
		self.parameter = parameter
		self.header = header
	}

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case pointer
		case parameter
		case header
	}

	// Encodable protocol methods

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(pointer, forKey: .pointer)
		try container.encodeIfPresent(parameter, forKey: .parameter)
		try container.encodeIfPresent(header, forKey: .header)
	}
}
