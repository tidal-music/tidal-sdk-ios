import Foundation

// MARK: - Download + Mock

public extension Download {
	static func mock(
		metadata: OfflineMediaItem.Metadata = .track(.mock()),
		imageURL: URL? = URL(string: "https://example.com/download-artwork.jpg")
	) -> Download {
		Download(
			metadata: metadata,
			imageURL: imageURL
		)
	}
}
