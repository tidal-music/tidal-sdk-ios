import Foundation

// MARK: - OfflineEngine

public final class OfflineEngine {
	private let downloader: Downloader
	private let storage: Storage
	private let playerEventSender: PlayerEventSender

	private weak var offlinerDelegate: OfflinerDelegate?

	init(downloader: Downloader, offlineStorage: Storage, playerEventSender: PlayerEventSender) {
		self.downloader = downloader
		storage = offlineStorage
		self.playerEventSender = playerEventSender
		self.downloader.setObserver(observer: self)
	}

	public func offline(mediaProduct: MediaProduct) -> Bool {
		guard let item = storage.get(mediaProduct: mediaProduct) else {
			offlinerDelegate?.offlineStarted(for: mediaProduct)
			downloader.download(mediaProduct: mediaProduct, sessionType: .DOWNLOAD)
			return true
		}

		if item.state() != .OFFLINED_AND_VALID {
			storage.delete(mediaProduct: mediaProduct)
			offlinerDelegate?.offlineStarted(for: mediaProduct)
			downloader.download(mediaProduct: mediaProduct, sessionType: .PLAYBACK)
			return true
		}

		return false
	}

	public func deleteOffline(mediaProduct: MediaProduct) -> Bool {
		guard let storageItem = storage.get(mediaProduct: mediaProduct) else {
			return false
		}

		delete(storageItem: storageItem)
		return true
	}

	public func deleteAllOfflines() -> Bool {
		storage.clear()
		offlinerDelegate?.allOfflinesDeleted()
		return true
	}

	public func getOfflineState(mediaProduct: MediaProduct) -> OfflineState {
		storage.get(mediaProduct: mediaProduct)?.state() ?? .NOT_OFFLINED
	}

	public func setOfflinerDelegate(_ offlinerDelegate: OfflinerDelegate) {
		self.offlinerDelegate = offlinerDelegate
	}
}

// MARK: DownloadObserver

extension OfflineEngine: DownloadObserver {
	func handle(streamingMetricsEvent: any StreamingMetricsEvent) {
		playerEventSender.send(streamingMetricsEvent)
	}

	func downloadCompleted(for mediaProduct: MediaProduct, storageItem: StorageItem) {
		storage.store(storageItem: storageItem)
		offlinerDelegate?.offlineDone(for: mediaProduct)
	}

	func downloadFailed(for mediaProduct: MediaProduct, with error: Error) {
		offlinerDelegate?.offlineFailed(for: mediaProduct)
	}

	func downloadProgress(for mediaProduct: MediaProduct, is percentage: Double) {
		offlinerDelegate?.offlineProgress(for: mediaProduct, is: percentage)
	}
}

private extension OfflineEngine {
	func delete(storageItem: StorageItem) {
		let mediaProduct = MediaProduct(
			productType: storageItem.productType,
			productId: storageItem.productId
		)

		guard let mediaUrl = storageItem.mediaUrl, let licenseUrl = storageItem.licenseUrl else {
			return
		}

		do {
			let fileManager = PlayerWorld.fileManagerClient
			try fileManager.removeItem(at: mediaUrl)
			try fileManager.removeItem(at: licenseUrl)
			storage.delete(mediaProduct: mediaProduct)
		} catch {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.deleteOfflinedItem(error: error))
			print("Failed to remove item: \(error)")
		}
	}
}
