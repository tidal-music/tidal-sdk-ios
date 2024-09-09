extension AuthWorldClient {
	/// Live client to be used when logging is desired
	static let live = AuthWorldClient(
		logger: .live
	)
}
