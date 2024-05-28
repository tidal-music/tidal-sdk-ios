@testable import Player
import XCTest

// MARK: - AssetTests

final class AssetTests: XCTestCase {
	private var player: PlayerMock!

	override func setUp() {
		player = PlayerMock()
	}
}

// MARK: - Tests

extension AssetTests {
	// MARK: - unload()

	func test_unload() {
		// GIVEN
		let asset = player.load()

		// WHEN
		asset.unload()

		// THEN
		XCTAssertEqual(player.unloadCallCount, 1)
	}

	// MARK: - setLoudnessNormalizationMode()

	func test_setLoudnessNormalizationMode() {
		// GIVEN
		let loudnessNormalizer: LoudnessNormalizer? = nil
		let loudnessNormalizationConfiguration = LoudnessNormalizationConfiguration(
			loudnessNormalizationMode: .NONE,
			loudnessNormalizer: loudnessNormalizer
		)
		let asset = Asset(with: player, loudnessNormalizationConfiguration: loudnessNormalizationConfiguration)

		// WHEN
		let newMode: LoudnessNormalizationMode = .ALBUM
		asset.setLoudnessNormalizationMode(newMode)

		// THEN
		XCTAssertEqual(loudnessNormalizationConfiguration.getLoudnessNormalizationMode(), newMode)
	}

	// MARK: - updatePreAmp()

	func test_updatePreAmp_when_loudnessNormalizationModeIsNONE() {
		// GIVEN
		let loudnessNormalizer: LoudnessNormalizer? = nil
		let loudnessNormalizationConfiguration = LoudnessNormalizationConfiguration(
			loudnessNormalizationMode: .NONE,
			loudnessNormalizer: loudnessNormalizer
		)
		let asset = Asset(with: player, loudnessNormalizationConfiguration: loudnessNormalizationConfiguration)

		// WHEN
		let newPreAmp: Float = 4
		asset.updatePreAmp(newPreAmp)

		// THEN
		XCTAssertEqual(loudnessNormalizationConfiguration.getLoudnessNormalizer()?.preAmp, nil)
	}

	func test_updatePreAmp_when_loudnessNormalizationModeIsALBUM() {
		// GIVEN
		let loudnessNormalizer = LoudnessNormalizer.mock()
		let loudnessNormalizationConfiguration = LoudnessNormalizationConfiguration(
			loudnessNormalizationMode: .ALBUM,
			loudnessNormalizer: loudnessNormalizer
		)
		let asset = Asset(with: player, loudnessNormalizationConfiguration: loudnessNormalizationConfiguration)

		// WHEN
		let newPreAmp: Float = 4
		asset.updatePreAmp(newPreAmp)

		// THEN
		XCTAssertEqual(loudnessNormalizationConfiguration.getLoudnessNormalizer()?.preAmp, newPreAmp)
	}

	// MARK: - updateVolume()

	func test_updateVolume_when_loudnessNormalizerIsNotNil_and_loudnessNormalizationModeIsALBUM() {
		let loudnessNormalizer = LoudnessNormalizer.mock()
		testUpdateVolume(
			givenLoudnessNormalizer: loudnessNormalizer,
			expectedLoudnessNormalizer: loudnessNormalizer,
			loudnessNormalizationMode: .ALBUM
		)
	}

	func test_updateVolume_when_loudnessNormalizerIsNotNil_and_loudnessNormalizationModeIsNONE() {
		let loudnessNormalizer = LoudnessNormalizer.mock()
		testUpdateVolume(
			givenLoudnessNormalizer: loudnessNormalizer,
			expectedLoudnessNormalizer: nil,
			loudnessNormalizationMode: .NONE
		)
	}

	func test_updateVolume_when_loudnessNormalizerIsNil_and_loudnessNormalizationModeIsALBUM() {
		let loudnessNormalizer: LoudnessNormalizer? = nil
		testUpdateVolume(
			givenLoudnessNormalizer: loudnessNormalizer,
			expectedLoudnessNormalizer: loudnessNormalizer,
			loudnessNormalizationMode: .ALBUM
		)
	}

	func test_updateVolume_when_loudnessNormalizerIsNil_and_loudnessNormalizationModeIsNONE() {
		let loudnessNormalizer: LoudnessNormalizer? = nil
		testUpdateVolume(
			givenLoudnessNormalizer: loudnessNormalizer,
			expectedLoudnessNormalizer: loudnessNormalizer,
			loudnessNormalizationMode: .NONE
		)
	}
}

// MARK: - Helpers

private extension AssetTests {
	func testUpdateVolume(
		givenLoudnessNormalizer: LoudnessNormalizer?,
		expectedLoudnessNormalizer: LoudnessNormalizer?,
		loudnessNormalizationMode: LoudnessNormalizationMode
	) {
		// GIVEN
		let loudnessNormalizationConfiguration = LoudnessNormalizationConfiguration(
			loudnessNormalizationMode: loudnessNormalizationMode,
			loudnessNormalizer: givenLoudnessNormalizer
		)
		let asset = Asset(with: player, loudnessNormalizationConfiguration: loudnessNormalizationConfiguration)

		// WHEN
		asset.updateVolume()

		// THEN
		XCTAssertEqual(player.updateVolumeCallCount, 1)
		XCTAssertEqual(player.loudnessNormalizers, [expectedLoudnessNormalizer])
	}
}
