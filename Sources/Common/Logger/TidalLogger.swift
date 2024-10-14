import Logging

/// Struct abstraction for a logger offering a convenient API for logging.
public struct TidalLogger {
	private var logger: Logger

	public init(label: String, level: Logger.Level = .trace) {
		self.logger = Logger(label: label)
		self.logger.logLevel = level
	}
}

private extension TidalLogger {
	func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata? = nil, source: String? = nil, file: String, function: String, line: UInt) {
		self.logger.log(level: level, message, metadata: metadata, source: source, file: file, function: function, line: line)
	}
}

public extension TidalLogger {
	func log(loggable: TidalLoggable, file: String = #fileID, function: String = #function, line: UInt = #line) {
		self.log(
			level: loggable.logLevel,
			message: loggable.loggingMessage,
			metadata: loggable.loggingMetadata,
			source: loggable.source,
			file: file,
			function: function,
			line: line
		)
	}
	
	/// Logs a string message
	/// - Parameters:
	///   - message: Message you want to log
	///   - source: The origin of a log message. If you don't provide it, it will be set automatically to the name of a calling module, which might not be intended
	///   - level: Level of a log message
	///   - metadata: Additional information attached to a log message
	///   - file: The file this log message originates from (there's usually no need to pass it explicitly as it
	///            defaults to `#fileID`.
	///   - function: The function this log message originates from (there's usually no need to pass it explicitly as
	///                it defaults to `#function`).
	///   - line: The line this log message originates from (there's usually no need to pass it explicitly as it
	///            defaults to `#line`).
	func log(
		message: String,
		source: String? = nil,
		level: Logger.Level? = nil,
		metadata: Logger.Metadata? = nil,
		file: String = #fileID,
		function: String = #function,
		line: UInt = #line
	) {
		let level = level ?? logger.logLevel
		let loggerMessage = Logger.Message(stringLiteral: message)
	
		self.log(
			level: level,
			message: loggerMessage,
			metadata: metadata,
			source: source,
			file: file,
			function: function,
			line: line
		)
	}
}
