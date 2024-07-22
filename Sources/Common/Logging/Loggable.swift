import Foundation

public protocol Loggable {
	var message: String { get }
	var level: LogLevel { get }
}
