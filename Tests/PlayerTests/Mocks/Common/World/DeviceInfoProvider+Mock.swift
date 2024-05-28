@testable import Player

extension DeviceInfoProvider {
	static let mock: Self = DeviceInfoProvider(
		operatingSystem: "iOS",
		operatingSystemVersion: "operatingSystemVersion",
		hardwarePlatform: "hardwarePlatform",
		screenWidth: { 1 },
		screenHeight: { 1 },
		mobileNetworkType: { networkType in
			guard networkType == .MOBILE else {
				return Constants.NA
			}
			return "mobile"
		},
		deviceType: { _ in
			Constants.deviceTypeMobile
		}
	)
}
