import Foundation

open class TidalError: Error, CustomStringConvertible {
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

	public var description: String {
		"\(String(describing: type(of: self))), code: \(code), substatus: \(subStatus?.description ?? "nil"), message: \(message ?? "nil"), throwable: \(String(describing: throwable))"
	}
}
