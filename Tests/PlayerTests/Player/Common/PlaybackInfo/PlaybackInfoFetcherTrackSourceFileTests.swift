import Foundation
@testable import Player
import Testing

// MARK: - Constants

private enum Constants {
	static let trackId = "12345"
	static let sourceFileId = UUID(uuidString: "A0EEBC99-9C0B-4EF8-BB6D-6BB9BD380A11")!
	static let streamingSessionId = "streamingSessionId"
}

// MARK: - PlaybackInfoFetcherTrackSourceFileTests

@Suite(.serialized)
final class PlaybackInfoFetcherTrackSourceFileTests {
	private var requests = [(sourceFileId: String, formats: [String], adaptive: Bool)]()
	private let playerEventSender = PlayerEventSenderMock()

	private var fetcher: PlaybackInfoFetcher {
		var configuration = Configuration.mock()
		configuration.streamingWifiAudioQuality = .LOSSLESS
		configuration.isImmersiveAudio = false
		configuration.allowVariablePlayback = false

		let networkMonitor = NetworkMonitorMock()
		networkMonitor.networkType = .WIFI

		return PlaybackInfoFetcher.mock(
			configuration: configuration,
			networkMonitor: networkMonitor,
			playerEventSender: playerEventSender,
			trackSourceFileManifestFetch: { sourceFileId, formats, adaptive in
				self.requests.append((sourceFileId, formats.map(\.rawValue), adaptive))
				return .mock(trackId: Constants.sourceFileId.uuidString.lowercased(), formats: [.heaacv1, .aaclc, .flac])
			}
		)
	}

	init() {
		PlayerWorld = PlayerWorldClient.mock()
	}

	private var sourceFile: TrackSourceFileMediaProduct {
		TrackSourceFileMediaProduct(sourceFileId: Constants.sourceFileId, trackId: Constants.trackId)
	}

	@Test
	func test_streaming_requestsSourceFileManifestBySourceFileId() async throws {
		let playbackInfo = try await fetcher.getPlaybackInfo(
			streamingSessionId: Constants.streamingSessionId,
			mediaProduct: sourceFile,
			playbackMode: .STREAM
		)

		#expect(requests.count == 1)
		#expect(requests.first?.sourceFileId == "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11")
		#expect(requests.first?.formats == ["HEAACV1", "AACLC", "FLAC"])
		#expect(requests.first?.adaptive == false)
		#expect(playbackInfo.productType == .TRACK_SOURCE_FILE)
		#expect(playbackInfo.productId == Constants.trackId)
		#expect(playbackInfo.assetPresentation == .FULL)
		#expect(playbackInfo.audioQuality == .LOSSLESS)
		#expect(playbackInfo.streamingSessionId == Constants.streamingSessionId)
		#expect(playerEventSender.streamingMetricsEvents.count == 1)
		#expect(playerEventSender.streamingMetricsEvents.first is PlaybackInfoFetch)
	}

	@Test
	func test_baseMediaProductWithSourceFileType_failsWithoutRequest() async {
		let malformed = MediaProduct.mock(productType: .TRACK_SOURCE_FILE, productId: Constants.trackId)

		await #expect(throws: PlayerInternalError.self) {
			try await self.fetcher.getPlaybackInfo(
				streamingSessionId: Constants.streamingSessionId,
				mediaProduct: malformed,
				playbackMode: .STREAM
			)
		}
		#expect(requests.isEmpty)
	}
}
