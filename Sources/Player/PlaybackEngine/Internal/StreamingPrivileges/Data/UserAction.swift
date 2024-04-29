import Foundation

struct UserAction: Encodable, Equatable {
	private let type = "USER_ACTION"
	private let payload: [String: String]

	init() {
		let formatter = ISO8601DateFormatter()
		let date = PlayerWorld.timeProvider.date()
		payload = ["startedAt": formatter.string(from: date)]
	}
}
