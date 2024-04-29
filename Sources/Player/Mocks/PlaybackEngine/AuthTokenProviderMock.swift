import Foundation

public final class AuthTokenProviderMock: AccessTokenProvider {
	public private(set) var accessToken: String? = "accessToken"

	public init() {}

	public func renewAccessToken(status: Int?) async throws {}
}
