import Foundation
import Network

// MARK: - NetworkType

enum NetworkType: String {
	case ETHERNET
	case WIFI
	case MOBILE
	case OTHER
}

// MARK: - NetworkMonitor

class NetworkMonitor {
	@Atomic private var networkType: NetworkType

	private let queue: DispatchQueue
	private let monitor: NWPathMonitor

	init() {
		networkType = .OTHER

		queue = DispatchQueue(label: "com.tidal.player.networkmonitor")

		monitor = NWPathMonitor()
		monitor.pathUpdateHandler = { [weak self] in
			guard let self else {
				return
			}
			networkType = networkType(of: $0)
		}
		monitor.start(queue: queue)
	}

	func getNetworkType() -> NetworkType {
		networkType
	}
}

private extension NetworkMonitor {
	func networkType(of path: NWPath) -> NetworkType {
		if path.usesInterfaceType(.wiredEthernet) {
			return .ETHERNET
		}

		if path.usesInterfaceType(.wifi) {
			return .WIFI
		}

		if path.usesInterfaceType(.cellular) {
			return .MOBILE
		}

		return .OTHER
	}
}
