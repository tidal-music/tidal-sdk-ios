import Common
import Foundation

public final class CredentialsProviderMock: CredentialsProvider {
	public var injectedAuthResult = AuthResult.success(Credentials.mock())
	public private(set) var getCredentialsCallCount = 0

	public init() {}

	public func getCredentials(apiErrorSubStatus: String?) async throws -> Credentials {
		getCredentialsCallCount += 1
		return try injectedAuthResult.get()
	}
}
