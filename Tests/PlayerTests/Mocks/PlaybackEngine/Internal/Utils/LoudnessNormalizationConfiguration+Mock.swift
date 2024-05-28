@testable import Player

extension LoudnessNormalizationConfiguration {
	static func mock(
		loudnessNormalizationMode: LoudnessNormalizationMode = .ALBUM,
		loudnessNormalizer: LoudnessNormalizer? = .mock()
	) -> Self {
		.init(loudnessNormalizationMode: loudnessNormalizationMode, loudnessNormalizer: loudnessNormalizer)
	}
}
