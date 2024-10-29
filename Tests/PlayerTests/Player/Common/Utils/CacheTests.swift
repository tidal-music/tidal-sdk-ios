@testable import Player
import XCTest

// MARK: - Constants

private enum Constants {
	static let prefix = "cachetests"
	static let timeToLive: Int = 1

	static let key = Data("1".utf8)
	static let data = Data("data".utf8)
}

// MARK: - CacheTests

final class CacheTests: XCTestCase {
	private var cache: Cache!

	private var timestamp: UInt64 = 1

	override func setUp() {
		let timeProvider = TimeProvider.mock(
			timestamp: {
				self.timestamp
			}
		)
		PlayerWorld = PlayerWorldClient.mock(timeProvider: timeProvider)

		cache = Cache(memoryCapacity: 512, diskCapacity: 1024, keyPrefix: Constants.prefix)
	}

	override func tearDown() {
		cache.clear()
	}
}

extension CacheTests {
	// MARK: - set()

	func test_set() {
		// GIVEN
		let key = Constants.key
		let data = Constants.data

		// WHEN
		cache.set(key: key, data: data, timeToLiveSeconds: nil)

		// THEN
		let request = urlRequest(of: key)
		let response = cache.cache.cachedResponse(for: request)
		let cachedData = response?.data
		XCTAssertEqual(cachedData, data)
	}

	// MARK: - get()

	func test_get() {
		// GIVEN
		let key = Constants.key
		let data = Constants.data
		cache.set(key: key, data: data, timeToLiveSeconds: nil)

		// WHEN
		let response = cache.get(key: key)

		// THEN
		let request = urlRequest(of: key)
		let cachedData = cache.cache.cachedResponse(for: request)?.data
		XCTAssertEqual(response, cachedData)
	}

	func test_get_whenTimeToLiveExpired_returnsNil() {
		// GIVEN
		let key = Data("ttl".utf8)
		let data = Constants.data
		cache.set(key: key, data: data, timeToLiveSeconds: Constants.timeToLive)

		// Set time to anything bigger than 1002ms (now 1002 - timestamp 1) to fake expiration (1000): 1001 > 1000.
		timestamp = 1002

		// WHEN
		let response = cache.get(key: key)

		// THEN
		_ = urlRequest(of: key)

		XCTAssertEqual(response, nil)
	}

	func test_get_whenItWasNotSet_returnsNil() {
		// GIVEN
		let key = Data("get".utf8)

		// WHEN
		let response = cache.get(key: key)

		// THEN
		XCTAssertEqual(response, nil)
	}

	// MARK: - delete()

	func test_delete() {
		// GIVEN
		let key = Constants.key
		let data = Constants.data
		cache.set(key: key, data: data, timeToLiveSeconds: nil)

		let request = urlRequest(of: key)
		let cachedData = cache.cache.cachedResponse(for: request)?.data
		XCTAssertEqual(cachedData, data)

		// WHEN
		cache.delete(key: key)

		optimizedWait {
			cache.cache.cachedResponse(for: request)?.data == nil
		}

		// THEN
		let responseAfterDeletion = cache.get(key: key)
		XCTAssertEqual(responseAfterDeletion, nil)
	}
}

// MARK: - Helpers

extension CacheTests {
	func urlRequest(of key: Data) -> URLRequest {
		let host = key.base64EncodedString()
			.replacingOccurrences(of: "+", with: "-")
			.replacingOccurrences(of: "/", with: "_")
			.replacingOccurrences(of: "=", with: "")
		let url = URL(string: "\(Constants.prefix)://\(host)")!
		return URLRequest(url: url)
	}
}
