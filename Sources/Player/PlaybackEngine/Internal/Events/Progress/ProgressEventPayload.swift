struct ProgressEventPayload: Codable, Equatable {
	let id: String
	let assetPosition: Int
	let duration: Int
	let type: String
	var source: ProgressEventPlaybackSource?

	private enum CodingKeys: String, CodingKey {
		case id
		case assetPosition = "playedMS"
		case duration = "durationMS"
		case type
		case source
	}

	init(id: String, assetPosition: Int, duration: Int, type: ProductType, sourceType: String?, sourceId: String?) {
		self.id = id
		self.assetPosition = assetPosition
		self.duration = duration
		self.type = type.rawValue.lowercased()

		if let sourceType, let sourceId {
			source = ProgressEventPlaybackSource(type: sourceType, id: sourceId)
		}
	}
}
