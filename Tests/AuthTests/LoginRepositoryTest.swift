@testable import Auth
import Common
import KeychainAccess
import XCTest

// swiftlint:disable type_body_length
// swiftlint:disable file_length
final class LoginRepositoryTest: XCTestCase {
	private var fakeLoginService: FakeLoginService?
	private var fakeTokensStore: FakeTokensStore?
	private var loginRepository: LoginRepository?
	private var testRetryPolicy: RetryPolicy!
	private let loginUri = "https://tidal.com/ios/login/auth"
	private let clientId = "12345"
	private let loginBaseUri = "https://login.tidal.com"
	private let clientUniqueKey = "testUniqueKey"
	private lazy var authConfig = AuthConfig(
		clientId: clientId,
		clientUniqueKey: clientUniqueKey,
		credentialsKey: "credentialsKey",
		scopes: .init(),
		enableCertificatePinning: false
	)

	private let QUERY_PREFIX = "(&|\\?)"
	private let VALID_URI = "https://tidal.com/ios/login/auth&code=123&appMode=android"

	override func setUp() async throws {
		loginRepository = nil
		fakeLoginService = nil
		fakeTokensStore = nil
	}

	private struct TestRetryPolicy: RetryPolicy {
		var numberOfRetries: Int { 3 }
		var delayMillis: Int { 1 }
		var delayFactor: Int { 1 }
	}

	func createLoginRepository(
		_ loginService: FakeLoginService = FakeLoginService(),
		_ tokensStore: FakeTokensStore = FakeTokensStore(credentialsKey: ""),
		retryPolicy: RetryPolicy = TestRetryPolicy()
	) {
		fakeLoginService = loginService
		fakeTokensStore = tokensStore
		testRetryPolicy = retryPolicy
		loginRepository = LoginRepository(
			authConfig: authConfig,
			tokensStore: tokensStore,
			loginUriBuilder: LoginUriBuilder(
				clientId: clientId,
				clientUniqueKey: clientUniqueKey,
				loginBaseUrl: loginBaseUri
			),
			loginService: loginService,
			exponentialBackoffPolicy: retryPolicy
		)
	}

	func testGetLoginUriUsesCorrectBaseUrl() {
		createLoginRepository()

		// given
		let expectedBaseUrl = "https://login.tidal.com/authorize"

		// when
		guard let actualUrl = loginRepository?.getLoginUri(redirectUri: loginUri, loginConfig: nil) else {
			XCTFail("actualUrl is nil")
			return
		}

		// then
		XCTAssertTrue(actualUrl.hasPrefix(expectedBaseUrl))
	}

	func testGetLoginUriAppendsTheSubmittedBaseQueryArguments() {
		// given
		createLoginRepository()
		let clientIdMatcher = "\(QUERY_PREFIX)\(LoginUriBuilder.QueryKeys.CLIENT_ID_KEY)=\(clientId)"
		let clientUniqueKeyMatcher = "\(QUERY_PREFIX)\(LoginUriBuilder.QueryKeys.CLIENT_UNIQUE_KEY)=\(clientUniqueKey)"
		let codeChallengeMethodMatcher = "\(QUERY_PREFIX)\(LoginUriBuilder.QueryKeys.CODE_CHALLENGE_METHOD_KEY)=S256"

		// when
		guard let generatedUri = loginRepository?.getLoginUri(redirectUri: loginUri, loginConfig: nil) else {
			XCTFail("generatedUri is nil")
			return
		}

		// then
		XCTAssertNotNil(
			generatedUri.range(of: clientIdMatcher, options: .regularExpression),
			"getLoginUri() should append the $CLIENT_ID_KEY"
		)
		XCTAssertNotNil(
			generatedUri.range(of: clientUniqueKeyMatcher, options: .regularExpression),
			"getLoginUri() should append the $CLIENT_UNIQUE_KEY"
		)
		XCTAssertNotNil(
			generatedUri.range(of: codeChallengeMethodMatcher, options: .regularExpression),
			"getLoginUri() should append the $$CODE_CHALLENGE_METHOD_KEY"
		)
	}

	func testGetLoginUriAppendsTheRedirectUriProperly() {
		// given
		createLoginRepository()
		let fakeUri = "fakeUri"

		let redirectUriMatcher = "\(QUERY_PREFIX)\(LoginUriBuilder.QueryKeys.REDIRECT_URI_KEY)=\(fakeUri)"

		// when
		guard let generatedUri = loginRepository?.getLoginUri(redirectUri: fakeUri, loginConfig: nil) else {
			XCTFail("generatedUri is nil")
			return
		}

		// then
		XCTAssertNotNil(
			generatedUri.range(of: redirectUriMatcher, options: .regularExpression),
			"getLoginUri() should append the $$REDIRECT_URI_KEY"
		)
	}

	func testGetLoginUriReturnsUriContainingAllCustomQueryArguments() {
		// given
		createLoginRepository()
		let loginConfig = LoginConfig(
			customParams: [
				QueryParameter(key: "key1", value: "value1"),
				QueryParameter(key: "key2", value: "value2"),
				QueryParameter(key: "key3", value: "value3"),
			]
		)

		// when
		guard let generatedUri = loginRepository?.getLoginUri(redirectUri: loginUri, loginConfig: loginConfig) else {
			XCTFail("generatedUri is nil")
			return
		}

		// then
		loginConfig.customParams.forEach { param in
			let matcher = "\(QUERY_PREFIX)\(param.key)=\(param.value)"
			XCTAssertNotNil(
				generatedUri.range(of: matcher, options: .regularExpression),
				"getLoginUrl() should append all custom query parameters"
			)
		}
	}

	func testDoNotGetTokenWithIncorrectLoginResponse() async throws {
		// given
		createLoginRepository()
		let incorrectUriString = "https://www.google.com"

		// when
		_ = loginRepository?.getLoginUri(redirectUri: loginUri, loginConfig: nil)
		let result = try await loginRepository?.getTokenFromLoginCode(uri: incorrectUriString)
		// then
		XCTAssertEqual(
			fakeLoginService?.calls.filter { $0 == .getTokenWithCodeVerifier }.count,
			0,
			"If the submitted uri is incorrect, the service should not get called"
		)

		switch result {
		case .success, .none:
			XCTFail("Result supposed to be a failure")
		case let .failure(error):
			XCTAssertTrue(
				error is AuthorizationError,
				"If the submitted uri is incorrect, a Failure containing an AuthorizationError should be returned."
			)
		}
	}

	func testGetTokenWithCorrectLoginResponse() async throws {
		// given
		createLoginRepository()
		let correctUriString = VALID_URI

		// when
		_ = loginRepository?.getLoginUri(redirectUri: loginUri, loginConfig: nil)
		let result = try await loginRepository?.getTokenFromLoginCode(uri: correctUriString)
		// then
		XCTAssertEqual(
			fakeLoginService?.calls.filter { $0 == .getTokenWithCodeVerifier }.count,
			1,
			"If the submitted uri is correct, the service should get called"
		)

		switch result {
		case .success:
			break
		case .failure, .none:
			XCTFail("Result supposed to be a success")
		}
	}

	func testCredentialsSavedUponSuccessfulRegularLogin() async throws {
		// given
		createLoginRepository()

		// when
		_ = loginRepository?.getLoginUri(redirectUri: loginUri, loginConfig: nil)
		_ = try await loginRepository?.getTokenFromLoginCode(uri: VALID_URI)

		// then
		XCTAssertEqual(
			1,
			fakeTokensStore?.saves,
			"TokensStore should have been called once to save after successful token retrieval"
		)
	}

	func testCredentialsSavedUponSuccessfulDeviceLogin() async throws {
		// given
		createLoginRepository()

		fakeLoginService?.deviceLoginBehaviour = DeviceLoginBehaviour(
			authorizationResponseExpirationSeconds: 10,
			loginPendingSeconds: 1,
			exceptionToFinishWith: nil
		)

		// when

		guard let authorizationResponse = try await loginRepository?.initializeDeviceLogin() else {
			XCTFail("initializeDeviceLogin failed to produce response")
			return
		}

		guard let deviceCode = authorizationResponse.successData?.deviceCode else {
			XCTFail("deviceCode is null")
			return
		}

		_ = try await loginRepository?.pollForDeviceLoginResponse(deviceCode: deviceCode)

		// then
		XCTAssertEqual(
			1,
			fakeTokensStore?.saves,
			"TokensStore should have been called once to save after successful token retrieval"
		)
	}

	func testFinalizeDeviceLoginReturnsSuccessIfResponseAvailableBeforeAuthExpires() async throws {
		// given
		createLoginRepository()
		fakeLoginService?.deviceLoginBehaviour = DeviceLoginBehaviour(
			authorizationResponseExpirationSeconds: 12,
			loginPendingSeconds: 9,
			exceptionToFinishWith: nil
		)
		// when
		guard let authorizationResponse = try await loginRepository?.initializeDeviceLogin() else {
			XCTFail("initializeDeviceLogin failed to produce response")
			return
		}

		guard let deviceCode = authorizationResponse.successData?.deviceCode else {
			XCTFail("deviceCode is null")
			return
		}

		guard let result = try await loginRepository?.pollForDeviceLoginResponse(deviceCode: deviceCode) else {
			XCTFail("pollForDeviceLoginResponse returned null")
			return
		}

		// then
		XCTAssertTrue(
			result.isSuccess,
			"If a response is returned before the expiration time, the call to finalizeDeviceLogin() should succeed"
		)
	}

	func testFinalizeDeviceLoginReturnsFailureIfResponseAvailableAfterAuthExpires() async throws {
		// given
		createLoginRepository()
		fakeLoginService?.deviceLoginBehaviour = DeviceLoginBehaviour(
			authorizationResponseExpirationSeconds: 9,
			loginPendingSeconds: 12,
			exceptionToFinishWith: nil
		)
		// when
		guard let authorizationResponse = try await loginRepository?.initializeDeviceLogin() else {
			XCTFail("initializeDeviceLogin failed to produce response")
			return
		}

		guard let deviceCode = authorizationResponse.successData?.deviceCode else {
			XCTFail("deviceCode is null")
			return
		}

		guard let result = try await loginRepository?.pollForDeviceLoginResponse(deviceCode: deviceCode) else {
			XCTFail("pollForDeviceLoginResponse returned null")
			return
		}

		// then
		switch result {
		case .success:
			XCTFail(
				"If a response is returned after the expiration time, the call to finalizeDeviceLogin() should fail and return a TokenResponseError"
			)
		case let .failure(message):
			XCTAssertTrue(
				message is UnexpectedError,
				"If a response is returned after the expiration time, the call to finalizeDeviceLogin() should fail and return a TokenResponseError"
			)
		}
	}

	func testGetTokenFromLoginCodeRetriesAsManyTimesAsSpecifiedInPolicyOn5xxError() async throws {
		// given
		struct CustomRetryPolicy: RetryPolicy {
			var numberOfRetries: Int { 3 }
			var delayMillis: Int { 5 }
			var delayFactor: Int { 1 }
		}

		let retryPolicy = CustomRetryPolicy()
		let fakeException = NetworkError(code: "503")

		createLoginRepository(FakeLoginService(throwableToThrow: fakeException), retryPolicy: retryPolicy)

		// when
		_ = loginRepository?.getLoginUri(redirectUri: loginUri, loginConfig: nil)
		_ = try await loginRepository?.getTokenFromLoginCode(uri: VALID_URI)

		// then
		XCTAssertEqual(
			fakeLoginService?.calls.filter { $0 == .getTokenWithCodeVerifier }.count,
			retryPolicy.numberOfRetries + 1,
			"getTokenFromLoginCode should retry as many times as specified, resulting in a total number of attempts that is equal to the policy's specified retries + 1"
		)
	}

	func testGetTokenFromLoginCodeReturnsFailureWithUnexpectedError4xxError() async throws {
		// given
		struct CustomRetryPolicy: RetryPolicy {
			var numberOfRetries: Int { 3 }
			var delayMillis: Int { 5 }
			var delayFactor: Int { 1 }
		}

		let errorCode = 400
		let retryPolicy = CustomRetryPolicy()
		let fakeException = NetworkError(code: "\(errorCode)")

		createLoginRepository(FakeLoginService(throwableToThrow: fakeException), retryPolicy: retryPolicy)

		// when
		_ = loginRepository?.getLoginUri(redirectUri: loginUri, loginConfig: nil)
		let result = try await loginRepository?.getTokenFromLoginCode(uri: VALID_URI)

		// then
		XCTAssertEqual(
			fakeLoginService?.calls.filter { $0 == .getTokenWithCodeVerifier }.count,
			1,
			"getTokenFromLoginCode should not retry on 4xx errors"
		)

		switch result {
		case .success, .none:
			XCTFail("Test suppose to fail due to an unexpected error")
		case let .failure(error):
			XCTAssertTrue(error is UnexpectedError, "Http 4xx errors should result in a Failure containing an UnexpectedError")
			XCTAssertEqual(error.code, "\(errorCode)", "The returned result should contain the exception's code")
		}
	}

	func testGetTokenFromLoginCodeRetriesAsSpecifiedAndReturnsFailureOn5xxError() async throws {
		// given
		struct CustomRetryPolicy: RetryPolicy {
			var numberOfRetries: Int { 3 }
			var delayMillis: Int { 5 }
			var delayFactor: Int { 1 }
		}

		let errorCode = 503
		let retryPolicy = CustomRetryPolicy()
		let fakeException = NetworkError(code: "\(errorCode)")

		createLoginRepository(FakeLoginService(throwableToThrow: fakeException), retryPolicy: retryPolicy)

		// when
		_ = loginRepository?.getLoginUri(redirectUri: loginUri, loginConfig: nil)
		let result = try await loginRepository?.getTokenFromLoginCode(uri: VALID_URI)

		// then
		XCTAssertEqual(
			fakeLoginService?.calls.filter { $0 == .getTokenWithCodeVerifier }.count,
			retryPolicy.numberOfRetries + 1,
			"The network call should be retried the specified number of times"
		)

		switch result {
		case .success, .none:
			XCTFail("Test suppose to fail due to an unexpected error")
		case let .failure(error):
			XCTAssertTrue(error is RetryableError, "Http 5xx errors should result in a Failure containing an RetryableError")
			XCTAssertEqual(error.code, "\(errorCode)", "The returned result should contain the exception's code")
		}
	}

	func testGetTokenFromLoginCodeDoesNotRetryAndReturnsFailureOnNonHttpException() async throws {
		// given
		struct CustomRetryPolicy: RetryPolicy {
			var numberOfRetries: Int { 3 }
			var delayMillis: Int { 5 }
			var delayFactor: Int { 1 }
		}

		let retryPolicy = CustomRetryPolicy()
		let fakeException = UnexpectedError(code: "Unknown")

		createLoginRepository(FakeLoginService(throwableToThrow: fakeException), retryPolicy: retryPolicy)

		// when
		_ = loginRepository?.getLoginUri(redirectUri: loginUri, loginConfig: nil)
		let result = try await loginRepository?.getTokenFromLoginCode(uri: VALID_URI)

		switch result {
		case .success, .none:
			XCTFail("Test suppose to fail due to an unexpected error")
		case let .failure(error):
			XCTAssertTrue(error is NetworkError, "Http 4xx errors should result in a Failure containing an NetworkError")
			XCTAssertEqual(
				fakeLoginService?.calls.filter { $0 == .getTokenWithCodeVerifier }.count,
				1,
				"getTokenFromLoginCode should not retry on non-5xx errors"
			)
		}
	}

	func testInitializeDeviceLoginRetriesOn5xxErrorsAndReturnsRetryableError() async throws {
		// given
		let errorCode = 503
		let fakeException = NetworkError(code: "\(errorCode)")
		createLoginRepository(FakeLoginService(throwableToThrow: fakeException))

		// when
		let result = try await loginRepository?.initializeDeviceLogin()
		let expectedNumberOfCalls = testRetryPolicy.numberOfRetries + 1

		// then
		XCTAssertEqual(
			fakeLoginService?.calls.filter { $0 == .getDeviceAuthorization }.count,
			expectedNumberOfCalls,
			"In case of 5xx returns, initializeDeviceLogin should trigger retries as defined by the retryPolicy"
		)

		switch result {
		case .success, .none:
			XCTFail("Test suppose to fail due to an unexpected error")
		case let .failure(error):
			XCTAssertTrue(error is RetryableError, "Http 5xx errors should result in a Failure containing an RetryableError")
			XCTAssertEqual(error.code, "\(errorCode)", "The returned result should contain the exception's code")
		}
	}

	func testPollForDeviceLoginResponseRetriesOn5xxerrors() async throws {
		// given
		createLoginRepository()
		fakeLoginService?.deviceLoginBehaviour = DeviceLoginBehaviour(
			authorizationResponseExpirationSeconds: 10,
			loginPendingSeconds: 9,
			exceptionToFinishWith: nil,
			exceptionToThrowWhilePending: NetworkError(code: "503")
		)

		// when
		guard let expirationTime = fakeLoginService?.deviceLoginBehaviour?.authorizationResponseExpirationSeconds else {
			XCTFail("authorizationResponseExpirationSeconds must be not nil")
			return
		}

		guard let authorizationResponse = try await loginRepository?.initializeDeviceLogin(),
		      let successData = authorizationResponse.successData
		else {
			XCTFail("authorizationResponse must be not nil")
			return
		}

		let expectedPollCalls = expirationTime / successData.interval
		let result = try await loginRepository?.pollForDeviceLoginResponse(deviceCode: successData.deviceCode)

		// then

		// the number of calls to expect are defined by the expiration and the interval
		// in the DeviceAuthorizationResponse as well as the retryPolicy's numberOfRetries
		let expectedTotalCalls = expectedPollCalls + expectedPollCalls * testRetryPolicy.numberOfRetries

		XCTAssertEqual(
			fakeLoginService?.calls.filter { $0 == .getTokenFromDeviceCode }.count,
			expectedTotalCalls,
			"In case of 5xx returns, each poll attempt should trigger retries as defined by the retryPolicy"
		)

		switch result {
		case .success, .none:
			XCTFail("Test suppose to fail due to an unexpected error")
		case let .failure(error):
			XCTAssertTrue(error is RetryableError, "When finished retrying, a RetryableError should be returned")
		}
	}

	func testPollForDeviceLoginResponseSuccessIfReturnsBeforeAuthorizationExpires() async throws {
		// given
		createLoginRepository()
		fakeLoginService?.deviceLoginBehaviour = DeviceLoginBehaviour(
			authorizationResponseExpirationSeconds: 12,
			loginPendingSeconds: 9,
			exceptionToFinishWith: nil
		)

		// when
		let authorizationResponse = try await loginRepository?.initializeDeviceLogin()
		guard let deviceCode = authorizationResponse?.successData?.deviceCode else {
			XCTFail("DeviceCode must be present")
			return
		}

		let result = try await loginRepository?.pollForDeviceLoginResponse(deviceCode: deviceCode)

		// then
		XCTAssertEqual(
			result?.isSuccess,
			true,
			"If a response is returned before the expiration time, the call to finalizeDeviceLogin() should succeed"
		)
	}

	func testPollForDeviceLoginResponseReturnsFailureIfReturnsAfterAuthExpires() async throws {
		// given
		createLoginRepository()
		fakeLoginService?.deviceLoginBehaviour = DeviceLoginBehaviour(
			authorizationResponseExpirationSeconds: 9,
			loginPendingSeconds: 12,
			exceptionToFinishWith: nil
		)

		// when
		let authorizationResponse = try await loginRepository?.initializeDeviceLogin()
		guard let deviceCode = authorizationResponse?.successData?.deviceCode else {
			XCTFail("DeviceCode must be present")
			return
		}

		let result = try await loginRepository?.pollForDeviceLoginResponse(deviceCode: deviceCode)

		// then
		switch result {
		case .success, .none:
			XCTFail("Test suppose to fail due to an unexpected error")
		case let .failure(error):
			XCTAssertTrue(
				error is UnexpectedError,
				"If a response is returned after the expiration time, the call to finalizeDeviceLogin() should fail and return a TokenResponseError"
			)
		}
	}

	func testPollForDeviceLoginResponseShouldPollingOn400And401Errors() async throws {
		// given
		createLoginRepository()
		let authorizationResponseExpirationSeconds = 10
		fakeLoginService?.deviceLoginBehaviour = DeviceLoginBehaviour(
			authorizationResponseExpirationSeconds: authorizationResponseExpirationSeconds,
			loginPendingSeconds: 9,
			exceptionToFinishWith: nil
		)

		let expectedPollCalls = authorizationResponseExpirationSeconds / 2

		// when
		let authorizationResponse = try await loginRepository?.initializeDeviceLogin()
		guard let deviceCode = authorizationResponse?.successData?.deviceCode else {
			XCTFail("DeviceCode must be present")
			return
		}

		_ = try await loginRepository?.pollForDeviceLoginResponse(deviceCode: deviceCode)

		// then
		XCTAssertEqual(
			fakeLoginService?.calls.filter { $0 == .getTokenFromDeviceCode }.count,
			expectedPollCalls,
			"Given an expiration of ${fakeLoginService.deviceLoginBehaviour.authorizationResponseExpirationSeconds} and a poll interval of ${authorizationResponse.successData!!.interval}, login service should have been called $expectedPollCalls"
		)
	}

	func testPollForDeviceLoginResponseReturnsTokenResponseErrorOn4xxOver401() async throws {
		// given
		createLoginRepository()
		fakeLoginService?.deviceLoginBehaviour = DeviceLoginBehaviour(
			authorizationResponseExpirationSeconds: 10,
			loginPendingSeconds: 9,
			exceptionToFinishWith: nil,
			exceptionToThrowWhilePending: NetworkError(code: "403")
		)

		// when
		let authorizationResponse = try await loginRepository?.initializeDeviceLogin()
		guard let deviceCode = authorizationResponse?.successData?.deviceCode else {
			XCTFail("DeviceCode must be present")
			return
		}

		let result = try await loginRepository?.pollForDeviceLoginResponse(deviceCode: deviceCode)

		// then
		switch result {
		case .success, .none:
			XCTFail("Test suppose to fail due to an unexpected error")
		case let .failure(error):
			XCTAssertTrue(
				error is TokenResponseError,
				"On 4xx errors that aren't 400 or 401, a TokenResponseError should be returned"
			)
		}
	}

	func testPollForDeviceLoginResponseReturnsRetryableErrorAfterFailingWith5xxError() async throws {
		// given
		createLoginRepository()
		fakeLoginService?.deviceLoginBehaviour = DeviceLoginBehaviour(
			authorizationResponseExpirationSeconds: 10,
			loginPendingSeconds: 9,
			exceptionToFinishWith: nil,
			exceptionToThrowWhilePending: NetworkError(code: "503")
		)

		// when
		let authorizationResponse = try await loginRepository?.initializeDeviceLogin()
		guard let deviceCode = authorizationResponse?.successData?.deviceCode else {
			XCTFail("DeviceCode must be present")
			return
		}

		let result = try await loginRepository?.pollForDeviceLoginResponse(deviceCode: deviceCode)

		// then
		switch result {
		case .success, .none:
			XCTFail("Test suppose to fail due to an unexpected error")
		case let .failure(error):
			XCTAssertTrue(error is RetryableError, "On 5xx errors, a RetryableError should be returned")
		}
	}

	func testIsLoggedIn() async throws {
		createLoginRepository()
		_ = loginRepository?.getLoginUri(redirectUri: loginUri, loginConfig: nil)

		let cases: [(userID: Int?, expectedIsLoggedIn: Bool)] = [
			(1, true),
			(nil, false),
		]

		for (userID, expectedIsLoggedIn) in cases {
			fakeLoginService?.userId = userID

			_ = try await loginRepository?.getTokenFromLoginCode(uri: VALID_URI)

			XCTAssertEqual(loginRepository?.isLoggedIn, expectedIsLoggedIn)
		}
	}
}

// swiftlint:enable type_body_length
