import Auth
import AVFoundation
@testable import Player
import Testing

// MARK: - Constants

private enum Constants {
	static let authNilTokenError = PlayerInternalError(errorId: .EUnexpected, errorType: .authError, code: 0)
}

// MARK: - FairPlayLicenseFetcherTests

@Suite(.serialized)
final class FairPlayLicenseFetcherTests {
	private var httpClient: HttpClient!
	private var credentialsProvider: CredentialsProviderMock!
	private var playerEventSender: PlayerEventSender!
	private var fetcher: FairPlayLicenseFetcher!

	init() {
		PlayerWorld = PlayerWorldClient.mock

		let sessionConfiguration = URLSessionConfiguration.default
		sessionConfiguration.protocolClasses = [JsonEncodedResponseURLProtocol.self]
		let urlSession = URLSession(configuration: sessionConfiguration)
		httpClient = HttpClient.mock(urlSession: urlSession)
		credentialsProvider = CredentialsProviderMock()
		playerEventSender = PlayerEventSenderMock()
		fetcher = FairPlayLicenseFetcher(
			with: httpClient,
			credentialsProvider: credentialsProvider,
			and: playerEventSender,
			featureFlagProvider: .mock
		)
	}
}

// MARK: - Tests

extension FairPlayLicenseFetcherTests {
	// MARK: - getLicense

	@Test
	func test_getLicense_shouldSucceed() async throws {
		// Given
		let keyRequest = KeyRequestMock()
		keyRequest.shouldGetKeyIdSucceed = true
		keyRequest.shouldCreateServerPlaybackContextSucceed = true

		// Inject license to be returned from server
		let response = "certificate"
		JsonEncodedResponseURLProtocol.succeed(with: response)
		let expectedLicense = try JSONEncoder().encode(response)

		// Provide a successful token
		let credentials = Credentials.mock(token: "token")
		credentialsProvider.injectedAuthResult = .success(credentials)

		// When
		let licence = try await fetcher.getLicense(streamingSessionId: "streamingSessionId", keyRequest: keyRequest)

		// Then
		#expect(licence == expectedLicense)
	}

	@Test
	func test_getLicense_whenTokenIsNil_shouldFail() async throws {
		// Given
		let keyRequest = KeyRequestMock()
		keyRequest.shouldGetKeyIdSucceed = true
		keyRequest.shouldCreateServerPlaybackContextSucceed = true

		// Inject license to be returned from server
		let response = "certificate"
		JsonEncodedResponseURLProtocol.succeed(with: response)

		// Provide a nil token which will cause it to fail
		let credentials = Credentials.mock()
		credentialsProvider.injectedAuthResult = .success(credentials)

		do {
			// When
			_ = try await fetcher.getLicense(streamingSessionId: "streamingSessionId", keyRequest: keyRequest)

			Issue.record("getLicense should have returned an error when token returned is nil")
		} catch {
			// Then
			#expect(error as? PlayerInternalError == Constants.authNilTokenError)
		}
	}

	@Test
	func test_getLicense_whenGetKeyIdFails_shouldFail() async throws {
		// Given
		let keyRequest = KeyRequestMock()
		keyRequest.shouldGetKeyIdSucceed = false
		keyRequest.shouldCreateServerPlaybackContextSucceed = false

		// Inject license to be returned from server
		let response = "certificate"
		JsonEncodedResponseURLProtocol.succeed(with: response)

		// Provide a successful token
		let credentials = Credentials.mock(token: "token")
		credentialsProvider.injectedAuthResult = .success(credentials)

		do {
			// When
			_ = try await fetcher.getLicense(streamingSessionId: "streamingSessionId", keyRequest: keyRequest)

			Issue.record("getLicense should have returned an error when getKeyId of key request fails")
		} catch {
			// Then
			let expectedError = keyRequest.error
			#expect(error as? PlayerInternalError == expectedError)
		}
	}

	@Test
	func test_getLicense_whenGetKeyIdSucceedsAndCreateServerPlaybackContextFails() async throws {
		// Given
		let keyRequest = KeyRequestMock()
		keyRequest.shouldGetKeyIdSucceed = true
		keyRequest.shouldCreateServerPlaybackContextSucceed = false

		// Inject license to be returned from server
		let response = "certificate"
		JsonEncodedResponseURLProtocol.succeed(with: response)

		// Provide a successful token
		let credentials = Credentials.mock(token: "token")
		credentialsProvider.injectedAuthResult = .success(credentials)

		do {
			// When
			_ = try await fetcher.getLicense(streamingSessionId: "streamingSessionId", keyRequest: keyRequest)

			Issue.record("getLicense should have returned an error when createServerPlaybackContext of key request fails")
		} catch {
			// Then
			let expectedError = keyRequest.error
			#expect(error as? PlayerInternalError == expectedError)
		}
	}
}
