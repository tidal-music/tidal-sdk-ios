import Foundation
@testable import Player

// MARK: - OperationQueueMock

final class OperationQueueMock: OperationQueue {
	override init() {
		super.init()
		super.maxConcurrentOperationCount = 1
		super.qualityOfService = .userInitiated
		super.name = "com.tidal.player.testplayerqueue"
	}

	override func addOperation(_ block: @escaping () -> Void) {
		addOperations([ClosureOperation(block)], waitUntilFinished: true)
	}
}

// MARK: - ClosureOperation

private final class ClosureOperation: Operation {
	private let block: () -> Void

	init(_ block: @escaping () -> Void) {
		self.block = block
	}

	override func main() {
		block()
	}
}
