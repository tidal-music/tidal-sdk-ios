import Foundation

// MARK: - CredentialsProvider

public protocol CredentialsProvider {
	func getCredentials(apiErrorSubStatus: String?) async throws -> Credentials
	var isUserLoggedIn: Bool { get }
}

public extension CredentialsProvider {
	func getCredentials() async throws -> Credentials {
		try await getCredentials(apiErrorSubStatus: nil)
	}
}
