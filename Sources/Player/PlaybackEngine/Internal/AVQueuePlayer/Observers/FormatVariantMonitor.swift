import AVFoundation
import Foundation

/// Monitors format variant switches in HLS streams using timed metadata.
/// Observes ext-x-daterange metadata with "com.tidal.format" identifier
/// to detect ABR variant changes and extract format details.
///
/// This monitor dispatches callbacks through a provided OperationQueue to ensure
/// consistent threading behavior with other SDK observers. Callbacks are dispatched
/// asynchronously to avoid blocking metadata processing.
class FormatVariantMonitor: NSObject {
	private weak var playerItem: AVPlayerItem?
	private var metadataCollector: AVPlayerItemMetadataCollector?
	private let onFormatChanged: (AssetPlaybackMetadata) -> Void
	private let queue: OperationQueue
	private var lastReportedFormat: AssetPlaybackMetadata?

	// Metadata identifier for Tidal format information
	private static let groupLabel = "com.tidal.format"

	// Cached whitespace character set for string trimming optimization
	private static let whitespaceCharacters = CharacterSet.whitespaces

	init(
		playerItem: AVPlayerItem,
		queue: OperationQueue,
		onFormatChanged: @escaping (AssetPlaybackMetadata) -> Void
	) {
		self.playerItem = playerItem
		self.queue = queue
		self.onFormatChanged = onFormatChanged
		super.init()

		setupMetadataCollector(for: playerItem)
	}

	deinit {
		teardownMetadataCollector()
	}

	/// Sets up the AVPlayerItemMetadataOutput to observe timed metadata
	private func setupMetadataCollector(for playerItem: AVPlayerItem) {
		let metadataCollector = AVPlayerItemMetadataCollector()
		metadataCollector.setDelegate(self, queue: DispatchQueue.main)
		playerItem.add(metadataCollector)
		self.metadataCollector = metadataCollector
		
		PlayerWorld.logger?.log(loggable: PlayerLoggable.formatVariantMonitorInitialized)
	}

	/// Tears down the metadata output when the monitor is deallocated
	private func teardownMetadataCollector() {
		if let collector = metadataCollector, let item = playerItem {
			item.remove(collector)
			PlayerWorld.logger?.log(loggable: PlayerLoggable.formatVariantMonitorRemoved)
		}
		metadataCollector = nil
	}

	/// Processes format metadata and reports changes
	/// Dispatches callbacks through the configured OperationQueue with playerItem validation
	private func processFormatMetadata(_ formatMetadata: AssetPlaybackMetadata) {
		// Only report if format changed
		guard formatMetadata != lastReportedFormat else {
			return
		}

		let previousFormat = lastReportedFormat?.formatString
		lastReportedFormat = formatMetadata
		let currentFormat = formatMetadata.formatString ?? "unknown"
		PlayerWorld.logger?.log(loggable: PlayerLoggable.formatVariantChanged(from: previousFormat, to: currentFormat))

		// Dispatch callback through configured queue with playerItem validation
		// to prevent race conditions during player item deallocation
		queue.addOperation { [weak self] in
			guard let self = self, self.playerItem != nil else {
				return
			}
			self.onFormatChanged(formatMetadata)
		}
	}

	/// Extracts format metadata from all items in a metadata group
	/// Parses X-COM-TIDAL-FORMAT, X-COM-TIDAL-SAMPLE-RATE, and X-COM-TIDAL-SAMPLE-DEPTH
	/// from the metadata items in the group
	private func extractGroupFormatMetadata(from metadataGroup: AVDateRangeMetadataGroup) -> AssetPlaybackMetadata? {
		var formatString: String?
		var sampleRate: Int?
		var bitDepth: Int?

		// Process all items in the group to extract format, sample rate, and bit depth
		for item in metadataGroup.items {
			guard let key = item.key as? String else {
				continue
			}

			if key.contains("X-COM-TIDAL-FORMAT") {
				if let value = item.value as? String {
					let trimmed = value.trimmingCharacters(in: Self.whitespaceCharacters)
					if !trimmed.isEmpty {
						PlayerWorld.logger?.log(loggable: PlayerLoggable.formatVariantExtractedFromValue(format: trimmed))
						formatString = trimmed
					}
				}
			} else if key.contains("X-COM-TIDAL-SAMPLE-RATE") {
				if let value = item.value {
					sampleRate = parseIntValue(value)
				}
			} else if key.contains("X-COM-TIDAL-SAMPLE-DEPTH") {
				if let value = item.value {
					bitDepth = parseIntValue(value)
				}
			}
		}

		// Return metadata only if we extracted all required fields
		if let format = formatString,
		   let sr = sampleRate,
		   let bd = bitDepth {
			return AssetPlaybackMetadata(formatString: format, sampleRate: sr, bitDepth: bd)
		}

		return nil
	}

	/// Safely parses an integer value from various types (String, NSNumber, Int, etc.)
	private func parseIntValue(_ value: Any) -> Int? {
		if let intValue = value as? Int {
			return intValue
		}
		if let stringValue = value as? String {
			return Int(stringValue)
		}
		if let numberValue = value as? NSNumber {
			return numberValue.intValue
		}
		return nil
	}
}

// MARK: AVPlayerItemMetadataCollectorPushDelegate
extension FormatVariantMonitor: AVPlayerItemMetadataCollectorPushDelegate {
	func metadataCollector(
		_ metadataCollector: AVPlayerItemMetadataCollector,
		didCollect metadataGroups: [AVDateRangeMetadataGroup],
		indexesOfNewGroups: IndexSet,
		indexesOfModifiedGroups: IndexSet
	) {
		indexesOfNewGroups.map { metadataGroups[$0] }
			.filter { $0.classifyingLabel == Self.groupLabel }
			.forEach { self.handleMetadataGroup($0) }
	}
	
	func handleMetadataGroup(_ metadataGroup: AVDateRangeMetadataGroup) {
		guard let formatMetadata = extractGroupFormatMetadata(from: metadataGroup) else {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.formatVariantExtractionFailed)
			return
		}
		processFormatMetadata(formatMetadata)
	}
}

