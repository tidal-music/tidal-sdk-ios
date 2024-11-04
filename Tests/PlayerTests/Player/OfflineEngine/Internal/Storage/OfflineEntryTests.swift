@testable import Player
import XCTest

// MARK: - OfflineEntryTests

final class OfflineEntryTests: XCTestCase {
	private var timeProvider: TimeProvider!
	private var currentTimestamp: UInt64 = 1

	override func setUpWithError() throws {
		timeProvider = .mock(timestamp: {
			self.currentTimestamp
		})
		PlayerWorld = PlayerWorldClient.mock(timeProvider: timeProvider)
	}

	// MARK: - state

	func test_state_offlined_not_valid() async throws {
		// GIVEN
		let trackPlaybackInfo = TrackPlaybackInfo.mock(
			licenseSecurityToken: "sdfasdfasdf",
			albumReplayGain: 4,
			albumPeakAmplitude: 1
		)
		let playbackInfo = PlaybackInfo.mock(mediaProduct: .mock(), trackPlaybackInfo: trackPlaybackInfo)
		let offlineEntry = OfflineEntry.mock(
			from: playbackInfo,
			assetURL: URL(string: "www.tidal.com")!,
			licenseURL: URL(string: "www.tidal.com/license")!
		)

		XCTAssertEqual(offlineEntry.state, .OFFLINED_BUT_NOT_VALID)
	}

	func test_state_no_license() async throws {
		// GIVEN
		let trackPlaybackInfo = TrackPlaybackInfo.mock(
			licenseSecurityToken: "sdfasdfasdf",
			albumReplayGain: 4,
			albumPeakAmplitude: 1
		)
		let playbackInfo = PlaybackInfo.mock(mediaProduct: .mock(), trackPlaybackInfo: trackPlaybackInfo)
		let offlineEntry = OfflineEntry.mock(
			from: playbackInfo,
			assetURL: URL(string: "www.tidal.com")!,
			licenseURL: nil
		)

		XCTAssertEqual(offlineEntry.state, .OFFLINED_BUT_NO_LICENSE)
	}

	func test_state_expired() async throws {
		// GIVEN
		currentTimestamp = 2 * 1000
		PlayerWorld.developmentFeatureFlagProvider.shouldCheckExpiryAndRevalidateOfflineItems = true

		let trackPlaybackInfo = TrackPlaybackInfo.mock(
			licenseSecurityToken: "sdfasdfasdf",
			albumReplayGain: 4,
			albumPeakAmplitude: 1,
			offlineValidUntil: 1
		)
		let playbackInfo = PlaybackInfo.mock(
			mediaProduct: .mock(),
			trackPlaybackInfo: trackPlaybackInfo
		)
		let offlineEntry = OfflineEntry.mock(
			from: playbackInfo,
			assetURL: URL(string: "www.tidal.com")!,
			licenseURL: URL(string: "www.tidal.com/license")!
		)
		XCTAssertEqual(offlineEntry.state, .OFFLINED_BUT_EXPIRED)
	}
}
