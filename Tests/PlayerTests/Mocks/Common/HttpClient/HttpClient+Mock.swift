import Foundation
@testable import Player

extension HttpClient {
	static func mock(
		urlSession: URLSession = URLSession(configuration: .default),
		responseErrorManager: ErrorManager = ErrorManagerMock(),
		networkErrorManager: ErrorManager = ErrorManagerMock(),
		timeoutErrorManager: ErrorManager = ErrorManagerMock()
	) -> HttpClient {
		HttpClient(
			using: urlSession,
			responseErrorManager: responseErrorManager,
			networkErrorManager: networkErrorManager,
			timeoutErrorManager: timeoutErrorManager
		)
	}
}
