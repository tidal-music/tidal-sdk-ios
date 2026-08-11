import AVFoundation
import Foundation

/// An error encountered while preparing a stored asset for AVFoundation playback.
public enum OfflinePlaybackAVAssetError: Error, Equatable {
	case storedLicenseNotFound(URL)
	case storedLicenseUnreadable(URL)
}

/// An AVFoundation asset prepared for offline playback.
///
/// This object owns the URL asset and, for protected media, the FairPlay content-key session, delegate, delegate queue,
/// and stored license data. Retain this object for as long as any `AVPlayerItem` created from `urlAsset` is queued or
/// playing. `AVPlayerItem` does not retain this playback preparation context for you.
public final class OfflinePlaybackAVAsset {
	public let urlAsset: AVURLAsset

	private let contentKeySession: AVContentKeySession?
	private let contentKeySessionDelegate: StoredOfflineLicenseDelegate?
	private let contentKeyDelegateQueue: DispatchQueue?

	var usesStoredLicense: Bool {
		contentKeySession != nil
	}

	public init(playbackAsset: OfflinePlaybackAsset) throws {
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
	) {}
}
