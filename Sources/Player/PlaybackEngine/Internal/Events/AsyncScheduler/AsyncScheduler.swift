protocol AsyncScheduler {
	static func schedule(code: @escaping () async -> Void) -> AsyncScheduler
}
