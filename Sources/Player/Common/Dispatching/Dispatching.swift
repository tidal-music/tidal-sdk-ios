import Foundation

// MARK: - Dispatching

/// Protocol to abstract work performed by a dispatch queue.
protocol Dispatching: AnyObject {
	func async(qos: DispatchQoS, execute work: @escaping () -> Void)
}

// MARK: - DispatchQueue + Dispatching

extension DispatchQueue: Dispatching {
	func async(qos: DispatchQoS, execute work: @escaping () -> Void) {
		async(group: nil, qos: qos, flags: [], execute: work)
	}
}
