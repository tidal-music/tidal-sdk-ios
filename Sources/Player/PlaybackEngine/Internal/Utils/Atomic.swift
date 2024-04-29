import Foundation

public typealias PlayerAtomic = Atomic

// MARK: - Atomic

@propertyWrapper
public final class Atomic<T> {
	private var value: T
	private let lock: DispatchSemaphore

	public init(wrappedValue value: T) {
		self.value = value
		lock = DispatchSemaphore(value: 1)
	}

	public var wrappedValue: T {
		get {
			lock.wait()
			defer { lock.signal() }
			return value
		}
		set {
			lock.wait()
			defer { lock.signal() }
			value = newValue
		}
	}
}
