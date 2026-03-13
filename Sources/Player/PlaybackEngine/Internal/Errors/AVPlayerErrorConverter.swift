import AVFoundation
import Foundation

enum AVPlayerErrorConverter {
	static func convertError(error: Error?, playerItem: AVPlayerItem) -> PlayerInternalError {
		guard let error else {
			return PlayerInternalError(
				errorId: .PERetryable,
				errorType: .avPlayerOtherError,
				code: Int.max,
				description: "Playback failed, but no error describing the failure was present"
			)
		}

		let description = "Error: {\(error)}, Error log: {\(errorLog(playerItem: playerItem))}"

		if let mediaError = mediaError(error, with: description) {
			return mediaError
		}

		if let networkError = networkError(error, with: description) {
			return networkError
		}

		return PlayerInternalError(
			errorId: .PERetryable,
			errorType: .avPlayerOtherError,
			code: (error as NSError).code,
			description: description
		)
	}

	static func mediaError(_ error: Error, with description: String) -> PlayerInternalError? {
		let nserror = error as NSError

		if nserror.domain == ErrorConstants.avfoundationErrorDomain,
		   nserror.code == ErrorConstants.averrorMediaServicesWereResetErrorCode
		{
			return PlayerInternalError(
				errorId: .PERetryable,
				errorType: .mediaServicesWereReset,
				code: nserror.code,
				description: description
			)
		} else {
			return (error as? AVError).map {
				PlayerInternalError(
					errorId: .PERetryable,
					errorType: .avPlayerAvError,
					code: $0.code.rawValue,
					description: description
				)
			}
		}
	}

	static func networkError(_ error: Error, with description: String) -> PlayerInternalError? {
		if let error = error as? URLError {
			switch error.code {
			case .timedOut, .networkConnectionLost, .notConnectedToInternet:
				return PlayerInternalError(
					errorId: .PENetwork,
					errorType: .avPlayerUrlError,
					code: error.code.rawValue,
					description: description
				)
			default:
				return PlayerInternalError(
					errorId: .PERetryable,
					errorType: .avPlayerUrlError,
					code: error.code.rawValue,
					description: description
				)
			}
		}

		let error = error as NSError
		if error.domain == "CoreMediaErrorDomain", error.code == -12889 {
			return PlayerInternalError(
				errorId: .PENetwork,
				errorType: .avPlayerOtherError,
				code: error.code,
				description: description
			)
		}

		return nil
	}

	static func errorLog(playerItem: AVPlayerItem) -> String {
		guard let log = playerItem.errorLog() else {
			return "empty"
		}

		let events = "Log Events: " + log.events.description

		guard let data = log.extendedLogData(),
		      let logString = NSString(data: data, encoding: log.extendedLogDataStringEncoding)
		else {
			return "empty / \(events)"
		}

		return "\(logString as String) / \(events)"
	}
}
