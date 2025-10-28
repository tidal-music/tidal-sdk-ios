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
			guard let strongSelf = self else {
				print("[ABRMonitor] Monitor was deallocated before format extraction started")
				return
			}

			let formatMetadata = await strongSelf.extractFormatMetadata(from: item)

			if !strongSelf.validateMonitorState(for: item, metadata: formatMetadata) {
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

	/// Validates monitor state during async operations
	private func validateMonitorState(for item: AVPlayerItem, metadata: AudioFormatMetadata?) -> Bool {
		// Verify the playerItem is still the same (in case playback changed)
		guard playerItem === item else {
			print("[ABRMonitor] Player item changed during format extraction, skipping quality update")
			return false
		}

		return true
	}

	/// Maps indicated bitrate to AudioQuality based on format metadata and audio specifications.
	/// Combines bitrate, bit depth, and sample rate for confident quality detection.
	/// This is the primary method for detecting quality changes during HLS ABR adaptation,
	/// since ABR happens at the variant stream level (bitrate changes), not audio track level.
	private static func mapBitrateToQuality(indicatedBitrate: Double, formatMetadata: AudioFormatMetadata? = nil) -> AudioQuality {
		guard let metadata = formatMetadata else {
			return qualityFromBitrate(indicatedBitrate)
		}

		let fourCC = decodeFourCC(metadata.audioFormatID)

		// FLAC detection
		if isProtectedFLAC(fourCC: fourCC, formatID: metadata.audioFormatID) {
			return qualityForFLAC(bitDepth: metadata.bitDepth, sampleRate: metadata.sampleRate)
		}

		// Protected AAC detection
		if isProtectedAAC(fourCC: fourCC) {
			return qualityForProtectedAAC(sampleRate: metadata.sampleRate)
		}

		// Standard AAC variants
		if metadata.audioFormatID == kAudioFormatMPEG4AAC_HE {
			return .LOW
		}

		if metadata.audioFormatID == kAudioFormatMPEG4AAC {
			return .HIGH
		}

		// eAC3 Atmos
		if metadata.audioFormatID == kAudioFormatEnhancedAC3 {
			return .LOSSLESS
		}

		return qualityFromBitrate(indicatedBitrate)
	}

	private static func isProtectedFLAC(fourCC: String, formatID: AudioFormatID) -> Bool {
		fourCC == "qflc" || formatID == kAudioFormatFLAC
	}

	private static func isProtectedAAC(fourCC: String) -> Bool {
		fourCC == "qach" || fourCC == "qacc"
	}

	private static func qualityForFLAC(bitDepth: Int, sampleRate: Int) -> AudioQuality {
		// HI_RES_LOSSLESS: >16-bit OR >44.1kHz
		if bitDepth > 16 || sampleRate > 44100 {
			return .HI_RES_LOSSLESS
		}
		// LOSSLESS: 16-bit AND 44.1kHz
		return .LOSSLESS
	}

	private static func qualityForProtectedAAC(sampleRate: Int) -> AudioQuality {
		sampleRate >= 44100 ? .HIGH : .LOW
	}

	private static func qualityFromBitrate(_ bitrate: Double) -> AudioQuality {
		if bitrate < 200000 {
			return .LOW
		} else if bitrate < 400000 {
			return .HIGH
		} else {
			return .LOSSLESS
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

		// Only access media selection for items with tracks to avoid -12718 errors
		// Skip media selection logging if no tracks present
		guard !item.tracks.isEmpty else {
			let debugInfo = """
			[ABRMonitor Debug] Access Log Entry:
			  - Current Media Selection: \(currentSelectionName)
			  - Media Selection State: No tracks
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
			return
		}

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

		let formatDescriptions = await loadFormatDescriptions(from: playerItem)

		guard !formatDescriptions.isEmpty else {
			return nil
		}

		return Self.findFirstValidAudioFormat(in: formatDescriptions)
	}

	/// Loads format descriptions from all available audio tracks
	private func loadFormatDescriptions(from playerItem: AVPlayerItem) async -> [CMFormatDescription] {
		var formatDescriptions = [CMFormatDescription]()

		// Extract format descriptions from audio tracks only to avoid -12718 errors on non-audio tracks
		for track in playerItem.tracks {
			do {
				if let assetTrack = await track.assetTrack {
					// Filter to audio tracks only to prevent errors when accessing audio-specific properties
					guard assetTrack.mediaType == .audio else {
						continue
					}

					let descriptions = try await assetTrack.load(.formatDescriptions)
					formatDescriptions.append(contentsOf: descriptions)
				}
			} catch {
				// Log individual track errors but continue with other tracks
				print("[ABRMonitor] Failed to load format descriptions for track: \(error)")
				continue
			}
		}

		return formatDescriptions
	}

	/// Finds the first valid audio format description with metadata
	private static func findFirstValidAudioFormat(in formatDescriptions: [CMFormatDescription]) -> AudioFormatMetadata? {
		for formatDesc in formatDescriptions {
			// Skip non-audio format descriptions to avoid -12718 errors
			guard CMFormatDescriptionGetMediaType(formatDesc) == kCMMediaType_Audio else {
				continue
			}

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
			let bitDepth = extractBitDepth(from: audioFormatFlags, formatID: audioFormatID)

			return AudioFormatMetadata(
				audioFormatID: audioFormatID,
				audioFormatFlags: audioFormatFlags,
				bitDepth: bitDepth,
				sampleRate: sampleRate
			)
		}

		return nil
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
				let protectedFormats: [String: String] = [
					"qflc": "Protected FLAC",
					"qach": "Protected AAC",
					"qacc": "Protected AAC"
				]
				if let annotation = protectedFormats[fourCC] {
					return "\(fourCC) (\(annotation))"
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
		let isQFlc = decodeFourCC(formatID) == "qflc"
		if formatID == kAudioFormatFLAC || isQFlc {
			let flacBitDepths: [AudioFormatFlags: Int] = [1: 16, 2: 20, 3: 24, 4: 32]
			return flacBitDepths[formatFlags] ?? 16
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
