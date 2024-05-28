public protocol EventSender {
	func sendEvent(
		name: String,
		consentCategory: ConsentCategory,
		headers: [String: String],
		payload: String
	) async throws
}
