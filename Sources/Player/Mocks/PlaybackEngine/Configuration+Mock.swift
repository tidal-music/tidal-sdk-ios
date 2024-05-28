public extension Configuration {
	static func mock(
		clientVersion: String = "clientVersion"
	) -> Self {
		Configuration(clientVersion: clientVersion)
	}
}
