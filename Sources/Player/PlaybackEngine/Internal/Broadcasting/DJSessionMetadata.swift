import Foundation

public struct DJSessionMetadata: Equatable {
	public let sessionId: String
	public let title: String
	public let sharingURL: URL
	public let reactions: [String]?
}
