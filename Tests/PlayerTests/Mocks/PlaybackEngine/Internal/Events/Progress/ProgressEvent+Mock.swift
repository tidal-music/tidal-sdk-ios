@testable import Player

extension ProgressEvent {
	static func mock(
		id: String = "id",
		assetPosition: Int = 1,
		duration: Int = 10,
		type: ProductType = .TRACK,
		sourceType: String? = nil,
		sourceId: String? = nil
	) -> Self {
		ProgressEvent(
			id: id,
			assetPosition: assetPosition,
			duration: duration,
			type: type,
			sourceType: sourceType,
			sourceId: sourceId
		)
	}
}
