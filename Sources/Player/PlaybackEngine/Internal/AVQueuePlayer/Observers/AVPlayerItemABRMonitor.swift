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
	/// For FLAC, uses format flags to differentiate between HI_RES and HI_RES_LOSSLESS based on bit depth and sample rate.
	@available(iOS 18.0, macOS 15.0, *)
	private static func formatQualityName(from audioAttrs: AVAssetVariant.AudioAttributes) -> String {
		let formatIds = audioAttrs.formatIDs
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
			// Try to access format flags via KVC to determine FLAC quality tier
			if let flagsValue = (audioAttrs as NSObject).value(forKey: "formatFlags") as? NSNumber {
				let flags = UInt32(flagsValue.uint32Value)
				return determineFLACQuality(flags: flags)
			} else {
				// Fallback if formatFlags not available
				return "FLAC"
			}
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

	/// Determines FLAC quality tier (HI_RES vs HI_RES_LOSSLESS) based on format flags.
	/// FLAC flags encode bit depth and sample rate information:
	/// - Bits 13-15: Bits per sample minus 1 (0=8bit, 1=12bit, 2=16bit, 3=20bit, 4=24bit)
	/// - Bits 4-7: Sample rate index (6=48kHz, 7=96kHz, 8=176.4kHz, 9=192kHz)
	private static func determineFLACQuality(flags: UInt32) -> String {
		// Extract bit depth from flags (bits 13-15)
		// FLAC encodes bits per sample minus 1: 0=8bit, 1=12bit, 2=16bit, 3=20bit, 4=24bit
		let bitDepthIndex = (flags >> 13) & 0x7
		let bitDepth: Int
		switch bitDepthIndex {
		case 0: bitDepth = 8
		case 1: bitDepth = 12
		case 2: bitDepth = 16
		case 3: bitDepth = 20
		case 4: bitDepth = 24
		case 5, 6, 7: bitDepth = 0 // Reserved/invalid
		default: bitDepth = 0
		}

		// Extract sample rate from flags (bits 4-7)
		// FLAC sample rate indices: 0=8kHz, 1=16kHz, 2=22.05kHz, 3=24kHz, 4=32kHz, 5=44.1kHz,
		// 6=48kHz, 7=96kHz, 8=176.4kHz, 9=192kHz, 10-14=reserved, 15=invalid
		let sampleRateIndex = (flags >> 4) & 0xF
		let sampleRate: Int
		switch sampleRateIndex {
		case 0: sampleRate = 8000
		case 1: sampleRate = 16000
		case 2: sampleRate = 22050
		case 3: sampleRate = 24000
		case 4: sampleRate = 32000
		case 5: sampleRate = 44100
		case 6: sampleRate = 48000
		case 7: sampleRate = 96000
		case 8: sampleRate = 176400
		case 9: sampleRate = 192000
		default: sampleRate = 0 // Reserved or invalid (10-15)
		}

		// Determine quality tier based on bit depth and sample rate
		// HI_RES_LOSSLESS: High bit depth (24+) and high sample rate (176.4kHz+)
		// HI_RES: 24-bit at high sample rates (96kHz+)
		// LOSSLESS: 16-20bit at any rate, or high sample rate without 24-bit
		// Standard FLAC: 16-bit or lower
		if bitDepth == 0 || sampleRate == 0 {
			// Invalid flags, return generic FLAC
			return "FLAC (unknown format)"
		} else if bitDepth >= 24 && sampleRate >= 176400 {
			return "FLAC (HI_RES_LOSSLESS) \(bitDepth)bit@\(sampleRate)Hz"
		} else if bitDepth >= 24 && sampleRate >= 96000 {
			return "FLAC (HI_RES) \(bitDepth)bit@\(sampleRate)Hz"
		} else if bitDepth >= 20 || sampleRate >= 96000 {
			return "FLAC (LOSSLESS) \(bitDepth)bit@\(sampleRate)Hz"
		} else if bitDepth >= 16 {
			return "FLAC \(bitDepth)bit@\(sampleRate)Hz"
		} else {
			return "FLAC (compressed) \(bitDepth)bit@\(sampleRate)Hz"
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
	/// Quality detection is based on bitrate from the access log.
	@available(iOS 18.0, macOS 15.0, *)
	private func handleVariantSwitchEvent(_ event: AVMetricPlayerItemVariantSwitchEvent) {
		print("[ABRMonitor] Variant switch event detected")

		// Extract variant information (codec info)
		let variantInfo = extractVariantInfo(from: event)

		// Log all available event properties for analysis
		logVariantSwitchEvent(event, info: variantInfo)

		// Detect quality from current bitrate in access log
		// The variant switch event signals that a change occurred, but we use bitrate for quality
		detectQualityFromAccessLog()
	}

	/// Extracts variant information from AVMetricPlayerItemVariantSwitchEvent.
	/// Retrieves all available audio metadata including bitrates and attributes.
	@available(iOS 18.0, macOS 15.0, *)
	private func extractVariantInfo(from event: AVMetricPlayerItemVariantSwitchEvent) -> VariantInfo {
		let fromVariant = event.fromVariant
		let toVariant = event.toVariant
		let didSucceed = event.didSucceed

		let mediaType: String = "audio"
		let codec: String = "unknown"
		let reason: String = didSucceed ? "switch_successful" : "switch_failed"
		var hasAudioAttrs = false

		// Extract all available audio metadata from "to" variant (new quality tier)
		if let audioAttrs = toVariant.audioAttributes {
			hasAudioAttrs = true

			// Get format IDs and flags to determine codec and quality tier
			let qualityName = Self.formatQualityName(from: audioAttrs)
			print("[ABRMonitor] toVariant audio codec: \(qualityName)")
		}

		// Extract all available audio metadata from "from" variant (previous quality tier) if available
		if let fromVariant = fromVariant, let audioAttrs = fromVariant.audioAttributes {
			// Get format IDs and flags to determine codec and quality tier
			let qualityName = Self.formatQualityName(from: audioAttrs)
			print("[ABRMonitor] fromVariant audio codec: \(qualityName)")
		}

		print("[ABRMonitor] Variant Switch Details:")
		print("[ABRMonitor]   - Success: \(didSucceed)")
		print("[ABRMonitor]   - From Variant: \(fromVariant != nil ? "present" : "nil (initial)")")
		print("[ABRMonitor]   - To Variant: present")

		return VariantInfo(
			bitrate: 0, // Bitrate is obtained from access log, not from variant metadata
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
