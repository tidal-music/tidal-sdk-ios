public extension Configuration {
	static func mock(
		clientToken: String = "clientToken",
		clientVersion: String = "clientVersion"
	) -> Self {
		Configuration(clientToken: clientToken, clientVersion: clientVersion)
	}
}
