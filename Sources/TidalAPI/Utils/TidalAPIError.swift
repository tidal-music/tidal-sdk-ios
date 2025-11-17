import Foundation

// MARK: - TidalAPIError

public struct TidalAPIError: LocalizedError, Equatable {
	let fileID: String
	let line: UInt
	let column: UInt
	public let message: String
	public let url: String
	public var statusCode: Int?
	public var subStatus: Int?
	public var type: ErrorType
	public let underlyingError: (any Error)?

	public init(
		fileID: StaticString = #fileID,
		line: UInt = #line,
		column: UInt = #column,
		message: String,
		url: String,
		statusCode: Int? = nil,
		subStatus: Int? = nil,
		type: ErrorType = .unknown,
		underlyingError: (any Error)? = nil
	) {
		self.fileID = String(describing: fileID)
		self.line = line
		self.column = column
		self.message = message
		self.url = url
		self.statusCode = statusCode
		self.subStatus = subStatus
		self.type = type
		self.underlyingError = underlyingError
	}

	public var errorDescription: String {
		"""
		API Error: \(String(describing: statusCode))
		URL: \(url)
		SubStatus: \(String(describing: subStatus))
		"""
	}
}

extension TidalAPIError {
	init(
		fileID: StaticString = #fileID,
		line: UInt = #line,
		column: UInt = #column,
		error: any Error,
		url: String,
		statusCode: Int? = nil,
		subStatus: Int? = nil,
		type: ErrorType = .unknown
	) {
		var errorMessage = ""
		dump(error, to: &errorMessage)
		self.init(
			fileID: fileID,
			line: line,
			column: column,
			message: errorMessage,
			url: url,
			statusCode: statusCode,
			subStatus: subStatus,
			type: type,
			underlyingError: error
		)
	}
}

// MARK: TidalAPIError.ErrorType

public extension TidalAPIError {
	enum ErrorType: String, Equatable {
		case api // HTTP / backend response
		case transport // URLSession / connectivity
		case cancelled // user or system cancellation
		case unknown
	}
}

// MARK: - Equatable

public func == (lhs: TidalAPIError, rhs: TidalAPIError) -> Bool {
	lhs.fileID == rhs.fileID &&
		lhs.line == rhs.line &&
		lhs.column == rhs.column &&
		lhs.message == rhs.message &&
		lhs.url == rhs.url &&
		lhs.statusCode == rhs.statusCode &&
		lhs.subStatus == rhs.subStatus &&
		lhs.type == rhs.type
}
