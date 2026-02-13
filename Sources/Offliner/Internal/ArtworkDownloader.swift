import Foundation
import TidalAPI

protocol ArtworkDownloaderProtocol {
	func downloadArtwork(for task: StoreItemTask) async throws -> URL?
	func downloadArtwork(for task: StoreCollectionTask) async throws -> URL?
}

final class ArtworkDownloader: ArtworkDownloaderProtocol {
	private let urlSession: URLSession

	init(urlSession: URLSession = .shared) {
		self.urlSession = urlSession
	}

	func downloadArtwork(for task: StoreItemTask) async throws -> URL? {
		let artwork: ArtworksResourceObject? = switch task.itemMetadata {
		case .track(let trackMetadata): trackMetadata.coverArt
		case .video(let videoMetadata): videoMetadata.thumbnail
		case nil: nil
		}

		guard let artwork else { return nil }

		return try await download(artwork: artwork)
	}

	func downloadArtwork(for task: StoreCollectionTask) async throws -> URL? {
		let artwork: ArtworksResourceObject? = switch task.metadata {
		case .album(let albumMetadata): albumMetadata.coverArt
		case .playlist(let playlistMetadata): playlistMetadata.coverArt
		case nil: nil
		}

		guard let artwork else { return nil }

		return try await download(artwork: artwork)
	}

	private func download(artwork: ArtworksResourceObject) async throws -> URL {
		guard let file = artwork.attributes?.files.first,
			  let imageURL = URL(string: file.href) else {
			throw ArtworkDownloaderError.missingArtworkURL
		}

		let (tempURL, response) = try await urlSession.download(from: imageURL)

		guard let httpResponse = response as? HTTPURLResponse,
			  (200 ... 299).contains(httpResponse.statusCode) else {
			throw ArtworkDownloaderError.downloadFailed
		}

		let fileExtension = imageURL.pathExtension.isEmpty ? "jpg" : imageURL.pathExtension
		let filename = "\(UUID().uuidString).\(fileExtension)"

		return try FileStorage.move(from: tempURL, subdirectory: "Artworks", filename: filename)
	}
}

enum ArtworkDownloaderError: Error {
	case missingArtworkURL
	case downloadFailed
}
