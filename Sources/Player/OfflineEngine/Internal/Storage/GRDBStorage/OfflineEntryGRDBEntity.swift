import Foundation
import GRDB

// MARK: - OfflineEntryGRDBEntity

struct OfflineEntryGRDBEntity: Codable, FetchableRecord, PersistableRecord {
	let productId: String
	let actualProductId: String
	let productType: ProductType
	let assetPresentation: AssetPresentation
	let audioMode: AudioMode?
	let audioQuality: AudioQuality?
	let audioCodec: AudioCodec?
	let audioSampleRate: Int?
	let audioBitDepth: Int?
	let videoQuality: VideoQuality?
	let revalidateAt: UInt64?
	let expiry: UInt64?
	let mediaType: String?
	let albumReplayGain: Float?
	let albumPeakAmplitude: Float?
	let trackReplayGain: Float?
	let trackPeakAmplitude: Float?
	let licenseSecurityToken: String?
	let size: Int
	let mediaBookmark: Data?
	let licenseBookmark: Data?

	var offlineEntry: OfflineEntry {
		OfflineEntry(
			productId: productId,
			actualProductId: actualProductId,
			productType: productType,
			assetPresentation: assetPresentation,
			audioMode: audioMode,
			audioQuality: audioQuality,
			audioCodec: audioCodec,
			audioSampleRate: audioSampleRate,
			audioBitDepth: audioBitDepth,
			videoQuality: videoQuality,
			revalidateAt: revalidateAt,
			expiry: expiry,
			mediaType: mediaType,
			albumReplayGain: albumReplayGain,
			albumPeakAmplitude: albumPeakAmplitude,
			trackReplayGain: trackReplayGain,
			trackPeakAmplitude: trackPeakAmplitude,
			licenseSecurityToken: licenseSecurityToken,
			size: size,
			mediaURL: mediaURL,
			licenseURL: licenseURL
		)
	}

	private var mediaURL: URL? {
		var isStale = false
		guard
			let mediaBookmark,
			let url = try? URL(resolvingBookmarkData: mediaBookmark, bookmarkDataIsStale: &isStale)
		else {
			return nil
		}
		return url
	}

	private var licenseURL: URL? {
		var isStale = false
		guard
			let licenseBookmark,
			let url = try? URL(resolvingBookmarkData: licenseBookmark, bookmarkDataIsStale: &isStale)
		else {
			return nil
		}
		return url
	}

	static let databaseTableName = "offlineEntries"

	enum Columns {
		static let productType = Column(CodingKeys.productType)
		static let productId = Column(CodingKeys.productId)
		static let assetPresentation = Column(CodingKeys.assetPresentation)
		static let size = Column(CodingKeys.size)
	}

	init(from entry: OfflineEntry) {
		productId = entry.productId
		actualProductId = entry.actualProductId
		productType = entry.productType
		assetPresentation = entry.assetPresentation
		audioMode = entry.audioMode
		audioQuality = entry.audioQuality
		audioCodec = entry.audioCodec
		audioSampleRate = entry.audioSampleRate
		audioBitDepth = entry.audioBitDepth
		videoQuality = entry.videoQuality
		revalidateAt = entry.revalidateAt
		expiry = entry.expiry
		mediaType = entry.mediaType
		albumReplayGain = entry.albumReplayGain
		albumPeakAmplitude = entry.albumPeakAmplitude
		trackReplayGain = entry.trackReplayGain
		trackPeakAmplitude = entry.trackPeakAmplitude
		licenseSecurityToken = entry.licenseSecurityToken
		size = entry.size
		mediaBookmark = try? entry.mediaURL?.bookmarkData()
		licenseBookmark = try? entry.licenseURL?.bookmarkData()
	}

	func bookmarkDataNeedsUpdating() -> Bool {
		do {
			var mediaBookmarkIsStale = false
			var licenseBookmarkIsStale = false

			if let mediaBookmark {
				_ = try URL(resolvingBookmarkData: mediaBookmark, bookmarkDataIsStale: &mediaBookmarkIsStale)
			}
			if let licenseBookmark {
				_ = try URL(resolvingBookmarkData: licenseBookmark, bookmarkDataIsStale: &licenseBookmarkIsStale)
			}

			return mediaBookmarkIsStale || licenseBookmarkIsStale
		} catch {
			return false
		}
	}
}
