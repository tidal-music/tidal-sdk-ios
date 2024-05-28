import Foundation

public extension Array {
	func chunkedBy(_ chunkSize: Int) -> [[Element]] {
		stride(from: 0, to: count, by: chunkSize).map {
			Array(self[$0 ..< Swift.min($0 + chunkSize, self.count)])
		}
	}
}
