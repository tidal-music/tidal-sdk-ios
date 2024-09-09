extension AuthWorldClient {
	/// Noop client to be used when logging is not desired
	static let noop = AuthWorldClient(logger: nil)
}
