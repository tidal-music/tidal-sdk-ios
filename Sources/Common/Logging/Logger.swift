import Foundation

// Main interface for the logging. Clients can inject their own implementations
public protocol Logger {
	func log(_ loggable: Loggable)
}
