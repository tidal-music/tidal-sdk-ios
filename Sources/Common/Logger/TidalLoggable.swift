import Logging

public protocol TidalLoggable {
	var loggingMessage: String { get }
	var loggingMetadata: [String: String] { get }
	var logLevel: LoggingLevel { get }
	var source: String { get }
}
