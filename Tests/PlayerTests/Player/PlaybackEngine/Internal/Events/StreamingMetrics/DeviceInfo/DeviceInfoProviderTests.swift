@testable import Player
import Testing

final class DeviceInfoProviderTests {
	private var deviceInfoProvider: DeviceInfoProvider!

	init() {
		deviceInfoProvider = DeviceInfoProvider.live
	}

	@Test
	func test_getMobileNetworkType_whenNotUsingData() {
		let mobileNetworkType = deviceInfoProvider.mobileNetworkType(.WIFI)
		#expect(mobileNetworkType == DeviceInfoProvider.Constants.NA)
	}

	/// In simulator, there's no Telephony, so we are only testing that it returns the default value in such case.
	@Test
	func test_getMobileNetworkType_whenUsingData() {
		let mobileNetworkType = deviceInfoProvider.mobileNetworkType(.MOBILE)
		#expect(mobileNetworkType == DeviceInfoProvider.Constants.NA)
	}
}
