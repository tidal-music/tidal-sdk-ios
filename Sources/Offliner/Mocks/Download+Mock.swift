import Foundation

// MARK: - Download + Mock

public extension Download {
	static func mock(
		title: String = "Mock Track",
		artists: [String] = ["Mock Artist"],
		imageURL: URL? = URL(string: "https://example.com/download-artwork.jpg")
	) -> Download {
		Download(
			title: title,
			artists: artists,
			imageURL: imageURL
		)
	}
}
