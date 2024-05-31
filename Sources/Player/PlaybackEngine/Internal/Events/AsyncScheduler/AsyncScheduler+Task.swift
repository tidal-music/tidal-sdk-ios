extension Task: AsyncScheduler {
  static func schedule(code: @escaping () async -> Void) -> AsyncScheduler {
	Task<Void, Never> {
	  await code()
	}
  }
}
