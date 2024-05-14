import AVFoundation
import Foundation

// MARK: - AVURLAssetFactory

final class AVURLAssetFactory: NSObject {
	private static let TTL: Int = 24 * 60 * 60

	private var downloads: [Download] = [Download]()

	private let queue: OperationQueue
	private let assetCache: AssetCache

	private lazy var session: AVAssetDownloadURLSession = AVAssetDownloadURLSession(
		configuration: URLSessionConfiguration.background(withIdentifier: "com.tidal.player.hls.cache"),
		assetDownloadDelegate: self,
		delegateQueue: queue
	)

	init(
		with queue: OperationQueue,
		assetCache: AssetCache = AssetCache()
	) {
		self.queue = queue
		self.assetCache = assetCache
	}

	func get(with cacheKey: String) -> AVURLAsset? {
		getAssetFromLocalStorage(with: cacheKey)
	}

	func create(using cacheKey: String, or url: URL) -> AVURLAsset {
		reset()
		return downloadAsset(with: url, and: cacheKey)
	}

	func reset() {
		downloads.forEach { $0.task.cancel() }
	}

	func clearCache() {
		// TODO: This can't be implemented until we fully fix caching in a later PR
	}
}

private extension AVURLAssetFactory {
	func getAssetFromLocalStorage(with cacheKey: String) -> AVURLAsset? {
		guard let url = assetCache.get(cacheKey) else {
			return nil
		}

		let asset = AVURLAsset(url: url)
		guard asset.isPlayableOffline else {
			assetCache.delete(cacheKey)
			return nil
		}

		updateDownloadPolicy(for: url)
		return asset
	}

	func downloadAsset(with url: URL, and cacheKey: String) -> AVURLAsset {
		let asset = AVURLAsset(url: url)

		let uuid = PlayerWorld.uuidProvider.uuidString()
		guard let task = session.aggregateAssetDownloadTask(
			with: asset,
			mediaSelections: asset.allMediaSelections,
			assetTitle: uuid,
			assetArtworkData: nil,
			options: [AVAssetDownloadTaskMinimumRequiredMediaBitrateKey: 0]
		) else {
			return asset
		}

		task.resume()

		downloads.append(Download(with: cacheKey, and: task))
		return task.urlAsset
	}

	func updateDownloadPolicy(for url: URL) {
		guard PlayerWorld.fileManagerClient.fileExistsAtPath(url.path) else {
			return
		}

		let newPolicy = AVMutableAssetDownloadStorageManagementPolicy()
		newPolicy.priority = .default
		newPolicy.expirationDate = Date(timeIntervalSinceNow: Double(AVURLAssetFactory.TTL))
		AVAssetDownloadStorageManager.shared().setStorageManagementPolicy(newPolicy, for: url)
	}
}

// MARK: AVAssetDownloadDelegate

extension AVURLAssetFactory: AVAssetDownloadDelegate {
	func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
		guard let download = downloads.first(where: { $0.task == task }) else {
			return
		}

		if let url = download.url, download.isComplete() {
			assetCache.set(url, with: download.identifier)
			updateDownloadPolicy(for: url)
		}

		downloads.removeAll(where: { $0 === download })
	}

	func urlSession(
		_ session: URLSession,
		aggregateAssetDownloadTask: AVAggregateAssetDownloadTask,
		willDownloadTo location: URL
	) {
		guard let download = downloads.first(where: { $0.task == aggregateAssetDownloadTask }) else {
			return
		}

		download.url = location
	}
}

// MARK: - Download

private final class Download {
	let identifier: String
	let task: URLSessionTask
	var url: URL?

	init(with identifier: String, and task: AVAggregateAssetDownloadTask) {
		self.identifier = identifier
		self.task = task
	}

	func isComplete() -> Bool {
		(task as? AVAggregateAssetDownloadTask).map { $0.urlAsset.isPlayableOffline } ?? false
	}
}

extension AVURLAsset {
	var isPlayableOffline: Bool {
		assetCache?.isPlayableOffline ?? false
	}
}
