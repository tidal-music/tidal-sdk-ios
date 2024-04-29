// MARK: - EventGroup

enum EventGroup: String {
	case streamingMetrics = "streaming_metrics"
	case playlog = "play_log"
	case playback

	var version: Int {
		switch self {
		case .streamingMetrics, .playlog: 2
		case .playback: 1
		}
	}
}

// MARK: - EventNames

enum EventNames {
	static let playbackSession = "playback_session"
	static let progress = "progress"
}
