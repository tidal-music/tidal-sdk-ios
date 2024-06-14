@testable import EventProducer
import XCTest

final class FileManagerHelperTests: XCTestCase {
	private let sut: FileManagerHelper = .shared
	private let maxDiskUsageBytes = 204800

	func testExceedsMaximumSize() {
		let data = Data(count: 10480)
		let exceedSize1 = sut.exceedsMaximumSize(object: data, maximumSize: maxDiskUsageBytes)
		XCTAssertEqual(exceedSize1, false)

		let maskDiskData = Data(count: maxDiskUsageBytes + 24)
		let exceedsSize2 = sut.exceedsMaximumSize(object: maskDiskData, maximumSize: maxDiskUsageBytes)
		XCTAssertEqual(exceedsSize2, true)
	}
}
