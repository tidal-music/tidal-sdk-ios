import Foundation

// MARK: - OfflineMediaItem + Mock

public extension OfflineMediaItem {
	static func mock(
		catalogMetadata: Metadata = .track(.mock()),
		playbackMetadata: PlaybackMetadata? = .mock(),
		mediaURL: URL = URL(string: "file:///mock/media.flac")!,
		licenseURL: URL? = nil,
		artworkURL: URL? = URL(string: "https://example.com/track-artwork.jpg")
	) -> Self {
		.init(
			catalogMetadata: catalogMetadata,
			playbackMetadata: playbackMetadata,
			mediaURL: mediaURL,
			licenseURL: licenseURL,
			artworkURL: artworkURL
		)
	}
}

// MARK: - OfflineMediaItem.TrackMetadata + Mock

public extension OfflineMediaItem.TrackMetadata {
	static func mock(
		id: String = "track-789",
		title: String = "Mock Track",
		artists: [String] = ["Mock Artist"],
		duration: Int = 210,
		explicit: Bool = false
	) -> Self {
		.init(
			id: id,
			title: title,
			artists: artists,
			duration: duration,
			explicit: explicit
		)
	}
}

// MARK: - OfflineMediaItem.VideoMetadata + Mock

public extension OfflineMediaItem.VideoMetadata {
	static func mock(
		id: String = "video-101",
		title: String = "Mock Video",
		artists: [String] = ["Mock Artist"],
		duration: Int = 300,
		explicit: Bool = false
	) -> Self {
		.init(
			id: id,
			title: title,
			artists: artists,
			duration: duration,
			explicit: explicit
		)
	}
}

// MARK: - OfflineMediaItem.NormalizationData + Mock

public extension OfflineMediaItem.NormalizationData {
	static func mock(
		peakAmplitude: Float? = 0.95,
		replayGain: Float? = -6.5
	) -> Self {
		.init(
			peakAmplitude: peakAmplitude,
			replayGain: replayGain
		)
	}
}

// MARK: - OfflineMediaItem.PlaybackMetadata + Mock

public extension OfflineMediaItem.PlaybackMetadata {
	static func mock(
		format: AudioFormat = .flac,
		albumNormalizationData: OfflineMediaItem.NormalizationData? = .mock(),
		trackNormalizationData: OfflineMediaItem.NormalizationData? = .mock()
	) -> Self {
		.init(
			format: format,
			albumNormalizationData: albumNormalizationData,
			trackNormalizationData: trackNormalizationData
		)
	}
}
