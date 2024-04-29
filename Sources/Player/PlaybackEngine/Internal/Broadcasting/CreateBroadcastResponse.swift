import Foundation

struct CreateBroadcastResponse: Decodable {
	let broadcastId: String
	let curationUrl: URL
	let sharingUrl: URL
	let reactions: [String]?
}
