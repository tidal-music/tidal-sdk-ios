import Foundation

public struct TidalAPIError: LocalizedError, Equatable {
	let fileID: String
	let line: UInt
	let column: UInt
	public let message: String
	public let url: String
	public var statusCode: Int?
	public var subStatus: Int?
	
	public init(
		fileID: StaticString = #fileID,
		line: UInt = #line,
		column: UInt = #column,
		message: String,
		url: String,
		statusCode: Int? = nil,
		subStatus: Int? = nil
	) {
		self.fileID = String(describing: fileID)
		self.line = line
		self.column = column
		self.message = message
		self.url = url
		self.statusCode = statusCode
		self.subStatus = subStatus
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
		subStatus: Int? = nil
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
			subStatus: subStatus
		)
	}
}
