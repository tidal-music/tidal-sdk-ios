import Foundation
@testable import Player

final class AsyncSchedulerFactorySpy: AsyncSchedulerFactory {
	var scheduleList: [AsyncSchedulerSpy] = []
	
	@discardableResult
	func create(code: @escaping () async -> Void) -> AsyncScheduler {
		let schedule = AsyncSchedulerSpy.schedule(code: code)
		
		if let schedule = schedule as? AsyncSchedulerSpy {
			scheduleList.append(schedule)
		}
		
		return schedule
	}
	
	func executeLast() async {
		await scheduleList.popLast()?.execute()
	}
	
	func executeAll() async {
		for item in scheduleList {
			await item.execute()
		}
	}
}
