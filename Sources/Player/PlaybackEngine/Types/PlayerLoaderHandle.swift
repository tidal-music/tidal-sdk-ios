import Foundation

public struct PlayerLoaderHandle {
	public let product: MediaProduct
	public let isCancelled: Bool = false

	private(set) var player: PlayerEngine

	public func cancel() {
		player.notificationsHandler = nil
		player.currentItem?.unload()
		player.reset()
	}
}
