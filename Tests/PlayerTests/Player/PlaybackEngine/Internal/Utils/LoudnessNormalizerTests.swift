@testable import Player
import XCTest

// MARK: - Constants

private enum Constants {
	static let albumReplayGain: Float = 1
	static let albumPeakAmplitude: Float = 3
	static let playbackInfo = PlaybackInfo.mock(
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

final class LoudnessNormalizerTests: XCTestCase {
	// MARK: - init()

	func test_init_returnsNilIfAnyParameterIsNil() {
		let loudnessNormalizer = LoudnessNormalizer(preAmp: 1, replayGain: 2, peakAmplitude: nil)
		XCTAssertEqual(loudnessNormalizer, nil)

		let loudnessNormalizer2 = LoudnessNormalizer(preAmp: nil, replayGain: 1, peakAmplitude: 2)
		XCTAssertEqual(loudnessNormalizer2, nil)

		let loudnessNormalizer3 = LoudnessNormalizer(preAmp: 1, replayGain: nil, peakAmplitude: 2)
		XCTAssertEqual(loudnessNormalizer3, nil)
	}

	// MARK: - getScaleFactor()

	func test_getScaleFactor() {
		let loudnessNormalizer = LoudnessNormalizer(preAmp: 4, replayGain: 16, peakAmplitude: 2)
		XCTAssertEqual(loudnessNormalizer?.getScaleFactor(), 1)

		let loudnessNormalizer2 = LoudnessNormalizer(preAmp: 0.000000001, replayGain: 0, peakAmplitude: 2)
		XCTAssertEqual(loudnessNormalizer2?.getScaleFactor(), 1)
	}

	// MARK: - getDecibelValue()

	func test_getDecibelValue() {
		let loudnessNormalizer = LoudnessNormalizer(preAmp: 4, replayGain: 16, peakAmplitude: 2)
		XCTAssertEqual(loudnessNormalizer?.getDecibelValue(), 20)

		let loudnessNormalizer2 = LoudnessNormalizer(preAmp: 0.000000001, replayGain: 0, peakAmplitude: 2)
		XCTAssertEqual(loudnessNormalizer2?.getDecibelValue(), 0.000000001)
	}

	// MARK: - updatePreAmp()

	func test_updatePreAmp() {
		let loudnessNormalizer = LoudnessNormalizer(preAmp: 4, replayGain: 16, peakAmplitude: 2)
		let newPreAmp: Float = 20
		loudnessNormalizer?.updatePreAmp(newPreAmp)

		XCTAssertEqual(loudnessNormalizer?.preAmp, newPreAmp)
	}

	// MARK: - create(from playbackInfo: PlaybackInfo)

	func test_create_from_PlaybackInfo() {
		let playbackInfo = Constants.playbackInfo

		let loudnessNormalizer = LoudnessNormalizer.create(from: playbackInfo, preAmp: Constants.preAmp)

		XCTAssertEqual(loudnessNormalizer, Constants.expectedLoudnessNormalizer)
	}

	// MARK: - create(from playableStorageItem: PlayableStorageItem)

	func test_create_from_PlayableStorageItem() {
		do {
			let storageItem = try StorageItem.mock(from: Constants.playbackInfo)
			guard let playableStorageItem = PlayableStorageItem(from: storageItem) else {
				XCTFail("Failed to create mock of PlayableStorageItem")
				return
			}

			let loudnessNormalizer = LoudnessNormalizer.create(from: playableStorageItem, preAmp: Constants.preAmp)

			XCTAssertEqual(loudnessNormalizer, Constants.expectedLoudnessNormalizer)
		} catch {
			XCTFail("Failed to create mock of StorageItem")
		}
	}

	// MARK: - create(from storedMediaProduct: StoredMediaProduct)

	func test_create_from_StoredMediaProduct() {
		let storedMediaProduct = StoredMediaProduct.storedMock(
			albumReplayGain: Constants.albumReplayGain,
			albumPeakAmplitude: Constants.albumPeakAmplitude,
			trackReplayGain: 2,
			trackPeakAmplitude: 4
		)

		let loudnessNormalizer = LoudnessNormalizer.create(from: storedMediaProduct, preAmp: Constants.preAmp)

		XCTAssertEqual(loudnessNormalizer, nil)
	}
}
