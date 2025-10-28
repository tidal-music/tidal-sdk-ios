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
		Task { [weak self] in
			let formatMetadata = await self?.extractFormatMetadata(from: item)
			if let metadata = formatMetadata {
				print("[ABRMonitor] Current variant format: formatID=\(metadata.audioFormatID), bitDepth=\(metadata.bitDepth), sampleRate=\(metadata.sampleRate) Hz")
			}
			// Quality is determined with format metadata (or nil if extraction failed)
			let quality = Self.mapBitrateToQuality(indicatedBitrate: event.indicatedBitrate, formatMetadata: formatMetadata)
			self?.reportQuality(quality)
		}
	}

	/// Maps indicated bitrate to AudioQuality based on typical bitrate ranges and format metadata.
	/// Combines bitrate with audio format information (codec, bit depth) for more confident detection.
	/// This is the primary method for detecting quality changes during HLS ABR adaptation,
	/// since ABR happens at the variant stream level (bitrate changes), not audio track level.
	private static func mapBitrateToQuality(indicatedBitrate: Double, formatMetadata: AudioFormatMetadata? = nil) -> AudioQuality {
		// Quality bitrate ranges (approximate, based on typical audio codec bitrates)
		// These ranges represent typical variant stream bitrates for each quality tier

		// Use format metadata to refine quality detection if available
		if let metadata = formatMetadata {
			// FLAC with 24-bit or higher typically indicates Hi-Res tiers
			if metadata.audioFormatID == kAudioFormatFLAC {
				if metadata.bitDepth >= 24 {
					if indicatedBitrate > 2000000 {
						return .HI_RES_LOSSLESS // FLAC 24-bit+ with high bitrate
					} else if indicatedBitrate > 1000000 {
						return .HI_RES // FLAC 24-bit+ with moderate bitrate
					} else {
						return .LOSSLESS // FLAC with lower bitrate
					}
				} else if metadata.bitDepth == 16 {
					return .LOSSLESS // FLAC 16-bit
				}
			}

			// ALAC detection (Apple Lossless Audio Codec)
			if metadata.audioFormatID == kAudioFormatAppleLossless {
				if metadata.bitDepth >= 24 {
					return .HI_RES // ALAC 24-bit or higher
				} else {
					return .LOSSLESS // ALAC 16-bit
				}
			}
		}

		// Fallback to bitrate-only detection when format metadata is unavailable
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
		do {
			var formatDescriptions = [CMFormatDescription]()
			for track in playerItem.tracks {
				if let assetTrack = await track.assetTrack {
					try await formatDescriptions.append(contentsOf: assetTrack.load(.formatDescriptions))
				}
			}

			guard !formatDescriptions.isEmpty else {
				return nil
			}

			// Extract audio format information from the highest quality track
			guard let formatDesc = formatDescriptions.first,
			      let audioStreamDesc = formatDesc.audioStreamBasicDescription else {
				return nil
			}

			let audioFormatID = audioStreamDesc.mFormatID
			let audioFormatFlags = audioStreamDesc.mFormatFlags
			let sampleRate = Int(audioStreamDesc.mSampleRate)

			// Extract bit depth from format flags
			let bitDepth = Self.extractBitDepth(from: audioFormatFlags, formatID: audioFormatID)

			return AudioFormatMetadata(
				audioFormatID: audioFormatID,
				audioFormatFlags: audioFormatFlags,
				bitDepth: bitDepth,
				sampleRate: sampleRate
			)
		} catch {
			// Silent failure - format metadata is optional and used only for enhanced detection
			return nil
		}
	}

	/// Extracts bit depth from audio format flags.
	/// For ALAC (Apple Lossless Audio Codec), decodes bit depth from format flags.
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
		}

		// For FLAC and other formats, use the bit depth bits if available
		// kAudioFormatFlagIsSignedInteger = 0x4 (bit 2)
		if (formatFlags & kAudioFormatFlagIsSignedInteger) != 0 {
			// Bit depth is encoded in the lower bytes
			let bytesPerSample = formatFlags >> 16
			return Int(bytesPerSample) * 8
		}

		// Default assumption for other formats
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
