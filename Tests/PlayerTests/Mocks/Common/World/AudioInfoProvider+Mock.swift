@testable import Player

extension AudioInfoProvider {
	static let mock: Self = AudioInfoProvider(
		isAirPlayOutputRoute: { false },
		isCarPlayOutputRoute: { false },
		currentOutputPortName: { "outputPortName" }
	)
}
