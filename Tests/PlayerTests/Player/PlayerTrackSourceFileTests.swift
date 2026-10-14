import Auth
import Foundation
import GRDB
@testable import Player
import Testing

// MARK: - Constants

private enum Constants {
	static let sourceFileId = UUID(uuidString: "A0EEBC99-9C0B-4EF8-BB6D-6BB9BD380A11")!
}

// MARK: - PlayerTrackSourceFileTests

/// `Player.play()` claims streaming privileges (`StreamingPrivilegesHandler.notify()`), except for track source files.
/// Each `notify()` asks the credentials provider first, so its call count counts claims.
@Suite(.serialized)
final class PlayerTrackSourceFileTests {
	private let privilegesCredentialsProvider = CredentialsProviderMock()
	private var playerEngine: PlayerEngine!
	private var player: Player!
	private var sourceFileManifestError: Error?

	private let sourceFile = TrackSourceFileMediaProduct(sourceFileId: Constants.sourceFileId, trackId: "12345")

	init() throws {
		PlayerWorld = PlayerWorldClient.mock(developmentFeatureFlagProvider: DevelopmentFeatureFlagProvider.mock)

		let configuration = Configuration.mock()
		let storage = try GRDBOfflineStorage(dbQueue: DatabaseQueue())
		let notificationsHandler = NotificationsHandler.mock()

		playerEngine = PlayerEngine.mock(
			notificationsHandler: notificationsHandler,
			trackSourceFileManifestFetch: { sourceFileId, formats, adaptive in
				if let error = self.sourceFileManifestError {
					throw error
				}
				return try await PlaybackInfoFetcher.mockTrackSourceFileManifestFetch(sourceFileId, formats, adaptive)
			}
		)

		player = Player(
			queue: OperationQueueMock(),
			urlSession: URLSession(configuration: .default),
			configuration: configuration,
			offlineStorage: storage,
			playerEventSender: PlayerEventSenderMock(),
			fairplayLicenseFetcher: FairPlayLicenseFetcher.mock(),
			streamingPrivilegesHandler: StreamingPrivilegesHandler(
				configuration: configuration,
				httpClient: HttpClient.mock(),
				credentialsProvider: privilegesCredentialsProvider
			),
			networkMonitor: NetworkMonitorMock(),
			notificationsHandler: notificationsHandler,
			playerEngine: playerEngine,
			offlineEngine: OfflineEngine.mock(storage: storage, notificationsHandler: notificationsHandler),
			featureFlagProvider: .mock,
			externalPlayersSupplier: nil,
			credentialsProvider: CredentialsProviderMock(),
			offlinePlaybackPrivilegeCheck: nil,
			offlineItemProvider: nil
		)
	}

	@Test
	func test_play_track_claims() async {
		playerEngine.load(MediaProduct.mock(productType: .TRACK, productId: "12345"), timestamp: 1)
		player.play()

		#expect(await claimCount(reaching: 1) == 1)
	}

	@Test
	func test_play_sourceFile_doesNotClaim() async {
		playerEngine.load(sourceFile, timestamp: 1)
		player.play()

		#expect(await claimCount(reaching: 1) == 0)
	}

	@Test
	func test_play_afterSourceFileFailedToLoad_doesNotClaim() async {
		sourceFileManifestError = URLError(.notConnectedToInternet)

		playerEngine.load(sourceFile, timestamp: 1)
		player.play()

		#expect(playerEngine.currentItem == nil)
		#expect(await claimCount(reaching: 1) == 0)
	}
}

private extension PlayerTrackSourceFileTests {
	/// Claims run in a task: waits up to a second for the count to reach `expected`, then returns it.
	func claimCount(reaching expected: Int) async -> Int {
		for _ in 0 ..< 20 where privilegesCredentialsProvider.getCredentialsCallCount < expected {
			try? await Task.sleep(nanoseconds: 50_000_000)
		}
		return privilegesCredentialsProvider.getCredentialsCallCount
	}
}
