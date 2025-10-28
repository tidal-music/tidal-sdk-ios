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
			return qualityForProtectedAAC(sampleRate: metadata.sampleRate, audioObjectType: metadata.audioObjectType)
		}

		// Standard AAC variants - use AOT if available, otherwise fall back to formatID
		if metadata.audioFormatID == kAudioFormatMPEG4AAC {
			if let aot = metadata.audioObjectType {
				return qualityForAAC(audioObjectType: aot)
			}
			return .HIGH
		}

		if metadata.audioFormatID == kAudioFormatMPEG4AAC_HE {
			return .LOW
		}

		// eAC3 Atmos
		if metadata.audioFormatID == kAudioFormatEnhancedAC3 {
			return .LOSSLESS
		}

		return qualityFromBitrate(indicatedBitrate)
	}

	private static func isProtectedFLAC(fourCC: String, formatID: AudioFormatID) -> Bool {
		// Primary: check the actual formatID (reliable)
		// Backup: check 'qflc' fourCC (QuickTime encoder tag, less reliable but can help with protected streams)
		formatID == kAudioFormatFLAC || fourCC == "qflc"
	}

	private static func isProtectedAAC(fourCC: String) -> Bool {
		fourCC == "qach" || fourCC == "qaac"
	}

	private static func qualityForFLAC(bitDepth: Int, sampleRate: Int) -> AudioQuality {
		// HI_RES_LOSSLESS: >16-bit OR >44.1kHz
		if bitDepth > 16 || sampleRate > 44100 {
			return .HI_RES_LOSSLESS
		}
		// LOSSLESS: 16-bit AND 44.1kHz
		return .LOSSLESS
	}

	private static func qualityForProtectedAAC(sampleRate: Int, audioObjectType: UInt8? = nil) -> AudioQuality {
		// If we have AOT, use it for more accurate detection
		if let aot = audioObjectType {
			return qualityForAAC(audioObjectType: aot)
		}
		// Fall back to sample rate-based detection
		return sampleRate >= 44100 ? .HIGH : .LOW
	}

	private static func qualityForAAC(audioObjectType: UInt8) -> AudioQuality {
		// AOT values: 2=AAC-LC, 5=HE-AAC (SBR), 29=HE-AAC v2 (SBR+PS)
		switch audioObjectType {
		case 2:
			// AAC-LC
			return .HIGH
		case 5, 29:
			// HE-AAC and HE-AAC v2
			return .LOW
		default:
			// Unknown AOT, default to HIGH for safety
			return .HIGH
		}
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

	/// Extracts Audio Object Type from AudioSpecificConfig in format description extensions
	/// AOT tells us the AAC profile: 2=AAC-LC, 5=HE-AAC (SBR), 29=HE-AAC v2 (SBR+PS)
	private static func extractAudioObjectType(from formatDesc: CMFormatDescription) -> UInt8? {
		guard let extensions = CMFormatDescriptionGetExtensions(formatDesc) as? [String: Any] else {
			return nil
		}

		// Try to get AudioSpecificConfig from direct keys first
		// It can be stored under different keys depending on the source
		let possibleKeys = [
			"AudioSpecificConfig",
			"com.apple.cmformatdescription.audio.aac_profile",
			"magicCookie"
		]

		for key in possibleKeys {
			if let ascData = extensions[key] as? Data, ascData.count >= 1 {
				return parseAudioObjectTypeFromASC(ascData)
			}
		}

		// If not found in direct keys, try extracting from esds atom
		// esds is Elementary Stream Descriptor atom, commonly found in SampleDescriptionExtensionAtoms
		let atomKeys = [
			kCMFormatDescriptionExtension_SampleDescriptionExtensionAtoms as String,
			"SampleDescriptionExtensionAtoms"
		]

		for key in atomKeys {
			if let atoms = extensions[key] as? [String: Any] {
				// Try direct esds key first
				if let esdsData = atoms["esds"] as? Data {
					if let aot = extractAudioObjectTypeFromEsds(esdsData) {
						return aot
					}
				}

				// Also try sinf which may contain esds
				if let sinfData = atoms["sinf"] as? Data {
					if let aot = extractAudioObjectTypeFromSinf(sinfData) {
						return aot
					}
				}
			}
		}

		return nil
	}

	/// Parses Audio Object Type from AudioSpecificConfig data
	private static func parseAudioObjectTypeFromASC(_ ascData: Data) -> UInt8 {
		var aot = (ascData[0] >> 3) & 0x1F

		// Handle escape sequence: if AOT == 31, read next 6 bits
		if aot == 31 && ascData.count >= 2 {
			let lowBits = UInt8((ascData[1] >> 2) & 0x3F)
			aot = 32 + lowBits
		}

		return aot
	}

	/// Extracts Audio Object Type from esds (Elementary Stream Descriptor) atom
	private static func extractAudioObjectTypeFromEsds(_ esdsData: Data) -> UInt8? {
		// esds structure: [size:4][tag:"esds":4][version+flags:4][ES_Descriptor][DecoderConfigDescriptor]
		// DecoderConfigDescriptor contains AudioSpecificConfig in tag 0x04
		// esds format: [4 bytes size][4 bytes "esds"][1 byte version][3 bytes flags][ES_Descriptor structure]
		// We need to find the DecoderConfigDescriptor (tag 0x04) which contains the ASC

		if esdsData.count < 12 { return nil }

		// Start after esds header (size + tag + version/flags = 12 bytes minimum)
		var offset = 8 // Skip size and "esds" tag

		while offset + 2 <= esdsData.count {
			let tag = esdsData[offset]
			offset += 1

			// Parse variable-length size field (MPEG-style)
			var size: Int = 0
			var sizeLength = 0
			while sizeLength < 4 && offset < esdsData.count {
				let byte = esdsData[offset]
				offset += 1
				sizeLength += 1
				size = (size << 7) | Int(byte & 0x7F)
				if (byte & 0x80) == 0 { break }
			}

			// Found DecoderConfigDescriptor (0x04)
			if tag == 0x04 && size >= 13 && offset + 13 <= esdsData.count {
				// Skip objectTypeIndicator (1) + streamType+upstream (1) + bufferSizeDB (3)
				offset += 5
				// Now we should be at the start of AudioSpecificConfig
				if offset < esdsData.count {
					return parseAudioObjectTypeFromASC(esdsData.subdata(in: offset..<esdsData.count))
				}
			}

			offset += size
		}

		return nil
	}

	/// Safely reads a big-endian UInt32 from any byte offset in Data
	private static func readBigEndianUInt32(from data: Data, at offset: Int) -> UInt32? {
		guard offset + 4 <= data.count else { return nil }
		var result: UInt32 = 0
		for i in 0..<4 {
			result = (result << 8) | UInt32(data[offset + i])
		}
		return result
	}

	/// Extracts Audio Object Type from sinf (Sample Information Box) atom
	private static func extractAudioObjectTypeFromSinf(_ sinfData: Data) -> UInt8? {
		// sinf contains nested atoms including potentially frma and esds
		// Look for esds within sinf structure
		let esdsTag: UInt32 = 0x65736473 // "esds"

		var offset = 8 // Skip sinf header

		while offset + 8 <= sinfData.count {
			// Safely read tag as individual bytes to avoid alignment issues
			guard let tag = readBigEndianUInt32(from: sinfData, at: offset + 4) else {
				offset += 1
				continue
			}

			if tag == esdsTag {
				// Found esds atom, extract just the data portion
				if offset + 12 <= sinfData.count {
					let atomData = sinfData.subdata(in: offset..<sinfData.count)
					return extractAudioObjectTypeFromEsds(atomData)
				}
			}

			offset += 1
		}

		return nil
	}

	/// Extracts the true codec from the frma atom for encrypted tracks
	/// When formatID is 'enca' (encrypted), the frma atom contains the actual codec family
	/// Returns the fourCC string: 'mp4a' (AAC), 'alac', 'fLaC', etc.
	private static func extractFrmaCodec(from formatDesc: CMFormatDescription) -> String? {
		guard let extensions = CMFormatDescriptionGetExtensions(formatDesc) as? [String: Any] else {
			return nil
		}

		// Try to get the sample description extension atoms
		let possibleKeys = [
			kCMFormatDescriptionExtension_SampleDescriptionExtensionAtoms as String,
			"SampleDescriptionExtensionAtoms"
		]

		for key in possibleKeys {
			if let atoms = extensions[key] as? [String: Any] {
				// Try direct "frma" key first (if exposed as separate key)
				if let frmaData = atoms["frma"] as? Data {
					return decodeFrmaFromData(frmaData)
				}

				// Otherwise, parse sinf atom which contains frma
				if let sinfData = atoms["sinf"] as? Data {
					// sinf structure: [4 bytes size][4 bytes "sinf"][... nested atoms ...]
					// frma is at offset 8 with structure: [4 bytes size][4 bytes "frma"][4 bytes fourCC]
					if sinfData.count >= 20 { // Minimum size for sinf with frma
						// Look for "frma" tag (0x66726d61) in the data
						let frmaTag: UInt32 = 0x66726d61
						var offset = 0
						while offset + 8 <= sinfData.count {
							// Safely read tag as individual bytes to avoid alignment issues
							guard let tag = readBigEndianUInt32(from: sinfData, at: offset + 4) else {
								offset += 1
								continue
							}
							if tag == frmaTag {
								// Found frma, extract the fourCC at offset + 8
								if let fourcc = readBigEndianUInt32(from: sinfData, at: offset + 8) {
									return decodeFourCC(fourcc)
								}
								break
							}
							offset += 1
						}
					}
				}
			}
		}

		return nil
	}

	/// Decodes fourCC from frma data
	private static func decodeFrmaFromData(_ data: Data) -> String? {
		guard data.count >= 4 else { return nil }
		let fourcc = data.withUnsafeBytes { $0.load(as: UInt32.self).bigEndian }
		return decodeFourCC(fourcc)
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

			// Extract Audio Object Type from format description for AAC profile detection
			let audioObjectType = extractAudioObjectType(from: formatDesc)

			// Extract frma atom for encrypted tracks to discover true codec
			let frmaCodec = extractFrmaCodec(from: formatDesc)

			return AudioFormatMetadata(
				audioFormatID: audioFormatID,
				audioFormatFlags: audioFormatFlags,
				bitDepth: bitDepth,
				sampleRate: sampleRate,
				audioObjectType: audioObjectType,
				frmaCodec: frmaCodec
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
				// Note: 'qflc', 'qaac', 'qach' are QuickTime encoder tags, not codec indicators.
				// They're shown here for logging/debugging only. For quality detection,
				// we rely on the actual formatID and AudioSpecificConfig.
				let protectedFormats: [String: String] = [
					"qflc": "Protected FLAC",
					"qach": "Protected AAC",
					"qaac": "Protected AAC"
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
	/// For FLAC, the formatFlags directly encode the bit depth.
	/// For other formats, derives bit depth from format flags.
	private static func extractBitDepth(from formatFlags: AudioFormatFlags, formatID: AudioFormatID) -> Int {
		// For FLAC, formatFlags directly encode bit depth
		// Primary: check kAudioFormatFLAC (reliable)
		// Backup: check 'qflc' fourCC for protected streams (less reliable but useful)
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
	let audioObjectType: UInt8?  // For AAC variants: 2=LC, 5=HE, 29=HE-v2
	let frmaCodec: String?  // For encrypted tracks: 'mp4a', 'alac', 'fLaC', etc.
}
