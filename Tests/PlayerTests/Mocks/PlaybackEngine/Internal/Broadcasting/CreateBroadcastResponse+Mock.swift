import Foundation
@testable import Player

extension CreateBroadcastResponse {
	static func mock(
		broadcastId: String = "broadcastId",
		curationUrl: URL = URL(string: "https://www.tidal.com")!,
		sharingUrl: URL = URL(string: "https://www.tidal.com")!,
		reactions: [String]? = nil
	) -> CreateBroadcastResponse {
		CreateBroadcastResponse(broadcastId: broadcastId, curationUrl: curationUrl, sharingUrl: sharingUrl, reactions: reactions)
	}
}
