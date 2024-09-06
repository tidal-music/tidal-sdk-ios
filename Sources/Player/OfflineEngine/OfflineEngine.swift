import Foundation

// MARK: - OfflineEngine

public final class OfflineEngine {
	private let downloader: Downloader
	private let offlineStorage: OfflineStorage
	private let playerEventSender: PlayerEventSender

	private weak var offlinerDelegate: OfflinerDelegate?

	init(downloader: Downloader, offlineStorage: OfflineStorage, playerEventSender: PlayerEventSender) {
		self.downloader = downloader
		self.offlineStorage = offlineStorage
		self.playerEventSender = playerEventSender
		self.downloader.setObserver(observer: self)
	}

	public func offline(mediaProduct: MediaProduct) -> Bool {
		guard let offlineEntry = try? offlineStorage.get(key: mediaProduct.productId) else {
			offlinerDelegate?.offlineStarted(for: mediaProduct)
			downloader.download(mediaProduct: mediaProduct, sessionType: .DOWNLOAD)
			return true
		}

		if offlineEntry.state != .OFFLINED_AND_VALID {
			delete(offlineEntry: offlineEntry)
			downloader.download(mediaProduct: mediaProduct, sessionType: .PLAYBACK)
			return true
		}

		return false
	}

	public func deleteOffline(mediaProduct: MediaProduct) -> Bool {
		guard let offlineEntry = try? offlineStorage.get(key: mediaProduct.productId) else {
			return false
		}

		delete(offlineEntry: offlineEntry)
		return true
	}

	public func deleteAllOfflines() -> Bool {
		downloader.cancellAll()
		try? offlineStorage.clear()
		offlinerDelegate?.allOfflinesDeleted()
		return true
	}

	public func getOfflineState(mediaProduct: MediaProduct) -> OfflineState {
		guard let offlineEntry = try? offlineStorage.get(key: mediaProduct.productId) else {
			return .NOT_OFFLINED
		}
		return offlineEntry.state.publicState
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

	func downloadStarted(for mediaProduct: MediaProduct) {
		offlinerDelegate?.offlineStarted(for: mediaProduct)
	}

	func downloadProgress(for mediaProduct: MediaProduct, is percentage: Double) {
		offlinerDelegate?.offlineProgress(for: mediaProduct, is: percentage)
	}

	func downloadCompleted(for mediaProduct: MediaProduct, offlineEntry: OfflineEntry) {
		do {
			try offlineStorage.save(offlineEntry)
			offlinerDelegate?.offlineDone(for: mediaProduct)
		} catch {
			print("Failed to save item: \(error)")
			offlinerDelegate?.offlineFailed(for: mediaProduct)
		}
	}

	func downloadFailed(for mediaProduct: MediaProduct, with error: Error) {
		offlinerDelegate?.offlineFailed(for: mediaProduct)
	}
}

private extension OfflineEngine {
	func delete(offlineEntry: OfflineEntry) {
		let mediaProduct = MediaProduct(
			productType: offlineEntry.productType,
			productId: offlineEntry.productId
		)
		guard 
			let mediaUrl = offlineEntry.mediaURL,
			let licenseUrl = offlineEntry.licenseURL
		else {
			return
		}

		do {
			let fileManager = PlayerWorld.fileManagerClient
			try fileManager.removeItem(at: mediaUrl)
			try fileManager.removeItem(at: licenseUrl)
			try offlineStorage.delete(key: mediaProduct.productId)
		} catch {
			print("Failed to remove item: \(error)")
		}
	}
}
