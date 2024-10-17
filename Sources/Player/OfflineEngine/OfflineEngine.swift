import Foundation

// MARK: - OfflineEngine

public final class OfflineEngine {
	private let downloader: Downloader
	private let offlineStorage: OfflineStorage
	private let playerEventSender: PlayerEventSender

	@Atomic private var notificationsHandler: NotificationsHandler?

	init(
		downloader: Downloader,
		offlineStorage: OfflineStorage,
		playerEventSender: PlayerEventSender,
		notificationsHandler: NotificationsHandler
	) {
		self.downloader = downloader
		self.offlineStorage = offlineStorage
		self.playerEventSender = playerEventSender
		self.notificationsHandler = notificationsHandler
		self.downloader.setObserver(observer: self)
	}

	public func offline(mediaProduct: MediaProduct) -> Bool {
		guard let offlineEntry = try? offlineStorage.get(key: mediaProduct.productId) else {
			notificationsHandler?.offliningStarted(for: mediaProduct)
			downloader.download(mediaProduct: mediaProduct, sessionType: .DOWNLOAD)
			return true
		}

		guard offlineEntry.state == .OFFLINED_AND_VALID else {
			delete(offlineEntry: offlineEntry)
			notificationsHandler?.offliningStarted(for: mediaProduct)
			downloader.download(mediaProduct: mediaProduct, sessionType: .DOWNLOAD)
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

	public func deleteAllOfflinedMediaProducts() -> Bool {
		downloader.cancellAll()
		try? offlineStorage.clear()
		notificationsHandler?.allOfflinedMediaProductsDeleted()
		return true
	}

	public func getOfflineState(mediaProduct: MediaProduct) -> OfflineState {
		guard let offlineEntry = try? offlineStorage.get(key: mediaProduct.productId) else {
			return .NOT_OFFLINED
		}
		return offlineEntry.state.publicState
	}
}

// MARK: DownloadObserver

extension OfflineEngine: DownloadObserver {
	func handle(streamingMetricsEvent: any StreamingMetricsEvent) {
		playerEventSender.send(streamingMetricsEvent)
	}

	func downloadStarted(for mediaProduct: MediaProduct) {
		notificationsHandler?.offliningStarted(for: mediaProduct)
	}

	func downloadProgress(for mediaProduct: MediaProduct, is percentage: Double) {
		notificationsHandler?.offliningProgress(for: mediaProduct, is: percentage)
	}

	func downloadCompleted(for mediaProduct: MediaProduct, offlineEntry: OfflineEntry) {
		do {
			try offlineStorage.save(offlineEntry)
			notificationsHandler?.offliningCompleted(for: mediaProduct)
		} catch {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.saveOfflinedItemFailed(error: error))
			notificationsHandler?.offliningFailed(for: mediaProduct)
		}
	}

	func downloadFailed(for mediaProduct: MediaProduct, with error: Error) {
		notificationsHandler?.offliningFailed(for: mediaProduct)
	}
}

private extension OfflineEngine {
	func delete(offlineEntry: OfflineEntry) {
		do {
			let fileManager = PlayerWorld.fileManagerClient
			if let mediaURL = offlineEntry.mediaURL {
				try? fileManager.removeItem(at: mediaURL)
			}
			if let licenseURL = offlineEntry.licenseURL {
				try? fileManager.removeItem(at: licenseURL)
			}
			try offlineStorage.delete(key: offlineEntry.productId)
			let mediaProduct = MediaProduct(productType: offlineEntry.productType, productId: offlineEntry.productId)
			notificationsHandler?.offlinedDeleted(for: mediaProduct)
		} catch {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.deleteOfflinedItemFailed(error: error))
		}
	}
}
