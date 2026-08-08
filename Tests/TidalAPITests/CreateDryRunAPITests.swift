import Foundation
@testable import TidalAPI
import XCTest

// MARK: - CreateDryRunAPITests

final class CreateDryRunAPITests: XCTestCase {
	func testIgnoringResponseBodyPreservesGeneratedRequest() {
		let original = ArtistsAPI.artistsPostWithRequestBuilder(
			idempotencyKey: "idempotency-key",
			artistsCreateOperationPayload: nil
		)

		let bodyIgnoring = RequestHelper.requestBuilderIgnoringResponseBody(original)

		XCTAssertEqual(bodyIgnoring.method, original.method)
		XCTAssertEqual(bodyIgnoring.URLString, original.URLString)
		XCTAssertEqual(bodyIgnoring.headers, original.headers)
		XCTAssertEqual(bodyIgnoring.requiresAuthentication, original.requiresAuthentication)
	}

	func testGenericSuccessDocumentIsAcceptedFor200() async throws {
		let response: Response<Void> = try await execute(
			statusCode: 200,
			data: Data(#"{"links":{"self":"/artists"},"meta":{"dryRun":true}}"#.utf8)
		)

		XCTAssertEqual(response.statusCode, 200)
	}

	func testGenericSuccessDocumentIsAcceptedFor201() async throws {
		let response: Response<Void> = try await execute(
			statusCode: 201,
			data: Data(#"{"links":{"self":"/artists"},"meta":{"dryRun":true}}"#.utf8)
		)

		XCTAssertEqual(response.statusCode, 201)
	}

	func testErrorResponseStillFails() async {
		do {
			let _: Response<Void> = try await execute(
				statusCode: 400,
				data: Data(#"{"errors":[{"status":"400"}]}"#.utf8)
			)
			XCTFail("Expected an error response to fail")
		} catch {
			// Expected.
		}
	}

	private func execute(statusCode: Int, data: Data?) async throws -> Response<Void> {
		let builder = StubRequestBuilder<Void>(
			method: "POST",
			URLString: "https://openapi.tidal.com/v2/artists",
			parameters: nil,
			requiresAuthentication: false
		)
		builder.stubSession = StubURLSession(statusCode: statusCode, data: data)
		return try await builder.execute()
	}
}

// MARK: - StubRequestBuilder

private final class StubRequestBuilder<T>: URLSessionRequestBuilder<T> {
	var stubSession: URLSessionProtocol = StubURLSession(statusCode: 500, data: nil)

	override func createURLSession() -> URLSessionProtocol {
		stubSession
	}
}

// MARK: - StubURLSession

private final class StubURLSession: URLSessionProtocol, @unchecked Sendable {
	private let statusCode: Int
	private let data: Data?

	init(statusCode: Int, data: Data?) {
		self.statusCode = statusCode
		self.data = data
	}

	func dataTaskFromProtocol(
		with request: URLRequest,
		completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
	) -> URLSessionDataTaskProtocol {
		let response = HTTPURLResponse(
			url: request.url!,
			statusCode: statusCode,
			httpVersion: nil,
			headerFields: ["Content-Type": "application/vnd.api+json"]
		)
		return StubURLSessionDataTask {
			completionHandler(self.data, response, nil)
		}
	}
}

// MARK: - StubURLSessionDataTask

private final class StubURLSessionDataTask: URLSessionDataTaskProtocol, @unchecked Sendable {
	let taskIdentifier = 1
	let progress = Progress(totalUnitCount: 1)

	private let completion: @Sendable () -> Void

	init(completion: @escaping @Sendable () -> Void) {
		self.completion = completion
	}

	func resume() {
		completion()
	}

	func cancel() {}
}
