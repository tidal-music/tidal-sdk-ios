@testable import Player
import Testing

// MARK: - Constants

private enum Constants {
	static let albumReplayGain: Float = 1
	static let albumPeakAmplitude: Float = 3
	static let playbackInfo = PlaybackInfo.mock(
		mediaType: MediaTypes.BTS,
		albumReplayGain: albumReplayGain,
		albumPeakAmplitude: albumPeakAmplitude,
		trackReplayGain: 2,
		trackPeakAmplitude: 4
	)
	static let preAmp: Float = 10

	static let expectedLoudnessNormalizer = LoudnessNormalizer(
		preAmp: preAmp,
		replayGain: albumReplayGain,
		peakAmplitude: albumPeakAmplitude
	)
}

// MARK: - LoudnessNormalizerTests

struct LoudnessNormalizerTests {
	// MARK: - init()

	@Test
	func test_init_returnsNilIfAnyParameterIsNil() {
		let loudnessNormalizer = LoudnessNormalizer(preAmp: 1, replayGain: 2, peakAmplitude: nil)
		#expect(loudnessNormalizer == nil)

		let loudnessNormalizer2 = LoudnessNormalizer(preAmp: nil, replayGain: 1, peakAmplitude: 2)
		#expect(loudnessNormalizer2 == nil)

		let loudnessNormalizer3 = LoudnessNormalizer(preAmp: 1, replayGain: nil, peakAmplitude: 2)
		#expect(loudnessNormalizer3 == nil)
	}

	// MARK: - getScaleFactor()

	@Test
	func test_getScaleFactor() {
		let loudnessNormalizer = LoudnessNormalizer(preAmp: 4, replayGain: 16, peakAmplitude: 2)
		#expect(loudnessNormalizer?.getScaleFactor() == 1)

		let loudnessNormalizer2 = LoudnessNormalizer(preAmp: 0.000000001, replayGain: 0, peakAmplitude: 2)
		#expect(loudnessNormalizer2?.getScaleFactor() == 1)
	}

	// MARK: - getDecibelValue()

	@Test
	func test_getDecibelValue() {
		let loudnessNormalizer = LoudnessNormalizer(preAmp: 4, replayGain: 16, peakAmplitude: 2)
		#expect(loudnessNormalizer?.getDecibelValue() == 20)

		let loudnessNormalizer2 = LoudnessNormalizer(preAmp: 0.000000001, replayGain: 0, peakAmplitude: 2)
		#expect(loudnessNormalizer2?.getDecibelValue() == 0.000000001)
	}

	// MARK: - updatePreAmp()

	@Test
	func test_updatePreAmp() {
		let loudnessNormalizer = LoudnessNormalizer(preAmp: 4, replayGain: 16, peakAmplitude: 2)
		let newPreAmp: Float = 20
		loudnessNormalizer?.updatePreAmp(newPreAmp)

		#expect(loudnessNormalizer?.preAmp == newPreAmp)
	}

	// MARK: - create(from playbackInfo: PlaybackInfo)

	@Test
	func test_create_from_PlaybackInfo() {
		let playbackInfo = Constants.playbackInfo

		let loudnessNormalizer = LoudnessNormalizer.create(from: playbackInfo, preAmp: Constants.preAmp)

		#expect(loudnessNormalizer == Constants.expectedLoudnessNormalizer)
	}

	// MARK: - create(from playableStorageItem: PlayableStorageItem)

	@Test
	func test_create_from_PlayableStorageItem() {
		guard let offlinedProduct = PlayableOfflinedMediaProduct(from: OfflineEntry.mock(from: Constants.playbackInfo)) else {
			Issue.record("Failed to create mock of PlayableOfflinedProduct")
			return
		}

		let loudnessNormalizer = LoudnessNormalizer.create(from: offlinedProduct, preAmp: Constants.preAmp)

		#expect(loudnessNormalizer == Constants.expectedLoudnessNormalizer)
	}

	// MARK: - create(from storedMediaProduct: StoredMediaProduct)

	@Test
	func test_create_from_StoredMediaProduct() {
		let storedMediaProduct = StoredMediaProduct.mock(
			albumReplayGain: Constants.albumReplayGain,
			albumPeakAmplitude: Constants.albumPeakAmplitude,
			trackReplayGain: 2,
			trackPeakAmplitude: 4
		)

		let loudnessNormalizer = LoudnessNormalizer.create(from: storedMediaProduct, preAmp: Constants.preAmp)

		#expect(loudnessNormalizer == nil)
	}
}
