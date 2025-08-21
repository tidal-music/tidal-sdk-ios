import Foundation
@testable import Player

extension Downloader {
	static func mock(
		playbackInfoFetcher: PlaybackInfoFetcher = .mock(),
		fairPlayLicenseFetcher: FairPlayLicenseFetcher = .mock(),
		networkMonitor: NetworkMonitor = NetworkMonitorMock(),
		featureFlagProvider: FeatureFlagProvider = .mock,
		stateManager: DownloadStateManager = DownloadStateManagerMock()
	) -> Downloader {
		Downloader(
			playbackInfoFetcher: playbackInfoFetcher,
			fairPlayLicenseFetcher: fairPlayLicenseFetcher,
			networkMonitor: networkMonitor,
			featureFlagProvider: featureFlagProvider,
			stateManager: stateManager
		)
	}
}
