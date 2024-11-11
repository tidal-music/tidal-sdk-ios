import Foundation
import Logging

public extension Logger.Metadata {
	init(stringDict: [String: String]) {
		self = stringDict.mapValues { .string($0) }
	}
	
	// Common keys that can be used in metadata for the sake of consistency
	static let errorKey = "error"
	static let codeKey = "code"
	static let reasonKey = "reason"
}
