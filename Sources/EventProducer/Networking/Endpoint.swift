import Common
import Foundation

enum Endpoint {
	case publicEvents(Data, clientAuth: [String: String])
	case events(Data, authHeader: [String: String])

	private var baseURL: String {
		Environment.system == .development ? "https://event-collector.obelix-staging-use1.tidalhi.fi" : "https://ec.tidal.com"
	}

	private var path: String {
		switch self {
		case .publicEvents:
			"/api/public/event-batch"
		case .events:
			"/api/event-batch"
		}
	}

	private var requestMethod: HTTPMethod {
		switch self {
		case .publicEvents, .events:
			.post
		}
	}

	private var urlComponents: URLComponents? {
		var components = URLComponents(string: baseURL)
		components?.path = path
		return components
	}

	public var request: URLRequest? {
		guard let urlComponents,
		      let url = urlComponents.url
		else {
			return nil
		}

		var request = URLRequest(url: url)
		request.httpMethod = requestMethod.rawValue

		switch self {
		case let .publicEvents(body, clientAuth):
			request.httpBody = body
			request.allHTTPHeaderFields = clientAuth
		case let .events(body, authHeader):
			request.httpBody = body
			request.allHTTPHeaderFields = authHeader
		}

		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		return request
	}
}
