public extension Configuration {
	static func mock(
		clientVersion: String = "clientVersion",
		cacheQuotaInBytes: Int? = nil
	) -> Self {
		Configuration(clientVersion: clientVersion, cacheQuotaInBytes: cacheQuotaInBytes)
	}
}
