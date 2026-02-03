import Foundation
import TidalAPI

final class ArtworkRepository {
	private let urlSession: URLSession

	init() {
		self.urlSession = .shared
	}

	func downloadArtwork(for task: StoreItemTask) async throws -> URL {
		let artwork = switch task.metadata {
		case .track(let trackMetadata): trackMetadata.coverArt
		case .video(let videoMetadata): videoMetadata.thumbnail
		}
		
		guard let artwork else {
			throw ArtworkRepositoryError.missingArtwork
		}
		
		return try await download(artwork: artwork)
	}

	func downloadArtwork(for task: StoreCollectionTask) async throws -> URL {
		let artwork = switch task.metadata {
		case .album(let albumMetadata): albumMetadata.coverArt
		case .playlist(let playlistMetadata): playlistMetadata.coverArt
		}
		
		guard let artwork else {
			throw ArtworkRepositoryError.missingArtwork
		}
		
		return try await download(artwork: artwork)
	}

	private func download(artwork: ArtworksResourceObject) async throws -> URL {
		guard let file = artwork.attributes?.files.first,
			  let imageURL = URL(string: file.href) else {
			throw ArtworkRepositoryError.missingArtworkURL
		}

		let (tempURL, response) = try await urlSession.download(from: imageURL)

		guard let httpResponse = response as? HTTPURLResponse,
			  (200 ... 299).contains(httpResponse.statusCode) else {
			throw ArtworkRepositoryError.downloadFailed
		}

		let fileExtension = imageURL.pathExtension.isEmpty ? "jpg" : imageURL.pathExtension
		let filename = "\(artwork.id).\(fileExtension)"

		return try FileRepository.move(from: tempURL, subdirectory: "Artworks", filename: filename)
	}
}

enum ArtworkRepositoryError: Error {
	case missingArtwork
	case missingArtworkURL
	case downloadFailed
}
