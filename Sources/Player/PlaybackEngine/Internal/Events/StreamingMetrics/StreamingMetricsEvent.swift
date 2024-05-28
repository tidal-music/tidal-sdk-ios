import Foundation

protocol StreamingMetricsEvent: Codable, Equatable {
	var name: String { get }
	var streamingSessionId: String { get }
}
