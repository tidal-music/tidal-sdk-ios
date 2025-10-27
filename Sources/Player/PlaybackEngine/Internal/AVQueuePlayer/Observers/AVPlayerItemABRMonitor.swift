import AVFoundation
import Foundation

final class AVPlayerItemABRMonitor {
	private weak var playerItem: AVPlayerItem?
	private let queue: OperationQueue
	private let onQualityChanged: (AudioQuality) -> Void
	private var mediaSelectionObservation: NSKeyValueObservation?
	private var accessLogObservation: NSObjectProtocol?
	private var lastReportedQuality: AudioQuality?

	init(
		playerItem: AVPlayerItem,
		queue: OperationQueue,
		onQualityChanged: @escaping (AudioQuality) -> Void
	) {
		self.playerItem = playerItem
		self.queue = queue
		self.onQualityChanged = onQualityChanged

		// Observe currentMediaSelection changes (iOS 9+)
		// Use .old and .new to detect actual changes and avoid redundant processing
		mediaSelectionObservation = playerItem.observe(
			\.currentMediaSelection,
			options: [.old, .new, .initial]
		) { [weak self] item, change in
			print("[ABRMonitor] currentMediaSelection KVO triggered")
			print("[ABRMonitor] oldValue: \(String(describing: change.oldValue))")
			print("[ABRMonitor] newValue: \(String(describing: change.newValue))")

			// Only process if the selection actually changed
			guard let oldSelection = change.oldValue,
			      let newSelection = change.newValue,
			      oldSelection != newSelection
			else {
				print("[ABRMonitor] Selection check: oldValue=\(change.oldValue != nil), newValue=\(change.newValue != nil), equal=\(change.oldValue == change.newValue)")
				// On initial observation, oldValue will be nil, so process it
				if change.oldValue == nil {
					print("[ABRMonitor] Initial observation detected, calling handleMediaSelectionChange")
					self?.handleMediaSelectionChange(item: item)
				}
				return
			}
			print("[ABRMonitor] Selection changed, calling handleMediaSelectionChange")
			self?.handleMediaSelectionChange(item: item)
		}

		// Observe access log for quality detection via bitrate (fallback) and debugging
		accessLogObservation = NotificationCenter.default.addObserver(
			forName: AVPlayerItem.newAccessLogEntryNotification,
			object: playerItem,
			queue: nil
		) { [weak self] _ in
			// Try bitrate-based quality detection as fallback
			self?.detectQualityFromAccessLog()
			// Also log for debugging
			self?.logAccessLogForDebug()
		}
	}

	deinit {
		mediaSelectionObservation?.invalidate()
		if let accessLogObservation {
			NotificationCenter.default.removeObserver(accessLogObservation)
		}
	}

	/// Quality detection method using currentMediaSelection.
	/// This reads the NAME attribute from HLS #EXT-X-MEDIA tags.
	private func handleMediaSelectionChange(item: AVPlayerItem) {
		print("[ABRMonitor] handleMediaSelectionChange called")

		guard let asset = item.asset as? AVURLAsset else {
			print("[ABRMonitor] Asset is not AVURLAsset")
			return
		}

		// Get the audio media selection group
		let mediaCharacteristics = asset.availableMediaCharacteristicsWithMediaSelectionOptions
		guard mediaCharacteristics.contains(.audible) else {
			print("[ABRMonitor] No audible media characteristics")
			return
		}

		guard let audioGroup = asset.mediaSelectionGroup(forMediaCharacteristic: .audible) else {
			print("[ABRMonitor] No audio group found")
			return
		}

		// Get the currently selected audio option
		let selection = item.currentMediaSelection
		guard let selectedOption = selection.selectedMediaOption(in: audioGroup) else {
			print("[ABRMonitor] No selected option in audio group")
			return
		}

		print("[ABRMonitor] Selected option displayName: \(selectedOption.displayName)")

		// Parse quality from the display name (NAME attribute in HLS manifest)
		// If no match found, default to LOW
		let quality = Self.parseQualityFromMediaOption(selectedOption)
		print("[ABRMonitor] Parsed quality: \(quality)")
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
	/// Returns .LOW as default if no match is found.
	private static func parseQualityFromMediaOption(_ option: AVMediaSelectionOption) -> AudioQuality {
		let displayName = option.displayName.uppercased()

		// Direct mapping from NAME to AudioQuality enum
		let qualityMap: [String: AudioQuality] = [
			"LOW": .LOW,
			"HIGH": .HIGH,
			"LOSSLESS": .LOSSLESS,
			"HI_RES": .HI_RES,
			"HI_RES_LOSSLESS": .HI_RES_LOSSLESS,
		]

		if let quality = qualityMap[displayName] {
			return quality
		}

		// Fallback: check if displayName contains any quality string
		for quality in [AudioQuality.HIGH, .LOSSLESS, .HI_RES, .HI_RES_LOSSLESS] {
			if displayName.contains(quality.rawValue) {
				return quality
			}
		}

		// Default to LOW if no match found
		return .LOW
	}

	/// Fallback bitrate-based quality detection.
	/// Maps indicatedBitrate to the closest available AudioQuality by comparing typical bitrates.
	/// Used as failover when currentMediaSelection doesn't provide quality information.
	private func detectQualityFromAccessLog() {
		guard let item = playerItem,
		      let accessLog = item.accessLog(),
		      let event = accessLog.events.last else {
			return
		}

		let quality = Self.mapBitrateToQuality(indicatedBitrate: event.indicatedBitrate)
		print("[ABRMonitor] Detected quality from bitrate: \(quality)")
		reportQuality(quality)
	}

	/// Maps indicated bitrate to AudioQuality based on typical bitrate ranges.
	/// Fallback method when media selection doesn't expose quality information.
	private static func mapBitrateToQuality(indicatedBitrate: Double) -> AudioQuality {
		// Quality bitrate ranges (approximate)
		if indicatedBitrate < 150000 {
			return .LOW // < 150 kbps
		} else if indicatedBitrate < 500000 {
			return .HIGH // 150 - 500 kbps
		} else if indicatedBitrate < 2000000 {
			return .LOSSLESS // 500 kbps - 2 Mbps
		} else if indicatedBitrate < 5000000 {
			return .HI_RES // 2 - 5 Mbps
		} else {
			return .HI_RES_LOSSLESS // > 5 Mbps
		}
	}

	/// Debug method: Logs access log information for bandwidth/bitrate debugging.
	/// This is used for debugging purposes only and not for quality detection.
	private func logAccessLogForDebug() {
		guard let item = playerItem,
		      let accessLog = item.accessLog(),
		      let event = accessLog.events.last else {
			return
		}

		// Get current media selection name
		var currentSelectionName = "Unknown"
		var availableOptions = "N/A"
		var mediaSelectionState = "Unknown"
		var tracksInfo = "N/A"
		var mediaCharacteristicsInfo = "N/A"

		if let asset = item.asset as? AVURLAsset {
			// Check all available media characteristics
			let mediaCharacteristics = asset.availableMediaCharacteristicsWithMediaSelectionOptions
			mediaCharacteristicsInfo = mediaCharacteristics.map { $0.rawValue }.joined(separator: ", ")
			print("[ABRMonitor] All media characteristics: \(mediaCharacteristicsInfo)")

			// Investigate audio group
			if mediaCharacteristics.contains(.audible),
			   let audioGroup = asset.mediaSelectionGroup(forMediaCharacteristic: .audible) {

				// Get list of available options with detailed metadata
				let options = audioGroup.options
				var optionInfo: [String] = []
				for (index, option) in options.enumerated() {
					// Try to extract codec name from metadata
					let codecName: String = option.displayName
					if let metadata = option.commonMetadata.first {
						let keyStr = (metadata.key as? String) ?? "nil"
						let valueStr = (metadata.value as? String) ?? "nil"
						print("[ABRMonitor] Option[\(index)] metadata: key=\(keyStr), value=\(valueStr)")
					}

					let info = "[\(index)] displayName='\(codecName)' locale='\(option.locale?.languageCode ?? "nil")'"
					optionInfo.append(info)
				}
				availableOptions = optionInfo.isEmpty ? "None" : optionInfo.joined(separator: " | ")

				// Get currently selected option
				let selection = item.currentMediaSelection
				if let selectedOption = selection.selectedMediaOption(in: audioGroup) {
					currentSelectionName = selectedOption.displayName
					mediaSelectionState = "Selected"
				} else {
					// No explicit selection - this might mean the first option or default
					mediaSelectionState = "No explicit selection"
					currentSelectionName = "None"
				}

				// Additional debug info
				let isAutomaticSelectionEnabled = audioGroup.allowsEmptySelection
				mediaSelectionState = "State: \(mediaSelectionState) | AllowsEmpty: \(isAutomaticSelectionEnabled)"
			}

			// Check AVPlayerItem.tracks
			var trackInfo: [String] = []
			for (index, track) in item.tracks.enumerated() {
				var trackDesc = "[\(index)] type=\(track.assetTrack?.mediaType.rawValue ?? "unknown")"
				if let assetTrack = track.assetTrack {
					trackDesc += " enabled=\(track.isEnabled)"
				}
				trackInfo.append(trackDesc)
			}
			tracksInfo = trackInfo.isEmpty ? "No tracks" : trackInfo.joined(separator: " | ")
			print("[ABRMonitor] Tracks: \(tracksInfo)")
		}

		// Log URI from access log
		let logURI = event.uri ?? "N/A"
		print("[ABRMonitor] Access Log URI: \(logURI)")

		let debugInfo = """
		[ABRMonitor Debug] Access Log Entry:
		  - URI: \(logURI)
		  - Current Media Selection: \(currentSelectionName)
		  - Media Selection State: \(mediaSelectionState)
		  - Available Options: \(availableOptions)
		  - Tracks: \(tracksInfo)
		  - Media Characteristics: \(mediaCharacteristicsInfo)
		  - Indicated Bitrate: \(event.indicatedBitrate) bps
		  - Observed Bitrate: \(event.observedBitrate) bps
		  - Average Audio Bitrate: \(event.averageAudioBitrate) bps
		  - Duration Watched: \(event.durationWatched) s
		  - Segments Downloaded Duration: \(event.segmentsDownloadedDuration) s
		  - Number of Media Requests: \(event.numberOfMediaRequests)
		  - Number of Stalls: \(event.numberOfStalls)
		  - Playback Type: \(event.playbackType ?? "Unknown")
		"""

		print(debugInfo)
	}
}
