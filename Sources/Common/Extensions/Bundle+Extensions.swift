import Foundation

public extension Bundle {
	var appVersion: String {
		infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
	}

	var appName: String {
		infoDictionary?["CFBundleName"] as? String ?? "unidentified"
	}
}
