import Foundation

public struct QueryParameter: Hashable {
	public let key: String
	public let value: String

	public init(key: String, value: String) {
		self.key = key
		self.value = value
	}
}
