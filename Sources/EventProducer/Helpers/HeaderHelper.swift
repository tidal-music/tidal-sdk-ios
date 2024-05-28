import Common
import Foundation
import protocol Auth.CredentialsProvider
#if canImport(UIKit)
	import UIKit
#endif

// MARK: - HeaderHelper

struct HeaderHelper {
	private func getCredentialsProviderToken() async throws -> String? {
		try? await credentialsProvider?.getCredentials().token
	}
	
	private func getCredentialsProviderClientId() async throws -> String? {
		try? await credentialsProvider?.getCredentials().clientId
	}
	
	func getAuthTokenHeader() async throws -> [String: String]? {
		do {
			if let token = try await getCredentialsProviderToken() {
				return [
					HTTPHeaderKeys.authorization.rawValue: "Bearer \(token)",
				]
			}
			return nil
		} catch {
			throw EventProducerError.authTokenMissingFailure(error.localizedDescription)
		}
	}

	func getClientAuthHeader() async throws -> [String: String]? {
		do {
			if let clientID = try await getCredentialsProviderClientId() {
				return [
					HTTPHeaderKeys.clientAuthKey.rawValue: clientID,
				]
			}
			return nil
		} catch {
			throw EventProducerError.clientIdMissingFailure
		}
	}

	let credentialsProvider: Auth.CredentialsProvider?

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
		
		let clientId = try? await getCredentialsProviderClientId()

		var headers: [HTTPHeaderKeys: String] = [
			.consentCategory: consentCategory.rawValue,
			.clientID: clientId ?? "",
			.timestamp: "\(timestamp.timeIntervalSince1970 * 1000)",
			.deviceVendor: Constants.deviceVendor,
			.deviceModel: deviceModel,
			.osName: systemName,
			.osVersion: systemVersion,
			.appName: Bundle.main.appName,
			.appVersion: Bundle.main.appVersion,
		]

		if !isMonitoringEvent,
		   let token = try? await getCredentialsProviderToken()
		{
			headers[.authorization] = token
		}
		return Dictionary(uniqueKeysWithValues: headers.mapValues { $0 }.map { ($0.rawValue, $1) })
	}
}
