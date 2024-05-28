import Foundation

// MARK: - Source

public struct Source: Codable, Equatable {
	public let sourceType: String?
	public let sourceId: String?

	public init(sourceType: String?, sourceId: String?) {
		self.sourceType = sourceType
		self.sourceId = sourceId
	}
}

// MARK: CustomStringConvertible

extension Source: CustomStringConvertible {
	public var description: String {
		"Source(sourceType: \(String(describing: sourceType)), sourceId: \"\(String(describing: sourceId))\")"
	}
}
