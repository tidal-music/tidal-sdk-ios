import Foundation
#if canImport(UIKit)
	import UIKit
#endif
import CoreTelephony

// MARK: - DeviceInfoProvider

struct DeviceInfoProvider {
	enum Constants {
		static let NA = "NA"
		static let machine = "hw.machine"
		static let deviceTypeMobile = "mobile"
		static let deviceTypeTablet = "tablet"
		static let deviceTypeTV = "tv"
		static let deviceTypeWearable = "wearable"
		static let deviceTypeEmbedded = "embedded"
	}

	var operatingSystem: String
	var operatingSystemVersion: String
	var hardwarePlatform: String
	var screenWidth: () -> Int
	var screenHeight: () -> Int
	var mobileNetworkType: (_ networkType: NetworkType) -> String
	var deviceType: (_ audioInfoProvider: AudioInfoProvider) -> String
}

extension DeviceInfoProvider {
	#if canImport(UIKit)
		static let live = DeviceInfoProvider(
			operatingSystem: UIDevice.current.systemName,
			operatingSystemVersion: UIDevice.current.systemVersion,
			hardwarePlatform: {
				var size = 0
				sysctlbyname(Constants.machine, nil, &size, nil, 0)
				var machine = [CChar](repeating: 0, count: size)
				sysctlbyname(Constants.machine, &machine, &size, nil, 0)
				return String(cString: machine)
			}(),
			screenWidth: { Int(UIScreen.main.bounds.width) },
			screenHeight: { Int(UIScreen.main.bounds.height) },
			mobileNetworkType: { networkType in
				guard networkType == .MOBILE else {
					return Constants.NA
				}
				let networkInfo = CTTelephonyNetworkInfo()
				return networkInfo.serviceCurrentRadioAccessTechnology?.first?.value ?? Constants.NA
			},
			deviceType: { audioInfoProvider in
				#if os(iOS)
					if UIDevice.current.userInterfaceIdiom == .pad {
						return Constants.deviceTypeTablet
					} else if UIDevice.current.userInterfaceIdiom == .carPlay || audioInfoProvider.isCarPlayOutputRoute() {
						// userInterfaceIdiom == .carPlay does not work on the simulator, but maybe it does on real hardware.
						return Constants.deviceTypeEmbedded
					} else if UIDevice.current.userInterfaceIdiom == .phone {
						return Constants.deviceTypeMobile
					} else {
						return Constants.NA
					}
				#elseif os(tvOS)
					return Constants.deviceTypeTV
				#elseif os(watchOS)
					return Constants.deviceTypeWearable
				#endif
			}
		)
	#else
		static let live = DeviceInfoProvider(
			operatingSystem: "",
			operatingSystemVersion: "",
			hardwarePlatform: "",
			screenWidth: { 0 },
			screenHeight: { 0 },
			mobileNetworkType: { _ in
				Constants.NA
			},
			deviceType: { _ in
				Constants.NA
			}
		)
	#endif
}
