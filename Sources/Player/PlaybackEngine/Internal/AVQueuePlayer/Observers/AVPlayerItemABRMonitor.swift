import AVFoundation
import Foundation

final class AVPlayerItemABRMonitor {
	private weak var playerItem: AVPlayerItem?
	private let qualities: [AudioQuality]
	private let queue: OperationQueue
	private let onQualityChanged: (AudioQuality) -> Void
	private var observation: NSObjectProtocol?
	private var lastReportedQuality: AudioQuality?

	init(
		playerItem: AVPlayerItem,
		qualities: [AudioQuality],
		queue: OperationQueue,
		onQualityChanged: @escaping (AudioQuality) -> Void
	) {
		self.playerItem = playerItem
		self.qualities = qualities
		self.queue = queue
		self.onQualityChanged = onQualityChanged

		observation = NotificationCenter.default.addObserver(
			forName: AVPlayerItem.newAccessLogEntryNotification,
			object: playerItem,
			queue: nil
		) { [weak self] _ in
			self?.handleAccessLog()
		}

		handleAccessLog()
	}

	deinit {
		if let observation {
			NotificationCenter.default.removeObserver(observation)
		}
	}

	private func handleAccessLog() {
		guard let item = playerItem,
		      let event = item.accessLog()?.events.last,
		      let quality = Self.map(
		      	indicatedBitrate: event.indicatedBitrate,
		      	availableQualities: qualities
		      )
		else {
			return
		}

		guard quality != lastReportedQuality else {
			return
		}

		lastReportedQuality = quality

		queue.dispatch { [weak self] in
			self?.onQualityChanged(quality)
		}
	}

	private static func map(
		indicatedBitrate: Double,
		availableQualities: [AudioQuality]
	) -> AudioQuality? {
		guard indicatedBitrate > 0 else {
			return nil
		}

		return availableQualities.min { lhs, rhs in
			abs(indicatedBitrate - lhs.typicalBitrate) < abs(indicatedBitrate - rhs.typicalBitrate)
		}
	}
}
