import Foundation

enum HttpError: Error, Equatable {
	case httpClientError(statusCode: Int, message: Data?)
	case httpServerError(statusCode: Int)
}
