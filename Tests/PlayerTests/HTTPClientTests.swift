// swiftlint:disable type_body_length
import Foundation
@testable import Player
import XCTest

final class HTTPClientTests: XCTestCase {
	var urlSession: URLSession!

	var httpClient: HttpClient!

	let networkBackoffPolicy = BackoffPolicyMock()
	let responseBackoffPolicy = BackoffPolicyMock()
	let timeoutBackoffPolicy = BackoffPolicyMock()

	override func setUp() {
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
	}

	override func tearDown() {
		JsonEncodedResponseURLProtocol.reset()
	}

	func testBackoffCancellation() async {
		let longBackoffPolicy = ForcedLongBackoffPolicy()
		let customHttpClient = HttpClient(
			using: urlSession,
			responseErrorManager: ResponseErrorManager(backoffPolicy: longBackoffPolicy),
			networkErrorManager: NetworkErrorManager(backoffPolicy: longBackoffPolicy),
			timeoutErrorManager: TimeoutErrorManager(backoffPolicy: longBackoffPolicy)
		)

		JsonEncodedResponseURLProtocol.replay([
			JsonEncodedResponseURLProtocol.Response(error: URLError(URLError.networkConnectionLost)),
			JsonEncodedResponseURLProtocol.Response(data: Data("Success 1".utf8)),
			JsonEncodedResponseURLProtocol.Response(data: Data("Success 2".utf8)),
		])

		do {
			_ = Task<Void, Error> {
				try? await Task.sleep(seconds: 1)
				customHttpClient.cancelAllRequests()
			}

			let _: [String] = try await withThrowingTaskGroup(of: Data.self) { taskGroup in

				var responses = [String]()

				taskGroup.addTask {
					try await customHttpClient.get(url: URL(string: "https://www.tidal.com")!, headers: [:])
				}
				taskGroup.addTask {
					try await customHttpClient.get(url: URL(string: "https://www.tidal.com")!, headers: [:])
				}
				taskGroup.addTask {
					try await customHttpClient.get(url: URL(string: "https://www.tidal.com")!, headers: [:])
				}

				for try await result in taskGroup {
					let stringResult = String(decoding: result, as: UTF8.self)
					responses.append(stringResult)
				}

				return responses
			}

			XCTFail("Request should have failed")
		} catch {
			XCTAssertTrue(error is CancellationError)
			XCTAssertEqual(longBackoffPolicy.counter, 1)
		}
	}

	func testValidRequest() async {
		JsonEncodedResponseURLProtocol.succeed(with: TrackPlaybackInfo.mock())

		do {
			let playbackInfo: TrackPlaybackInfo = try await httpClient.getJson(
				url: URL(string: "https://www.tidal.com")!,
				headers: [:]
			)
			XCTAssertEqual(playbackInfo.trackId, TrackPlaybackInfo.mock().trackId)
			XCTAssertEqual(networkBackoffPolicy.counter, 0)
			XCTAssertEqual(responseBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)
		} catch {
			XCTFail("Import fail: \(error)")
		}
	}

	func testCancelledError() async {
		JsonEncodedResponseURLProtocol.fail(with: URLError(URLError.cancelled))

		do {
			let _: TrackPlaybackInfo = try await httpClient.getJson(url: URL(string: "https://www.tidal.com")!, headers: [:])
			XCTFail("Request should have failed")
		} catch {
			XCTAssertTrue(error is CancellationError)
			XCTAssertEqual(networkBackoffPolicy.counter, 0)
			XCTAssertEqual(responseBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)
		}
	}

	func testNetworkConnectionLost() async {
		JsonEncodedResponseURLProtocol.fail(with: URLError(URLError.networkConnectionLost))

		do {
			let _: TrackPlaybackInfo = try await httpClient.getJson(url: URL(string: "https://www.tidal.com")!, headers: [:])
			XCTFail("Request should have failed")
		} catch {
			guard let internalError = error as? PlayerInternalError else {
				XCTFail("Invalid error type")
				return
			}
			XCTAssertEqual(internalError.errorId, .PENetwork)
			XCTAssertEqual(internalError.errorType, .networkError)
			XCTAssertEqual(internalError.errorCode, URLError.networkConnectionLost.rawValue)
			XCTAssertEqual(networkBackoffPolicy.counter, 10)
			XCTAssertEqual(responseBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)
		}
	}

	func testTimeoutError() async {
		JsonEncodedResponseURLProtocol.fail(with: URLError(URLError.timedOut))

		do {
			let _: TrackPlaybackInfo = try await httpClient.getJson(url: URL(string: "https://www.tidal.com")!, headers: [:])
			XCTFail("Request should have failed")
		} catch {
			guard let internalError = error as? PlayerInternalError else {
				XCTFail("Invalid error type")
				return
			}
			XCTAssertEqual(internalError.errorId, .PENetwork)
			XCTAssertEqual(internalError.errorType, .timeOutError)
			XCTAssertEqual(internalError.errorCode, URLError.timedOut.rawValue)
			XCTAssertEqual(networkBackoffPolicy.counter, 0)
			XCTAssertEqual(responseBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 3)
		}
	}

	func testUnexpectedURLError() async {
		JsonEncodedResponseURLProtocol.fail(with: URLError(URLError.resourceUnavailable))

		do {
			let _: TrackPlaybackInfo = try await httpClient.getJson(url: URL(string: "https://www.tidal.com")!, headers: [:])
			XCTFail("Request should have failed")
		} catch {
			guard let internalError = error as? PlayerInternalError else {
				XCTFail("Invalid error type")
				return
			}
			XCTAssertEqual(internalError.errorId, .PERetryable)
			XCTAssertEqual(internalError.errorType, .urlSessionError)
			XCTAssertEqual(internalError.errorCode, URLError.resourceUnavailable.rawValue)
			XCTAssertEqual(networkBackoffPolicy.counter, 10)
			XCTAssertEqual(responseBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)
		}
	}

	func test4XXError_HTTPClientError() async {
		let httpErrorCode = 401
		let randomData = Data("RandomData".utf8)
		JsonEncodedResponseURLProtocol.fail(with: httpErrorCode, data: randomData)

		do {
			let _: TrackPlaybackInfo = try await httpClient.getJson(url: URL(string: "https://www.tidal.com")!, headers: [:])
			XCTFail("Request should have failed")
		} catch {
			guard let httpError = error as? HttpError else {
				XCTFail("Invalid error type")
				return
			}

			XCTAssertEqual(httpError, .httpClientError(statusCode: httpErrorCode, message: randomData))
			XCTAssertEqual(networkBackoffPolicy.counter, 0)
			XCTAssertEqual(responseBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)
		}
	}

	func test429Error_HTTPClientError() async {
		let httpErrorCode = 429
		let randomData = Data("RandomData".utf8)
		JsonEncodedResponseURLProtocol.fail(with: httpErrorCode, data: randomData)

		do {
			let _: TrackPlaybackInfo = try await httpClient.getJson(url: URL(string: "https://www.tidal.com")!, headers: [:])
			XCTFail("Request should have failed")
		} catch {
			guard let httpError = error as? HttpError else {
				XCTFail("Invalid error type")
				return
			}

			XCTAssertEqual(httpError, .httpClientError(statusCode: httpErrorCode, message: randomData))
			XCTAssertEqual(responseBackoffPolicy.counter, 3)
			XCTAssertEqual(networkBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)
		}
	}

	func test5XXError_HTTPServerError() async {
		let httpErrorCode = 501
		let randomData = Data("RandomData".utf8)
		JsonEncodedResponseURLProtocol.fail(with: httpErrorCode, data: randomData)

		do {
			let _: TrackPlaybackInfo = try await httpClient.getJson(url: URL(string: "https://www.tidal.com")!, headers: [:])
			XCTFail("Request should have failed")
		} catch {
			guard let httpError = error as? HttpError else {
				XCTFail("Invalid error type")
				return
			}

			XCTAssertEqual(httpError, .httpServerError(statusCode: httpErrorCode))
			XCTAssertEqual(responseBackoffPolicy.counter, 3)
			XCTAssertEqual(networkBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)
		}
	}

	func test503Error_HTTPServerError() async {
		let httpErrorCode = 503
		let randomData = Data("RandomData".utf8)
		JsonEncodedResponseURLProtocol.fail(with: httpErrorCode, data: randomData)

		do {
			let _: TrackPlaybackInfo = try await httpClient.getJson(url: URL(string: "https://www.tidal.com")!, headers: [:])
			XCTFail("Request should have failed")
		} catch {
			guard let httpError = error as? HttpError else {
				XCTFail("Invalid error type")
				return
			}

			XCTAssertEqual(httpError, .httpServerError(statusCode: httpErrorCode))
			XCTAssertEqual(responseBackoffPolicy.counter, 3)
			XCTAssertEqual(networkBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)
		}
	}

	func test7XXError_UnsupportedHttpStatus() async {
		let httpErrorCode = 707
		let randomData = Data("RandomData".utf8)
		JsonEncodedResponseURLProtocol.fail(with: httpErrorCode, data: randomData)

		do {
			let _: TrackPlaybackInfo = try await httpClient.getJson(url: URL(string: "https://www.tidal.com")!, headers: [:])
			XCTFail("Request should have failed")
		} catch {
			guard let internalError = error as? PlayerInternalError else {
				XCTFail("Invalid error type")
				return
			}
			XCTAssertEqual(internalError.errorId, .EUnexpected)
			XCTAssertEqual(internalError.errorType, .httpClientError)
			XCTAssertEqual(internalError.errorCode, ErrorCode.unsupportedHttpStatus.rawValue)
			XCTAssertEqual(responseBackoffPolicy.counter, 0)
			XCTAssertEqual(networkBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)
		}
	}

	func testSomeNetworkErrors_thenSucceed() async {
		// swiftlint:disable force_try
		let data = try! JSONEncoder().encode(TrackPlaybackInfo.mock())
		// swiftlint:enable force_try

		var responses = [JsonEncodedResponseURLProtocol.Response](
			repeating: JsonEncodedResponseURLProtocol.Response(error: URLError(URLError.networkConnectionLost)),
			count: 3
		)
		responses.append(JsonEncodedResponseURLProtocol.Response(data: data))

		JsonEncodedResponseURLProtocol.replay(responses)

		do {
			let playbackInfo: TrackPlaybackInfo = try await httpClient.getJson(
				url: URL(string: "https://www.tidal.com")!,
				headers: [:]
			)
			XCTAssertEqual(playbackInfo.trackId, TrackPlaybackInfo.mock().trackId)
			XCTAssertEqual(networkBackoffPolicy.counter, 3)
			XCTAssertEqual(responseBackoffPolicy.counter, 0)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)
		} catch {
			XCTFail("Import fail: \(error)")
		}
	}

	func testSomeNetworkErrors_thenResponseError_thenSucceed() async {
		// swiftlint:disable force_try
		let data = try! JSONEncoder().encode(TrackPlaybackInfo.mock())
		// swiftlint:enable force_try

		let httpErrorCode = 501
		let randomData = Data("RandomData".utf8)

		var responses = [JsonEncodedResponseURLProtocol.Response](
			repeating: JsonEncodedResponseURLProtocol.Response(error: URLError(URLError.networkConnectionLost)),
			count: 3
		)
		responses.append(JsonEncodedResponseURLProtocol.Response(httpStatus: httpErrorCode, data: randomData))
		responses.append(JsonEncodedResponseURLProtocol.Response(data: data))

		JsonEncodedResponseURLProtocol.replay(responses)

		do {
			let playbackInfo: TrackPlaybackInfo = try await httpClient.getJson(
				url: URL(string: "https://www.tidal.com")!,
				headers: [:]
			)
			XCTAssertEqual(playbackInfo.trackId, TrackPlaybackInfo.mock().trackId)
			XCTAssertEqual(networkBackoffPolicy.counter, 3)
			XCTAssertEqual(responseBackoffPolicy.counter, 1)
			XCTAssertEqual(timeoutBackoffPolicy.counter, 0)
		} catch {
			XCTFail("Import fail: \(error)")
		}
	}

	// MARK: - Skipped

	/// Seems like there is no way to get a succesful response without data
	/// https://stackoverflow.com/questions/62406384/how-to-load-nil-data-with-a-urlprotocol-subclass
	/// So we would need to modify the current httpClient implementation to check if data.length == 0
	///
	func testNoDataError() async throws {
		throw XCTSkip("No way for this error to happen")
	}

	/// Seems like there is no way for that error to actually happen
	/// https://developer.apple.com/forums/thread/120099
	/// As long as the url has an http scheme, the URLResponse can always be downcastto an HTTPURLResponse
	/// so we will never reach that part of the code
	///
	func testNoResponseError() async throws {
		throw XCTSkip("No way for this error to happen")
	}
}

// swiftlint:enable type_body_length
