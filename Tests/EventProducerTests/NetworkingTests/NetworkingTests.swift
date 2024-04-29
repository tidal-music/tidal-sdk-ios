import Common
@testable import EventProducer
import XCTest

final class NetworkingTests: XCTestCase {
	private let networkService: NetworkingService = .init()

	func testEventAPIGetRequestBodyData() throws {
		let parameters = ["name": "value", "test": "123"]

		guard let data = try networkService.getRequestBodyData(parameters: parameters) else {
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

		guard let data = try networkService.getRequestBodyData(parameters: parameters) else {
			XCTFail("data error")
			return
		}

		let endpoint: Endpoint = .publicEvents(data, clientAuth: ["X-Auth-Header-Key": "clientID123"])

		guard let request = endpoint.request else {
			XCTFail("request error")
			return
		}

		XCTAssertEqual(request.url?.path, "/api/public/event-batch")
		XCTAssertEqual(request.url?.host, "event-collector.obelix-staging-use1.tidalhi.fi")
		XCTAssertEqual(request.httpBody, data)
		XCTAssertEqual(request.httpMethod, HTTPMethod.post.rawValue)
	}
}
