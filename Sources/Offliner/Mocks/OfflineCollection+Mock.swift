import Foundation

// MARK: - OfflineCollection + Mock

public extension OfflineCollection {
	static func mock(
		catalogMetadata: Metadata = .album(.mock()),
		artworkURL: URL? = URL(string: "https://example.com/artwork.jpg")
	) -> Self {
		.init(
			catalogMetadata: catalogMetadata,
			artworkURL: artworkURL
		)
	}
}

// MARK: - OfflineCollection.AlbumMetadata + Mock

public extension OfflineCollection.AlbumMetadata {
	static func mock(
		id: String = "album-123",
		title: String = "Mock Album",
		artists: [String] = ["Mock Artist"],
		copyright: String? = "2025 Mock Records",
		releaseDate: Date? = Date(timeIntervalSince1970: 1_704_067_200),
		explicit: Bool = false,
		backgroundColorHex: String? = nil
	) -> Self {
		.init(
			id: id,
			title: title,
			artists: artists,
			copyright: copyright,
			releaseDate: releaseDate,
			explicit: explicit,
			backgroundColorHex: backgroundColorHex
		)
	}
}

// MARK: - OfflineCollection.PlaylistMetadata + Mock

public extension OfflineCollection.PlaylistMetadata {
	static func mock(
		id: String = "playlist-456",
		title: String = "Mock Playlist",
		backgroundColorHex: String? = nil
	) -> Self {
		.init(
			id: id,
			title: title,
			backgroundColorHex: backgroundColorHex
		)
	}
}
