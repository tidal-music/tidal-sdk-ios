import AVFoundation
import CoreMedia
import Foundation

final class AVPlayerItemABRMonitor {
	private weak var playerItem: AVPlayerItem?
	private let queue: OperationQueue
	private let onQualityChanged: (AudioQuality) -> Void
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

		// Observe access log for quality detection via bitrate
		// This is compatible with all iOS versions and provides reliable quality detection.
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

	/// Bitrate-based quality detection from access log enhanced with format metadata.
	/// Maps indicatedBitrate + format information to AudioQuality for confident detection.
	/// This is the primary quality detection method across all iOS versions.
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

		// Extract format metadata asynchronously to get current variant information
		// This is done on a background task to avoid blocking the access log handler
		// Defensive: capture weak self and verify it's still valid after async operations
		Task { [weak self] in
			// Verify self is still valid at the start of the task
			guard let strongSelf = self else {
				print("[ABRMonitor] Monitor was deallocated before format extraction started")
				return
			}

			let formatMetadata = await strongSelf.extractFormatMetadata(from: item)

			// Verify self is still valid after the async format extraction
			// (the monitor might have been deallocated while waiting)
			guard self != nil else {
				print("[ABRMonitor] Monitor was deallocated during format extraction")
				return
			}

			// Verify the playerItem is still the same (in case playback changed)
			guard strongSelf.playerItem === item else {
				print("[ABRMonitor] Player item changed during format extraction, skipping quality update")
				return
			}

			if let metadata = formatMetadata {
				let formatName = Self.formatIDName(metadata.audioFormatID)
				print("[ABRMonitor] Current variant format: \(formatName), bitDepth=\(metadata.bitDepth), sampleRate=\(metadata.sampleRate) Hz")
			}
			// Quality is determined with format metadata (or nil if extraction failed)
			let quality = Self.mapBitrateToQuality(indicatedBitrate: event.indicatedBitrate, formatMetadata: formatMetadata)
			strongSelf.reportQuality(quality)
		}
	}

	/// Maps indicated bitrate to AudioQuality based on format metadata and audio specifications.
	/// Combines bitrate, bit depth, and sample rate for confident quality detection.
	/// This is the primary method for detecting quality changes during HLS ABR adaptation,
	/// since ABR happens at the variant stream level (bitrate changes), not audio track level.
	private static func mapBitrateToQuality(indicatedBitrate: Double, formatMetadata: AudioFormatMetadata? = nil) -> AudioQuality {
		// Use format metadata to refine quality detection if available
		if let metadata = formatMetadata {
			// FLAC detection with bit-depth and sample rate analysis (including qflc: protected FLAC)
			let isQFlc = decodeFourCC(metadata.audioFormatID) == "qflc"
			if metadata.audioFormatID == kAudioFormatFLAC || isQFlc {
				// For qflc (protected FLAC), bitDepth might be 0, so infer from bitrate
				let inferredBitDepth = metadata.bitDepth > 0 ? metadata.bitDepth : Self.inferBitDepthFromBitrate(indicatedBitrate)

				// HI_RES_LOSSLESS: FLAC/qflc 20+ bit depth and 48KHz+ sample rate
				if inferredBitDepth >= 20 && metadata.sampleRate >= 48000 {
					return .HI_RES_LOSSLESS
				}
				// All other FLAC variants fall to LOSSLESS
				return .LOSSLESS
			}

			// AAC variants
			if metadata.audioFormatID == kAudioFormatMPEG4AAC_HE {
				return .LOW // AAC-HE
			}
			if metadata.audioFormatID == kAudioFormatMPEG4AAC {
				return .HIGH // AAC
			}

			// eAC3 Atmos
			if metadata.audioFormatID == kAudioFormatEnhancedAC3 {
				return .LOSSLESS
			}
		}

		// Fallback to bitrate-only detection when format metadata is unavailable
		// Quality bitrate ranges (approximate, based on typical audio codec bitrates)
		if indicatedBitrate < 200000 {
			return .LOW // < 200 kbps (e.g., AAC-HE 96 kbps)
		} else if indicatedBitrate < 400000 {
			return .HIGH // 200 - 400 kbps (e.g., AAC 256-320 kbps)
		} else {
			return .LOSSLESS // 400 kbps+ (e.g., FLAC, Vorbis)
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
		var mediaSelectionState = "Unknown"

		if let asset = item.asset as? AVURLAsset {
			// Investigate audio group
			let mediaCharacteristics = asset.availableMediaCharacteristicsWithMediaSelectionOptions
			if mediaCharacteristics.contains(.audible),
			   let audioGroup = asset.mediaSelectionGroup(forMediaCharacteristic: .audible) {

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
		}

		let debugInfo = """
		[ABRMonitor Debug] Access Log Entry:
		  - Current Media Selection: \(currentSelectionName)
		  - Media Selection State: \(mediaSelectionState)
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

	/// Extracts audio format metadata (AudioFormatID, bit depth, sample rate) from the current playing track.
	/// Uses the same pattern as AVQueuePlayerWrapper's readPlaybackMetadata to ensure consistency.
	private func extractFormatMetadata(from playerItem: AVPlayerItem) async -> AudioFormatMetadata? {
		// Guard against invalid player state
		guard !playerItem.tracks.isEmpty else {
			return nil
		}

		var formatDescriptions = [CMFormatDescription]()

		// Extract format descriptions from available tracks with error handling
		for track in playerItem.tracks {
			do {
				if let assetTrack = await track.assetTrack {
					let descriptions = try await assetTrack.load(.formatDescriptions)
					formatDescriptions.append(contentsOf: descriptions)
				}
			} catch {
				// Log individual track errors but continue with other tracks
				print("[ABRMonitor] Failed to load format descriptions for track: \(error)")
				continue
			}
		}

		guard !formatDescriptions.isEmpty else {
			return nil
		}

		// Extract audio format information from the first available format description
		var metadata: AudioFormatMetadata?
		for formatDesc in formatDescriptions {
			guard let audioStreamDesc = formatDesc.audioStreamBasicDescription else {
				continue
			}

			// Validate extracted values
			let audioFormatID = audioStreamDesc.mFormatID
			let audioFormatFlags = audioStreamDesc.mFormatFlags
			let sampleRate = Int(audioStreamDesc.mSampleRate)

			// Skip invalid sample rates
			guard sampleRate > 0 else {
				print("[ABRMonitor] Skipping format with invalid sample rate: \(sampleRate)")
				continue
			}

			// Extract bit depth from format flags
			let bitDepth = Self.extractBitDepth(from: audioFormatFlags, formatID: audioFormatID)

			metadata = AudioFormatMetadata(
				audioFormatID: audioFormatID,
				audioFormatFlags: audioFormatFlags,
				bitDepth: bitDepth,
				sampleRate: sampleRate
			)
			break // Use first valid format found
		}

		return metadata
	}

	/// Infers FLAC bit depth from indicated bitrate when mBitsPerChannel is unavailable.
	/// Used for protected FLAC (qflc) where bit depth info may not be directly available.
	private static func inferBitDepthFromBitrate(_ bitrate: Double) -> Int {
		// Typical FLAC bitrates by quality:
		// - 16-bit CD Quality (44.1KHz): ~600-900 kbps
		// - 20-24-bit Hi-Res (48KHz+): >1200 kbps
		if bitrate > 1200000 {
			return 24 // High bitrate suggests 20+ bit (assume 24-bit for HI_RES_LOSSLESS)
		} else {
			return 16 // Lower bitrate suggests 16-bit CD quality
		}
	}

	/// Maps AudioFormatID to human-readable format name for logging.
	private static func formatIDName(_ formatID: AudioFormatID) -> String {
		switch formatID {
		case kAudioFormatMPEG4AAC_HE:
			return "AAC-HE (Low)"
		case kAudioFormatMPEG4AAC:
			return "AAC (Low-High)"
		case kAudioFormatEnhancedAC3:
			return "eAC3 Atmos"
		case kAudioFormatFLAC:
			return "FLAC"
		case kAudioFormatLinearPCM:
			return "PCM"
		case kAudioFormatAC3:
			return "Dolby Digital"
		case kAudioFormatMPEGLayer3:
			return "MP3"
		case kAudioFormatOpus:
			return "Opus"
		default:
			// Try to decode as FourCC string if possible
			let fourCC = decodeFourCC(formatID)
			if !fourCC.isEmpty {
				// Add helpful annotations for known FourCC codes
				if fourCC == "qflc" {
					return "qflc (Protected FLAC)"
				}
				return fourCC
			}
			return "Unknown (0x\(String(formatID, radix: 16)))"
		}
	}

	/// Decodes AudioFormatID as a FourCC string (4-character code).
	private static func decodeFourCC(_ formatID: AudioFormatID) -> String {
		let bytes = [
			UInt8((formatID >> 24) & 0xFF),
			UInt8((formatID >> 16) & 0xFF),
			UInt8((formatID >> 8) & 0xFF),
			UInt8(formatID & 0xFF)
		]

		// Check if all bytes are printable ASCII characters (32-126)
		let isAllPrintable = bytes.allSatisfy { byte in
			byte >= 32 && byte <= 126
		}

		if isAllPrintable {
			let string = String(bytes: bytes, encoding: .ascii) ?? ""
			let trimmed = string.trimmingCharacters(in: .whitespaces)
			if !trimmed.isEmpty {
				return trimmed
			}
		}

		return ""
	}

	/// Extracts bit depth from audio format flags.
	/// For FLAC/qflc, the formatFlags directly encode the bit depth.
	/// For other formats, derives bit depth from format flags.
	private static func extractBitDepth(from formatFlags: AudioFormatFlags, formatID: AudioFormatID) -> Int {
		// For FLAC and qflc (protected FLAC), formatFlags directly encode bit depth
		// kAppleLosslessFormatFlag_16BitSourceData = 1
		// kAppleLosslessFormatFlag_20BitSourceData = 2
		// kAppleLosslessFormatFlag_24BitSourceData = 3
		// kAppleLosslessFormatFlag_32BitSourceData = 4
		let isQFlc = decodeFourCC(formatID) == "qflc"
		if formatID == kAudioFormatFLAC || isQFlc {
			switch formatFlags {
			case 1:
				return 16 // 16-bit CD Quality
			case 2:
				return 20 // 20-bit
			case 3:
				return 24 // 24-bit Hi-Res
			case 4:
				return 32 // 32-bit Hi-Res
			default:
				return 16 // Default to 16-bit if flag is unknown
			}
		}

		// For other formats, try to extract from format flags
		// kAudioFormatFlagIsSignedInteger = 0x4 (bit 2)
		if (formatFlags & kAudioFormatFlagIsSignedInteger) != 0 {
			// Bit depth is encoded in the lower bytes
			let bytesPerSample = formatFlags >> 16
			let bitDepth = Int(bytesPerSample) * 8

			// Validate extracted bit depth is reasonable (8-32 bits)
			if bitDepth > 0 && bitDepth <= 32 {
				return bitDepth
			}
		}

		// Default assumption for other formats or invalid extractions
		return 16
	}

}

// MARK: - AudioFormatMetadata

/// Metadata describing the audio format of the current playback stream.
private struct AudioFormatMetadata: Equatable {
	let audioFormatID: AudioFormatID
	let audioFormatFlags: AudioFormatFlags
	let bitDepth: Int
	let sampleRate: Int
}
