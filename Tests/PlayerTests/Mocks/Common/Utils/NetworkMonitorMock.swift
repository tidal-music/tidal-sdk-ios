@testable import Player

final class NetworkMonitorMock: NetworkMonitor {
	var networkType: NetworkType = .MOBILE

	override func getNetworkType() -> NetworkType {
		networkType
	}
}
