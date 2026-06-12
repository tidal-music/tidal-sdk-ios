import Foundation
@testable import Player
import Testing

// MARK: - OfflineEntryTests

@Suite(.serialized)
final class OfflineEntryTests {
	private var timeProvider: TimeProvider!
	private var currentTimestamp: UInt64 = 1

	init() throws {
		timeProvider = .mock(timestamp: {
			self.currentTimestamp
		})
		PlayerWorld = PlayerWorldClient.mock(timeProvider: timeProvider)
	}

	// MARK: - state

	@Test
	func test_stateIsOfflinedButNotValid_whenNoPlayableAVPlayer() async throws {
		// GIVEN
		let playbackInfo = PlaybackInfo.mock(
			licenseSecurityToken: "sdfasdfasdf",
			albumReplayGain: 4,
			albumPeakAmplitude: 1
		)
		let offlineEntry = OfflineEntry.mock(
			from: playbackInfo,
			assetURL: URL(string: "www.tidal.com")!,
			licenseURL: URL(string: "www.tidal.com/license")!
		)

		// THEN
		#expect(offlineEntry.state == .OFFLINED_BUT_NOT_VALID)
	}

	@Test
	func test_stateIsOfflinedButNotLicense_whenNoLicenseURL() async throws {
		// GIVEN
		let playbackInfo = PlaybackInfo.mock(
			licenseSecurityToken: "sdfasdfasdf",
			albumReplayGain: 4,
			albumPeakAmplitude: 1
		)
		let offlineEntry = OfflineEntry.mock(
			from: playbackInfo,
			assetURL: URL(string: "www.tidal.com")!,
			licenseURL: nil
		)

		// THEN
		#expect(offlineEntry.state == .OFFLINED_BUT_NO_LICENSE)
	}

	@Test
	func test_stateIsOfflinedButExpired_whenOfflineValidUntilHasPassed() async throws {
		// GIVEN
		currentTimestamp = 2 * 1000
		PlayerWorld.developmentFeatureFlagProvider.shouldCheckAndRevalidateOfflineItems = true

		let playbackInfo = PlaybackInfo.mock(
			licenseSecurityToken: "sdfasdfasdf",
			albumReplayGain: 4,
			albumPeakAmplitude: 1,
			offlineValidUntil: 1
		)
		let offlineEntry = OfflineEntry.mock(
			from: playbackInfo,
			assetURL: URL(string: "www.tidal.com")!,
			licenseURL: URL(string: "www.tidal.com/license")!
		)

		// THEN
		#expect(offlineEntry.state == .OFFLINED_BUT_EXPIRED)
	}

	// MARK: - needsLicense

	@Test
	func test_needsLicense_returnsTrue_whenLicenseSecurityTokenIsSet() {
		// GIVEN
		let playbackInfo = PlaybackInfo.mock(
			mediaType: MediaTypes.EMU,
			licenseSecurityToken: "some-token"
		)
		let offlineEntry = OfflineEntry.mock(from: playbackInfo)

		// THEN
		#expect(offlineEntry.needsLicense())
	}

	@Test
	func test_needsLicense_returnsTrue_whenTrackWithHLSMediaType() {
		// GIVEN - HLS track without licenseSecurityToken (new playback endpoints scenario)
		let playbackInfo = PlaybackInfo.mock(
			productType: .TRACK,
			mediaType: MediaTypes.HLS,
			licenseSecurityToken: nil
		)
		let offlineEntry = OfflineEntry.mock(from: playbackInfo)

		// THEN
		#expect(offlineEntry.needsLicense())
	}

	@Test
	func test_needsLicense_returnsFalse_whenNoTokenAndNotHLSTrack() {
		// GIVEN - EMU track without licenseSecurityToken
		let playbackInfo = PlaybackInfo.mock(
			productType: .TRACK,
			mediaType: MediaTypes.EMU,
			licenseSecurityToken: nil
		)
		let offlineEntry = OfflineEntry.mock(from: playbackInfo)

		// THEN
		#expect(!(offlineEntry.needsLicense()))
	}

	@Test
	func test_needsLicense_returnsFalse_whenVideoWithHLSAndNoToken() {
		// GIVEN - HLS video without licenseSecurityToken (videos don't use this path)
		let playbackInfo = PlaybackInfo.mock(
			productType: .VIDEO,
			mediaType: MediaTypes.HLS,
			licenseSecurityToken: nil
		)
		let offlineEntry = OfflineEntry.mock(from: playbackInfo)

		// THEN
		#expect(!(offlineEntry.needsLicense()))
	}

	@Test
	func test_stateIsOfflinedButNoLicense_whenHLSTrackWithoutLicenseURL() {
		// GIVEN - HLS track without licenseSecurityToken and no license URL (the bug scenario)
		let playbackInfo = PlaybackInfo.mock(
			productType: .TRACK,
			mediaType: MediaTypes.HLS,
			licenseSecurityToken: nil
		)
		let offlineEntry = OfflineEntry.mock(
			from: playbackInfo,
			assetURL: URL(string: "www.tidal.com")!,
			licenseURL: nil
		)

		// THEN
		#expect(offlineEntry.state == .OFFLINED_BUT_NO_LICENSE)
	}
}
