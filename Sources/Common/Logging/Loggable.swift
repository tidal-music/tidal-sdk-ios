import Foundation

public protocol Loggable {
	var message: String { get }
	var level: LogLevel { get }
}

public extension Loggable {
	var message: String {
		return "Loggable message: \(self)"
	}
	
	var level: LogLevel {
		return .info
	}
}
