@testable import Player

extension AudioInfoProvider {
    static let mock: Self = AudioInfoProvider(
        isBluetoothOutputRoute: { false },
        isAirPlayOutputRoute: { false },
        isCarPlayOutputRoute: { false },
        currentOutputPortName: { "outputPortName" }
    )
}
