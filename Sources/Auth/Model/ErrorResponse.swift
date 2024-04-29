import Common
import Foundation

// MARK: - ErrorResponse

struct ErrorResponse: Codable {
	let status: Int
	let subStatus: Int
	private enum CodingKeys: String, CodingKey {
		case status
		case subStatus = "sub_status"
	}
}

extension NetworkError {
	func getErrorResponse() -> ErrorResponse? {
		guard let status = code.toInt, let subStatus else {
			return nil
		}
		return ErrorResponse(status: status, subStatus: subStatus)
	}
}
