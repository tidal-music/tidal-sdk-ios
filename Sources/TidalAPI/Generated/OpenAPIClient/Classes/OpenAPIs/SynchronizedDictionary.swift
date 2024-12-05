import Foundation

struct SynchronizedDictionary<K: Hashable, V> {
	private var dictionary = [K: V]()
	private let lock = NSRecursiveLock()

	subscript(key: K) -> V? {
		get {
			lock.lock()
			defer { lock.unlock() }
			return dictionary[key]
		}
		set {
			lock.lock()
			defer { lock.unlock() }
			dictionary[key] = newValue
		}
	}
}
