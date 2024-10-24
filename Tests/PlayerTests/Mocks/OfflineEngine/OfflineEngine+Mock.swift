import Foundation
@testable import Player

extension OfflineEngine {
	static func mock(
		downloader: Downloader = .mock(),
		storage: OfflineStorage,
		playerEventSender: PlayerEventSender = PlayerEventSenderMock(),
		notificationsHandler: NotificationsHandler = .mock()
	) -> OfflineEngine {
		OfflineEngine(
			downloader: downloader,
			offlineStorage: storage,
			playerEventSender: playerEventSender,
			notificationsHandler: notificationsHandler
		)
	}
}
