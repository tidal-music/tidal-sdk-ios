import Foundation

struct OfflinePlay: Codable, Equatable {
	let id: Int
	let quality: String
	let deliveredDuration: Float
	let playDate: UInt64
	let playbackMode: String
	let type: String
	let audioMode: AudioMode?
	let playbackSessionId: String?

	init(
		id: Int,
		quality: String,
		deliveredDuration: Float,
		playDate: UInt64,
		productType: ProductType,
		audioMode: AudioMode?,
		playbackSessionId: String?
	) {
		self.id = id
		self.quality = quality
		self.deliveredDuration = deliveredDuration
		self.playDate = playDate
		playbackMode = "OFFLINE_OFFLINE"
		type = productType.rawValue
		self.audioMode = audioMode
		self.playbackSessionId = playbackSessionId
	}
}
