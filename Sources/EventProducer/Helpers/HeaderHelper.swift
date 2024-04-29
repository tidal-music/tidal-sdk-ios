import Common
import Foundation
#if canImport(UIKit)
	import UIKit
#endif

// MARK: - HeaderHelper

struct HeaderHelper {
	func getAuthTokenHeader() async -> [String: String]? {
		if let token = await auth?.getToken() {
			return [
				HTTPHeaderKeys.authorization.rawValue: "Bearer \(token)",
			]
		}
		return nil
	}

	var clientAuthHeader: [String: String]? {
		if let clientID = auth?.clientID {
			return [
				HTTPHeaderKeys.clientAuthKey.rawValue: clientID,
			]
		}
		return nil
	}

	let auth: AuthProvider?

	init(auth: AuthProvider?) {
		self.auth = auth
	}

	func getDefaultHeaders(
		with consentCategory: ConsentCategory,
		timestamp: Date = .init(),
		isMonitoringEvent: Bool = false
	) async -> [String: String] {
		var deviceModel = ""
		var systemName = ""
		var systemVersion = ""

		#if os(iOS)
			deviceModel = await UIDevice.current.localizedModel
			systemName = await UIDevice.current.systemName
			systemVersion = await UIDevice.current.systemVersion
		#endif

		var headers: [HTTPHeaderKeys: String] = [
			.consentCategory: consentCategory.rawValue,
			.clientID: auth?.clientID ?? "",
			.timestamp: "\(timestamp.timeIntervalSince1970 * 1000)",
			.deviceVendor: Constants.deviceVendor,
			.deviceModel: deviceModel,
			.osName: systemName,
			.osVersion: systemVersion,
			.appName: Bundle.main.appName,
			.appVersion: Bundle.main.appVersion,
		]

		if !isMonitoringEvent,
		   let token = await auth?.getToken()
		{
			headers[.authorization] = token
		}
		return Dictionary(uniqueKeysWithValues: headers.mapValues { $0 }.map { ($0.rawValue, $1) })
	}
}
