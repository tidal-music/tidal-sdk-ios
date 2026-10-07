@testable import Player
@testable import TidalAPI

/// Lives apart from the other mocks: importing TidalAPI next to Player makes `Configuration` ambiguous.
extension PlaybackInfoFetcher {
	static let mockTrackSourceFileManifestFetch: TrackSourceFileManifestFetch = { _, _, _ in
		TrackManifestsSingleResourceDataDocument.mock()
	}
}
