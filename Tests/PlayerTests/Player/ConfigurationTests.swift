@testable import Player
import XCTest

// MARK: - ConfigurationTests

final class ConfigurationTests: XCTestCase {
	private var isAirPlayOutputRoute = false
	private let configuration: Configuration = {
		var configuration = Configuration.mock()
		configuration.loudnessNormalizationMode = .ALBUM
		configuration.loudnessNormalizationPreAmp = 1
		configuration.loudnessNormalizationPreAmpAirplay = 0.5
		return configuration
	}()

	override func setUp() {
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

	func test_currentPreAmpValue_when_AirPlay() {
		let configuration = configuration

		isAirPlayOutputRoute = true
		XCTAssertEqual(configuration.currentPreAmpValue, configuration.loudnessNormalizationPreAmpAirplay)
	}

	func test_currentPreAmpValue_when_not_AirPlay() {
		let configuration = configuration

		isAirPlayOutputRoute = false
		XCTAssertEqual(configuration.currentPreAmpValue, configuration.loudnessNormalizationPreAmp)
	}
}
