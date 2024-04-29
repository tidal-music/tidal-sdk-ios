import Foundation

public struct PlayerError: Error {
	public let errorId: ErrorId
	public let errorCode: String

	public init(errorId: ErrorId, errorCode: String) {
		self.errorId = errorId
		self.errorCode = errorCode
	}
}
