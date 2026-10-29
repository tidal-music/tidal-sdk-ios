import Foundation
import Testing
@testable import TidalAPI

// MARK: - AtomicOperationsRequestTests

struct AtomicOperationsRequestTests {
	@Test(arguments: [nil, "selected-tidal-site"] as [String?])
	func creationIncludesOnlyAnExplicitPublicationTarget(siteID: String?) throws {
		let operation = AtomicOperationsRequestAtomicOperationsInner.atomicOperationsRequestAtomicOperationsInnerOneOf1(.init(
			data: .init(
				attributes: .init(title: "Tour tee"), lid: "tee",
				relationships: siteID.map { .init(sites: .init(data: [.init(id: $0, type: .squaresites)])) },
				type: .squareitems
			), op: .add
		))
		let builder = SquareItemsAPI.operationsPostWithRequestBuilder(
			idempotencyKey: "create-item", atomicOperationsRequest: .init(atomicOperations: [operation])
		)
		let body = try #require(urlRequest(for: builder).httpBody)
		let document = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])
		let operations = try #require(document["atomic:operations"] as? [[String: Any]])
		let item = try #require(operations.first?["data"] as? [String: Any])
		if let siteID {
			let relationships = try #require(item["relationships"] as? [String: Any])
			let sites = try #require(relationships["sites"] as? [String: Any])
			#expect(sites["data"] as? [[String: String]] == [["id": siteID, "type": "squareSites"]])
		} else {
			#expect(item["relationships"] == nil)
		}
	}

	@Test
	func atomicRequestsPreserveQuotedExtension() throws {
		let payload = AtomicOperationsRequest(atomicOperations: [])
		let builders = [
			SquareItemsAPI.operationsPostWithRequestBuilder(idempotencyKey: "create-item", atomicOperationsRequest: payload),
			SquareItemVariationsAPI.operationsPostWithRequestBuilder(idempotencyKey: "create-item", atomicOperationsRequest: payload),
		]
		for builder in builders {
			let request = try urlRequest(for: builder)
			#expect(request.value(forHTTPHeaderField: "Content-Type") == #"application/vnd.api+json;ext="https://jsonapi.org/ext/atomic""#)
			#expect(request.value(forHTTPHeaderField: "Idempotency-Key") == "create-item")
			#expect(request.httpMethod == "POST")
			#expect(request.url?.path == "/v2/operations")
			let body = try #require(request.httpBody)
			let document = try #require(JSONSerialization.jsonObject(with: body) as? [String: Any])
			#expect((document["atomic:operations"] as? [Any])?.isEmpty == true)
		}
	}

	@Test
	func ordinaryJSONAPIRequestKeepsItsMediaType() throws {
		let builder = SquareItemsAPI.squareItemsIdPatchWithRequestBuilder(id: "item", idempotencyKey: "update-item")
		let request = try urlRequest(for: builder)
		#expect(request.value(forHTTPHeaderField: "Content-Type") == "application/vnd.api+json")
	}
}

private extension AtomicOperationsRequestTests {
	func urlRequest<Value: Decodable>(for builder: RequestBuilder<Value>) throws -> URLRequest {
		let builder = try #require(builder as? URLSessionDecodableRequestBuilder<Value>)
		let method = try #require(HTTPMethod(rawValue: builder.method))
		return try builder.createURLRequest(
			urlSession: URLSession.shared,
			method: method,
			encoding: JSONDataEncoding(),
			headers: builder.headers
		)
	}
}
