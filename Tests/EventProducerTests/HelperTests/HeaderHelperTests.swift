import Common
@testable import EventProducer
@testable import Auth
import XCTest

// MARK: - HeaderHelperTests

final class HeaderHelperTests: XCTestCase {
	private struct MockCredentialsProvider: CredentialsProvider {
		var testAccessToken: String? = nil
		let testClientId: String
		func getCredentials(apiErrorSubStatus: String?) async throws -> Credentials {
			return Credentials(
				clientId: testClientId,
				requestedScopes: .init(),
				clientUniqueKey: "",
				grantedScopes: .init(),
				userId: "testUserId",
				expires: nil,
				token: testAccessToken
			)
		}
		var isUserLoggedIn: Bool
	}

	private var sut: HeaderHelper!

	func testGetDefaultHeaders() async throws {
		let clientID = "42"
		sut = HeaderHelper(credentialsProvider: MockCredentialsProvider(testClientId: clientID, isUserLoggedIn: true))

		let timestamp = Date(timeIntervalSinceNow: 3000)
		let headers = await sut.getDefaultHeaders(with: .necessary, timestamp: timestamp)
		let keys = headers.compactMap { HTTPHeaderKeys(rawValue: $0.key) }

		let mappedHeaders = [
			HTTPHeaderKeys.consentCategory.rawValue: ConsentCategory.necessary.rawValue,
			HTTPHeaderKeys.timestamp.rawValue: "\(timestamp.timeIntervalSince1970 * 1000)",
			HTTPHeaderKeys.deviceVendor.rawValue: Constants.deviceVendor,
			HTTPHeaderKeys.deviceModel.rawValue: deviceInfo.deviceModel,
			HTTPHeaderKeys.osName.rawValue: deviceInfo.systemName,
			HTTPHeaderKeys.osVersion.rawValue: deviceInfo.systemVersion,
			HTTPHeaderKeys.appName.rawValue: Bundle.main.appName,
			HTTPHeaderKeys.appVersion.rawValue: Bundle.main.appVersion,
			HTTPHeaderKeys.clientID.rawValue: clientID,
		]

		XCTAssertTrue(keys.filter { $0 == .authorization }.isEmpty)
		XCTAssertEqual(headers, mappedHeaders)
	}

	func testGetDefaultHeadersForMonitoringEvent() async throws {
		let testAccessToken = "testAccessToken"
		let clientID = "42"
		let credentialsProvider = MockCredentialsProvider(testAccessToken: testAccessToken, testClientId: clientID, isUserLoggedIn: true)
		sut = HeaderHelper(credentialsProvider: credentialsProvider)

		let headers = await sut.getDefaultHeaders(with: .necessary, isMonitoringEvent: false)
		let keys = headers.compactMap { HTTPHeaderKeys(rawValue: $0.key) }
		
		let token = try? await credentialsProvider.getCredentials().token

		XCTAssertTrue(!keys.filter { $0 == .authorization }.isEmpty)
		XCTAssertEqual(headers[HTTPHeaderKeys.authorization.rawValue], token)
	}

	private var deviceInfo: DeviceInfo {
		var deviceModel = ""
		var systemName = ""
		var systemVersion = ""

		#if canImport(UIKit)
			deviceModel = UIDevice.current.localizedModel
			systemName = UIDevice.current.systemName
			systemVersion = UIDevice.current.systemVersion
		#endif

		return DeviceInfo(
			deviceModel: deviceModel,
			systemName: systemName,
			systemVersion: systemVersion
		)
	}
}

// MARK: HeaderHelperTests.DeviceInfo

private extension HeaderHelperTests {
	struct DeviceInfo {
		let deviceModel: String
		let systemName: String
		let systemVersion: String
	}
}
