import Foundation

open class TidalError: Error {
	public let code: String
	public let subStatus: Int?
	public let message: String?
	public let throwable: Error?

	public init(
		code: String,
		subStatus: Int? = nil,
		message: String? = nil,
		throwable: Error? = nil
	) {
		self.code = code
		self.subStatus = subStatus
		self.message = message
		self.throwable = throwable
	}
}
