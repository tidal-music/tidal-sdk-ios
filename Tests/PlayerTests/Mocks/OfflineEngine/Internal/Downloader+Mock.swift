import Foundation
@testable import Player

extension Downloader {
	static func mock(
		playbackInfoFetcher: PlaybackInfoFetcher = .mock(),
		fairPlayLicenseFetcher: FairPlayLicenseFetcher = .mock(),
		networkMonitor: NetworkMonitor = NetworkMonitorMock()
	) -> Downloader {
		Downloader(
			playbackInfoFetcher: playbackInfoFetcher,
			fairPlayLicenseFetcher: fairPlayLicenseFetcher,
			networkMonitor: networkMonitor
		)
	}
}
