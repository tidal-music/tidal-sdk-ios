import Foundation
import Logging

/// Structured logging events for cache operations.
/// Follows the pattern of existing PlayerLoggable and AuthLoggable enums.
enum CacheLoggable: TidalLoggable {
	case recordPlaybackFailed(cacheKey: String, error: Error)
	case persistCacheEntryFailed(cacheKey: String, error: Error)
	case calculateSizeFailed(url: URL, error: Error)
	case clearCacheFailed(error: Error)
	case deleteCacheFileFailed(fileName: String, error: Error)
	case pruningStarted(currentSize: Int, targetSize: Int)
	case pruningCompleted(newSize: Int, entriesRemoved: Int)
	case pruneFailed(error: Error)

	var loggingMessage: Logger.Message {
		switch self {
		case .recordPlaybackFailed(let cacheKey, _):
			return "Failed to record playback for cache key: \(cacheKey)"
		case .persistCacheEntryFailed(let cacheKey, _):
			return "Failed to persist cache entry: \(cacheKey)"
		case .calculateSizeFailed(let url, _):
			return "Failed to calculate cache entry size for: \(url.lastPathComponent)"
		case .clearCacheFailed:
			return "Failed to clear cache"
		case .deleteCacheFileFailed(let fileName, _):
			return "Failed to delete cache file: \(fileName)"
		case .pruningStarted(let current, let target):
			return "Cache quota exceeded. Pruning from \(current) to \(target) bytes"
		case .pruningCompleted(let newSize, let removed):
			return "Cache pruning completed. New size: \(newSize) bytes, removed: \(removed) entries"
		case .pruneFailed:
			return "Failed to prune cache to target size"
		}
	}

	var loggingMetadata: Logger.Metadata {
		switch self {
		case .recordPlaybackFailed(_, let error):
			return ["error": .string(error.localizedDescription)]
		case .persistCacheEntryFailed(_, let error):
			return ["error": .string(error.localizedDescription)]
		case .calculateSizeFailed(_, let error):
			return ["error": .string(error.localizedDescription)]
		case .clearCacheFailed(let error):
			return ["error": .string(error.localizedDescription)]
		case .deleteCacheFileFailed(_, let error):
			return ["error": .string(error.localizedDescription)]
		case .pruningStarted:
			return [:]
		case .pruningCompleted:
			return [:]
		case .pruneFailed(let error):
			return ["error": .string(error.localizedDescription)]
		}
	}

	var logLevel: Logger.Level {
		switch self {
		case .recordPlaybackFailed, .persistCacheEntryFailed, .calculateSizeFailed, .clearCacheFailed, .pruneFailed:
			return .error
		case .deleteCacheFileFailed:
			return .warning
		case .pruningStarted, .pruningCompleted:
			return .debug
		}
	}

	var source: String? {
		return "PlayerCacheManager"
	}
}
