import AVFoundation
import Foundation

public extension AVPlayerItemErrorLogEvent {
	override var description: String {
		let httpResponseHeaderFields: String = if #available(iOS 17.5, macOS 14.5, *) {
			self.allHTTPResponseHeaderFields?.description ?? "N/A"
		} else {
			"N/A"
		}

		return """
		Error Log Event: Date: \(date?.description ?? "N/A"),
		URI: \(uri ?? "N/A"), Server Address: \(serverAddress ?? "N/A"),
		Playback Session ID: \(playbackSessionID ?? "N/A"),
		Error Status Code: \(errorStatusCode),
		Error Domain: \(errorDomain),
		Error Comment: \(errorComment ?? "N/A"),
		HTTP Response Header Fields: \(httpResponseHeaderFields)
		"""
	}
}

public extension Array where Element: AVPlayerItemErrorLogEvent {
	var description: String {
		let descriptions = map { $0.description }
		return "[\(descriptions.joined(separator: ", "))]"
	}
}
