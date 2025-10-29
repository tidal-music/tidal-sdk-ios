import AVFoundation
import Foundation

/// Monitors format variant switches in HLS streams using timed metadata.
/// Observes ext-x-daterange metadata with "com.tidal.format" identifier
/// to detect ABR variant changes and extract format details.
final class FormatVariantMonitor: NSObject, AVPlayerItemMetadataOutputPushDelegate {
	private weak var playerItem: AVPlayerItem?
	private var metadataOutput: AVPlayerItemMetadataOutput?
	private let onFormatChanged: (FormatVariantMetadata) -> Void
	private var lastReportedFormat: FormatVariantMetadata?

	// Metadata identifier for Tidal format information
	private static let formatMetadataIdentifier = AVMetadataIdentifier(rawValue: "com.tidal.format")

	init(
		playerItem: AVPlayerItem,
		onFormatChanged: @escaping (FormatVariantMetadata) -> Void
	) {
		self.playerItem = playerItem
		self.onFormatChanged = onFormatChanged
		super.init()

		setupMetadataOutput(for: playerItem)
	}

	deinit {
		teardownMetadataOutput()
	}

	/// Sets up the AVPlayerItemMetadataOutput to observe timed metadata
	private func setupMetadataOutput(for playerItem: AVPlayerItem) {
		// Create metadata output configured for common metadata identifier schemes
		let metadataOutput = AVPlayerItemMetadataOutput(identifiers: [Self.formatMetadataIdentifier.rawValue])
		metadataOutput.setDelegate(self, queue: DispatchQueue.main)

		// Add the metadata output to the player item
		playerItem.add(metadataOutput)
		self.metadataOutput = metadataOutput

		PlayerWorld.logger?.log(loggable: PlayerLoggable.formatVariantMonitorInitialized)
	}

	/// Tears down the metadata output when the monitor is deallocated
	private func teardownMetadataOutput() {
		if let output = metadataOutput, let item = playerItem {
			item.remove(output)
			PlayerWorld.logger?.log(loggable: PlayerLoggable.formatVariantMonitorRemoved)
		}
		metadataOutput = nil
	}

	// MARK: - AVPlayerItemMetadataOutputPushDelegate

	/// Called when new metadata is available
	func metadataOutput(
		_ output: AVPlayerItemMetadataOutput,
		didOutputTimedMetadataGroups groups: [AVTimedMetadataGroup],
		from track: AVPlayerItemTrack?
	) {
		for group in groups {
			for item in group.items {
				// Look for com.tidal.format identifier
				if item.identifier == Self.formatMetadataIdentifier {
					processFormatMetadata(item, timestamp: group.timeRange.start)
				}
			}
		}
	}

	/// Processes format metadata and reports changes
	private func processFormatMetadata(_ metadataItem: AVMetadataItem, timestamp: CMTime) {
		guard let formatData = extractFormatData(from: metadataItem) else {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.formatVariantExtractionFailed)
			return
		}

		let formatMetadata = FormatVariantMetadata(
			formatString: formatData,
			timestamp: timestamp
		)

		// Only report if format changed
		guard formatMetadata != lastReportedFormat else {
			return
		}

		let previousFormat = lastReportedFormat?.formatString
		lastReportedFormat = formatMetadata
		PlayerWorld.logger?.log(loggable: PlayerLoggable.formatVariantChanged(from: previousFormat, to: formatData))

		onFormatChanged(formatMetadata)
	}

	/// Extracts format string from X-COM-TIDAL-FORMAT attribute or value
	/// Supports multiple metadata formats:
	/// 1. Direct string value from metadataItem.value
	/// 2. X-COM-TIDAL-FORMAT from extraAttributes (AVFoundation dictionary)
	/// 3. Parsed from key-value pairs in dictionary representation
	private func extractFormatData(from metadataItem: AVMetadataItem) -> String? {
		// Strategy 1: Check if value is directly a format string
		if let value = metadataItem.value as? String, !value.isEmpty {
			let trimmed = value.trimmingCharacters(in: .whitespaces)
			// Valid format strings contain quality, codec, or attribute indicators
			if !trimmed.isEmpty {
				PlayerWorld.logger?.log(loggable: PlayerLoggable.formatVariantExtractedFromValue(format: trimmed))
				return trimmed
			}
		}

		// Strategy 2: Check if value is a dictionary with format attributes
		if let dictValue = metadataItem.value as? [String: Any] {
			if let format = dictValue["X-COM-TIDAL-FORMAT"] as? String {
				let trimmed = format.trimmingCharacters(in: .whitespaces)
				if !trimmed.isEmpty {
					PlayerWorld.logger?.log(loggable: PlayerLoggable.formatVariantExtractedFromDictionary(format: trimmed))
					return trimmed
				}
			}
		}

		// Strategy 3: Check extraAttributes for custom format attributes
		if let extraAttributes = metadataItem.extraAttributes as? [String: Any] {
			// Try common attribute names
			let attributeNames = ["X-COM-TIDAL-FORMAT", "x-com-tidal-format", "format", "FORMAT"]
			for attrName in attributeNames {
				if let format = extraAttributes[attrName] as? String {
					let trimmed = format.trimmingCharacters(in: .whitespaces)
					if !trimmed.isEmpty {
						PlayerWorld.logger?.log(loggable: PlayerLoggable.formatVariantExtractedFromAttributes(format: trimmed, attribute: attrName))
						return trimmed
					}
				}
			}
		}

		return nil
	}
}

// MARK: - FormatVariantMetadata

/// Metadata describing the format variant for an HLS stream segment
public struct FormatVariantMetadata: Equatable {
	public let formatString: String
	public let timestamp: CMTime

	public var description: String {
		"FormatVariantMetadata(format: \(formatString), time: \(timestamp.seconds)s)"
	}

	public init(formatString: String, timestamp: CMTime) {
		self.formatString = formatString
		self.timestamp = timestamp
	}
}
