import Auth
@testable import Player
import XCTest

// MARK: - Constants

private enum Constants {
	/// Default pre amp defined in ``loudnessNormalizationPreAmp`` in ``Configuration``.
	static let defaultPreAmp: Float = 4
}

// MARK: - InternalPlayerLoaderTests

final class InternalPlayerLoaderTests: XCTestCase {
	private var fairPlayLicenseFetcher: FairPlayLicenseFetcher!
	private var internalLoader: InternalPlayerLoader!
	private var mockPlayer: PlayerMock!

	override func setUpWithError() throws {
		fairPlayLicenseFetcher = FairPlayLicenseFetcher.mock()
		let cachePath = URL(fileURLWithPath: NSTemporaryDirectory())
		internalLoader = InternalPlayerLoader(
			with: Configuration.mock(),
			and: fairPlayLicenseFetcher,
			featureFlagProvider: FeatureFlagProvider.mock,
			credentialsProvider: CredentialsProviderMock(),
			avQueuePlayerWrapper: AVQueuePlayerWrapper(cachePath: cachePath, featureFlagProvider: .mock),
			crossfadingPlayerWrapper: CrossfadingPlayerWrapper(cachePath: cachePath, featureFlagProvider: .mock),
			externalPlayers: [PlayerMock.self]
		)
		mockPlayer = internalLoader.players.first { $0 is PlayerMock } as? PlayerMock
	}

	override func tearDown() {
		// Reset isSimulator to its default value after each test
		#if targetEnvironment(simulator)
		PlayerWorld.isSimulator = true
		#else
		PlayerWorld.isSimulator = false
		#endif
		super.tearDown()
	}

	// MARK: - DRM

	func testProduct_withDRM_hasLicenseLoader() async throws {
		// GIVEN
		let sessionId = "1"
		// Override isSimulator to false so we can test license loader creation
		PlayerWorld.isSimulator = false

		// WHEN
		_ = try await internalLoader.load(
			PlaybackInfo.mock(licenseSecurityToken: "security_token"),
			streamingSessionId: sessionId
		)

		// THEN
		XCTAssertEqual(mockPlayer.loadCallCount, 1)
		XCTAssertEqual(mockPlayer.licenseLoaders.count, 1)
		let expectedLicenseLoader = StreamingLicenseLoader(
			fairPlayLicenseFetcher: fairPlayLicenseFetcher,
			streamingSessionId: sessionId,
			featureFlagProvider: .mock
		)
		XCTAssertEqual(mockPlayer.licenseLoaders as? [StreamingLicenseLoader], [expectedLicenseLoader])
	}

	func testProduct_track_alwaysHasLicenseLoader() async throws {
		// GIVEN
		let sessionId = "1"
		PlayerWorld.isSimulator = false

		// WHEN
		_ = try await internalLoader.load(
			PlaybackInfo.mock(licenseSecurityToken: nil),
			streamingSessionId: sessionId
		)

		// THEN
		let expectedLicenseLoader = StreamingLicenseLoader(
			fairPlayLicenseFetcher: fairPlayLicenseFetcher,
			streamingSessionId: sessionId,
			featureFlagProvider: .mock
		)
		XCTAssertEqual(mockPlayer.loadCallCount, 1)
		XCTAssertEqual(mockPlayer.licenseLoaders.count, 1)
		XCTAssertEqual(mockPlayer.licenseLoaders as? [StreamingLicenseLoader], [expectedLicenseLoader])
	}

	// MARK: - load

	func test_load_PlayableStorageItem() async throws {
		// GIVEN
		let playbackInfo = PlaybackInfo.mock(
			mediaType: MediaTypes.BTS,
			licenseSecurityToken: "sdf2ewerqwe",
			albumReplayGain: 4,
			albumPeakAmplitude: 1
		)
		let offlinedMediaProduct = PlayableOfflinedMediaProduct(from: OfflineEntry.mock(
			from: playbackInfo,
			assetURL: URL(string: "www.tidal.com")!,
			licenseURL: URL(string: "www.tidal.com/license")!
		))!

		let loudnessNormalizer = LoudnessNormalizer.mock(
			preAmp: Constants.defaultPreAmp,
			replayGain: 4,
			peakAmplitude: 1
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
		PlayerWorld.isSimulator = false
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
		let expectedLicenseLoader = StreamingLicenseLoader(
			fairPlayLicenseFetcher: fairPlayLicenseFetcher,
			streamingSessionId: playbackInfo.streamingSessionId!,
			featureFlagProvider: .mock
		)

		XCTAssertEqual(asset, expectedAsset)
		XCTAssertEqual(mockPlayer.loadCallCount, 1)
		XCTAssertEqual(mockPlayer.assets, [expectedAsset])
		XCTAssertEqual(mockPlayer.licenseLoaders.count, 1)
		XCTAssertEqual(mockPlayer.licenseLoaders as? [StreamingLicenseLoader], [expectedLicenseLoader])
	}
}
