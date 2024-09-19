import AVFoundation
import Foundation

// MARK: - LicenseDownloader

final class LicenseDownloader: NSObject {
	private let fairPlayLicenseFetcher: FairPlayLicenseFetcher
	private let licenseSecurityToken: String
	private weak var downloadTask: DownloadTask?

	init(
		fairPlayLicenseFetcher: FairPlayLicenseFetcher,
		licenseSecurityToken: String,
		downloadTask: DownloadTask
	) {
		self.fairPlayLicenseFetcher = fairPlayLicenseFetcher
		self.licenseSecurityToken = licenseSecurityToken
		self.downloadTask = downloadTask
	}

	private func store(_ license: Data, for downloadTask: DownloadTask) throws {
		let uuid = PlayerWorld.uuidProvider.uuidString()
		let url = PlayerWorld.fileManagerClient.cachesDirectory().appendingPathComponent("\(uuid).license")
		try license.write(to: url, options: .atomic)
		downloadTask.setLicenseUrl(url)
	}
}

// MARK: AVContentKeySessionDelegate

extension LicenseDownloader: AVContentKeySessionDelegate {
	func contentKeySession(_ session: AVContentKeySession, didProvide keyRequest: AVContentKeyRequest) {
		guard let downloadTask else {
			return
		}
		do {
			#if os(iOS)
				try keyRequest.respondByRequestingPersistableContentKeyRequestAndReturnError()
			#else
				try keyRequest.respondByRequestingPersistableContentKeyRequest()
			#endif
		} catch {
			PlayerWorld.logger?.log(loggable: PlayerLoggable.licenseDownloaderContentKeyRequestFailed(error: error))
			downloadTask.failed(with: error)
		}
	}

	func contentKeySession(_ session: AVContentKeySession, didProvide keyRequest: AVPersistableContentKeyRequest) {
		SafeTask {
			do {
				guard let downloadTask = self.downloadTask else {
					return
				}

				let license = try await self.fairPlayLicenseFetcher.getLicense(
					streamingSessionId: downloadTask.id,
					keyRequest: keyRequest
				)

				try self.store(license, for: downloadTask)

			} catch {
				PlayerWorld.logger?.log(loggable: PlayerLoggable.licenseDownloaderGetLicenseFailed(error: error))
				downloadTask?.failed(with: error)
			}
		}
	}
}
