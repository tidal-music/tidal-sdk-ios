import Foundation
@testable import Player

extension NotificationsHandler {
	static func mock(
		listener: PlayerListener = PlayerListenerMock(),
		offlineEngineListener: OfflineEngineListener = OfflineEngineListenerMock(),
		queue: DispatchQueue = DispatchQueue(label: "com.tidal.queue.for.testing")
	) -> NotificationsHandler {
		NotificationsHandler(
			listener: listener,
			offlineEngineListener: offlineEngineListener,
			queue: queue
		)
	}
}
