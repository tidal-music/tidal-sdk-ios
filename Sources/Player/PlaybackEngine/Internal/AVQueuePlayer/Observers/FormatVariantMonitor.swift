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

		print("[FormatVariantMonitor] Metadata output initialized for format tracking")
	}

	/// Tears down the metadata output when the monitor is deallocated
	private func teardownMetadataOutput() {
		if let output = metadataOutput, let item = playerItem {
			item.remove(output)
			print("[FormatVariantMonitor] Metadata output removed")
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
			print("[FormatVariantMonitor] Failed to extract format data from metadata")
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

		lastReportedFormat = formatMetadata
		print("[FormatVariantMonitor] Format changed: \(formatData)")

		onFormatChanged(formatMetadata)
	}

	/// Extracts format string from X-COM-TIDAL-FORMAT attribute or value
	private func extractFormatData(from metadataItem: AVMetadataItem) -> String? {
		// First, try to get the value directly (if it contains the format string)
		if let value = metadataItem.value as? String, !value.isEmpty {
			// Check if it looks like a format string (contains quality indicators)
			if value.contains("=") || value.contains(",") || !value.isEmpty {
				return value
			}
		}

		// Try to extract from commonKey or key
		if let commonKey = metadataItem.commonKey {
			print("[FormatVariantMonitor] Common key: \(commonKey)")
		}

		if let key = metadataItem.key {
			print("[FormatVariantMonitor] Key: \(key)")
		}

		// Try to get from extraAttributes (sometimes metadata stores custom attributes)
		if let extraAttributes = metadataItem.extraAttributes as? [String: Any] {
			if let format = extraAttributes["X-COM-TIDAL-FORMAT"] as? String {
				return format
			}
		}

		// If no explicit format string, try to construct from available metadata
		// This is a fallback for when format info is in different attributes
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
