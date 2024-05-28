import Foundation

// MARK: - IncomingMessageType

enum IncomingMessageType: String, Decodable {
	case PRIVILEGED_SESSION_NOTIFICATION
	case RECONNECT
}

// MARK: - IncomingMessage

struct IncomingMessage: Decodable {
	let type: IncomingMessageType
	let payload: [String: String]?
}
