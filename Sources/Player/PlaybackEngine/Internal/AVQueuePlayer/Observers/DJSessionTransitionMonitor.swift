import AVFoundation
import Foundation

// MARK: - DJSessionTransitionMonitor

final class DJSessionTransitionMonitor: NSObject, AVPlayerItemMetadataCollectorPushDelegate {
	private static let PERIOD_METADATA_CLASS_VALUE = "com.tidal.period.metadata"
	private static let X_COM_TIDAL_PRODUCT_ID = AVMetadataItem.identifier(
		forKey: "X-COM-TIDAL-PRODUCT-ID",
		keySpace: .hlsDateRange
	)!
	private static let X_COM_TIDAL_STATUS = AVMetadataItem.identifier(forKey: "X-COM-TIDAL-STATUS", keySpace: .hlsDateRange)!

	private let playerItem: AVPlayerItem
	private let queue: DispatchQueue
	private let onTransition: (AVPlayerItem, DJSessionTransition) -> Void
	private let metadataCollector: AVPlayerItemMetadataCollector

	init(
		with playerItem: AVPlayerItem,
		and queue: DispatchQueue,
		onTransition: @escaping (AVPlayerItem, DJSessionTransition) -> Void
	) {
		self.playerItem = playerItem
		self.queue = queue
		self.onTransition = onTransition

		metadataCollector = AVPlayerItemMetadataCollector()
		super.init()
		metadataCollector.setDelegate(self, queue: queue)
		playerItem.add(metadataCollector)
	}

	func metadataCollector(
		_ metadataCollector: AVPlayerItemMetadataCollector,
		didCollect metadataGroups: [AVDateRangeMetadataGroup],
		indexesOfNewGroups: IndexSet,
		indexesOfModifiedGroups: IndexSet
	) {
		guard let playerTime = playerItem.currentDate()?.timeIntervalSince1970 else {
			return
		}

		indexesOfNewGroups.map { metadataGroups[$0] }.forEach { self.handle($0, currentTime: playerTime) }
	}
}

private extension DJSessionTransitionMonitor {
	func handle(_ metadataGroup: AVDateRangeMetadataGroup, currentTime: Double) {
		guard metadataGroup.classifyingLabel == DJSessionTransitionMonitor.PERIOD_METADATA_CLASS_VALUE else {
			return
		}

		let metadataStartTime = metadataGroup.startDate.timeIntervalSince1970
		let offset = Int(max(0, metadataStartTime - currentTime))

		queue.asyncAfter(deadline: .now() + .seconds(offset)) { [weak self] in
			guard let self else {
				return
			}

			let status = metadataGroup.items
				.first(where: { $0.identifier == DJSessionTransitionMonitor.X_COM_TIDAL_STATUS })?.stringValue
				.flatMap { DJSessionStatus(rawValue: $0) }

			let mediaProduct = metadataGroup.items
				.first(where: { $0.identifier == DJSessionTransitionMonitor.X_COM_TIDAL_PRODUCT_ID })?.stringValue
				.map { MediaProduct(productType: .TRACK, productId: $0) }

			if let status, let mediaProduct {
				onTransition(playerItem, DJSessionTransition(status: status, mediaProduct: mediaProduct))
			}
		}
	}
}
