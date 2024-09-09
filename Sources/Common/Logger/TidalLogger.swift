import Logging

public struct TidalLogger {
	private var logger: Logger

	public init(label: String, level: Logger.Level) {
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
		let newMetadata = loggable.loggingMetadata.mapValues { originalValue in
			Logger.MetadataValue(stringLiteral: originalValue)
		}
		self.log(
			level: loggable.logLevel.loggerLevel,
			message: Logger.Message(stringLiteral: loggable.loggingMessage),
			metadata: newMetadata
		)
	}
}

private extension LoggingLevel {
	var loggerLevel: Logger.Level {
		switch self {
		case .trace:
			return .trace
		case .debug:
			return .debug
		case .info:
			return .info
		case .notice:
			return .notice
		case .warning:
			return .warning
		case .error:
			return .error
		case .critical:
			return .critical
		}
	}
}
