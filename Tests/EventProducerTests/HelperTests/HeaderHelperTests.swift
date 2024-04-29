import Common
@testable import EventProducer
import XCTest

// MARK: - HeaderHelperTests

final class HeaderHelperTests: XCTestCase {
	private struct MockAuthProvider: AuthProvider {
		let token: String?
		let clientID: String?
		func refreshAccessToken(status: Int?) {}
		func getToken() async -> String? {
			token
		}
	}

	private var sut: HeaderHelper!

	func testGetDefaultHeaders() async throws {
		let clientID = "42"
		sut = HeaderHelper(auth: MockAuthProvider(token: nil, clientID: clientID))

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
		let auth = MockAuthProvider(token: "token123", clientID: "id123")
		sut = HeaderHelper(auth: auth)

		let headers = await sut.getDefaultHeaders(with: .necessary, isMonitoringEvent: false)
		let keys = headers.compactMap { HTTPHeaderKeys(rawValue: $0.key) }

		XCTAssertTrue(!keys.filter { $0 == .authorization }.isEmpty)
		XCTAssertEqual(headers[HTTPHeaderKeys.authorization.rawValue], auth.token)
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
