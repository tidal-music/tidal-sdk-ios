import Foundation

final class NotificationsHandler {
	private let listener: PlayerListener
	private let offlineEngineListener: OfflineEngineListener?
	private let queue: DispatchQueue

	init(listener: PlayerListener, offlineEngineListener: OfflineEngineListener?, queue: DispatchQueue) {
		self.listener = listener
		self.offlineEngineListener = offlineEngineListener
		self.queue = queue
	}

	func stateChanged(to state: State) {
		queue.async {
			self.listener.stateChanged(to: state)
		}
	}

	func ended(_ playerItem: PlayerItem) {
		queue.async {
			self.listener.ended(playerItem.mediaProduct)
		}
	}

	func mediaTransitioned(to playerItem: PlayerItem?) {
		if let mediaProduct = playerItem?.mediaProduct, let playbackContext = playerItem?.playbackContext {
			queue.async {
				self.listener.mediaTransitioned(to: mediaProduct, with: playbackContext)
			}
		}
	}

	func streamingPrivilegesLost(to device: String?) {
		queue.async {
			self.listener.streamingPrivilegesLost(to: device)
		}
	}

	func failed(with error: PlayerError) {
		queue.async {
			self.listener.failed(with: error)
		}
	}

	func djSessionStarted(with metadata: DJSessionMetadata) {
		queue.async {
			self.listener.djSessionStarted(metadata)
		}
	}

	func djSessionEnded(with reason: DJSessionEndReason) {
		queue.async {
			self.listener.djSessionEnded(with: reason)
		}
	}

	func djSessionTransitioned(to transition: DJSessionTransition) {
		queue.async {
			self.listener.djSessionTransitioned(to: transition)
		}
	}

	func offliningStarted(for mediaProduct: MediaProduct) {
		queue.async {
			self.offlineEngineListener?.offliningStarted(for: mediaProduct)
		}
	}

	func offliningProgress(for mediaProduct: MediaProduct, is downloadPercentage: Double) {
		queue.async {
			self.offlineEngineListener?.offliningProgressed(for: mediaProduct, is: downloadPercentage)
		}
	}

	func offliningCompleted(for mediaProduct: MediaProduct) {
		queue.async {
			self.offlineEngineListener?.offliningCompleted(for: mediaProduct)
		}
	}

	func offliningFailed(for mediaProduct: MediaProduct) {
		queue.async {
			self.offlineEngineListener?.offliningFailed(for: mediaProduct)
		}
	}

	func offlinedDeleted(for mediaProduct: MediaProduct) {
		queue.async {
			self.offlineEngineListener?.offlinedDeleted(for: mediaProduct)
		}
	}

	func allOfflinedMediaProductsDeleted() {
		queue.async {
			self.offlineEngineListener?.allOfflinedMediaProductsDeleted()
		}
	}
}
