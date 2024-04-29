import Auth
import Common

extension CredentialsProviderMock {
	/// Injects a successful access token and user id into the provider - resulting in a level user auth.
	func injectSuccessfulUserLevelCredentials() {
		let credentials = Credentials.mock(userId: "userId", token: "token")
		injectedAuthResult = .success(credentials)
	}

	func injectFailedCredentials() {
		injectedAuthResult = .failure(.init(code: "0"))
	}
}
