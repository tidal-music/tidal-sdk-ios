import AVFoundation
import Foundation

final class AVPlayerItemABRMonitor {
	private weak var playerItem: AVPlayerItem?
	private let qualities: [AudioQuality]
	private let queue: OperationQueue
	private let onQualityChanged: (AudioQuality) -> Void
	private var mediaSelectionObservation: NSKeyValueObservation?
	private var accessLogObservation: NSObjectProtocol?
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

		// Primary method: observe currentMediaSelection changes (iOS 9+)
		// Use .old and .new to detect actual changes and avoid redundant processing
		mediaSelectionObservation = playerItem.observe(
			\.currentMediaSelection,
			options: [.old, .new]
		) { [weak self] item, change in
			// Only process if the selection actually changed
			guard let oldSelection = change.oldValue,
			      let newSelection = change.newValue,
			      oldSelection != newSelection
			else {
				// On initial observation, oldValue will be nil, so process it
				if change.oldValue == nil {
					self?.handleMediaSelectionChange(item: item)
				}
				return
			}
			self?.handleMediaSelectionChange(item: item)
		}

		// Fallback method: observe access log for bitrate-based detection
		// This handles cases where media selection doesn't provide quality info
		accessLogObservation = NotificationCenter.default.addObserver(
			forName: AVPlayerItem.newAccessLogEntryNotification,
			object: playerItem,
			queue: nil
		) { [weak self] _ in
			self?.handleAccessLog()
		}
	}

	deinit {
		mediaSelectionObservation?.invalidate()
		if let accessLogObservation {
			NotificationCenter.default.removeObserver(accessLogObservation)
		}
	}

	/// Primary quality detection method using currentMediaSelection.
	/// This reads the NAME attribute from HLS #EXT-X-MEDIA tags.
	private func handleMediaSelectionChange(item: AVPlayerItem) {
		guard let asset = item.asset as? AVURLAsset else {
			return
		}

		// Get the audio media selection group
		let mediaCharacteristics = asset.availableMediaCharacteristicsWithMediaSelectionOptions
		guard mediaCharacteristics.contains(.audible) else {
			return
		}

		guard let audioGroup = asset.mediaSelectionGroup(forMediaCharacteristic: .audible) else {
			return
		}

		// Get the currently selected audio option
		let selection = item.currentMediaSelection
		guard let selectedOption = selection.selectedMediaOption(in: audioGroup) else {
			return
		}

		// Try to parse quality from the display name (NAME attribute in HLS manifest)
		if let quality = Self.parseQualityFromMediaOption(selectedOption, availableQualities: qualities) {
			reportQuality(quality)
		}
		// If we can't determine quality from media selection, fall back to bitrate detection
	}

	/// Fallback quality detection method using access log bitrate matching.
	/// Used when currentMediaSelection doesn't provide quality information.
	private func handleAccessLog() {
		// Only use bitrate fallback if we haven't detected quality via media selection
		guard lastReportedQuality == nil else {
			return
		}

		guard let item = playerItem,
		      let event = item.accessLog()?.events.last,
		      let quality = Self.mapBitrateToQuality(
		      	indicatedBitrate: event.indicatedBitrate,
		      	availableQualities: qualities
		      )
		else {
			return
		}

		reportQuality(quality)
	}

	/// Reports a quality change if it differs from the last reported quality.
	private func reportQuality(_ quality: AudioQuality) {
		guard quality != lastReportedQuality else {
			return
		}

		lastReportedQuality = quality

		queue.dispatch { [weak self] in
			self?.onQualityChanged(quality)
		}
	}

	/// Parses AudioQuality from AVMediaSelectionOption by checking its displayName.
	/// Expected names match AudioQuality enum cases: "LOW", "HIGH", "LOSSLESS", "HI_RES", "HI_RES_LOSSLESS"
	private static func parseQualityFromMediaOption(
		_ option: AVMediaSelectionOption,
		availableQualities: [AudioQuality]
	) -> AudioQuality? {
		// Try displayName first (this is what HLS NAME attribute maps to)
		let displayName = option.displayName.uppercased()

		// Direct mapping from NAME to AudioQuality enum
		let qualityMap: [String: AudioQuality] = [
			"LOW": .LOW,
			"HIGH": .HIGH,
			"LOSSLESS": .LOSSLESS,
			"HI_RES": .HI_RES,
			"HI_RES_LOSSLESS": .HI_RES_LOSSLESS,
		]

		if let quality = qualityMap[displayName], availableQualities.contains(quality) {
			return quality
		}

		// Fallback: check if displayName contains the quality string
		for quality in availableQualities where displayName.contains(quality.rawValue) {
			return quality
		}

		return nil
	}

	/// Legacy bitrate-based quality mapping (fallback).
	/// Maps indicatedBitrate to the closest available AudioQuality by comparing typical bitrates.
	private static func mapBitrateToQuality(
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
