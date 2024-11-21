import Auth
import AuthenticationServices
import Foundation

// MARK: - AuthViewModel

@MainActor
class AuthViewModel: NSObject, ObservableObject {
	private let CLIENT_UNIQUE_KEY = "ClientUniqueKey"
	private let CLIENT_ID_DEVICE_LOGIN = "ClientIDDeviceLogin"
	private let CLIENT_ID = "ClientID"
	private let CLIENT_SECRET = "ClientSecret"
	private let customScheme = "testauthsdk"
	private let redirectUri = "testauthsdk://auth-test"
	private let scopes: Set<String> = []

	@Published var isDeviceLoginEnabled: Bool = false {
		didSet {
			auth.config(config: authConfig)
		}
	}

	@Published var userCode: String = ""
	@Published var isLoggedIn: Bool = false
	@Published var errorMessage: String = ""
	@Published var expiresIn: String = ""

	private var webAuthSession: ASWebAuthenticationSession?
	private var contextProvider: ASWebAuthenticationPresentationContextProviding?

	private var loginUrl: URL?
	private var loginConfig: LoginConfig {
		LoginConfig(customParams: [QueryParameter(key: "appMode", value: "iOS")])
	}

	private var expiresAt: Date = Date()
	private var isDeviceLoginCodeExpired: Bool {
		Date() > expiresAt
	}

	private var auth: TidalAuth {
		.shared
	}

	private var authConfig: AuthConfig {
		AuthConfig(
			clientId: isDeviceLoginEnabled ? CLIENT_ID_DEVICE_LOGIN : CLIENT_ID,
			clientUniqueKey: CLIENT_UNIQUE_KEY,
			credentialsKey: "auth-storage",
			scopes: scopes
		)
	}

	override init() {
		super.init()
		initAuth()
	}

	func initAuth() {
		auth.config(config: authConfig)
		isLoggedIn = auth.isUserLoggedIn
	}

	func logout() {
		do {
			try auth.logout()
			userCode = ""
			errorMessage = ""
			isLoggedIn = auth.isUserLoggedIn
		} catch {
			errorMessage = "Logout error: " + error.localizedDescription
		}
	}

	func initializeLogin() {
		guard let url = auth.initializeLogin(redirectUri: redirectUri, loginConfig: loginConfig) else {
			loginUrl = nil
			errorMessage = "Error: login URL can't be populated"
			return
		}
		startAuthenticationFlow(with: url)
	}

	func finalizeLogin(_ url: String) {
		Task {
			defer {
				contextProvider = nil
				webAuthSession = nil
			}

			do {
				try await auth.finalizeLogin(loginResponseUri: url)
				isLoggedIn = auth.isUserLoggedIn
			} catch {
				errorMessage = "Login error: " + error.localizedDescription
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
				isLoggedIn = auth.isUserLoggedIn
			} catch let error as TidalError {
				if let message = error.message {
					errorMessage = message
				} else {
					errorMessage = error.localizedDescription
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

		if #available(iOS 16, *) {
			let duration = Duration.seconds(expiresAt.timeIntervalSinceNow)
			expiresIn = duration.formatted(.time(pattern: .minuteSecond(padMinuteToLength: 2)))
		} else {
			let timeInterval = expiresAt.timeIntervalSinceNow
			let minutes = Int(timeInterval) / 60
			let seconds = Int(timeInterval) % 60
			expiresIn = String(format: "%02d:%02d", minutes, seconds)
		}
	}
}

private extension AuthViewModel {
	private func startAuthenticationFlow(with loginURL: URL) {
		errorMessage = ""
		loginUrl = loginURL

		let completionHandler: ASWebAuthenticationSession.CompletionHandler = { [weak self] callbackURL, error in
			guard let self else {
				return
			}
			if let error {
				errorMessage = "Authentication failed: " + error.localizedDescription
			} else if let callbackURL {
				finalizeLogin(callbackURL.absoluteString)
			}
		}

		if #available(iOS 17.4, *) {
			webAuthSession = ASWebAuthenticationSession(
				url: loginURL,
				callback: .customScheme(customScheme),
				completionHandler: completionHandler
			)
		} else {
			webAuthSession = ASWebAuthenticationSession(
				url: loginURL,
				callbackURLScheme: customScheme,
				completionHandler: completionHandler
			)
		}

		// Provide the presentation context for iPad compatibility
		contextProvider = PresentationContextProvider()
		webAuthSession?.presentationContextProvider = contextProvider
		webAuthSession?.prefersEphemeralWebBrowserSession = false
		webAuthSession?.start()
	}
}
