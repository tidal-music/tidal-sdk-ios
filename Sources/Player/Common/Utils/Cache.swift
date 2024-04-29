import Foundation

private let TS_KEY = "ts"
private let TTL_KEY = "ttl"

// MARK: - Cache

final class Cache {
	let cache: URLCache
	private let keyPrefix: String

	init(memoryCapacity: Int, diskCapacity: Int, keyPrefix: String) {
		cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity)
		self.keyPrefix = keyPrefix
	}

	func get(key: Data) -> Data? {
		guard let request = request(of: key) else {
			return nil
		}

		guard let response = cache.cachedResponse(for: request) else {
			return nil
		}

		if response.hasExpired() {
			cache.removeCachedResponse(for: request)
			return nil
		}

		return response.data
	}

	func set(key: Data, data: Data, timeToLiveSeconds: Int? = nil) {
		guard let request = request(of: key) else {
			return
		}

		if let response = CachedURLResponse(request: request, data: data, timeToLiveSeconds: timeToLiveSeconds) {
			cache.storeCachedResponse(response, for: request)
		}
	}

	func delete(key: Data) {
		guard let request = request(of: key) else {
			return
		}

		cache.removeCachedResponse(for: request)
	}

	func clear() {
		cache.removeAllCachedResponses()
	}
}

private extension Cache {
	func request(of key: Data) -> URLRequest? {
		let host = key.base64EncodedString()
			.replacingOccurrences(of: "+", with: "-")
			.replacingOccurrences(of: "/", with: "_")
			.replacingOccurrences(of: "=", with: "")

		guard let url = URL(string: "\(keyPrefix)://\(host)") else {
			return nil
		}

		return URLRequest(url: url)
	}
}

extension CachedURLResponse {
	convenience init?(request: URLRequest, data: Data, timeToLiveSeconds: Int?) {
		guard let url = request.url,
		      let response = HTTPURLResponse(
		      	url: url,
		      	statusCode: 200,
		      	httpVersion: nil,
		      	headerFields: nil
		      )
		else {
			return nil
		}

		let now = PlayerWorld.timeProvider.timestamp()
		self.init(
			response: response,
			data: data,
			userInfo: timeToLiveSeconds.map { [TS_KEY: "\(now)", TTL_KEY: "\($0)"] },
			storagePolicy: .allowed
		)
	}

	func hasExpired() -> Bool {
		guard let userInfo,
		      let ts = userInfo[TS_KEY] as? String,
		      let ttl = userInfo[TTL_KEY] as? String
		else {
			return false
		}

		guard let timestamp = UInt64(ts), let timeToLive = UInt64(ttl) else {
			return false
		}

		let now = PlayerWorld.timeProvider.timestamp()
		return now - timestamp > timeToLive * 1000
	}
}
