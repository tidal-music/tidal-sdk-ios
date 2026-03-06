import Foundation

// MARK: - OfflineCollection + Mock

public extension OfflineCollection {
	static func mock(
		catalogMetadata: Metadata = .album(.mock()),
		artworkURL: URL? = URL(string: "https://example.com/artwork.jpg"),
		artworkId: String? = "artwork-789"
	) -> Self {
		.init(
			catalogMetadata: catalogMetadata,
			artworkURL: artworkURL,
			artworkId: artworkId
		)
	}
}

// MARK: - OfflineCollection.AlbumMetadata + Mock

public extension OfflineCollection.AlbumMetadata {
	static func mock(
		id: String = "album-123",
		title: String = "Mock Album",
		artists: [String] = ["Mock Artist"],
		artistIds: [String]? = ["artist-1"],
		copyright: String? = "2025 Mock Records",
		releaseDate: Date? = Date(timeIntervalSince1970: 1_704_067_200),
		explicit: Bool = false
	) -> Self {
		.init(
			id: id,
			title: title,
			artists: artists,
			artistIds: artistIds,
			copyright: copyright,
			releaseDate: releaseDate,
			explicit: explicit
		)
	}
}

// MARK: - OfflineCollection.PlaylistMetadata + Mock

public extension OfflineCollection.PlaylistMetadata {
	static func mock(
		id: String = "playlist-456",
		title: String = "Mock Playlist",
		description: String? = "A mock playlist",
		createdAt: Date? = Date(timeIntervalSince1970: 1_704_067_200),
		lastModifiedAt: Date? = Date(timeIntervalSince1970: 1_704_067_200)
	) -> Self {
		.init(
			id: id,
			title: title,
			description: description,
			createdAt: createdAt,
			lastModifiedAt: lastModifiedAt
		)
	}
}
