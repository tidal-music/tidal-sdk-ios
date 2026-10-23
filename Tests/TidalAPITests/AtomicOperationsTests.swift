import Foundation
@testable import TidalAPI
import XCTest

final class AtomicOperationsTests: XCTestCase {
	func testAtomicRequestEncodesLocalLinkageAndRequiredExtension() throws {
		let payload = AtomicOperationsRequest(atomicOperations: [
			.atomicOperationsRequestAtomicOperationsInnerOneOf1(.init(
				data: .init(attributes: .init(title: "Tour tee"), lid: "item", type: .squareitems),
				op: .add
			)),
			.atomicOperationsRequestAtomicOperationsInnerOneOf(.init(
				data: .init(
					attributes: .init(name: "Small", price: "12.34", stockTracked: true),
					lid: "small",
					relationships: .init(items: .init(data: [.init(lid: "item", type: .squareitems)])),
					type: .squareitemvariations
				),
				op: .add
			)),
		])
		let encoded = try JSONEncoder().encode(payload)
		let document = try XCTUnwrap(JSONSerialization.jsonObject(with: encoded) as? [String: Any])
		let operations = try XCTUnwrap(document["atomic:operations"] as? [[String: Any]])
		let item = try XCTUnwrap(operations.first?["data"] as? [String: Any])
		let variation = try XCTUnwrap(operations.last?["data"] as? [String: Any])
		let relationships = try XCTUnwrap(variation["relationships"] as? [String: Any])
		let items = try XCTUnwrap(relationships["items"] as? [String: Any])
		let linkage = try XCTUnwrap(items["data"] as? [[String: String]])
		XCTAssertEqual(operations.count, 2)
		XCTAssertEqual(item["lid"] as? String, "item")
		XCTAssertEqual(linkage, [["lid": "item", "type": "squareItems"]])
		XCTAssertNil(item["id"])

		let builder = SquareItemsAPI.operationsPostWithRequestBuilder(idempotencyKey: "create-tee", atomicOperationsRequest: payload)
		XCTAssertEqual(builder.method, "POST")
		XCTAssertTrue(builder.URLString.hasSuffix("/operations"))
		XCTAssertEqual(builder.headers["Idempotency-Key"], "create-tee")
		XCTAssertEqual(builder.headers["Content-Type"], #"application/vnd.api+json;ext="https://jsonapi.org/ext/atomic""#)
	}

	func testOrdinaryJSONAPIMediaTypeIsPreserved() {
		let builder = SquareItemsAPI.squareItemsIdPatchWithRequestBuilder(id: "item", idempotencyKey: "update-item")
		XCTAssertEqual(builder.headers["Content-Type"], "application/vnd.api+json")
	}
}
