import Auth
import Common

// swiftlint:disable file_length type_body_length
import Foundation
@testable import Player
import XCTest

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

	func testValidTrackPlaybackInfo() async {
		featureFlagProvider.shouldUseAuthModule = { false }

		JsonEncodedResponseURLProtocol.succeed(with: TrackPlaybackInfo.mock())

		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			playerEventSender: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)

		do {
			let info: PlaybackInfo = try await fetcher.getPlaybackInfo(
				streamingSessionId: "1234",
				mediaProduct: MediaProduct.mock(),
				playbackMode: .STREAM
			)
			XCTAssertEqual(info.productId, String(TrackPlaybackInfo.mock().trackId))
			XCTAssertEqual(info.audioSampleRate, TrackPlaybackInfo.mock().sampleRate)
			XCTAssertEqual(info.audioBitDepth, TrackPlaybackInfo.mock().bitDepth)
			XCTAssertEqual(responseBackoffPolicy.counter, 0)
			XCTAssertEqual(networkBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)
		} catch {
			XCTFail("Import fail: \(error)")
		}
	}

	func test4XXError_UnHandledHttpStatus_withLegacyAuth() async {
		featureFlagProvider.shouldUseAuthModule = { false }

		let httpErrorCode = 412
		let randomData = "RandomData".data(using: .utf8)
		JsonEncodedResponseURLProtocol.fail(with: httpErrorCode, data: randomData)

		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			playerEventSender: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)

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

	func testAuth_MissingAccessToken_FailingRenewal() async {
		featureFlagProvider.shouldUseAuthModule = { false }

		let accessTokenProvider = ConfigurableAuthTokenProvider(accessToken: nil, onRenewal: { throw AnError() })
		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			accessTokenProvider: accessTokenProvider,
			playerEventSender: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)

		JsonEncodedResponseURLProtocol.succeed(with: TrackPlaybackInfo.mock())

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
			XCTAssertEqual(internalError.errorCode, PlaybackInfoFetcherError.unableToRenewAccessToken.rawValue)
			XCTAssertEqual(responseBackoffPolicy.counter, 0)
			XCTAssertEqual(networkBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)
		}
	}

	func testAuth_MissingAccessToken_SuccessfulRenewal() async {
		featureFlagProvider.shouldUseAuthModule = { false }

		let accessTokenProvider = ConfigurableAuthTokenProvider(accessToken: nil, onRenewal: { "SUCCESS" })
		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			accessTokenProvider: accessTokenProvider,
			playerEventSender: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)

		JsonEncodedResponseURLProtocol.succeed(with: TrackPlaybackInfo.mock())

		do {
			_ = try await fetcher.getPlaybackInfo(
				streamingSessionId: "1234",
				mediaProduct: MediaProduct.mock(),
				playbackMode: .STREAM
			)
			XCTAssertEqual(responseBackoffPolicy.counter, 0)
			XCTAssertEqual(networkBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)
		} catch {
			XCTFail("Request should have succeeded")
		}
	}

	func test401_InvalidToken_FailingRenewal() async {
		featureFlagProvider.shouldUseAuthModule = { false }

		let accessTokenProvider = ConfigurableAuthTokenProvider(accessToken: "FAIL", onRenewal: { throw AnError() })
		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			accessTokenProvider: accessTokenProvider,
			playerEventSender: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)

		JsonEncodedResponseURLProtocol.fail(with: 401, data: "RandomData".data(using: .utf8))

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
			XCTAssertEqual(internalError.errorCode, PlaybackInfoFetcherError.unableToRenewAccessToken.rawValue)
			XCTAssertEqual(responseBackoffPolicy.counter, 0)
			XCTAssertEqual(networkBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)
		}
	}

	func test401_InvalidToken_SuccessfulRenewal() async {
		featureFlagProvider.shouldUseAuthModule = { false }

		let accessTokenProvider = ConfigurableAuthTokenProvider(accessToken: "FAIL", onRenewal: {
			JsonEncodedResponseURLProtocol.succeed(with: TrackPlaybackInfo.mock())
			return "SUCCESS"
		})

		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			accessTokenProvider: accessTokenProvider,
			playerEventSender: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)

		JsonEncodedResponseURLProtocol.fail(with: 401, data: "RandomData".data(using: .utf8))

		do {
			_ = try await fetcher.getPlaybackInfo(
				streamingSessionId: "1234",
				mediaProduct: MediaProduct.mock(),
				playbackMode: .STREAM
			)
			XCTAssertEqual(responseBackoffPolicy.counter, 0)
			XCTAssertEqual(networkBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)
		} catch {
			XCTFail("Request should have succeeded")
		}
	}

	func test403ErrorNoSubstatus_PlaybackInfoFetcherError_withLegacyAuth() async {
		featureFlagProvider.shouldUseAuthModule = { false }

		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			playerEventSender: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)

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

	func test403ErrorWithSubstatus4006_StreamingPrivilegesLostError_withLegacyAuth() async {
		featureFlagProvider.shouldUseAuthModule = { false }

		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			playerEventSender: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)

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

	func test403ErrorWithSubstatus4010_MonthlyStreamQuotaExceeded_withLegacyAuth() async {
		featureFlagProvider.shouldUseAuthModule = { false }

		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			playerEventSender: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)

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

	func test403ErrorWithSubstatus4032_ContentNotAvailableInLocation_withLegacyAuth() async {
		featureFlagProvider.shouldUseAuthModule = { false }

		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			playerEventSender: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)

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

	func test403ErrorWithSubstatus4033_ContentNotAvailableForSubscription_withLegacyAuth() async {
		featureFlagProvider.shouldUseAuthModule = { false }

		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			playerEventSender: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)

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

	func test403ErrorWithSubstatus4035_ContentNotAvailableInLocation_withLegacyAuth() async {
		featureFlagProvider.shouldUseAuthModule = { false }

		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			playerEventSender: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)

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

	func test403ErrorWithSubstatus40XX_PlaybackInfoForbidden_withLegacyAuth() async {
		featureFlagProvider.shouldUseAuthModule = { false }

		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			playerEventSender: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)

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

	func test404Error_PlaybackInfoFetcherError_withLegacyAuth() async {
		featureFlagProvider.shouldUseAuthModule = { false }

		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			playerEventSender: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)

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

	func test404ErrorWithSubstatusXXXX_withLegacyAuth() async {
		featureFlagProvider.shouldUseAuthModule = { false }

		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			playerEventSender: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)

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

	func test429Error_PlaybackInfoFetcherError_withLegacyAuth() async {
		featureFlagProvider.shouldUseAuthModule = { false }

		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			playerEventSender: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)

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

	func test5XXError_PlaybackInfoServerError_withLegacyAuth() async {
		featureFlagProvider.shouldUseAuthModule = { false }

		let fetcher = PlaybackInfoFetcher.mock(
			httpClient: httpClient,
			credentialsProvider: credentialsProvider,
			playerEventSender: playerEventSender,
			featureFlagProvider: featureFlagProvider
		)

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
					playbackMode: playbackMode
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
					playbackMode: playbackMode
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
}

extension PlaybackInfoFetcherTests {
	func playbackInfoURL(trackId: String, audioQuality: AudioQuality, playbackMode: PlaybackMode) -> String {
		let path = "https://api.tidal.com/v1/tracks/\(trackId)/playbackinfo"
		let parameters = "audioquality=\(audioQuality.rawValue)&assetpresentation=FULL&playbackmode=\(playbackMode.rawValue)"
		let url = "\(path)?\(parameters)"
		return url
	}
}

// swiftlint:enable file_length type_body_length
