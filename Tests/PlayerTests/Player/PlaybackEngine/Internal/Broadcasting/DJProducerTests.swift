import Auth
import AVFoundation
@testable import Player
import XCTest

// MARK: - Constants

private enum Constants {
	private static let url = URL(string: "https://www.tidal.com")!
	static let createBroadcastResponse = CreateBroadcastResponse.mock(
		broadcastId: "broadcastId",
		curationUrl: url,
		sharingUrl: url
	)

	static let title = "🎶"
}

// MARK: - DJProducerTests

final class DJProducerTests: XCTestCase {
	private var httpClient: HttpClient!
	private var accessTokenProvider: AccessTokenProvider!
	private var credentialsProvider: CredentialsProviderMock!
	private var djProducerListener: DJProducerListenerMock!
	private var djProducer: DJProducer!

	override func setUp() {
		super.setUp()

		PlayerWorld = PlayerWorldClient.mock

		let sessionConfiguration = URLSessionConfiguration.default
		sessionConfiguration.protocolClasses = [JsonEncodedResponseURLProtocol.self]
		let urlSession = URLSession(configuration: sessionConfiguration)
		httpClient = HttpClient.mock(urlSession: urlSession)
		accessTokenProvider = AuthTokenProviderMock()
		credentialsProvider = CredentialsProviderMock()

		djProducer = DJProducer(
			httpClient: httpClient,
			with: accessTokenProvider,
			credentialsProvider: credentialsProvider,
			featureFlagProvider: .mock
		)

		djProducerListener = DJProducerListenerMock()
		djProducer.delegate = djProducerListener
	}
}

// MARK: - Tests

extension DJProducerTests {
	// MARK: - start

	func test_start_whenAuthSucceedsAndCreatingABroadcastingSessionSucceeeds_shouldCall_DJProducerListener_djSessionStarted() {
		// Given
		// Provide a successful token
		let credentials = Credentials.mock(token: "token")
		credentialsProvider.injectedAuthResult = .success(credentials)

		// Inject create broadcast response to be returned from server
		let response = Constants.createBroadcastResponse
		JsonEncodedResponseURLProtocol.succeed(with: response)

		// When
		djProducer.start(Constants.title, with: .mock(), at: 0)

		// Then
		optimizedWait(until: {
			djProducerListener.djSessionStartedMetadatas.count == 1
		})

		let expectedDJSessionMetadata = DJSessionMetadata(
			sessionId: Constants.createBroadcastResponse.broadcastId,
			title: Constants.title,
			sharingURL: Constants.createBroadcastResponse.sharingUrl,
			reactions: Constants.createBroadcastResponse.reactions
		)
		XCTAssertEqual(djProducerListener.djSessionStartedMetadatas, [expectedDJSessionMetadata])
	}

	func test_start_whenAuthSucceedsAndCreatingABroadcastingSessionFails_shouldCall_DJProducerListener_djSessionEnded() {
		// Given
		// Provide a successful token
		let credentials = Credentials.mock(token: "token")
		credentialsProvider.injectedAuthResult = .success(credentials)

		// Inject failure
		JsonEncodedResponseURLProtocol.fail()

		// When
		djProducer.start(Constants.title, with: .mock(), at: 0)

		// Then
		optimizedWait(until: {
			djProducerListener.djSessionEndReasons.count == 1
		})

		let expectedDJSessionMetadata = DJSessionEndReason.failedToStart(code: "1")
		XCTAssertEqual(djProducerListener.djSessionEndReasons, [expectedDJSessionMetadata])
	}

	func test_start_whenAuthFails_shouldCall_DJProducerListener_djSessionEnded() {
		// Given
		// Provide a failed token
		let error = TidalErrorMock(code: "0")
		credentialsProvider.injectedAuthResult = .failure(error)

		// When
		djProducer.start(Constants.title, with: .mock(), at: 0)

		// Then
		let expectation =
			expectation(description: "DJProducer should call DJProducerListener djSessionEnded() after failed fetching auth token")

		let expectedDJSessionMetadata = DJSessionEndReason.failedToStart(code: "1")

		_ = XCTWaiter.wait(for: [expectation], timeout: 0.1)
		XCTAssertEqual(djProducerListener.djSessionEndReasons, [expectedDJSessionMetadata])
	}
}
