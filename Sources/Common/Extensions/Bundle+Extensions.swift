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
		infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
	}

	var buildNumber: String {
		infoDictionary?["CFBundleVersion"] as? String ?? "N/A"
	}
}
