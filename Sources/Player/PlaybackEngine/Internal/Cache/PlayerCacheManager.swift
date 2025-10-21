import AVFoundation
import Foundation

// MARK: - Protocols

public protocol PlayerCacheManagerDelegate: AnyObject {
	func playerCacheManager(
		_ manager: PlayerCacheManaging,
		didFinishDownloading urlAsset: AVURLAsset,
		to location: URL,
		for cacheKey: String
	)
}

public protocol PlayerCacheManaging: AnyObject {
	var delegate: PlayerCacheManagerDelegate? { get set }

	func prepareCache(isEnabled: Bool)
	func resolveAsset(for url: URL, cacheKey: String?) -> PlayerCacheResult
	func startCachingIfNeeded(_ urlAsset: AVURLAsset, cacheState: AssetCacheState?)
	func cancelDownload(for cacheKey: String)
	func reset()
}

// MARK: - Result

public struct PlayerCacheResult {
	public let urlAsset: AVURLAsset
	public let cacheState: AssetCacheState?

	public init(urlAsset: AVURLAsset, cacheState: AssetCacheState?) {
		self.urlAsset = urlAsset
		self.cacheState = cacheState
	}
}

// MARK: - PlayerCacheManager

public final class PlayerCacheManager: PlayerCacheManaging {
	public weak var delegate: PlayerCacheManagerDelegate?

    private let assetFactory: AVURLAssetFactory
    private let storageDirectory: URL

    public init(storageDirectory: URL? = nil) {
        let resolvedDirectory = storageDirectory ?? PlayerWorld.fileManagerClient.cachesDirectory()
        self.storageDirectory = resolvedDirectory

        let assetCache = AssetCache(storageDirectory: resolvedDirectory)
        assetFactory = AVURLAssetFactory(assetCache: assetCache)
        self.assetFactory.delegate = self
    }

	public func prepareCache(isEnabled: Bool) {
		if !isEnabled {
			assetFactory.clearCache()
		}
	}

	public func resolveAsset(for url: URL, cacheKey: String?) -> PlayerCacheResult {
		guard let cacheKey else {
			return PlayerCacheResult(
				urlAsset: AVURLAsset(
					url: url,
					options: [AVURLAssetPreferPreciseDurationAndTimingKey: url.isFileURL]
				),
				cacheState: nil
			)
		}

		var cacheState = assetFactory.get(with: cacheKey)
		let urlAsset: AVURLAsset

		switch cacheState {
		case .none:
			urlAsset = AVURLAsset(
				url: url,
				options: [AVURLAssetPreferPreciseDurationAndTimingKey: url.isFileURL]
			)
		case let .some(state):
			switch state.status {
			case .notCached:
				urlAsset = AVURLAsset(url: url)
				cacheState = state
			case let .cached(cachedURL):
				let cachedAsset = AVURLAsset(url: cachedURL)
				if cachedAsset.isPlayableOffline {
					urlAsset = cachedAsset
					cacheState = state
				} else {
					assetFactory.delete(state.key)
					let fallbackState = AssetCacheState(key: state.key, status: .notCached)
					cacheState = fallbackState
					urlAsset = AVURLAsset(url: url)
				}
			}
		}

		return PlayerCacheResult(urlAsset: urlAsset, cacheState: cacheState)
	}

	public func startCachingIfNeeded(_ urlAsset: AVURLAsset, cacheState: AssetCacheState?) {
		guard let cacheState else {
			return
		}

		switch cacheState.status {
		case .notCached:
			assetFactory.cacheAsset(urlAsset, for: cacheState.key)
		case .cached:
			break
		}
	}

	public func cancelDownload(for cacheKey: String) {
		assetFactory.cancel(with: cacheKey)
	}

	public func reset() {
		assetFactory.reset()
	}
}

// MARK: - AssetFactoryDelegate

extension PlayerCacheManager: AssetFactoryDelegate {
	func assetFinishedDownloading(_ urlAsset: AVURLAsset, to location: URL, for cacheKey: String) {
		delegate?.playerCacheManager(
			self,
			didFinishDownloading: urlAsset,
			to: location,
			for: cacheKey
		)
	}
}
