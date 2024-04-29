import Auth
import Common
import Foundation

@MainActor
class AuthViewModel: ObservableObject {
	private let CLIENT_UNIQUE_KEY = "ClientUniqueKey"
	private let CLIENT_ID_DEVICE_LOGIN = "ClientID2"
	private let CLIENT_ID = "ClientID"
	static let redirectUri = "https://tidal.com/android/login/auth"

	@Published var isDeviceLoginEnabled: Bool = false {
		didSet {
			auth.config(config: authConfig)
		}
	}

	@Published var userCode: String = ""
	@Published var isLoggedIn: Bool = false
	@Published var errorMessage: String = ""
	@Published var expiresIn: String = ""
	private(set) var loginUrl: URL?
	private var expiresAt: Date = Date()

	private var authConfig: AuthConfig {
		let scopes = (try? Scopes(scopes: ["r_usr", "w_usr", "w_sub"])) ?? Scopes()
		return AuthConfig(
			clientId: isDeviceLoginEnabled ? CLIENT_ID_DEVICE_LOGIN : CLIENT_ID,
			clientUniqueKey: CLIENT_UNIQUE_KEY,
			credentialsKey: "storage",
			scopes: scopes
		)
	}

	private var loginConfig: LoginConfig {
		LoginConfig(customParams: [QueryParameter(key: "appMode", value: "iOS")])
	}

	var isDeviceLoginCodeExpired: Bool {
		Date() > expiresAt
	}

	var auth: TidalAuth {
		.shared
	}

	init() {
		auth.config(config: authConfig)
		isLoggedIn = auth.isLoggedIn
	}

	func logout() {
		do {
			try auth.logout()
			userCode = ""
			errorMessage = ""
			isLoggedIn = auth.isLoggedIn
		} catch {
			errorMessage = error.localizedDescription
		}
	}

	func initializeLogin() {
		if let url = auth.initializeLogin(redirectUri: Self.redirectUri, loginConfig: loginConfig) {
			loginUrl = url
		} else {
			loginUrl = nil
			errorMessage = "Error: login URL can't be populated"
		}
	}

	func finalizeLogin(_ url: String) {
		Task {
			do {
				try await auth.finalizeLogin(loginResponseUri: url)
				isLoggedIn = auth.isLoggedIn
			} catch {
				errorMessage = error.localizedDescription
			}
		}
	}

	func initializeDeviceLogin() {
		errorMessage = ""
		Task {
			do {
				let response = try await auth.initializeDeviceLogin()
				userCode = response.userCode
				expiresAt = Date().addingTimeInterval(TimeInterval(response.expiresIn))
				try await auth.finalizeDeviceLogin(deviceCode: response.deviceCode)
				isLoggedIn = auth.isLoggedIn
			} catch let error as TidalError {
				if let message = error.message {
					errorMessage = message
				}
			} catch {
				errorMessage = error.localizedDescription
			}
		}
	}

	func updateTimer() {
		if isDeviceLoginCodeExpired, !userCode.isEmpty {
			userCode = ""
			return
		}

		let duration = Duration.seconds(expiresAt.timeIntervalSinceNow)
		expiresIn = duration.formatted(.time(pattern: .minuteSecond(padMinuteToLength: 2)))
	}
}
