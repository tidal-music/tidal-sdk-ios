import Logging

/// Protocol that defines the requirements for a loggable object.
public protocol TidalLoggable {
	/// Message you want to log
	var loggingMessage: Logger.Message { get }
	
	/// Additional information attached to a log message
	var loggingMetadata: Logger.Metadata { get }
	
	/// Level of a log message
	var logLevel: Logger.Level { get }
	
	/// The origin of a log message. If you don't provide it, it will be set automatically to the name of a calling module, which might not be intended
	var source: String? { get }
}
