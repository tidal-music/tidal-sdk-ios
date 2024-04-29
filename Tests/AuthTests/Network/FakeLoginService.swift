@testable import Auth
import Common
import Foundation

// MARK: - FakeLoginService

final class FakeLoginService: LoginService {
	var calls = [CallType]()
	var deviceLoginBehaviour: DeviceLoginBehaviour?
	var deviceLoginPendingHelper: DeviceLoginPendingHelper?
	var deviceAuthorizationResponse: DeviceAuthorizationResponse?
	let throwableToThrow: Error?

	private let accessToken = "accessToken"
	private let clientName = "clientName"
	private let expiresIn = 0
	private let refreshToken = "refreshToken"
	private let tokenType = "tokenType"
	private let scopesString = ""
	var userId: Int? = 123

	private var fakeLoginResponse: LoginResponse {
		.init(
			accessToken: accessToken,
			clientName: clientName,
			expiresIn: expiresIn,
			refreshToken: refreshToken,
			tokenType: tokenType,
			scopesString: scopesString,
			userId: userId
		)
	}

	init(throwableToThrow: Error? = nil) {
		self.throwableToThrow = throwableToThrow
	}

	func getTokenWithCodeVerifier(
		code: String,
		clientId: String,
		grantType: String,
		redirectUri: String,
		scopes: String,
		codeVerifier: String,
		clientUniqueKey: String?
	) async throws -> LoginResponse {
		calls.append(.getTokenWithCodeVerifier)
		if let throwableToThrow {
			throw throwableToThrow
		}

		return fakeLoginResponse
	}

	func getDeviceAuthorization(clientId: String, scope: String) async throws -> DeviceAuthorizationResponse {
		calls.append(.getDeviceAuthorization)
		if let throwableToThrow {
			throw throwableToThrow
		}

		let response = try makeDeviceAuthorizationResponse()
		deviceAuthorizationResponse = response
		return response
	}

	func getTokenFromDeviceCode(
		clientId: String,
		clientSecret: String?,
		deviceCode: String,
		grantType: String,
		scopes: String,
		clientUniqueKey: String?
	) async throws -> LoginResponse {
		calls.append(.getTokenFromDeviceCode)

		guard let deviceLoginBehaviour else {
			fatalError("DeviceLoginBehaviour must be defined")
		}

		if let deviceLoginPendingHelper, deviceLoginPendingHelper.isPending {
			throw deviceLoginBehaviour.exceptionToThrowWhilePending
		}

		if let error = deviceLoginBehaviour.exceptionToFinishWith {
			throw error
		}

		return try returnLoginResponseOrThrow()
	}

	private func returnLoginResponseOrThrow() throws -> LoginResponse {
		if let throwableToThrow {
			throw throwableToThrow
		}

		return fakeLoginResponse
	}

	private func makeDeviceAuthorizationResponse() throws -> DeviceAuthorizationResponse {
		guard let deviceLoginBehaviour else {
			throw UnexpectedError(code: "-1", message: "deviceLoginBehaviour is not defined")
		}

		deviceLoginPendingHelper = DeviceLoginPendingHelper(pendingForSeconds: deviceLoginBehaviour.loginPendingSeconds)

		return DeviceAuthorizationResponse(
			deviceCode: "deviceCode",
			userCode: "userCode",
			verificationUri: "verificationUri",
			verificationUriComplete: "verificationUriComplete",
			expiresIn: deviceLoginBehaviour.authorizationResponseExpirationSeconds,
			interval: 2
		)
	}
}

// MARK: - DeviceLoginBehaviour

/// Use this struct to define [FakeLoginService]'s behaviour when using the
/// device login flow. Note that you need to supply a [CoroutineTestTimeProvider]
/// and start it before making calls.
struct DeviceLoginBehaviour {
	let authorizationResponseExpirationSeconds: Int
	let loginPendingSeconds: Int
	let exceptionToFinishWith: Error?
	var exceptionToThrowWhilePending: Error = NetworkError(code: "401")
}

// MARK: - CallType

enum CallType {
	case getTokenWithCodeVerifier, getTokenFromDeviceCode, getDeviceAuthorization
}

// MARK: - DeviceLoginPendingHelper

struct DeviceLoginPendingHelper {
	private let pendingForSeconds: Int
	private let startTime = Date()

	init(pendingForSeconds: Int) {
		self.pendingForSeconds = pendingForSeconds
	}

	var isPending: Bool {
		Date() < startTime.addingTimeInterval(TimeInterval(pendingForSeconds))
	}
}
