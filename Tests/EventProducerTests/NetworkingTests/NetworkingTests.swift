import Common
@testable import EventProducer
import XCTest

final class NetworkingTests: XCTestCase {
	private struct MockAuthProvider: AuthProvider {
		let token: String?
		let clientID: String?
		func refreshAccessToken(status: Int?) {}
		func getToken() async -> String? {
			token
		}
	}

	private let maxDiskUsageBytes = 204_800

	private var mockAuthProvider: AuthProvider {
		MockAuthProvider(token: "testAccessToken", clientID: "testURL")
	}

	private var mockNetworkService: NetworkingService {
		NetworkingService(consumerUri: "https://consumer.uri")
	}

	func testEventAPIGetRequestBodyData() throws {
		let parameters = ["name": "value", "test": "123"]

		guard let data = try mockNetworkService.getRequestBodyData(parameters: parameters) else {
			XCTFail("data error")
			return
		}
		guard let body = String(data: data, encoding: .utf8) else {
			XCTFail("body string issue")
			return
		}

		let sortedBody = body.sorted(by: <)
		let sortedParams = "name=value&test=123".sorted(by: <)

		XCTAssertEqual(sortedParams, sortedBody)
	}

	func testEndpointRequest() throws {
		let parameters = ["name": "value", "test": "123"]

		guard let data = try mockNetworkService.getRequestBodyData(parameters: parameters) else {
			XCTFail("data error")
			return
		}

		let endpoint: Endpoint = .publicEvents(data, clientAuth: ["X-Auth-Header-Key": "clientID123"])

		guard let request = endpoint.request(to: "https://ec.tidal.com/api") else {
			XCTFail("request error")
			return
		}

		XCTAssertEqual(request.url?.path, "/api/public/event-batch")
		XCTAssertEqual(request.url?.host, "ec.tidal.com")
		XCTAssertEqual(request.httpBody, data)
		XCTAssertEqual(request.httpMethod, HTTPMethod.post.rawValue)
	}
}
