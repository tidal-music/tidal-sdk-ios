import AVFoundation
import Foundation

final class AVPlayerItemABRMonitor {
	private weak var playerItem: AVPlayerItem?
	private let queue: OperationQueue
	private let onQualityChanged: (AudioQuality) -> Void
	private var accessLogObservation: NSObjectProtocol?
	private var metricsObservationTask: Task<Void, Never>? // iOS 18+ AVMetrics observation
	private var lastReportedQuality: AudioQuality?

	init(
		playerItem: AVPlayerItem,
		queue: OperationQueue,
		onQualityChanged: @escaping (AudioQuality) -> Void
	) {
		self.playerItem = playerItem
		self.queue = queue
		self.onQualityChanged = onQualityChanged

		// Observe variant switch events for iOS 18+ (primary quality detection)
		// These events fire when HLS adapts to a different variant stream (quality change).
		if #available(iOS 18.0, macOS 15.0, *) {
			metricsObservationTask = Task { [weak self, weak playerItem] in
				guard let playerItem = playerItem else { return }
				print("[ABRMonitor] Starting AVMetrics observation for variant switch events (iOS 18+)")
				let metrics = playerItem.metrics(forType: AVMetricPlayerItemVariantSwitchEvent.self)
				do {
					for try await event in metrics {
						self?.handleVariantSwitchEvent(event)
					}
				} catch {
					print("[ABRMonitor] Error observing variant switch events: \(error)")
				}
			}
		}

		// Observe access log for fallback quality detection via bitrate (iOS < 18)
		// Also used for debugging to understand bitrate patterns during playback.
		accessLogObservation = NotificationCenter.default.addObserver(
			forName: AVPlayerItem.newAccessLogEntryNotification,
			object: playerItem,
			queue: nil
		) { [weak self] _ in
			self?.detectQualityFromAccessLog()
			self?.logAccessLogForDebug()
		}
	}

	deinit {
		if let accessLogObservation {
			NotificationCenter.default.removeObserver(accessLogObservation)
		}
		metricsObservationTask?.cancel()
	}

	/// Reports a quality change if it differs from the last reported quality.
	private func reportQuality(_ quality: AudioQuality) {
		guard quality != lastReportedQuality else {
			return
		}

		let previousQuality = lastReportedQuality
		lastReportedQuality = quality

		print("[ABRMonitor] Quality changed: \(String(describing: previousQuality)) → \(quality)")

		queue.dispatch { [weak self] in
			self?.onQualityChanged(quality)
		}
	}

	/// Bitrate-based quality detection from access log.
	/// Maps indicatedBitrate to the closest available AudioQuality by comparing typical bitrates.
	/// This is used during playback on iOS < 18, where AVMetrics API is not available.
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

	/// Maps audio format IDs to human-readable quality names.
	/// Returns a string describing the codec and quality tier based on the format ID.
	private static func formatQualityName(from formatIds: [AudioFormatID]) -> String {
		guard !formatIds.isEmpty else { return "unknown" }

		let formatId = formatIds[0]

		switch formatId {
		case kAudioFormatMPEG4AAC_HE:
			return "AAC-HE (Low 96)"
		case kAudioFormatMPEG4AAC:
			return "AAC (Low 320)"
		case kAudioFormatEnhancedAC3:
			return "Enhanced AC-3 (Atmos)"
		case kAudioFormatFLAC:
			return "FLAC (High/Max with flags)"
		default:
			// Format the unknown format ID as FourCC for debugging
			let fourCC = String(format: "%c%c%c%c",
				UInt8(formatId >> 24),
				UInt8((formatId >> 16) & 0xFF),
				UInt8((formatId >> 8) & 0xFF),
				UInt8(formatId & 0xFF))
			return "Unknown (\(fourCC) / \(formatId))"
		}
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

		print("[ABRMonitor] Number of access log events: \(accessLog.events.count)")
		
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

	/// Handles variant switch events from iOS 18+ AVMetrics API.
	/// These events fire when HLS adapts to a different variant stream (quality change).
	/// This is more accurate than bitrate-based detection.
	@available(iOS 18.0, macOS 15.0, *)
	private func handleVariantSwitchEvent(_ event: AVMetricPlayerItemVariantSwitchEvent) {
		print("[ABRMonitor] Variant switch event detected")

		// Extract variant information
		let variantInfo = extractVariantInfo(from: event)

		// Log all available event properties for analysis
		logVariantSwitchEvent(event, info: variantInfo)

		// Detect quality from variant bitrate
		let qualityFromVariant = Self.mapBitrateToQuality(indicatedBitrate: variantInfo.bitrate)
		print("[ABRMonitor] Quality from variant event: \(qualityFromVariant) (bitrate: \(variantInfo.bitrate) bps)")

		// Trigger comparison with bitrate-based detection for validation
		// (This happens asynchronously, so both methods run in parallel for testing)

		// Report the quality change
		reportQuality(qualityFromVariant)
	}

	/// Extracts variant information from AVMetricPlayerItemVariantSwitchEvent.
	/// Retrieves all available audio metadata including bitrates and attributes.
	@available(iOS 18.0, macOS 15.0, *)
	private func extractVariantInfo(from event: AVMetricPlayerItemVariantSwitchEvent) -> VariantInfo {
		let fromVariant = event.fromVariant
		let toVariant = event.toVariant
		let didSucceed = event.didSucceed

		// Extract audio attributes from "to" variant (the new quality tier)
		var toBitrate: Double = 0
		var fromBitrate: Double = 0
		let mediaType: String = "audio"
		let codec: String = "unknown"
		let reason: String = didSucceed ? "switch_successful" : "switch_failed"
		var hasAudioAttrs = false

		// Extract all available audio metadata from "to" variant (new quality tier)
		if let audioAttrs = toVariant.audioAttributes {
			hasAudioAttrs = true

			// Get the average bitrate from audio attributes
			// This uses KVC to access the private _averageBitRate property
			if let avgBitrate = (audioAttrs as NSObject).value(forKey: "_averageBitRate") as? NSNumber {
				toBitrate = avgBitrate.doubleValue
				print("[ABRMonitor] toVariant audio average bitrate: \(toBitrate) bps (\(toBitrate / 1000) kbps)")
			}

			// Get peak bitrate if available
			if let peakBitrate = (audioAttrs as NSObject).value(forKey: "_peakBitRate") as? NSNumber {
				print("[ABRMonitor] toVariant audio peak bitrate: \(peakBitrate.doubleValue) bps (\(peakBitrate.doubleValue / 1000) kbps)")
			}

			// Get format IDs (audio codec identifiers)
			let formatIds = audioAttrs.formatIDs
			if !formatIds.isEmpty {
				let qualityName = Self.formatQualityName(from: formatIds)
				print("[ABRMonitor] toVariant audio codec: \(qualityName)")
			}
		}

		// Extract all available audio metadata from "from" variant (previous quality tier) if available
		if let fromVariant = fromVariant, let audioAttrs = fromVariant.audioAttributes {
			if let avgBitrate = (audioAttrs as NSObject).value(forKey: "_averageBitRate") as? NSNumber {
				fromBitrate = avgBitrate.doubleValue
				print("[ABRMonitor] fromVariant audio average bitrate: \(fromBitrate) bps (\(fromBitrate / 1000) kbps)")
			}

			// Get peak bitrate if available
			if let peakBitrate = (audioAttrs as NSObject).value(forKey: "_peakBitRate") as? NSNumber {
				print("[ABRMonitor] fromVariant audio peak bitrate: \(peakBitrate.doubleValue) bps (\(peakBitrate.doubleValue / 1000) kbps)")
			}

			// Get format IDs (audio codec identifiers)
			let formatIds = audioAttrs.formatIDs
			if !formatIds.isEmpty {
				let qualityName = Self.formatQualityName(from: formatIds)
				print("[ABRMonitor] fromVariant audio codec: \(qualityName)")
			}
		}

		print("[ABRMonitor] Variant Switch Details:")
		print("[ABRMonitor]   - Success: \(didSucceed)")
		print("[ABRMonitor]   - From Variant: \(fromVariant != nil ? "present (bitrate: \(fromBitrate) bps)" : "nil (initial)")")
		print("[ABRMonitor]   - To Variant: present (bitrate: \(toBitrate) bps)")
		if fromBitrate > 0 {
			let percentChange = (toBitrate - fromBitrate) / fromBitrate * 100
			print("[ABRMonitor]   - Bitrate Change: \(fromBitrate) → \(toBitrate) bps (\(String(format: "%.1f", percentChange))% change)")
		}

		return VariantInfo(
			bitrate: toBitrate,
			mediaType: mediaType,
			codec: codec,
			reason: reason,
			fromVariant: fromVariant != nil,
			toVariant: true,
			didSucceed: didSucceed,
			hasAudioAttrs: hasAudioAttrs
		)
	}

	/// Extracts detailed audio attributes from a variant if available.
	/// This requires the current media selection option to get rendition-specific attributes.
	@available(iOS 18.0, macOS 15.0, *)
	private func extractAudioAttributes(from variant: AVAssetVariant, for mediaOption: AVMediaSelectionOption?) -> String {
		guard let audioAttrs = variant.audioAttributes else {
			return "no_audio_attributes"
		}

		var attributes: [String] = ["audio_present"]

		// Extract rendition-specific attributes if we have a media option
		if let mediaOption = mediaOption,
		   let renditionAttrs = audioAttrs.renditionSpecificAttributes(for: mediaOption) {
			if #available(iOS 16.0, *) {
				if renditionAttrs.isBinaural {
					attributes.append("binaural")
				}
				if renditionAttrs.isDownmix {
					attributes.append("downmix")
				}
			}
			if #available(iOS 17.0, *) {
				if renditionAttrs.isImmersive {
					attributes.append("immersive")
				}
			}
		}

		return attributes.joined(separator: ",")
	}

	/// Logs comprehensive variant switch event information for debugging.
	@available(iOS 18.0, macOS 15.0, *)
	private func logVariantSwitchEvent(_ event: AVMetricPlayerItemVariantSwitchEvent, info: VariantInfo) {
		let debugInfo = """
		[ABRMonitor] Variant Switch Event:
		  - Bitrate: \(info.bitrate) bps
		  - Media Type: \(info.mediaType)
		  - Codec: \(info.codec)
		  - Reason: \(info.reason)
		  - Timestamp: \(Date())
		"""
		print(debugInfo)
	}

	/// Information extracted from a variant switch event.
	private struct VariantInfo {
		let bitrate: Double
		let mediaType: String
		let codec: String
		let reason: String
		let fromVariant: Bool
		let toVariant: Bool
		let didSucceed: Bool
		let hasAudioAttrs: Bool
	}
}
