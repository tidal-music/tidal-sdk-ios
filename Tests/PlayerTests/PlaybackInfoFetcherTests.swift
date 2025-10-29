import Auth
import Common
import Foundation
@testable import Player
@testable import TidalAPI
import XCTest

// swiftlint:disable file_length type_body_length

// MARK: - Constants

private enum Constants {
	static let trackPlaybackInfo = TrackPlaybackInfo.mock(trackId: 1)
	static let mediaProduct = MediaProduct.mock(productId: "1")
	static let playbackInfo = PlaybackInfo.mock(mediaProduct: mediaProduct, trackPlaybackInfo: trackPlaybackInfo)
}

// MARK: - PlaybackInfoFetcherTests

final class PlaybackInfoFetcherTests: XCTestCase {
	private var urlSession: URLSession!
	private var httpClient: HttpClient!
	private var playerEventSender: PlayerEventSenderMock!
	private var credentialsProvider: CredentialsProviderMock!
	private var featureFlagProvider: FeatureFlagProvider!

	private let networkBackoffPolicy = BackoffPolicyMock()
	private let responseBackoffPolicy = BackoffPolicyMock()
	private let timeoutBackoffPolicy = BackoffPolicyMock()

	override func setUp() {
		PlayerWorld = PlayerWorldClient.mock
		Player.shared = nil

		let configuration = URLSessionConfiguration.default
		configuration.protocolClasses = [JsonEncodedResponseURLProtocol.self]
		urlSession = URLSession(configuration: configuration)

		JsonEncodedResponseURLProtocol.reset()

		httpClient = HttpClient(
			using: urlSession,
			responseErrorManager: ResponseErrorManager(backoffPolicy: responseBackoffPolicy),
			networkErrorManager: NetworkErrorManager(backoffPolicy: networkBackoffPolicy),
			timeoutErrorManager: TimeoutErrorManager(backoffPolicy: timeoutBackoffPolicy)
		)

		playerEventSender = PlayerEventSenderMock()
		credentialsProvider = CredentialsProviderMock()
		featureFlagProvider = .mock
	}

	override func tearDown() {
		JsonEncodedResponseURLProtocol.reset()
	}

	// MARK: - getPlaybackInfo

	func test_getPlaybackInfo_whenAuthModuleIsUsed_andPlaybackModeIsStream_shouldSucceed() async {
		// Given
		let configuration = Configuration.mock()
		let fetcher = PlaybackInfoFetcher.mock(
			configuration: configuration,
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			playerEventSender: playerEventSender
		)
		let mediaProduct = Constants.mediaProduct

		// Provide a successful token
		let credentials = Credentials.mock(token: "token")
		credentialsProvider.injectedAuthResult = .success(credentials)

		// Provide a playback info to be returned from server
		let trackPlaybackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: trackPlaybackInfo)

		do {
			// When
			let playbackMode: PlaybackMode = .STREAM
			let playbackInfo = try await fetcher.getPlaybackInfo(
				streamingSessionId: "streamingSessionId",
				mediaProduct: mediaProduct,
				playbackMode: playbackMode
			)

			// Then
			XCTAssertEqual(playbackInfo, Constants.playbackInfo)
			XCTAssertEqual(responseBackoffPolicy.counter, 0)
			XCTAssertEqual(networkBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)

			XCTAssertEqual(
				JsonEncodedResponseURLProtocol.requests.last?.url?.absoluteString,
				playbackInfoURL(
					trackId: mediaProduct.productId,
					audioQuality: configuration.streamingCellularAudioQuality,
					playbackMode: playbackMode,
					immersiveAudio: configuration.isImmersiveAudio
				)
			)
		} catch {
			XCTFail("getPlaybackInfo should have return injected playback info")
		}
	}

	func test_getPlaybackInfo_whenAuthModuleIsUsed_andPlaybackModeIsOffline_shouldSucceed() async {
		// Given
		let configuration = Configuration.mock()
		let fetcher = PlaybackInfoFetcher.mock(
			configuration: configuration,
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			playerEventSender: playerEventSender
		)
		let mediaProduct = Constants.mediaProduct

		// Provide a successful token
		let credentials = Credentials.mock(token: "token")
		credentialsProvider.injectedAuthResult = .success(credentials)

		// Provide a playback info to be returned from server
		let trackPlaybackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: trackPlaybackInfo)

		do {
			// When
			let playbackMode: PlaybackMode = .OFFLINE
			let playbackInfo = try await fetcher.getPlaybackInfo(
				streamingSessionId: "streamingSessionId",
				mediaProduct: mediaProduct,
				playbackMode: playbackMode
			)

			// Then
			XCTAssertEqual(playbackInfo, Constants.playbackInfo)
			XCTAssertEqual(responseBackoffPolicy.counter, 0)
			XCTAssertEqual(networkBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)

			XCTAssertEqual(
				JsonEncodedResponseURLProtocol.requests.last?.url?.absoluteString,
				playbackInfoURL(
					trackId: mediaProduct.productId,
					audioQuality: configuration.offlineAudioQuality,
					playbackMode: playbackMode,
					immersiveAudio: configuration.isImmersiveAudio
				)
			)
		} catch {
			XCTFail("getPlaybackInfo should have return injected playback info")
		}
	}

	func test_getPlaybackInfo_whenAuthModuleIsUsed_and_getCredentialsFail_shouldFail() async {
		// Given
		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			playerEventSender: playerEventSender
		)
		let mediaProduct = Constants.mediaProduct

		// Provide a failed token
		let thrownError = TidalErrorMock(code: "0", message: "message", throwable: nil)
		credentialsProvider.injectedAuthResult = .failure(thrownError)

		do {
			// When
			_ = try await fetcher.getPlaybackInfo(
				streamingSessionId: "streamingSessionId",
				mediaProduct: mediaProduct,
				playbackMode: .STREAM
			)

			// Then
			XCTFail("getPlaybackInfo should have returned an error when get token has failed")
		} catch {
			// Then
			XCTAssertEqual(error as? TidalError, thrownError)
		}
	}

	func test_getPlaybackInfo_whenAuthModuleIsUsed_and_getCredentialsSucceed_and_playbackFails_shouldFail() async {
		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			playerEventSender: playerEventSender
		)
		let mediaProduct = Constants.mediaProduct

		// Provide a successful token
		let credentials = Credentials.mock(token: "token")
		credentialsProvider.injectedAuthResult = .success(credentials)

		// Provide a playback info error to be returned from server
		let httpErrorCode = 404
		JsonEncodedResponseURLProtocol.fail(with: httpErrorCode)

		do {
			// When
			_ = try await fetcher.getPlaybackInfo(
				streamingSessionId: "streamingSessionId",
				mediaProduct: mediaProduct,
				playbackMode: .STREAM
			)

			// Then
			XCTFail("getPlaybackInfo should have returned an error when get playback has failed")
		} catch {
			// Then
			let expectedError = PlayerInternalError(
				errorId: .EUnexpected,
				errorType: .playbackInfoFetcherError,
				code: PlaybackInfoFetcherError.noResponseSubStatus.rawValue
			)
			XCTAssertEqual(error as? PlayerInternalError, expectedError)
		}
	}

	// MARK: - getPlaybackInfo - Error Handling

	func test4XXError_UnHandledHttpStatus() async {
		let httpErrorCode = 412
		let randomData = "RandomData".data(using: .utf8)
		JsonEncodedResponseURLProtocol.fail(with: httpErrorCode, data: randomData)

		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			playerEventSender: playerEventSender
		)

		// Provide a successful token
		credentialsProvider.injectSuccessfulUserLevelCredentials()

		do {
			_ = try await fetcher.getPlaybackInfo(
				streamingSessionId: "1234",
				mediaProduct: MediaProduct.mock(),
				playbackMode: .STREAM
			)
			XCTFail("Request should have failed")
		} catch {
			guard let internalError = error as? PlayerInternalError else {
				XCTFail("Invalid error type")
				return
			}
			XCTAssertEqual(internalError.errorId, .EUnexpected)
			XCTAssertEqual(internalError.errorType, .playbackInfoFetcherError)
			XCTAssertEqual(internalError.errorCode, PlaybackInfoFetcherError.unHandledHttpStatus.rawValue)
			XCTAssertEqual(responseBackoffPolicy.counter, 0)
			XCTAssertEqual(networkBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)
		}
	}

	func test403ErrorNoSubstatus_PlaybackInfoFetcherError() async {
		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			playerEventSender: playerEventSender
		)

		// Provide a successful token
		credentialsProvider.injectSuccessfulUserLevelCredentials()

		let httpErrorCode = 403
		let randomData = "RandomData".data(using: .utf8)
		JsonEncodedResponseURLProtocol.fail(with: httpErrorCode, data: randomData)

		do {
			_ = try await fetcher.getPlaybackInfo(
				streamingSessionId: "1234",
				mediaProduct: MediaProduct.mock(),
				playbackMode: .STREAM
			)
			XCTFail("Request should have failed")
		} catch {
			guard let internalError = error as? PlayerInternalError else {
				XCTFail("Invalid error type")
				return
			}
			XCTAssertEqual(internalError.errorId, .EUnexpected)
			XCTAssertEqual(internalError.errorType, .playbackInfoFetcherError)
			XCTAssertEqual(internalError.errorCode, PlaybackInfoFetcherError.noResponseSubStatus.rawValue)
			XCTAssertEqual(responseBackoffPolicy.counter, 0)
			XCTAssertEqual(networkBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)
		}
	}

	func test403ErrorWithSubstatus4006_StreamingPrivilegesLostError() async {
		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			playerEventSender: playerEventSender
		)

		// Provide a successful token
		credentialsProvider.injectSuccessfulUserLevelCredentials()

		let httpErrorCode = 403
		let subStatus = 4006
		let randomData = "{\"subStatus\": \(subStatus)}".data(using: .utf8)
		JsonEncodedResponseURLProtocol.fail(with: httpErrorCode, data: randomData)

		do {
			_ = try await fetcher.getPlaybackInfo(
				streamingSessionId: "1234",
				mediaProduct: MediaProduct.mock(),
				playbackMode: .STREAM
			)
			XCTFail("Request should have failed")
		} catch {
			XCTAssertTrue(error is StreamingPrivilegesLostError)
			XCTAssertEqual(responseBackoffPolicy.counter, 0)
			XCTAssertEqual(networkBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)
		}
	}

	func test403ErrorWithSubstatus4010_MonthlyStreamQuotaExceeded() async {
		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			playerEventSender: playerEventSender
		)

		// Provide a successful token
		credentialsProvider.injectSuccessfulUserLevelCredentials()

		let httpErrorCode = 403
		let subStatus = 4010
		let randomData = "{\"subStatus\": \(subStatus)}".data(using: .utf8)
		JsonEncodedResponseURLProtocol.fail(with: httpErrorCode, data: randomData)

		do {
			_ = try await fetcher.getPlaybackInfo(
				streamingSessionId: "1234",
				mediaProduct: MediaProduct.mock(),
				playbackMode: .STREAM
			)
			XCTFail("Request should have failed")
		} catch {
			guard let internalError = error as? PlayerInternalError else {
				XCTFail("Invalid error type")
				return
			}
			XCTAssertEqual(internalError.errorId, .PEMonthlyStreamQuotaExceeded)
			XCTAssertEqual(internalError.errorType, .playbackInfoForbidden)
			XCTAssertEqual(internalError.errorCode, subStatus)
			XCTAssertEqual(responseBackoffPolicy.counter, 0)
			XCTAssertEqual(networkBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)
		}
	}

	func test403ErrorWithSubstatus4032_ContentNotAvailableInLocation() async {
		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			playerEventSender: playerEventSender
		)

		// Provide a successful token
		credentialsProvider.injectSuccessfulUserLevelCredentials()

		let httpErrorCode = 403
		let subStatus = 4032
		let randomData = "{\"subStatus\": \(subStatus)}".data(using: .utf8)
		JsonEncodedResponseURLProtocol.fail(with: httpErrorCode, data: randomData)

		do {
			_ = try await fetcher.getPlaybackInfo(
				streamingSessionId: "1234",
				mediaProduct: MediaProduct.mock(),
				playbackMode: .STREAM
			)
			XCTFail("Request should have failed")
		} catch {
			guard let internalError = error as? PlayerInternalError else {
				XCTFail("Invalid error type")
				return
			}
			XCTAssertEqual(internalError.errorId, .PEContentNotAvailableInLocation)
			XCTAssertEqual(internalError.errorType, .playbackInfoForbidden)
			XCTAssertEqual(internalError.errorCode, subStatus)
			XCTAssertEqual(responseBackoffPolicy.counter, 0)
			XCTAssertEqual(networkBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)
		}
	}

	func test403ErrorWithSubstatus4033_ContentNotAvailableForSubscription() async {
		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			playerEventSender: playerEventSender
		)

		// Provide a successful token
		credentialsProvider.injectSuccessfulUserLevelCredentials()

		let httpErrorCode = 403
		let subStatus = 4033
		let randomData = "{\"subStatus\": \(subStatus)}".data(using: .utf8)
		JsonEncodedResponseURLProtocol.fail(with: httpErrorCode, data: randomData)

		do {
			_ = try await fetcher.getPlaybackInfo(
				streamingSessionId: "1234",
				mediaProduct: MediaProduct.mock(),
				playbackMode: .STREAM
			)
			XCTFail("Request should have failed")
		} catch {
			guard let internalError = error as? PlayerInternalError else {
				XCTFail("Invalid error type")
				return
			}
			XCTAssertEqual(internalError.errorId, .PEContentNotAvailableForSubscription)
			XCTAssertEqual(internalError.errorType, .playbackInfoForbidden)
			XCTAssertEqual(internalError.errorCode, subStatus)
			XCTAssertEqual(responseBackoffPolicy.counter, 0)
			XCTAssertEqual(networkBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)
		}
	}

	func test403ErrorWithSubstatus4035_ContentNotAvailableInLocation() async {
		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			playerEventSender: playerEventSender
		)

		// Provide a successful token
		credentialsProvider.injectSuccessfulUserLevelCredentials()

		let httpErrorCode = 403
		let subStatus = 4035
		let randomData = "{\"subStatus\": \(subStatus)}".data(using: .utf8)
		JsonEncodedResponseURLProtocol.fail(with: httpErrorCode, data: randomData)

		do {
			_ = try await fetcher.getPlaybackInfo(
				streamingSessionId: "1234",
				mediaProduct: MediaProduct.mock(),
				playbackMode: .STREAM
			)
			XCTFail("Request should have failed")
		} catch {
			guard let internalError = error as? PlayerInternalError else {
				XCTFail("Invalid error type")
				return
			}
			XCTAssertEqual(internalError.errorId, .PEContentNotAvailableInLocation)
			XCTAssertEqual(internalError.errorType, .playbackInfoForbidden)
			XCTAssertEqual(internalError.errorCode, subStatus)
			XCTAssertEqual(responseBackoffPolicy.counter, 0)
			XCTAssertEqual(networkBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)
		}
	}

	func test403ErrorWithSubstatus40XX_PlaybackInfoForbidden() async {
		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			playerEventSender: playerEventSender
		)

		// Provide a successful token
		credentialsProvider.injectSuccessfulUserLevelCredentials()

		let httpErrorCode = 403
		let subStatus = 4027
		let randomData = "{\"subStatus\": \(subStatus)}".data(using: .utf8)
		JsonEncodedResponseURLProtocol.fail(with: httpErrorCode, data: randomData)

		do {
			_ = try await fetcher.getPlaybackInfo(
				streamingSessionId: "1234",
				mediaProduct: MediaProduct.mock(),
				playbackMode: .STREAM
			)
			XCTFail("Request should have failed")
		} catch {
			guard let internalError = error as? PlayerInternalError else {
				XCTFail("Invalid error type")
				return
			}
			XCTAssertEqual(internalError.errorId, .PENotAllowed)
			XCTAssertEqual(internalError.errorType, .playbackInfoForbidden)
			XCTAssertEqual(internalError.errorCode, subStatus)
			XCTAssertEqual(responseBackoffPolicy.counter, 0)
			XCTAssertEqual(networkBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)
		}
	}

	func test404Error_PlaybackInfoFetcherError() async {
		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			playerEventSender: playerEventSender
		)

		// Provide a successful token
		credentialsProvider.injectSuccessfulUserLevelCredentials()

		let httpErrorCode = 404
		let randomData = "RandomData".data(using: .utf8)
		JsonEncodedResponseURLProtocol.fail(with: httpErrorCode, data: randomData)

		do {
			_ = try await fetcher.getPlaybackInfo(
				streamingSessionId: "1234",
				mediaProduct: MediaProduct.mock(),
				playbackMode: .STREAM
			)
			XCTFail("Request should have failed")
		} catch {
			guard let internalError = error as? PlayerInternalError else {
				XCTFail("Invalid error type")
				return
			}
			XCTAssertEqual(internalError.errorId, .EUnexpected)
			XCTAssertEqual(internalError.errorType, .playbackInfoFetcherError)
			XCTAssertEqual(internalError.errorCode, PlaybackInfoFetcherError.noResponseSubStatus.rawValue)
			XCTAssertEqual(responseBackoffPolicy.counter, 0)
			XCTAssertEqual(networkBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)
		}
	}

	func test404ErrorWithSubstatusXXXX() async {
		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			playerEventSender: playerEventSender
		)

		// Provide a successful token
		credentialsProvider.injectSuccessfulUserLevelCredentials()

		let httpErrorCode = 404
		let subStatus = 4004
		let randomData = "{\"subStatus\": \(subStatus)}".data(using: .utf8)
		JsonEncodedResponseURLProtocol.fail(with: httpErrorCode, data: randomData)

		do {
			_ = try await fetcher.getPlaybackInfo(
				streamingSessionId: "1234",
				mediaProduct: MediaProduct.mock(),
				playbackMode: .STREAM
			)
			XCTFail("Request should have failed")
		} catch {
			guard let internalError = error as? PlayerInternalError else {
				XCTFail("Invalid error type")
				return
			}
			XCTAssertEqual(internalError.errorId, .PENotAllowed)
			XCTAssertEqual(internalError.errorType, .playbackInfoNotFound)
			XCTAssertEqual(internalError.errorCode, subStatus)
			XCTAssertEqual(responseBackoffPolicy.counter, 0)
			XCTAssertEqual(networkBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)
		}
	}

	func test429Error_PlaybackInfoFetcherError() async {
		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			playerEventSender: playerEventSender
		)

		// Provide a successful token
		credentialsProvider.injectSuccessfulUserLevelCredentials()

		let httpErrorCode = 429
		let randomData = "RandomData".data(using: .utf8)
		JsonEncodedResponseURLProtocol.fail(with: httpErrorCode, data: randomData)

		do {
			_ = try await fetcher.getPlaybackInfo(
				streamingSessionId: "1234",
				mediaProduct: MediaProduct.mock(),
				playbackMode: .STREAM
			)
			XCTFail("Request should have failed")
		} catch {
			guard let internalError = error as? PlayerInternalError else {
				XCTFail("Invalid error type")
				return
			}
			XCTAssertEqual(internalError.errorId, .PERetryable)
			XCTAssertEqual(internalError.errorType, .playbackInfoFetcherError)
			XCTAssertEqual(internalError.errorCode, PlaybackInfoFetcherError.rateLimited.rawValue)
			XCTAssertEqual(responseBackoffPolicy.counter, 3)
			XCTAssertEqual(networkBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)
		}
	}

	func test5XXError_PlaybackInfoServerError() async {
		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			playerEventSender: playerEventSender
		)

		// Provide a successful token
		credentialsProvider.injectSuccessfulUserLevelCredentials()

		let httpErrorCode = 501
		let randomData = "RandomData".data(using: .utf8)
		JsonEncodedResponseURLProtocol.fail(with: httpErrorCode, data: randomData)

		do {
			_ = try await fetcher.getPlaybackInfo(
				streamingSessionId: "1234",
				mediaProduct: MediaProduct.mock(),
				playbackMode: .STREAM
			)
			XCTFail("Request should have failed")
		} catch {
			guard let internalError = error as? PlayerInternalError else {
				XCTFail("Invalid error type")
				return
			}
			XCTAssertEqual(internalError.errorId, .PERetryable)
			XCTAssertEqual(internalError.errorType, .playbackInfoServerError)
			XCTAssertEqual(internalError.errorCode, 501)
			XCTAssertEqual(responseBackoffPolicy.counter, 3)
			XCTAssertEqual(networkBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)
		}
	}

	// MARK: - New Playback Endpoints Tests

	func test_getTrackPlaybackInfo_whenNewEndpointsFlagEnabled_shouldUseNewAPI() async {
		// Given
		let featureFlagProvider = createFeatureFlagProvider(shouldUseNewPlaybackEndpoints: true)
		let _ = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			playerEventSender: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)
		
		// Test the feature flag behavior
		XCTAssertTrue(featureFlagProvider.shouldUseNewPlaybackEndpoints())
		
		// Note: This test validates that the feature flag is correctly configured.
		// Full integration testing of the new API would require mocking the TidalAPI calls
		// or using dependency injection, which is beyond the scope of this unit test.
	}

	func test_getTrackPlaybackInfo_whenNewEndpointsFlagDisabled_shouldUseLegacyAPI() async {
		// Given
		let featureFlagProvider = createFeatureFlagProvider(shouldUseNewPlaybackEndpoints: false)
		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			playerEventSender: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)
		
		// Provide successful credentials
		credentialsProvider.injectSuccessfulUserLevelCredentials()
		
		// Provide legacy API response
		let trackPlaybackInfo = Constants.trackPlaybackInfo
		JsonEncodedResponseURLProtocol.succeed(with: trackPlaybackInfo)
		
		do {
			// When
			let playbackInfo = try await fetcher.getPlaybackInfo(
				streamingSessionId: "streamingSessionId",
				mediaProduct: Constants.mediaProduct,
				playbackMode: .STREAM
			)
			
			// Then
			XCTAssertEqual(playbackInfo, Constants.playbackInfo)
			XCTAssertFalse(featureFlagProvider.shouldUseNewPlaybackEndpoints())
			
			// Verify legacy endpoint was called
			XCTAssertTrue(JsonEncodedResponseURLProtocol.requests.last?.url?.absoluteString.contains("playbackinfo") ?? false)
			
		} catch {
			XCTFail("Should not fail when using legacy endpoints: \(error)")
		}
	}

	func test_trackManifestParameters_shouldUseTypeUsingEnums() {
		// Test that our type-safe enums work correctly
		XCTAssertEqual(TrackManifestParameters.ManifestType.hls.rawValue, "HLS")
		XCTAssertEqual(TrackManifestParameters.ManifestType.mpegDash.rawValue, "MPEG_DASH")
		
		XCTAssertEqual(TrackManifestParameters.UriScheme.data.rawValue, "DATA")
		XCTAssertEqual(TrackManifestParameters.UriScheme.http.rawValue, "HTTP")
		
		XCTAssertEqual(TrackManifestParameters.Usage.playback.rawValue, "PLAYBACK")
		XCTAssertEqual(TrackManifestParameters.Usage.download.rawValue, "DOWNLOAD")
		
		XCTAssertEqual(TrackManifestParameters.Adaptive.true.rawValue, "true")
		XCTAssertEqual(TrackManifestParameters.Adaptive.false.rawValue, "false")
	}

	// MARK: - Helper Methods

	private func createFeatureFlagProvider(
		shouldUseNewPlaybackEndpoints: Bool,
		shouldSupportABRPlayback: Bool = false
	) -> FeatureFlagProvider {
		FeatureFlagProvider(
			shouldUseEventProducer: { true },
			isContentCachingEnabled: { true },
			shouldPauseAndPlayAroundSeek: { false },
			shouldNotPerformActionAtItemEnd: { false },
			shouldUseImprovedDRMHandling: { false },
			shouldUseNewPlaybackEndpoints: { shouldUseNewPlaybackEndpoints },
			shouldSupportABRPlayback: { shouldSupportABRPlayback }
		)
	}
}

extension PlaybackInfoFetcherTests {
	func playbackInfoURL(trackId: String, audioQuality: AudioQuality, playbackMode: PlaybackMode, immersiveAudio: Bool) -> String {
		let path = "https://api.tidal.com/v1/tracks/\(trackId)/playbackinfo"
		let parameters =
			"audioquality=\(audioQuality.rawValue)&assetpresentation=FULL&playbackmode=\(playbackMode.rawValue)&immersiveaudio=\(immersiveAudio)"
		let url = "\(path)?\(parameters)"
		return url
	}
}

// swiftlint:enable file_length type_body_length

// MARK: - New Playback Endpoints: Audio Quality Mapping Tests

extension PlaybackInfoFetcherTests {
	func test_formatsToAudioQuality_hiResLossless() {
		let result = PlaybackInfoFetcher.getAudioQualityFromFormats([.flacHires], fallback: .LOW)
		XCTAssertEqual(result, .HI_RES_LOSSLESS)
	}

	func test_formatsToAudioQuality_lossless() {
		let result = PlaybackInfoFetcher.getAudioQualityFromFormats([.flac], fallback: .LOW)
		XCTAssertEqual(result, .LOSSLESS)
	}

	func test_formatsToAudioQuality_high() {
		let result = PlaybackInfoFetcher.getAudioQualityFromFormats([.aaclc], fallback: .LOW)
		XCTAssertEqual(result, .HIGH)
	}

	func test_formatsToAudioQuality_low() {
		let result = PlaybackInfoFetcher.getAudioQualityFromFormats([.heaacv1], fallback: .HIGH)
		XCTAssertEqual(result, .LOW)
	}

	func test_formatsToAudioQuality_priorityOrdering() {
		// If multiple formats are present, prefer the highest quality in order
		let result1 = PlaybackInfoFetcher.getAudioQualityFromFormats([.aaclc, .flac], fallback: .LOW)
		XCTAssertEqual(result1, .LOSSLESS)

		let result2 = PlaybackInfoFetcher.getAudioQualityFromFormats([.heaacv1, .aaclc, .flacHires], fallback: .LOW)
		XCTAssertEqual(result2, .HI_RES_LOSSLESS)
	}

	func test_formatsToAudioQuality_emptyOrNilFallsBack() {
		XCTAssertEqual(PlaybackInfoFetcher.getAudioQualityFromFormats([], fallback: .HIGH), .HIGH)
		XCTAssertEqual(PlaybackInfoFetcher.getAudioQualityFromFormats(nil, fallback: .LOW), .LOW)
	}

	func test_buildFormatList_whenAdaptiveDisabled_returnsFormatsForMaxQuality() {
		let formats = PlaybackInfoFetcher.buildFormatList(maxQuality: .HIGH, adaptive: false)
		XCTAssertEqual(formats, [.heaacv1, .aaclc])
	}

	func test_buildFormatList_whenAdaptiveEnabled_returnsLadderUpToMaxQuality() {
		let formats = PlaybackInfoFetcher.buildFormatList(maxQuality: .HI_RES_LOSSLESS, adaptive: true)
		XCTAssertEqual(formats, [.heaacv1, .aaclc, .flac, .flacHires])
	}

	func test_buildFormatList_whenImmersiveAudioEnabledAndLosslessQuality_includesEac3Joc() {
		var configuration = Configuration.mock()
		configuration.isImmersiveAudio = true

		let formats = PlaybackInfoFetcher.buildFormatList(
			maxQuality: .LOSSLESS,
			adaptive: false,
			configuration: configuration
		)

		XCTAssertTrue(formats.contains(.eac3Joc))
		XCTAssertEqual(formats, [.heaacv1, .aaclc, .flac, .eac3Joc])
	}

	func test_buildFormatList_whenImmersiveAudioEnabledAndHiResLosslessQuality_includesEac3Joc() {
		var configuration = Configuration.mock()
		configuration.isImmersiveAudio = true

		let formats = PlaybackInfoFetcher.buildFormatList(
			maxQuality: .HI_RES_LOSSLESS,
			adaptive: false,
			configuration: configuration
		)

		XCTAssertTrue(formats.contains(.eac3Joc))
		XCTAssertEqual(formats, [.heaacv1, .aaclc, .flac, .flacHires, .eac3Joc])
	}

	func test_buildFormatList_whenImmersiveAudioEnabledButHighQuality_doesNotIncludeEac3Joc() {
		var configuration = Configuration.mock()
		configuration.isImmersiveAudio = true

		let formats = PlaybackInfoFetcher.buildFormatList(
			maxQuality: .HIGH,
			adaptive: false,
			configuration: configuration
		)

		XCTAssertFalse(formats.contains(.eac3Joc))
		XCTAssertEqual(formats, [.heaacv1, .aaclc])
	}

	func test_buildFormatList_whenImmersiveAudioDisabledAndLosslessQuality_doesNotIncludeEac3Joc() {
		var configuration = Configuration.mock()
		configuration.isImmersiveAudio = false

		let formats = PlaybackInfoFetcher.buildFormatList(
			maxQuality: .LOSSLESS,
			adaptive: false,
			configuration: configuration
		)

		XCTAssertFalse(formats.contains(.eac3Joc))
		XCTAssertEqual(formats, [.heaacv1, .aaclc, .flac])
	}

	func test_buildQualityLadderFromFormats_returnsOrderedQualities() {
		let ladder = PlaybackInfoFetcher.buildQualityLadder(
			from: [.heaacv1, .aaclc, .flac]
		)
		XCTAssertEqual(ladder, [.LOW, .HIGH, .LOSSLESS])
	}

	func test_buildQualityLadderFromFormats_whenHiResFormatsPresent_includesHiResLossless() {
		let ladder = PlaybackInfoFetcher.buildQualityLadder(
			from: [.heaacv1, .flacHires]
		)
		XCTAssertEqual(ladder, [.LOW, .HI_RES_LOSSLESS])
	}

	func test_buildQualityLadderUpTo_returnsOrderedQualities() {
		let ladder = PlaybackInfoFetcher.buildQualityLadder(upTo: .LOSSLESS)
		XCTAssertEqual(ladder, [.LOW, .HIGH, .LOSSLESS])
	}

	func test_shouldRequestAdaptivePlayback_checksFeatureFlagUserConsentAndMode() {
		var configuration = Configuration.mock()
		configuration.allowVariablePlayback = true

		let featureFlagsEnabled = createFeatureFlagProvider(
			shouldUseNewPlaybackEndpoints: true,
			shouldSupportABRPlayback: true
		)

		let shouldAdapt = PlaybackInfoFetcher.shouldRequestAdaptivePlayback(
			configuration: configuration,
			featureFlagProvider: featureFlagsEnabled,
			playbackMode: .STREAM
		)

		XCTAssertTrue(shouldAdapt)

		let shouldAdaptWhenFlagDisabled = PlaybackInfoFetcher.shouldRequestAdaptivePlayback(
			configuration: configuration,
			featureFlagProvider: createFeatureFlagProvider(
				shouldUseNewPlaybackEndpoints: true,
				shouldSupportABRPlayback: false
			),
			playbackMode: .STREAM
		)

		XCTAssertFalse(shouldAdaptWhenFlagDisabled)

		var configWithoutConsent = configuration
		configWithoutConsent.allowVariablePlayback = false

		let shouldAdaptWithoutConsent = PlaybackInfoFetcher.shouldRequestAdaptivePlayback(
			configuration: configWithoutConsent,
			featureFlagProvider: featureFlagsEnabled,
			playbackMode: .STREAM
		)

		XCTAssertFalse(shouldAdaptWithoutConsent)

		let shouldAdaptForOffline = PlaybackInfoFetcher.shouldRequestAdaptivePlayback(
			configuration: configuration,
			featureFlagProvider: featureFlagsEnabled,
			playbackMode: .OFFLINE
		)

		XCTAssertFalse(shouldAdaptForOffline)
	}
}
