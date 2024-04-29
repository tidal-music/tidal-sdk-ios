import Foundation

struct ProgressEvent: Codable, Equatable {
	let playback: ProgressEventPayload

	init(id: String, assetPosition: Int, duration: Int, type: ProductType, sourceType: String?, sourceId: String?) {
		playback = ProgressEventPayload(
			id: id,
			assetPosition: assetPosition,
			duration: duration,
			type: type,
			sourceType: sourceType,
			sourceId: sourceId
		)
	}
}
