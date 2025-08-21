import Foundation
@testable import Player

extension Downloader {
	static func mock(
		playbackInfoFetcher: PlaybackInfoFetcher = .mock(),
		fairPlayLicenseFetcher: FairPlayLicenseFetcher = .mock(),
		networkMonitor: NetworkMonitor = NetworkMonitorMock(),
		featureFlagProvider: FeatureFlagProvider = .mock
	) -> Downloader {
		Downloader(
			playbackInfoFetcher: playbackInfoFetcher,
			fairPlayLicenseFetcher: fairPlayLicenseFetcher,
			networkMonitor: networkMonitor,
			featureFlagProvider: featureFlagProvider
		)
	}
}
