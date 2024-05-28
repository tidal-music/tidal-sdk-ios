import Foundation

struct PlayLogEvent: Codable, Equatable {
	let playbackSessionId: String
	let startTimestamp: UInt64
	let startAssetPosition: Double
	let isPostPaywall: Bool
	let productType: String
	let requestedProductId: String
	let actualProductId: String
	let actualAssetPresentation: String
	let actualAudioMode: String?
	let actualQuality: String
	let sourceType: String?
	let sourceId: String?
	let actions: [Action]
	let endTimestamp: UInt64
	let endAssetPosition: Double

	init(
		playbackSessionId: String,
		startTimestamp: UInt64,
		startAssetPosition: Double,
		isPostPaywall: Bool,
		productType: ProductType,
		requestedProductId: String,
		actualProductId: String,
		actualAssetPresentation: AssetPresentation,
		actualAudioMode: AudioMode?,
		actualQuality: String,
		sourceType: String?,
		sourceId: String?,
		actions: [Action],
		endTimestamp: UInt64,
		endAssetPosition: Double
	) {
		self.playbackSessionId = playbackSessionId
		self.startTimestamp = startTimestamp
		self.startAssetPosition = startAssetPosition
		self.isPostPaywall = isPostPaywall
		self.productType = productType.rawValue
		self.requestedProductId = requestedProductId
		self.actualProductId = actualProductId
		self.actualAssetPresentation = actualAssetPresentation.rawValue
		self.actualAudioMode = actualAudioMode?.rawValue
		self.actualQuality = actualQuality
		self.sourceType = sourceType
		self.sourceId = sourceId
		self.actions = actions
		self.endTimestamp = endTimestamp
		self.endAssetPosition = endAssetPosition
	}
}
