import Foundation
import Logging

public extension Logger.Metadata {
	init(stringDict: [String: String]) {
		self = stringDict.mapValues { .string($0) }
	}
}
