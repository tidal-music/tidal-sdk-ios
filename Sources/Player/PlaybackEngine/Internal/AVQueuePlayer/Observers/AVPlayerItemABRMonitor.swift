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

	/// Maps indicated bitrate to AudioQuality based on typical bitrate ranges and format metadata.
	/// Combines bitrate with audio format information (codec, bit depth) for more confident detection.
	/// This is the primary method for detecting quality changes during HLS ABR adaptation,
	/// since ABR happens at the variant stream level (bitrate changes), not audio track level.
	private static func mapBitrateToQuality(indicatedBitrate: Double, formatMetadata: AudioFormatMetadata? = nil) -> AudioQuality {
		// Use format metadata to refine quality detection if available
		if let metadata = formatMetadata {
			// FLAC detection with bit-depth analysis
			if metadata.audioFormatID == kAudioFormatFLAC {
				if metadata.bitDepth >= 24 {
					// FLAC 24-bit or higher (Hi-Res source)
					if indicatedBitrate > 2000000 {
						return .HI_RES_LOSSLESS // FLAC Hi-Res 24-bit+ at high bitrate (>2 Mbps)
					} else if indicatedBitrate > 1000000 {
						return .HI_RES // FLAC Hi-Res 24-bit+ at moderate bitrate (>1 Mbps)
					} else {
						return .LOSSLESS // FLAC Hi-Res downmixed to lower bitrate
					}
				} else if metadata.bitDepth == 16 {
					return .LOSSLESS // FLAC CD Quality (16-bit)
				}
			}

			// ALAC (Apple Lossless Audio Codec) detection
			if metadata.audioFormatID == kAudioFormatAppleLossless {
				if metadata.bitDepth >= 24 {
					return .HI_RES // ALAC Hi-Res (24-bit or higher)
				} else {
					return .LOSSLESS // ALAC CD Quality (16-bit)
				}
			}

			// AAC variants
			if metadata.audioFormatID == kAudioFormatMPEG4AAC_HE {
				return .LOW // AAC-HE (Low bitrate, typically 96 kbps)
			}
			if metadata.audioFormatID == kAudioFormatMPEG4AAC {
				if indicatedBitrate > 250000 {
					return .HIGH // AAC at high bitrate (256-320 kbps)
				} else {
					return .LOW // AAC at low-mid bitrate
				}
			}

			// Dolby Digital+ (Enhanced AC-3) for Atmos
			if metadata.audioFormatID == kAudioFormatEnhancedAC3 {
				return .HIGH // Atmos is treated as HIGH quality
			}
		}

		// Fallback to bitrate-only detection when format metadata is unavailable
		// Quality bitrate ranges (approximate, based on typical audio codec bitrates)
		if indicatedBitrate < 200000 {
			return .LOW // < 200 kbps (e.g., AAC-HE 96 kbps)
		} else if indicatedBitrate < 400000 {
			return .HIGH // 200 - 400 kbps (e.g., AAC 256-320 kbps)
		} else if indicatedBitrate < 1200000 {
			return .LOSSLESS // 400 kbps - 1.2 Mbps (e.g., FLAC CD, Vorbis)
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

	/// Maps AudioFormatID to human-readable format name for logging.
	private static func formatIDName(_ formatID: AudioFormatID) -> String {
		switch formatID {
		case kAudioFormatMPEG4AAC_HE:
			return "AAC-HE (Low)"
		case kAudioFormatMPEG4AAC:
			return "AAC (Low-High)"
		case kAudioFormatEnhancedAC3:
			return "Dolby Digital+ (Atmos)"
		case kAudioFormatFLAC:
			return "FLAC"
		case kAudioFormatAppleLossless:
			return "ALAC"
		case kAudioFormatLinearPCM:
			return "PCM"
		case kAudioFormatAC3:
			return "Dolby Digital"
		default:
			return "Unknown (0x\(String(formatID, radix: 16)))"
		}
	}

	/// Extracts bit depth from audio format flags.
	/// For ALAC (Apple Lossless Audio Codec), decodes bit depth from format flags.
	/// Defensive: validates flags and returns sensible defaults if extraction fails.
	private static func extractBitDepth(from formatFlags: AudioFormatFlags, formatID: AudioFormatID) -> Int {
		// ALAC bit depth is encoded in format flags
		if formatID == kAudioFormatAppleLossless {
			if formatFlags == kAppleLosslessFormatFlag_16BitSourceData {
				return 16
			} else if formatFlags == kAppleLosslessFormatFlag_24BitSourceData {
				return 24
			} else if formatFlags == kAppleLosslessFormatFlag_32BitSourceData {
				return 32
			}
			// Unknown ALAC flag, return default
			return 16
		}

		// For FLAC and other formats, use the bit depth bits if available
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
