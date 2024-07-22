import Foundation

// Main interface for the logging. Clients can inject their own implementations
public protocol Logger {
	func log(_ loggable: Loggable)
}

// Loggable event.
public protocol Loggable {
	var message: String { get }
	var level: LogLevel { get }
}

public enum LogLevel {
	case info
	case warning
	case error
}
