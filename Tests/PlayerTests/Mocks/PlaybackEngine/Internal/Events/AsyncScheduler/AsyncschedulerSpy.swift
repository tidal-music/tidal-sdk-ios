import Foundation
@testable import Player

final class AsyncSchedulerSpy: AsyncScheduler {
	var code: (() async -> Void)?
	
	init(code: @escaping () async -> Void) {
		self.code = code
	}
	
	static func schedule(code: @escaping () async -> Void) -> AsyncScheduler {
		return AsyncSchedulerSpy(code: code)
	}
	
	func execute() async {
		await code?()
	}
}
