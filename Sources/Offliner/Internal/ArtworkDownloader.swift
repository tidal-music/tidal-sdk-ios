import Foundation
import TidalAPI

// MARK: - ArtworkDownloaderProtocol

protocol ArtworkDownloaderProtocol {
	func downloadArtwork(for artwork: ArtworksResourceObject?) async throws -> URL?
}

// MARK: - ArtworkDownloader

final class ArtworkDownloader: ArtworkDownloaderProtocol {
	private let urlSession: URLSession

	init(urlSession: URLSession = .shared) {
		self.urlSession = urlSession
	}

	func downloadArtwork(for artwork: ArtworksResourceObject?) async throws -> URL? {
		guard let artwork else {
			return nil
		}
		return try await download(artwork: artwork)
	}

	private func download(artwork: ArtworksResourceObject) async throws -> URL {
		guard let imageURL = artwork.largestFileURL else {
			throw ArtworkDownloaderError.missingArtworkURL
		}

		let (tempURL, response) = try await urlSession.download(from: imageURL)

		guard let httpResponse = response as? HTTPURLResponse,
		      (200 ... 299).contains(httpResponse.statusCode)
		else {
			throw ArtworkDownloaderError.downloadFailed
		}

		let fileExtension = imageURL.pathExtension.isEmpty ? "jpg" : imageURL.pathExtension
		let filename = "\(UUID().uuidString).\(fileExtension)"

		return try FileStorage.move(from: tempURL, subdirectory: "Artworks", filename: filename)
	}
}

// MARK: - ArtworkDownloaderError

enum ArtworkDownloaderError: Error {
	case missingArtworkURL
	case downloadFailed
}
