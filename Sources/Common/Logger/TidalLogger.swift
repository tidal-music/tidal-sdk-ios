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
	func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata? = nil, source: String? = nil) {
		self.logger.log(level: level, message, metadata: metadata, source: source)
	}
}

public extension TidalLogger {
	func log(loggable: TidalLoggable) {
		self.log(
			level: loggable.logLevel,
			message: loggable.loggingMessage,
			metadata: loggable.loggingMetadata
		)
	}
}
