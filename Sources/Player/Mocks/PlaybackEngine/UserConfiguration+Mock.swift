public extension UserConfiguration {
	static func mock(
		userId: Int = 19,
		userClientId: Int = 10
	) -> UserConfiguration {
		UserConfiguration(userId: userId, userClientId: userClientId)
	}
}
