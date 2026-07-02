import Foundation
import OSLog

// MARK: - HTTPMediaDownloader

/// A media download engine built on plain `URLSession`, for platforms without `AVAssetDownloadURLSession` (watchOS).
///
/// Downloads the HLS manifest referenced by `manifestURL`, resolves the media playlist, fetches every segment, and
/// assembles them into a single media file on disk. Only clear (non-DRM) content is supported: encrypted playlists and
/// FairPlay licenses are rejected.
final class HTTPMediaDownloader: MediaDownloaderProtocol {
	private static let logger = Logger(subsystem: "com.tidal.sdk.offliner", category: "HTTPMediaDownloader")

	private let urlSession: URLSession

	init(urlSession: URLSession = URLSession(configuration: .default)) {
		self.urlSession = urlSession
	}

	func handleBackgroundURLSessionEvents(identifier: String, completionHandler: @escaping () -> Void) {
		// Downloads run in-process; there is no background URLSession to rejoin yet.
		DispatchQueue.main.async {
			completionHandler()
		}
	}

	func download(
		taskId: String,
		manifestURL: URL,
		licenseDownloadResult: LicenseDownloadResult?,
		title: String,
		onProgress: @escaping @Sendable (Double) async -> Void
	) async throws -> MediaDownloadResult {
		guard licenseDownloadResult == nil else {
			throw HTTPMediaDownloaderError.drmNotSupported
		}

		Self.logger.debug("initiate download: \(title, privacy: .public) [task: \(taskId, privacy: .public)]")

		let playlist = try await resolveMediaPlaylist(manifestURL: manifestURL)

		guard playlist.isClearContent else {
			throw HTTPMediaDownloaderError.encryptedContentNotSupported
		}

		let segmentURLs = playlist.allSegmentURLs
		guard !segmentURLs.isEmpty else {
			throw MediaDownloaderError.manifestNotFound
		}

		let mediaLocation = try await assembleSegments(
			segmentURLs,
			taskId: taskId,
			onProgress: onProgress
		)

		Self.logger.debug("finished download [task: \(taskId, privacy: .public)]")

		return MediaDownloadResult(
			duration: Int(playlist.duration.rounded()),
			mediaLocation: mediaLocation
		)
	}

	// MARK: - Playlist Resolution

	private func resolveMediaPlaylist(manifestURL: URL) async throws -> HLSMediaPlaylist {
		let manifestText = try await fetchText(url: manifestURL)

		if HLSPlaylistParser.isMasterPlaylist(manifestText) {
			guard let variantURL = HLSPlaylistParser.firstVariantURL(in: manifestText, baseURL: manifestURL) else {
				throw MediaDownloaderError.manifestNotFound
			}
			let mediaPlaylistText = try await fetchText(url: variantURL)
			return try HLSPlaylistParser.parseMediaPlaylist(mediaPlaylistText, baseURL: variantURL)
		}

		return try HLSPlaylistParser.parseMediaPlaylist(manifestText, baseURL: manifestURL)
	}

	private func fetchText(url: URL) async throws -> String {
		let data: Data
		if url.scheme == "data" {
			data = try Data(contentsOf: url)
		} else {
			(data, _) = try await urlSession.data(from: url)
		}

		guard let text = String(data: data, encoding: .utf8) else {
			throw MediaDownloaderError.manifestNotFound
		}

		return text
	}

	// MARK: - Segment Assembly

	private func assembleSegments(
		_ segmentURLs: [URL],
		taskId: String,
		onProgress: @escaping @Sendable (Double) async -> Void
	) async throws -> URL {
		let temporaryURL = FileManager.default.temporaryDirectory
			.appendingPathComponent("offliner-\(UUID().uuidString)")
			.appendingPathExtension("mp4")

		FileManager.default.createFile(atPath: temporaryURL.path, contents: nil)

		let fileHandle = try FileHandle(forWritingTo: temporaryURL)
		defer { try? fileHandle.close() }

		do {
			for (index, segmentURL) in segmentURLs.enumerated() {
				try Task.checkCancellation()

				let (data, response) = try await urlSession.data(from: segmentURL)

				if let httpResponse = response as? HTTPURLResponse,
				   !(200 ... 299).contains(httpResponse.statusCode) {
					throw HTTPMediaDownloaderError.segmentDownloadFailed(statusCode: httpResponse.statusCode)
				}

				try fileHandle.write(contentsOf: data)

				await onProgress(Double(index + 1) / Double(segmentURLs.count))
			}
		} catch {
			try? FileStorage.delete(url: temporaryURL)
			throw error
		}

		return try FileStorage.move(
			from: temporaryURL,
			subdirectory: "Media",
			filename: temporaryURL.lastPathComponent
		)
	}
}

// MARK: - HLSMediaPlaylist

struct HLSMediaPlaylist {
	struct Segment {
		let url: URL
		let duration: Double
	}

	let initializationSegmentURL: URL?
	let segments: [Segment]
	let isClearContent: Bool

	var duration: Double {
		segments.reduce(0) { $0 + $1.duration }
	}

	var allSegmentURLs: [URL] {
		(initializationSegmentURL.map { [$0] } ?? []) + segments.map(\.url)
	}
}

// MARK: - HLSPlaylistParser

enum HLSPlaylistParser {
	static func isMasterPlaylist(_ text: String) -> Bool {
		text.contains("#EXT-X-STREAM-INF")
	}

	static func firstVariantURL(in text: String, baseURL: URL) -> URL? {
		var lines = text.split(whereSeparator: \.isNewline).map(String.init).makeIterator()

		while let line = lines.next() {
			guard line.hasPrefix("#EXT-X-STREAM-INF") else { continue }

			while let uriLine = lines.next() {
				let trimmed = uriLine.trimmingCharacters(in: .whitespaces)
				guard !trimmed.isEmpty else { continue }
				guard !trimmed.hasPrefix("#") else { break }
				return resolve(uri: trimmed, against: baseURL)
			}
		}

		return nil
	}

	static func parseMediaPlaylist(_ text: String, baseURL: URL) throws -> HLSMediaPlaylist {
		var initializationSegmentURL: URL?
		var segments: [HLSMediaPlaylist.Segment] = []
		var isClearContent = true
		var pendingDuration: Double?

		for rawLine in text.split(whereSeparator: \.isNewline) {
			let line = String(rawLine).trimmingCharacters(in: .whitespaces)
			guard !line.isEmpty else { continue }

			if line.hasPrefix("#EXT-X-KEY") {
				if !line.contains("METHOD=NONE") {
					isClearContent = false
				}
			} else if line.hasPrefix("#EXT-X-MAP") {
				if let uri = attributeValue(named: "URI", in: line) {
					initializationSegmentURL = resolve(uri: uri, against: baseURL)
				}
			} else if line.hasPrefix("#EXTINF:") {
				let value = line.dropFirst("#EXTINF:".count).split(separator: ",").first
				pendingDuration = value.flatMap { Double($0) }
			} else if !line.hasPrefix("#") {
				guard let url = resolve(uri: line, against: baseURL) else {
					throw MediaDownloaderError.manifestNotFound
				}
				segments.append(HLSMediaPlaylist.Segment(url: url, duration: pendingDuration ?? 0))
				pendingDuration = nil
			}
		}

		return HLSMediaPlaylist(
			initializationSegmentURL: initializationSegmentURL,
			segments: segments,
			isClearContent: isClearContent
		)
	}

	private static func attributeValue(named name: String, in line: String) -> String? {
		guard let range = line.range(of: "\(name)=\"") else { return nil }
		let remainder = line[range.upperBound...]
		guard let closingQuote = remainder.firstIndex(of: "\"") else { return nil }
		return String(remainder[..<closingQuote])
	}

	private static func resolve(uri: String, against baseURL: URL) -> URL? {
		if let absolute = URL(string: uri), absolute.scheme != nil {
			return absolute
		}

		guard baseURL.scheme != "data" else { return nil }
		return URL(string: uri, relativeTo: baseURL)?.absoluteURL
	}
}

// MARK: - HTTPMediaDownloaderError

enum HTTPMediaDownloaderError: Error {
	case drmNotSupported
	case encryptedContentNotSupported
	case segmentDownloadFailed(statusCode: Int)
}
