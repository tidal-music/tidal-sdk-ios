import Foundation

public protocol Loggable {
	var message: String { get }
	var logLevel: LogLevel { get }
}

public extension Loggable {
	var message: String {
		return "Loggable message: \(self)"
	}
	
	var logLevel: LogLevel {
		return .info
	}
}
