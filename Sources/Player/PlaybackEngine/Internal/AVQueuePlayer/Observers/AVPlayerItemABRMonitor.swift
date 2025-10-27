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

		// Observe currentMediaSelection changes (iOS 9+) for codec information
		// Note: This only fires when the selected audio track actually changes.
		// With HLS ABR, all quality variants typically use the same audio track,
		// so this won't fire during adaptive bitrate switching.
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
					print("[ABRMonitor] Initial observation detected, analyzing media selection")
					self?.handleMediaSelectionChange(item: item, mediaSelection: change.newValue!)
				}
				return
			}
			print("[ABRMonitor] Audio track changed, analyzing new media selection")
			self?.handleMediaSelectionChange(item: item, mediaSelection: newSelection)
		}

		// Observe access log for PRIMARY quality detection via bitrate
		// This is the main method for detecting quality changes during playback,
		// since HLS ABR happens at the variant stream level (bitrate), not audio track level.
		accessLogObservation = NotificationCenter.default.addObserver(
			forName: AVPlayerItem.newAccessLogEntryNotification,
			object: playerItem,
			queue: nil
		) { [weak self] _ in
			// Bitrate-based quality detection is the primary method during playback
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
	/// Detection strategy (priority order):
	/// 1. MediaSelectionOptionsTaggedMediaCharacteristics (codec format identifier from backend)
	/// 2. displayName attribute from HLS #EXT-X-MEDIA NAME tag
	/// 3. Fall back to bitrate detection if manifest doesn't support proper audio grouping
	private func handleMediaSelectionChange(item: AVPlayerItem, mediaSelection: AVMediaSelection) {
		print("[ABRMonitor] handleMediaSelectionChange called")

		guard let asset = item.asset as? AVURLAsset else {
			print("[ABRMonitor] Asset is not AVURLAsset")
			return
		}

		guard let audioGroup = asset.mediaSelectionGroup(forMediaCharacteristic: .audible) else {
			print("[ABRMonitor] No audio group found - manifest may not support media selection")
			print("[ABRMonitor] Will rely on bitrate-based quality detection instead")
			logAvailableMediaCharacteristics(asset: asset)
			return
		}

		guard let selectedOption = mediaSelection.selectedMediaOption(in: audioGroup) else {
			print("[ABRMonitor] No selected option in audio group")
			return
		}

		print("[ABRMonitor] Selected option displayName: \(selectedOption.displayName)")
		print("[ABRMonitor] Selected option metadata: \(selectedOption.commonMetadata)")
		print("[ABRMonitor] Selected option propertyList: \(selectedOption.propertyList())")

		// Parse quality from selected media option (characteristics > displayName > default LOW)
		let quality = Self.parseQualityFromMediaOption(selectedOption)
		print("[ABRMonitor] Parsed quality: \(quality)")
		reportQuality(quality)
	}

	/// Logs available media characteristics to help debug manifest structure issues.
	private func logAvailableMediaCharacteristics(asset: AVURLAsset) {
		let mediaCharacteristics = asset.availableMediaCharacteristicsWithMediaSelectionOptions
		print("[ABRMonitor] Available media characteristics: \(mediaCharacteristics.map { $0.rawValue }.joined(separator: ", "))")

		for characteristic in mediaCharacteristics {
			if let group = asset.mediaSelectionGroup(forMediaCharacteristic: characteristic) {
				print("[ABRMonitor] Group for \(characteristic.rawValue): \(group.options.count) options")
				for (index, option) in group.options.enumerated() {
					print("[ABRMonitor]   Option [\(index)]: \(option.displayName)")
				}
			}
		}
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

	/// Parses AudioQuality from AVMediaSelectionOption using multiple detection strategies.
	/// Priority order:
	/// 1. MediaSelectionOptionsTaggedMediaCharacteristics (format: "com.tidal.format.CODECNAME")
	/// 2. displayName attribute
	/// 3. Default to LOW
	private static func parseQualityFromMediaOption(_ option: AVMediaSelectionOption) -> AudioQuality {
		// First: Try to extract quality from characteristic attribute
		if let quality = parseQualityFromCharacteristics(option) {
			return quality
		}

		// Second: Try to parse from displayName
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

	/// Extracts AudioQuality from MediaSelectionOptionsTaggedMediaCharacteristics.
	/// Characteristics are formatted as "com.tidal.format.CODECNAME" where CODECNAME maps to quality levels.
	/// Returns nil if characteristics not found or cannot be parsed.
	private static func parseQualityFromCharacteristics(_ option: AVMediaSelectionOption) -> AudioQuality? {
		let propertyList = option.propertyList()
		guard let dict = propertyList as? [String: Any],
		      let characteristics = dict["MediaSelectionOptionsTaggedMediaCharacteristics"] as? [String] else {
			return nil
		}

		// Map characteristic codec names to AudioQuality
		let characteristicMap: [String: AudioQuality] = [
			"com.tidal.format.HEAACV1": .LOW,
			"com.tidal.format.AACLC": .HIGH,
			"com.tidal.format.FLAC": .LOSSLESS,
			"com.tidal.format.FLAC_HIRES": .HI_RES_LOSSLESS,
			// Also support HI_RES for potential future formats
			"com.tidal.format.MQA": .HI_RES,
		]

		// Find the first characteristic that matches our codec map
		for characteristic in characteristics {
			if let quality = characteristicMap[characteristic] {
				print("[ABRMonitor] Quality detected from characteristic: \(characteristic) → \(quality)")
				return quality
			}
		}

		return nil
	}

	/// Fallback bitrate-based quality detection.
	/// Maps indicatedBitrate to the closest available AudioQuality by comparing typical bitrates.
	/// Used when currentMediaSelection doesn't provide quality information.
	/// This is the primary quality detection method when the HLS manifest doesn't support
	/// proper media selection grouping.
	private func detectQualityFromAccessLog() {
		guard let item = playerItem,
		      let accessLog = item.accessLog(),
		      let event = accessLog.events.last else {
			return
		}

		// Only report quality if bitrate is available (> 0)
		guard event.indicatedBitrate > 0 else {
			print("[ABRMonitor] Access log event has no bitrate data yet")
			return
		}

		let quality = Self.mapBitrateToQuality(indicatedBitrate: event.indicatedBitrate)
		print("[ABRMonitor] Detected quality from bitrate: \(quality) (indicated: \(event.indicatedBitrate) bps, observed: \(event.observedBitrate) bps)")
		reportQuality(quality)
	}

	/// Maps indicated bitrate to AudioQuality based on typical bitrate ranges.
	/// This is the primary method for detecting quality changes during HLS ABR adaptation,
	/// since ABR happens at the variant stream level (bitrate changes), not audio track level.
	private static func mapBitrateToQuality(indicatedBitrate: Double) -> AudioQuality {
		// Quality bitrate ranges (approximate, based on typical audio codec bitrates)
		// These ranges represent typical variant stream bitrates for each quality tier
		if indicatedBitrate < 200000 {
			return .LOW // < 200 kbps (e.g., AAC 128 kbps)
		} else if indicatedBitrate < 400000 {
			return .HIGH // 200 - 400 kbps (e.g., AAC 256-320 kbps)
		} else if indicatedBitrate < 1200000 {
			return .LOSSLESS // 400 kbps - 1.2 Mbps (e.g., FLAC, Vorbis)
		} else if indicatedBitrate < 3000000 {
			return .HI_RES // 1.2 - 3 Mbps (e.g., FLAC Hi-Res)
		} else {
			return .HI_RES_LOSSLESS // > 3 Mbps (e.g., FLAC Hi-Res Lossless)
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
				if track.assetTrack != nil {
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
