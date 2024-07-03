import Foundation

protocol Scheduler: AnyObject {
	var schedulingTime: TimeInterval { get }
	func timerTriggered(headerHelper: HeaderHelper) async throws
	var schedulerTask: Task<Void, Error>? { get set }
}

extension Scheduler {
	func runScheduling(with headerHelper: HeaderHelper) {
		guard schedulerTask == nil else {
			return
		}
		
		schedulerTask = Task { [weak self, headerHelper] in
			repeat {
				guard let self else {
					return
				}
				
				let schedulingTimeInNanoseconds = UInt64(schedulingTime) * NSEC_PER_SEC
				
				try await Task.sleep(nanoseconds: schedulingTimeInNanoseconds)
				try await self.timerTriggered(headerHelper: headerHelper)
			} while !Task.isCancelled
		}
	}
	
	func invalidateTimer() {
		schedulerTask?.cancel()
		schedulerTask = nil
	}
}
