import Foundation

// MARK: - OfflineCollectionItem + Mock

public extension OfflineCollectionItem {
	static func mock(
		item: OfflineMediaItem = .mock(),
		volume: Int = 1,
		position: Int = 1
	) -> Self {
		.init(
			item: item,
			volume: volume,
			position: position
		)
	}
}

// MARK: - OfflineCollectionItemsPage + Mock

public extension OfflineCollectionItemsPage {
	static func mock(
		items: [OfflineCollectionItem] = [.mock()],
		cursor: Int64? = nil
	) -> Self {
		.init(
			items: items,
			cursor: cursor
		)
	}
}
