import Foundation

public final class ConfigurableAuthTokenProvider: AccessTokenProvider {
	public var accessToken: String?
	public let onRenewal: () throws -> String

	public init(accessToken: String?, onRenewal: @escaping () throws -> String) {
		self.accessToken = accessToken
		self.onRenewal = onRenewal
	}

	public func renewAccessToken(status: Int?) async throws {
		accessToken = try onRenewal()
	}
}
