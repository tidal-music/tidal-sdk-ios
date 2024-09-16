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
		self.logger.log(level: level, message, metadata: metadata, file: file, function: function, line: line)
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
}
