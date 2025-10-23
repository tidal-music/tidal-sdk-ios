import AVFoundation
@testable import Player

final class PlayerItemMonitorMock: PlayerItemMonitor {
	struct FailedItem {
		let playerItemId: String
		let error: Error
	}

	private(set) var loadedItems = [String]()
	private(set) var playingItems = [String]()
	private(set) var pausedItems = [String]()
	private(set) var stalledItems = [String]()
	private(set) var downloadedItems = [String]()
	private(set) var completedItems = [String]()
	private(set) var failedItems = [FailedItem]()
	private(set) var playbackMetadataLoadedItems = [String]()

	func loaded(playerItem: PlayerItem) {
		loadedItems.append(playerItem.id)
	}

	func playing(playerItem: PlayerItem) {
		playingItems.append(playerItem.id)
	}

	func paused(playerItem: PlayerItem) {
		pausedItems.append(playerItem.id)
	}

	func stalled(playerItem: PlayerItem) {
		stalledItems.append(playerItem.id)
	}

	func downloaded(playerItem: PlayerItem) {
		downloadedItems.append(playerItem.id)
	}

	func completed(playerItem: PlayerItem) {
		completedItems.append(playerItem.id)
	}

	func failed(playerItem: PlayerItem, with error: Error) {
		failedItems.append(FailedItem(playerItemId: playerItem.id, error: error))
	}

	func playbackMetadataLoaded(playerItem: PlayerItem) {
		playbackMetadataLoadedItems.append(playerItem.id)
	}
}
