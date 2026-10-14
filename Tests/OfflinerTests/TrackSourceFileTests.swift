@testable import Offliner
import Player
import XCTest

final class TrackSourceFileTests: OfflinerTestCase {
	/// A source file's productId is its track id: it must not resolve to the offlined track.
	func testGetSourceFileDoesNotReturnOfflinedTrack() async throws {
		let offliner = createOffliner(
			offlineApiClient: StubOfflineApiClient(),
			artworkDownloader: SucceedingArtworkDownloader(),
			mediaDownloader: SucceedingMediaDownloader()
		)

		try await offliner.download(mediaType: .tracks, resourceId: .identifier("track-123"))
		try await downloadAndWaitForCompletion(offliner)

		let trackItem = await offliner.get(productType: .TRACK, productId: "track-123")
		XCTAssertNotNil(trackItem)

		let sourceFileItem = await offliner.get(productType: .TRACK_SOURCE_FILE, productId: "track-123")
		XCTAssertNil(sourceFileItem)
	}
}
