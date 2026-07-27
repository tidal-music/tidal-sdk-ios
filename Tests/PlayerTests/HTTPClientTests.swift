// swiftlint:disable type_body_length
import Foundation
@testable import Player
import Testing

// MARK: - TestResponse

private struct TestResponse: Codable, Equatable {
	let id: Int

	static func mock(id: Int = 1) -> Self {
		TestResponse(id: id)
	}
}

// MARK: - HTTPClientTests

@Suite(.serialized)
final class HTTPClientTests {
	var urlSession: URLSession!

	var httpClient: HttpClient!

	let networkBackoffPolicy = BackoffPolicyMock()
	let responseBackoffPolicy = BackoffPolicyMock()
	let timeoutBackoffPolicy = BackoffPolicyMock()

	init() {
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

	deinit {
		JsonEncodedResponseURLProtocol.reset()
	}

	@Test
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
					if let stringResult = String(data: result, encoding: .utf8) {
						responses.append(stringResult)
					}
				}

				return responses
			}

			Issue.record("Request should have failed")
		} catch {
			#expect(error is CancellationError)
			#expect(longBackoffPolicy.counter == 1)
		}
	}

	@Test
	func testValidRequest() async {
		JsonEncodedResponseURLProtocol.succeed(with: TestResponse.mock())

		do {
			let playbackInfo: TestResponse = try await httpClient.getJson(
				url: URL(string: "https://www.tidal.com")!,
				headers: [:]
			)
			#expect(playbackInfo.id == TestResponse.mock().id)
			#expect(networkBackoffPolicy.counter == 0)
			#expect(responseBackoffPolicy.counter == 0)
			#expect(timeoutBackoffPolicy.counter == 0)
		} catch {
			Issue.record("Import fail: \(error)")
		}
	}

	@Test
	func testCancelledError() async {
		JsonEncodedResponseURLProtocol.fail(with: URLError(URLError.cancelled))

		do {
			let _: TestResponse = try await httpClient.getJson(url: URL(string: "https://www.tidal.com")!, headers: [:])
			Issue.record("Request should have failed")
		} catch {
			#expect(error is CancellationError)
			#expect(networkBackoffPolicy.counter == 0)
			#expect(responseBackoffPolicy.counter == 0)
			#expect(timeoutBackoffPolicy.counter == 0)
		}
	}

	@Test
	func testNetworkConnectionLost() async {
		JsonEncodedResponseURLProtocol.fail(with: URLError(URLError.networkConnectionLost))

		do {
			let _: TestResponse = try await httpClient.getJson(url: URL(string: "https://www.tidal.com")!, headers: [:])
			Issue.record("Request should have failed")
		} catch {
			guard let internalError = error as? PlayerInternalError else {
				Issue.record("Invalid error type")
				return
			}
			#expect(internalError.errorId == .PENetwork)
			#expect(internalError.errorType == .networkError)
			#expect(internalError.errorCode == URLError.networkConnectionLost.rawValue)
			#expect(networkBackoffPolicy.counter == 10)
			#expect(responseBackoffPolicy.counter == 0)
			#expect(timeoutBackoffPolicy.counter == 0)
		}
	}

	@Test
	func testTimeoutError() async {
		JsonEncodedResponseURLProtocol.fail(with: URLError(URLError.timedOut))

		do {
			let _: TestResponse = try await httpClient.getJson(url: URL(string: "https://www.tidal.com")!, headers: [:])
			Issue.record("Request should have failed")
		} catch {
			guard let internalError = error as? PlayerInternalError else {
				Issue.record("Invalid error type")
				return
			}
			#expect(internalError.errorId == .PENetwork)
			#expect(internalError.errorType == .timeOutError)
			#expect(internalError.errorCode == URLError.timedOut.rawValue)
			#expect(networkBackoffPolicy.counter == 0)
			#expect(responseBackoffPolicy.counter == 0)
			#expect(timeoutBackoffPolicy.counter == 3)
		}
	}

	@Test
	func testUnexpectedURLError() async {
		JsonEncodedResponseURLProtocol.fail(with: URLError(URLError.resourceUnavailable))

		do {
			let _: TestResponse = try await httpClient.getJson(url: URL(string: "https://www.tidal.com")!, headers: [:])
			Issue.record("Request should have failed")
		} catch {
			guard let internalError = error as? PlayerInternalError else {
				Issue.record("Invalid error type")
				return
			}
			#expect(internalError.errorId == .PERetryable)
			#expect(internalError.errorType == .urlSessionError)
			#expect(internalError.errorCode == URLError.resourceUnavailable.rawValue)
			#expect(networkBackoffPolicy.counter == 10)
			#expect(responseBackoffPolicy.counter == 0)
			#expect(timeoutBackoffPolicy.counter == 0)
		}
	}

	@Test
	func test4XXError_HTTPClientError() async {
		let httpErrorCode = 401
		let randomData = Data("RandomData".utf8)
		JsonEncodedResponseURLProtocol.fail(with: httpErrorCode, data: randomData)

		do {
			let _: TestResponse = try await httpClient.getJson(url: URL(string: "https://www.tidal.com")!, headers: [:])
			Issue.record("Request should have failed")
		} catch {
			guard let httpError = error as? HttpError else {
				Issue.record("Invalid error type")
				return
			}

			#expect(httpError == .httpClientError(statusCode: httpErrorCode, message: randomData))
			#expect(networkBackoffPolicy.counter == 0)
			#expect(responseBackoffPolicy.counter == 0)
			#expect(timeoutBackoffPolicy.counter == 0)
		}
	}

	@Test
	func test429Error_HTTPClientError() async {
		let httpErrorCode = 429
		let randomData = Data("RandomData".utf8)
		JsonEncodedResponseURLProtocol.fail(with: httpErrorCode, data: randomData)

		do {
			let _: TestResponse = try await httpClient.getJson(url: URL(string: "https://www.tidal.com")!, headers: [:])
			Issue.record("Request should have failed")
		} catch {
			guard let httpError = error as? HttpError else {
				Issue.record("Invalid error type")
				return
			}

			#expect(httpError == .httpClientError(statusCode: httpErrorCode, message: randomData))
			#expect(responseBackoffPolicy.counter == 3)
			#expect(networkBackoffPolicy.counter == 0)
			#expect(timeoutBackoffPolicy.counter == 0)
		}
	}

	@Test
	func test5XXError_HTTPServerError() async {
		let httpErrorCode = 501
		let randomData = Data("RandomData".utf8)
		JsonEncodedResponseURLProtocol.fail(with: httpErrorCode, data: randomData)

		do {
			let _: TestResponse = try await httpClient.getJson(url: URL(string: "https://www.tidal.com")!, headers: [:])
			Issue.record("Request should have failed")
		} catch {
			guard let httpError = error as? HttpError else {
				Issue.record("Invalid error type")
				return
			}

			#expect(httpError == .httpServerError(statusCode: httpErrorCode))
			#expect(responseBackoffPolicy.counter == 3)
			#expect(networkBackoffPolicy.counter == 0)
			#expect(timeoutBackoffPolicy.counter == 0)
		}
	}

	@Test
	func test503Error_HTTPServerError() async {
		let httpErrorCode = 503
		let randomData = Data("RandomData".utf8)
		JsonEncodedResponseURLProtocol.fail(with: httpErrorCode, data: randomData)

		do {
			let _: TestResponse = try await httpClient.getJson(url: URL(string: "https://www.tidal.com")!, headers: [:])
			Issue.record("Request should have failed")
		} catch {
			guard let httpError = error as? HttpError else {
				Issue.record("Invalid error type")
				return
			}

			#expect(httpError == .httpServerError(statusCode: httpErrorCode))
			#expect(responseBackoffPolicy.counter == 3)
			#expect(networkBackoffPolicy.counter == 0)
			#expect(timeoutBackoffPolicy.counter == 0)
		}
	}

	@Test
	func test7XXError_UnsupportedHttpStatus() async {
		let httpErrorCode = 707
		let randomData = Data("RandomData".utf8)
		JsonEncodedResponseURLProtocol.fail(with: httpErrorCode, data: randomData)

		do {
			let _: TestResponse = try await httpClient.getJson(url: URL(string: "https://www.tidal.com")!, headers: [:])
			Issue.record("Request should have failed")
		} catch {
			guard let internalError = error as? PlayerInternalError else {
				Issue.record("Invalid error type")
				return
			}
			#expect(internalError.errorId == .EUnexpected)
			#expect(internalError.errorType == .httpClientError)
			#expect(internalError.errorCode == ErrorCode.unsupportedHttpStatus.rawValue)
			#expect(responseBackoffPolicy.counter == 0)
			#expect(networkBackoffPolicy.counter == 0)
			#expect(timeoutBackoffPolicy.counter == 0)
		}
	}

	@Test
	func testSomeNetworkErrors_thenSucceed() async {
		// swiftlint:disable force_try
		let data = try! JSONEncoder().encode(TestResponse.mock())
		// swiftlint:enable force_try

		var responses = [JsonEncodedResponseURLProtocol.Response](
			repeating: JsonEncodedResponseURLProtocol.Response(error: URLError(URLError.networkConnectionLost)),
			count: 3
		)
		responses.append(JsonEncodedResponseURLProtocol.Response(data: data))

		JsonEncodedResponseURLProtocol.replay(responses)

		do {
			let playbackInfo: TestResponse = try await httpClient.getJson(
				url: URL(string: "https://www.tidal.com")!,
				headers: [:]
			)
			#expect(playbackInfo.id == TestResponse.mock().id)
			#expect(networkBackoffPolicy.counter == 3)
			#expect(responseBackoffPolicy.counter == 0)
			#expect(timeoutBackoffPolicy.counter == 0)
		} catch {
			Issue.record("Import fail: \(error)")
		}
	}

	@Test
	func testSomeNetworkErrors_thenResponseError_thenSucceed() async {
		// swiftlint:disable force_try
		let data = try! JSONEncoder().encode(TestResponse.mock())
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
			let playbackInfo: TestResponse = try await httpClient.getJson(
				url: URL(string: "https://www.tidal.com")!,
				headers: [:]
			)
			#expect(playbackInfo.id == TestResponse.mock().id)
			#expect(networkBackoffPolicy.counter == 3)
			#expect(responseBackoffPolicy.counter == 1)
			#expect(timeoutBackoffPolicy.counter == 0)
		} catch {
			Issue.record("Import fail: \(error)")
		}
	}

	// MARK: - Skipped

	/// Seems like there is no way to get a succesful response without data
	/// https://stackoverflow.com/questions/62406384/how-to-load-nil-data-with-a-urlprotocol-subclass
	/// So we would need to modify the current httpClient implementation to check if data.length == 0
	///
	@Test(.disabled("No way for this error to happen"))
	func testNoDataError() async throws {}

	/// Seems like there is no way for that error to actually happen
	/// https://developer.apple.com/forums/thread/120099
	/// As long as the url has an http scheme, the URLResponse can always be downcastto an HTTPURLResponse
	/// so we will never reach that part of the code
	///
	@Test(.disabled("No way for this error to happen"))
	func testNoResponseError() async throws {}
}

// swiftlint:enable type_body_length
