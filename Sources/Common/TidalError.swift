import Foundation

open class TidalError: LocalizedError {
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

	public var errorDescription: String? {
		"\(self), code: \(code), substatus: \(subStatus?.description ?? "nil"), message: \(message ?? "nil"), throwable: \(throwable.map { "\($0)" } ?? "nil"), throwable description: \(throwable?.localizedDescription ?? "nil")"
	}
}
