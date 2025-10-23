@testable import Player
import XCTest

// MARK: - Constants

private enum Constants {
	/// Default pre amp defined in ``loudnessNormalizationPreAmp`` in ``Configuration``.
	static let defaultPreAmp: Float = 4
}

extension InternalPlayerLoader {
	func getMainPlayerInstance() -> GenericMediaPlayer {
		mainPlayer
	}
}

// MARK: - InternalPlayerLoaderTests

final class InternalPlayerLoaderTests: XCTestCase {
	private var fairPlayLicenseFetcher: FairPlayLicenseFetcher!
	private var internalLoader: InternalPlayerLoader!
	private var mockPlayer: PlayerMock!

	override func setUpWithError() throws {
		fairPlayLicenseFetcher = FairPlayLicenseFetcher.mock()
		internalLoader = InternalPlayerLoader(
			with: Configuration.mock(),
			and: fairPlayLicenseFetcher,
			featureFlagProvider: FeatureFlagProvider.mock,
			mainPlayer: PlayerMock.self,
			externalPlayers: []
		)
		mockPlayer = internalLoader.getMainPlayerInstance() as? PlayerMock
	}

	// MARK: - DRM

	func testProduct_withDRM_hasLicenseLoader() async throws {
		// GIVEN
		let sessionId = "1"
		let expectedLicenseLoader = StreamingLicenseLoader(
			fairPlayLicenseFetcher: fairPlayLicenseFetcher,
			streamingSessionId: sessionId,
			featureFlagProvider: .mock
		)

		// WHEN
		_ = try await internalLoader.load(
			PlaybackInfo.mock(licenseSecurityToken: "security_token"),
			streamingSessionId: sessionId
		)

		// THEN
		XCTAssertEqual(mockPlayer.loadCallCount, 1)
		XCTAssertEqual(mockPlayer.licenseLoaders.count, 1)
		XCTAssertEqual(mockPlayer.licenseLoaders as? [StreamingLicenseLoader], [expectedLicenseLoader])
	}

	func testProduct_withoutDRM_noLicenseLoader() async throws {
		// GIVEN
		let sessionId = "1"
		let expectedLicenseLoader: StreamingLicenseLoader? = nil

		// WHEN
		_ = try await internalLoader.load(
			PlaybackInfo.mock(licenseSecurityToken: nil),
			streamingSessionId: sessionId
		)

		// THEN
		XCTAssertEqual(mockPlayer.loadCallCount, 1)
		XCTAssertEqual(mockPlayer.licenseLoaders.count, 1)
		XCTAssertEqual(mockPlayer.licenseLoaders as? [StreamingLicenseLoader?], [expectedLicenseLoader])
	}

	// MARK: - load

	func test_load_PlayableStorageItem() async throws {
		// GIVEN
		let trackPlaybackInfo = TrackPlaybackInfo.mock(
			licenseSecurityToken: "sdf2ewerqwe",
			manifestMimeType: MediaTypes.BTS,
			albumReplayGain: 4,
			albumPeakAmplitude: 1
		)
		let playbackInfo = PlaybackInfo.mock(mediaProduct: .mock(), trackPlaybackInfo: trackPlaybackInfo)
		let offlinedMediaProduct = PlayableOfflinedMediaProduct(from: OfflineEntry.mock(
			from: playbackInfo,
			assetURL: URL(string: "www.tidal.com")!,
			licenseURL: URL(string: "www.tidal.com/license")!
		))!

		let loudnessNormalizer = LoudnessNormalizer.mock(
			preAmp: Constants.defaultPreAmp,
			replayGain: trackPlaybackInfo.albumReplayGain!,
			peakAmplitude: trackPlaybackInfo.albumPeakAmplitude!
		)
		mockPlayer.loudnessNormalizer = loudnessNormalizer

		// WHEN
		let asset = try await internalLoader.load(offlinedMediaProduct)

		// THEN
		let expectedLoudnessConfiguration = LoudnessNormalizationConfiguration(
			loudnessNormalizationMode: .ALBUM,
			loudnessNormalizer: loudnessNormalizer
		)
		let expectedAsset = AssetMock(with: mockPlayer, loudnessNormalizationConfiguration: expectedLoudnessConfiguration)

		XCTAssertEqual(asset, expectedAsset)
		XCTAssertEqual(mockPlayer.loadCallCount, 1)
		XCTAssertEqual(mockPlayer.assets, [expectedAsset])
		XCTAssertEqual(mockPlayer.licenseLoaders.count, 1)
		XCTAssertEqual(mockPlayer.licenseLoaders as? [StreamingLicenseLoader?], [nil])
	}

	func test_load_StoredMediaProduct() async throws {
		// GIVEN
		let storedMediaProduct = StoredMediaProduct.mock(albumReplayGain: 4, albumPeakAmplitude: 1)

		let loudnessNormalizer = LoudnessNormalizer.mock(
			preAmp: Constants.defaultPreAmp,
			replayGain: storedMediaProduct.albumReplayGain!,
			peakAmplitude: storedMediaProduct.albumPeakAmplitude!
		)
		mockPlayer.loudnessNormalizer = loudnessNormalizer

		// WHEN
		let asset = try await internalLoader.load(storedMediaProduct)

		// THEN
		let expectedLoudnessConfiguration = LoudnessNormalizationConfiguration(
			loudnessNormalizationMode: .ALBUM,
			loudnessNormalizer: loudnessNormalizer
		)
		let expectedAsset = AssetMock(with: mockPlayer, loudnessNormalizationConfiguration: expectedLoudnessConfiguration)

		XCTAssertEqual(asset, expectedAsset)
		XCTAssertEqual(mockPlayer.loadCallCount, 1)
		XCTAssertEqual(mockPlayer.assets, [expectedAsset])
		XCTAssertEqual(mockPlayer.licenseLoaders.count, 1)
		XCTAssertEqual(mockPlayer.licenseLoaders as? [StreamingLicenseLoader?], [nil])
	}

	func test_load_PlaybackInfo() async throws {
		// GIVEN
		let playbackInfo = PlaybackInfo.mock(albumReplayGain: 4, albumPeakAmplitude: 1)

		let loudnessNormalizer = LoudnessNormalizer.mock(
			preAmp: Constants.defaultPreAmp,
			replayGain: playbackInfo.albumReplayGain!,
			peakAmplitude: playbackInfo.albumPeakAmplitude!
		)
		mockPlayer.loudnessNormalizer = loudnessNormalizer

		// WHEN
		let asset = try await internalLoader.load(playbackInfo, streamingSessionId: playbackInfo.streamingSessionId!)

		// THEN
		let expectedLoudnessConfiguration = LoudnessNormalizationConfiguration(
			loudnessNormalizationMode: .ALBUM,
			loudnessNormalizer: loudnessNormalizer
		)
		let expectedAsset = AssetMock(with: mockPlayer, loudnessNormalizationConfiguration: expectedLoudnessConfiguration)

		XCTAssertEqual(asset, expectedAsset)
		XCTAssertEqual(mockPlayer.loadCallCount, 1)
		XCTAssertEqual(mockPlayer.assets, [expectedAsset])
		XCTAssertEqual(mockPlayer.licenseLoaders.count, 1)
		XCTAssertEqual(mockPlayer.licenseLoaders as? [StreamingLicenseLoader?], [nil])
	}
}
