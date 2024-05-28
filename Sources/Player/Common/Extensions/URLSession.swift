import Foundation

extension URLSession {
	static func new(
		with timeoutPolicy: TimeoutPolicy? = nil,
		name: String? = nil,
		serviceType: URLRequest.NetworkServiceType? = nil,
		cache: URLCache? = nil,
		delegate: URLSessionDelegate? = nil,
		delegateQueue: OperationQueue? = nil
	) -> URLSession {
		let configuration = URLSessionConfiguration.default

		if let timeoutPolicy {
			configuration.timeoutIntervalForRequest = timeoutPolicy.requestTimeout
			configuration.timeoutIntervalForResource = timeoutPolicy.resourceTimeout
		}

		if let serviceType {
			configuration.networkServiceType = serviceType
		}

		if let cache {
			configuration.urlCache = cache
		}

		let session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: delegateQueue)

		if let name {
			session.sessionDescription = name
		}

		return session
	}
}
