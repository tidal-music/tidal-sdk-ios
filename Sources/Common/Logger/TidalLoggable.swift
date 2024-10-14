import Logging

/// Protocol that defines the requirements for a loggable object.
public protocol TidalLoggable {
	var loggingMessage: Logger.Message { get }
	var loggingMetadata: Logger.Metadata { get }
	var logLevel: Logger.Level { get }
	var source: String? { get }
}
