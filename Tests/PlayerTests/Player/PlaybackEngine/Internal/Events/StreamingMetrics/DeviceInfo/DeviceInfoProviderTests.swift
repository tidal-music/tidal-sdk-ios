@testable import Player
import XCTest

final class DeviceInfoProviderTests: XCTestCase {
	private var deviceInfoProvider: DeviceInfoProvider!

	override func setUp() {
		deviceInfoProvider = DeviceInfoProvider.live
	}

	override func tearDown() {}

	func test_getMobileNetworkType_whenNotUsingData() {
		let mobileNetworkType = deviceInfoProvider.mobileNetworkType(.WIFI)
		XCTAssertEqual(mobileNetworkType, DeviceInfoProvider.Constants.NA)
	}

	/// In simulator, there's no Telephony, so we are only testing that it returns the default value in such case.
	func test_getMobileNetworkType_whenUsingData() {
		let mobileNetworkType = deviceInfoProvider.mobileNetworkType(.MOBILE)
		XCTAssertEqual(mobileNetworkType, DeviceInfoProvider.Constants.NA)
	}
}
