import Common
import Foundation

struct DeviceLoginPollHelper {
	let loginService: LoginService
	private var pollRetryPolicy: RetryPolicy?

	init(loginService: LoginService) {
		self.loginService = loginService
	}

	mutating func prepareForPoll(interval: Int, maxDuration: Int) {
		pollRetryPolicy = DeviceLoginRetryPolicy(maxDuration: maxDuration, interval: interval)
	}

	func poll(
		authConfig: AuthConfig,
		deviceCode: String,
		grantType: String,
		retryPolicy: RetryPolicy
	) async -> AuthResult<LoginResponse> {
		guard let pollRetryPolicy else {
			fatalError("prepareForPoll must be called before the poll function")
		}
		return await retryWithPolicy(pollRetryPolicy, authErrorPolicy: PollErrorPolicy()) {
			try await retryWithPolicyUnwrapped(retryPolicy) {
				try await loginService.getTokenFromDeviceCode(
					clientId: authConfig.clientId,
					clientSecret: authConfig.clientSecret,
					deviceCode: deviceCode,
					grantType: grantType,
					scopes: authConfig.scopes.toScopesString(),
					clientUniqueKey: authConfig.clientUniqueKey
				)
			}
		}
	}

	struct DeviceLoginRetryPolicy: RetryPolicy {
		let maxDuration: Int
		let interval: Int
		private let expirationDate: Date

		init(maxDuration: Int, interval: Int) {
			self.maxDuration = maxDuration
			self.interval = interval
			numberOfRetries = maxDuration / interval
			delayMillis = interval.toMilliseconds
			delayFactor = 1

			expirationDate = Date().addingTimeInterval(TimeInterval(maxDuration))
		}

		let numberOfRetries: Int
		let delayMillis: Int
		let delayFactor: Int

		func shouldRetry(errorResponse: ErrorResponse?, throwable: Error?, attempt: Int) -> Bool {
			let isTokenExpired = errorResponse?.subStatus.description.isSubStatus(status: .expiredAccessToken) ?? false
			return attempt < numberOfRetries && !isTokenExpired
		}
	}

	private class PollErrorPolicy: AuthErrorPolicy {
		func handleError<T>(errorResponse: ErrorResponse?, throwable: Error?) -> AuthResult<T> {
			guard let throwable = throwable as? NetworkError else {
				return .failure(NetworkError(code: "0", throwable: throwable))
			}

			let subStatus = ApiErrorSubStatus.allCases.first(where: { $0.rawValue == errorResponse?.subStatus.description })
			if throwable.isServerError {
				return .failure(RetryableError(code: throwable.code, subStatus: subStatus?.rawValue.toInt, throwable: throwable))
			}

			if throwable.isClientError {
				if let code = Int(throwable.code), code > HTTP_UNAUTHORIZED {
					return .failure(TokenResponseError(code: throwable.code, throwable: throwable))
				} else {
					return .failure(handleSubStatus(subStatus: subStatus, exception: throwable))
				}
			}

			return .failure(NetworkError(code: "1", throwable: throwable))
		}

		private func handleSubStatus(subStatus: ApiErrorSubStatus?, exception: NetworkError) -> TidalError {
			switch subStatus {
			case .authorizationPending:
				RetryableError(
					code: exception.code,
					subStatus: subStatus?.rawValue.toInt,
					throwable: exception
				)
			case .expiredAccessToken:
				TokenResponseError(
					code: exception.code,
					subStatus: subStatus?.rawValue.toInt,
					throwable: exception
				)
			default:
				UnexpectedError(
					code: exception.code,
					subStatus: subStatus?.rawValue.toInt,
					throwable: exception
				)
			}
		}
	}
}
