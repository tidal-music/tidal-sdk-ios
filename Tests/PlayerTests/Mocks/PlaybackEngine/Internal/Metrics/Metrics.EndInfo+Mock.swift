@testable import Player

extension Metrics.EndInfo {
	static func mock(
		reason: EndReason = .COMPLETE,
		message: String? = nil,
		code: String? = nil
	) -> Self {
		Metrics.EndInfo(reason: reason, message: message, code: code)
	}
}
