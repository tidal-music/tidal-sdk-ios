import Foundation
@testable import Player

final class DispatchQueueMock: Dispatching {
	func async(qos: DispatchQoS, execute work: @escaping () -> Void) {
		work()
	}
}
