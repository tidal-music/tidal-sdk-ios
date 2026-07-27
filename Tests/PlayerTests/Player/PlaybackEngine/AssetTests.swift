@testable import Player
import Testing

// MARK: - AssetTests

final class AssetTests {
	private var player: PlayerMock!

	init() {
		player = PlayerMock()
	}
}

// MARK: - Tests

extension AssetTests {
	// MARK: - unload()

	@Test
	func test_unload() {
		// GIVEN
		let asset = player.load()

		// WHEN
		asset.unload()

		// THEN
		#expect(player.unloadCallCount == 1)
	}

	// MARK: - setLoudnessNormalizationMode()

	@Test
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
		#expect(loudnessNormalizationConfiguration.getLoudnessNormalizationMode() == newMode)
	}

	// MARK: - updatePreAmp()

	@Test
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
		#expect(loudnessNormalizationConfiguration.getLoudnessNormalizer()?.preAmp == nil)
	}

	@Test
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
		#expect(loudnessNormalizationConfiguration.getLoudnessNormalizer()?.preAmp == newPreAmp)
	}

	// MARK: - updateVolume()

	@Test
	func test_updateVolume_when_loudnessNormalizerIsNotNil_and_loudnessNormalizationModeIsALBUM() {
		let loudnessNormalizer = LoudnessNormalizer.mock()
		testUpdateVolume(
			givenLoudnessNormalizer: loudnessNormalizer,
			expectedLoudnessNormalizer: loudnessNormalizer,
			loudnessNormalizationMode: .ALBUM
		)
	}

	@Test
	func test_updateVolume_when_loudnessNormalizerIsNotNil_and_loudnessNormalizationModeIsNONE() {
		let loudnessNormalizer = LoudnessNormalizer.mock()
		testUpdateVolume(
			givenLoudnessNormalizer: loudnessNormalizer,
			expectedLoudnessNormalizer: nil,
			loudnessNormalizationMode: .NONE
		)
	}

	@Test
	func test_updateVolume_when_loudnessNormalizerIsNil_and_loudnessNormalizationModeIsALBUM() {
		let loudnessNormalizer: LoudnessNormalizer? = nil
		testUpdateVolume(
			givenLoudnessNormalizer: loudnessNormalizer,
			expectedLoudnessNormalizer: loudnessNormalizer,
			loudnessNormalizationMode: .ALBUM
		)
	}

	@Test
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
		#expect(player.updateVolumeCallCount == 1)
		#expect(player.loudnessNormalizers == [expectedLoudnessNormalizer])
	}
}
