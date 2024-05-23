import Foundation

public extension Bundle {
	var appVersion: String {
		versionNumber + "." + buildNumber
	}

	var appName: String {
		infoDictionary?["CFBundleName"] as? String ?? "unidentified"
	}
}

private extension Bundle {
	var versionNumber: String {
		infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
	}

	var buildNumber: String {
		infoDictionary?["CFBundleVersion"] as? String ?? "1"
	}
}
