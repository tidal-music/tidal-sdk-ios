import AVFoundation
import Foundation

// MARK: - OfflinePlaybackAVAssetError

/// An error encountered while preparing a stored asset for AVFoundation playback.
enum OfflinePlaybackAVAssetError: Error, Equatable {
	case storedLicenseNotFound(URL)
	case storedLicenseUnreadable(URL)
}

// MARK: - OfflinePlaybackAVAsset

/// An AVFoundation asset prepared for offline playback.
///
/// This object owns the URL asset and, for protected media, the FairPlay content-key session, delegate, delegate queue,
/// and stored license data. Retain this object for as long as any `AVPlayerItem` created from `urlAsset` is queued or
/// playing. `AVPlayerItem` does not retain this playback preparation context for you. Construction validates that stored
/// license data exists, is readable, and is non-empty; AVFoundation validates the license itself during playback and
/// reports failures through `AVPlayerItem.status` and `AVPlayerItem.error`.
public final class OfflinePlaybackAVAsset {
	public let urlAsset: AVURLAsset

	private let contentKeySession: AVContentKeySession?
	private let contentKeySessionDelegate: StoredOfflineLicenseDelegate?
	private let contentKeyDelegateQueue: DispatchQueue?

	var usesStoredLicense: Bool {
		contentKeySession != nil
	}

	init(playbackAsset: OfflinePlaybackAsset) throws {
		let urlAsset = AVURLAsset(url: playbackAsset.mediaURL)
		guard let licenseURL = playbackAsset.licenseURL else {
			self.urlAsset = urlAsset
			contentKeySession = nil
			contentKeySessionDelegate = nil
			contentKeyDelegateQueue = nil
			return
		}

		var isDirectory: ObjCBool = false
		guard FileManager.default.fileExists(atPath: licenseURL.path, isDirectory: &isDirectory) else {
			throw OfflinePlaybackAVAssetError.storedLicenseNotFound(licenseURL)
		}
		guard !isDirectory.boolValue else {
			throw OfflinePlaybackAVAssetError.storedLicenseUnreadable(licenseURL)
		}

		let license: Data
		do {
			license = try Data(contentsOf: licenseURL)
		} catch {
			throw OfflinePlaybackAVAssetError.storedLicenseUnreadable(licenseURL)
		}
		guard !license.isEmpty else {
			throw OfflinePlaybackAVAssetError.storedLicenseUnreadable(licenseURL)
		}

		let delegate = StoredOfflineLicenseDelegate(license: license)
		let delegateQueue = DispatchQueue(label: "com.tidal.offliner.stored-license")
		let session = AVContentKeySession(keySystem: .fairPlayStreaming)
		session.setDelegate(delegate, queue: delegateQueue)
		session.addContentKeyRecipient(urlAsset)

		self.urlAsset = urlAsset
		contentKeySession = session
		contentKeySessionDelegate = delegate
		contentKeyDelegateQueue = delegateQueue
	}
}

// MARK: - StoredOfflineLicenseDelegate

private final class StoredOfflineLicenseDelegate: NSObject, AVContentKeySessionDelegate {
	private let license: Data

	init(license: Data) {
		self.license = license
	}

	func contentKeySession(
		_ session: AVContentKeySession,
		didProvide keyRequest: AVContentKeyRequest
	) {
		do {
			#if os(iOS)
				try keyRequest.respondByRequestingPersistableContentKeyRequestAndReturnError()
			#else
				try keyRequest.respondByRequestingPersistableContentKeyRequest()
			#endif
		} catch {
			keyRequest.processContentKeyResponseError(error)
		}
	}

	func contentKeySession(
		_ session: AVContentKeySession,
		didProvide keyRequest: AVPersistableContentKeyRequest
	) {
		let response = AVContentKeyResponse(fairPlayStreamingKeyResponseData: license)
		keyRequest.processContentKeyResponse(response)
	}

	func contentKeySession(
		_ session: AVContentKeySession,
		contentKeyRequest keyRequest: AVContentKeyRequest,
		didFailWithError error: Error
	) {
		// AVPlayerItem.status/error is the consumer-facing runtime failure channel.
	}
}
