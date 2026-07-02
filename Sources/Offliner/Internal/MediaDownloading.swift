import Foundation

// MARK: - MediaDownloadResult

struct MediaDownloadResult {
	let duration: Int
	let mediaLocation: URL
}

// MARK: - MediaDownloaderProtocol

protocol MediaDownloaderProtocol {
	func download(
		taskId: String,
		manifestURL: URL,
		licenseDownloadResult: LicenseDownloadResult?,
		title: String,
		onProgress: @escaping @Sendable (Double) async -> Void
	) async throws -> MediaDownloadResult

	func handleBackgroundURLSessionEvents(identifier: String, completionHandler: @escaping () -> Void)
}

// MARK: - MediaDownloaderFactory

enum MediaDownloaderFactory {
	static func make(configuration: Configuration) -> MediaDownloaderProtocol {
		#if os(watchOS)
		HTTPMediaDownloader()
		#else
		MediaDownloader(configuration: configuration)
		#endif
	}
}

// MARK: - MediaDownloaderError

enum MediaDownloaderError: Error {
	case failedToCreateTask
	case noDownloadedFile
	case manifestNotFound
}
