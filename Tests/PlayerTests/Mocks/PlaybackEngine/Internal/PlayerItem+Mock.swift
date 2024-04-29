@testable import Player

extension PlayerItem {
	static func mock(
		startReason: StartReason = .EXPLICIT,
		mediaProduct: MediaProduct = MediaProduct.mock(),
		networkType: NetworkType = NetworkMonitorMock().getNetworkType(),
		outputDevice: String? = "",
		sessionType: SessionType = .PLAYBACK,
		playerItemMonitor: PlayerItemMonitor,
		playerEventSender: PlayerEventSender = PlayerEventSenderMock(),
		timestamp: UInt64 = 1,
		isPreload: Bool = false
	) -> PlayerItem {
		PlayerItem(
			startReason: startReason,
			mediaProduct: mediaProduct,
			networkType: networkType,
			outputDevice: outputDevice,
			sessionType: sessionType,
			playerItemMonitor: playerItemMonitor,
			playerEventSender: playerEventSender,
			timestamp: timestamp,
			isPreload: isPreload
		)
	}
}
