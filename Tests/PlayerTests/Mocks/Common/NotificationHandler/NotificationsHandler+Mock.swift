import Foundation
@testable import Player

extension NotificationsHandler {
	static func mock(
		listener: PlayerListener = PlayerListenerMock(),
		queue: DispatchQueue = DispatchQueue(label: "com.tidal.queue.for.testing")
	) -> NotificationsHandler {
		NotificationsHandler(listener: listener, queue: queue)
	}
}
