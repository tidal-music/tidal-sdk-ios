import Foundation
@testable import Player

extension StorageItem {
	static func mock(
		from playbackInfo: PlaybackInfo = .mock(),
		assetUrl: URL = URL(string: "https://www.tidal.com")!,
		licenseUrl: URL? = nil
	) throws -> Self {
		try StorageItem(from: playbackInfo, with: assetUrl, and: licenseUrl)
	}
}
