public extension LoudnessNormalizer {
	static func mock(
		preAmp: Float = 0.5,
		replayGain: Float = 1,
		peakAmplitude: Float = 2
	) -> LoudnessNormalizer {
		LoudnessNormalizer(preAmp: preAmp, replayGain: replayGain, peakAmplitude: peakAmplitude)!
	}
}
