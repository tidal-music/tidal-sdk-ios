import Foundation

public extension OperationQueue {
	func dispatch(_ work: @escaping () -> Void) {
		addOperation(work)
	}

	func dispatch(_ work: @escaping () async -> Void) {
		addOperation {
			let semaphore = DispatchSemaphore(value: 0)

			SafeTask {
				await work()
				semaphore.signal()
			}

			semaphore.wait()
		}
	}

	func block(_ work: @escaping () -> Void) {
		addOperations([BlockOperation(block: work)], waitUntilFinished: true)
	}
}
