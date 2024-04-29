@testable import Player

extension OfflinePlay {
	static func mock(
		id: Int = 1,
		quality: String = "quality",
		deliveredDuration: Float = 10,
		playDate: UInt64 = 1,
		productType: ProductType = .TRACK,
		audioMode: AudioMode? = nil,
		playbackSessionId: String? = nil
	) -> Self {
		OfflinePlay(
			id: id,
			quality: quality,
			deliveredDuration: deliveredDuration,
			playDate: playDate,
			productType: productType,
			audioMode: audioMode,
			playbackSessionId: playbackSessionId
		)
	}
}
