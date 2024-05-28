@_documentation(visibility: internal)
public final class AssetMock: Asset {
	private(set) var loudnessNormalizationModes = [LoudnessNormalizationMode]()
	private(set) var updateVolumeCallCount = 0
	private(set) var preAmpValues = [Float]()

	// MARK: - Overridden funcs

	override func setLoudnessNormalizationMode(_ loudnessNormalizationMode: LoudnessNormalizationMode) {
		loudnessNormalizationModes.append(loudnessNormalizationMode)
	}

	/// Updates the volume of the asset in its player based on the loudness normalization mode.
	override func updateVolume() {
		updateVolumeCallCount += 1
	}

	/// Updates the preAmp of the loudness normalizer.
	override func updatePreAmp(_ preAmpValue: Float) {
		preAmpValues.append(preAmpValue)
	}
}
