import Common
import Foundation

protocol Scheduler: AnyObject {
	var schedulingTime: TimeInterval { get }
	func timerTriggered(headerHelper: HeaderHelper) async throws
	var schedulerTask: Task<Void, Error>? { get set }
}

extension Scheduler {
	/// The Scheduler applies a best-effort approach to sending events to the TL Consumer, meaning that it continuously tries to send
	/// events while the app is executing,
	/// regardless of current internet conditions or if the app considers itself to be online or not. As long as the app is
	/// executing, the Scheduler shall be running
	func runScheduling(with headerHelper: HeaderHelper) {
		guard schedulerTask == nil else {
			return
		}
		
		schedulerTask = Task { [weak self, headerHelper] in
			repeat {
				guard let self else {
					return
				}
				
				try await Task.sleep(seconds: schedulingTime)
				try await self.timerTriggered(headerHelper: headerHelper)
			} while !Task.isCancelled
		}
	}
	
	func invalidateTimer() {
		schedulerTask?.cancel()
		schedulerTask = nil
	}
}
