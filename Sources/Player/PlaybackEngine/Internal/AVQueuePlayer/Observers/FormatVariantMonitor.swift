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
	private let onFormatChanged: (FormatVariantMetadata) -> Void
	private let queue: OperationQueue
	private var lastReportedFormat: FormatVariantMetadata?

	// Metadata identifier for Tidal format information
	private static let groupLabel = "com.tidal.format"

	// Cached whitespace character set for string trimming optimization
	private static let whitespaceCharacters = CharacterSet.whitespaces

	init(
		playerItem: AVPlayerItem,
		queue: OperationQueue,
		onFormatChanged: @escaping (FormatVariantMetadata) -> Void
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
	private func processFormatMetadata(_ metadataItem: AVMetadataItem) {
		guard let formatMetadata = extractFormatMetadata(from: metadataItem) else {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.formatVariantExtractionFailed)
			return
		}

		// Only report if format changed
		guard formatMetadata != lastReportedFormat else {
			return
		}

		let previousFormat = lastReportedFormat?.formatString
		lastReportedFormat = formatMetadata
		PlayerWorld.logger?.log(loggable: PlayerLoggable.formatVariantChanged(from: previousFormat, to: formatMetadata.formatString))

		// Dispatch callback through configured queue with playerItem validation
		// to prevent race conditions during player item deallocation
		queue.addOperation { [weak self] in
			guard let self = self, self.playerItem != nil else {
				return
			}
			self.onFormatChanged(formatMetadata)
		}
	}

	/// Extracts format string from X-COM-TIDAL-FORMAT attribute or value
	/// Supports multiple metadata formats:
	/// 1. Direct string value from metadataItem.value
	/// 2. X-COM-TIDAL-FORMAT from extraAttributes (AVFoundation dictionary)
	/// 3. Parsed from key-value pairs in dictionary representation
	private func extractFormatMetadata(from metadataItem: AVMetadataItem) -> FormatVariantMetadata? {
		// Strategy 1: Check if value is directly a format string
		if let value = metadataItem.value as? String, !value.isEmpty {
			let trimmed = value.trimmingCharacters(in: Self.whitespaceCharacters)
			// Valid format strings contain quality, codec, or attribute indicators
			if !trimmed.isEmpty {
				PlayerWorld.logger?.log(loggable: PlayerLoggable.formatVariantExtractedFromValue(format: trimmed))
				return FormatVariantMetadata(formatString: trimmed)
			}
		}

		// Strategy 2: Check if value is a dictionary with format attributes
		if let dictValue = metadataItem.value as? [String: Any] {
			if let format = dictValue["X-COM-TIDAL-FORMAT"] as? String {
				let trimmed = format.trimmingCharacters(in: Self.whitespaceCharacters)
				if !trimmed.isEmpty {
					PlayerWorld.logger?.log(loggable: PlayerLoggable.formatVariantExtractedFromDictionary(format: trimmed))
					return FormatVariantMetadata(formatString: trimmed)
				}
			}
		}

		// Strategy 3: Check extraAttributes for custom format attributes
		if let extraAttributes = metadataItem.extraAttributes as? [String: Any] {
			// Try common attribute names
			let attributeNames = ["X-COM-TIDAL-FORMAT", "x-com-tidal-format", "format", "FORMAT"]
			for attrName in attributeNames {
				if let format = extraAttributes[attrName] as? String {
					let trimmed = format.trimmingCharacters(in: Self.whitespaceCharacters)
					if !trimmed.isEmpty {
						PlayerWorld.logger?.log(loggable: PlayerLoggable.formatVariantExtractedFromAttributes(format: trimmed, attribute: attrName))
						return FormatVariantMetadata(formatString: trimmed)
					}
				}
			}
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
		metadataGroup.items.forEach { self.processFormatMetadata($0) }
	}
}

// MARK: - FormatVariantMetadata

/// Metadata describing the format variant for an HLS stream segment
public struct FormatVariantMetadata: Equatable {
	public let formatString: String

	public var description: String {
		"FormatVariantMetadata(format: \(formatString))"
	}

	public init(formatString: String) {
		self.formatString = formatString
	}

	/// Custom equality: compares only formatString to enable reliable deduplication
	public static func == (lhs: FormatVariantMetadata, rhs: FormatVariantMetadata) -> Bool {
		lhs.formatString == rhs.formatString
	}
}
