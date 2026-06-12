@testable import Player
import Testing

// MARK: - ConfigurationTests

@Suite(.serialized)
final class ConfigurationTests {
	private var isAirPlayOutputRoute = false
	private let configuration: Configuration = {
		var configuration = Configuration.mock()
		configuration.loudnessNormalizationMode = .ALBUM
		configuration.loudnessNormalizationPreAmp = 1
		configuration.loudnessNormalizationPreAmpAirplay = 0.5
		return configuration
	}()

	init() {
		var audioInfoProvider = AudioInfoProvider.mock
		audioInfoProvider.isAirPlayOutputRoute = {
			self.isAirPlayOutputRoute
		}

		PlayerWorld = PlayerWorldClient.mock(audioInfoProvider: audioInfoProvider)
	}
}

// MARK: - Tests

extension ConfigurationTests {
	// MARK: - currentPreAmpValue

	@Test
	func test_currentPreAmpValue_when_AirPlay() {
		let configuration = configuration

		isAirPlayOutputRoute = true
		#expect(configuration.currentPreAmpValue == configuration.loudnessNormalizationPreAmpAirplay)
	}

	@Test
	func test_currentPreAmpValue_when_not_AirPlay() {
		let configuration = configuration

		isAirPlayOutputRoute = false
		#expect(configuration.currentPreAmpValue == configuration.loudnessNormalizationPreAmp)
	}
}
