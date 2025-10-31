import AVFoundation
import Foundation

// MARK: - AssetFactoryDelegate

protocol AssetFactoryDelegate: AnyObject {
	func assetFinishedDownloading(_ urlAsset: AVURLAsset, to location: URL, for cacheKey: String)
}

// MARK: - AVURLAssetFactory

final class AVURLAssetFactory: NSObject {
	private static let TTL: Int = 24 * 60 * 60

	private let assetCache: AssetCache

	private var downloads: [Download] = [Download]()
	private lazy var uuid: String = PlayerWorld.uuidProvider.uuidString()

	weak var delegate: AssetFactoryDelegate?

	private lazy var session: AVAssetDownloadURLSession = AVAssetDownloadURLSession(
		configuration: URLSessionConfiguration.background(withIdentifier: "com.tidal.player.hls-cache-\(uuid)"),
		assetDownloadDelegate: self,
		delegateQueue: nil
	)

	init(
		assetCache: AssetCache = AssetCache()
	) {
		self.assetCache = assetCache
	}

	func get(with cacheKey: String?) -> AssetCacheState? {
		guard let cacheKey else {
			return nil
		}

		let state = assetCache.get(cacheKey)
		switch state.status {
		case .notCached:
			return state
		case let .cached(cachedURL: cachedURL):
			guard cachedURL.isFileURL, FileManager.default.fileExists(atPath: cachedURL.path) else {
				assetCache.delete(cacheKey)
				return AssetCacheState(key: cacheKey, status: .notCached)
			}

			updateDownloadPolicy(for: cachedURL)
			return AssetCacheState(key: cacheKey, status: state.status)
		}
	}

	func delete(_ cacheKey: String) {
		assetCache.delete(cacheKey)
	}

	func cacheAsset(_ urlAsset: AVURLAsset, for cacheKey: String) {
		downloadAsset(with: urlAsset, for: cacheKey)
	}

	func cancel(with cacheKey: String) {
		guard let download = downloads.first(where: { $0.identifier == cacheKey }) else {
			return
		}
		download.task.cancel()
	}

	func reset() {
		downloads.forEach { $0.task.cancel() }
	}

	func clearCache() {
		// TODO: This can't be implemented until we fully fix caching in a later PR
	}
}

private extension AVURLAssetFactory {
	func downloadAsset(with urlAsset: AVURLAsset, for cacheKey: String) {
		let title = "track-cached-\(cacheKey)"
		guard let task = session.makeAssetDownloadTask(
			asset: urlAsset,
			assetTitle: title,
			assetArtworkData: nil
		) else {
			return
		}

		downloads.append(Download(with: cacheKey, and: task))

		task.resume()
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

		defer {
			downloads.removeAll(where: { $0 === download })
		}

		if let url = download.url {
			if download.isComplete() {
				assetCache.set(url, with: download.identifier)
				updateDownloadPolicy(for: url)
				delegate?.assetFinishedDownloading(
					download.task.urlAsset,
					to: url,
					for: download.identifier
				)
			} else {
				assetCache.deleteFile(at: url)
			}
		}
	}

	func urlSession(
		_ session: URLSession,
		assetDownloadTask: AVAssetDownloadTask,
		didFinishDownloadingTo location: URL
	) {
		guard let download = downloads.first(where: { $0.task == assetDownloadTask }) else {
			return
		}
		download.url = location
	}
}

// MARK: - Download

private final class Download {
	let identifier: String
	let task: AVAssetDownloadTask
	var url: URL?

	init(with identifier: String, and task: AVAssetDownloadTask) {
		self.identifier = identifier
		self.task = task
	}

	func isComplete() -> Bool {
		task.urlAsset.isPlayableOffline
	}
}
