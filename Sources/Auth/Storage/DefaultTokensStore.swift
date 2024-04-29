import Foundation
import KeychainAccess

final class DefaultTokensStore: TokensStore {
	private let PREFS_FILE_NAME = "tidal_auth_prefs"
	private let credentialsKey: String
	private let storageKey: String
	private let encryptedStorage: Keychain

	private var latestTokens: Tokens?

	init(credentialsKey: String) {
		storageKey = "\(credentialsKey)_\(PREFS_FILE_NAME)"
		self.credentialsKey = credentialsKey
		encryptedStorage = Keychain(service: storageKey)
	}

	func getLatestTokens() throws -> Tokens? {
		latestTokens = try latestTokens ?? loadTokens()
		return latestTokens
	}

	private func loadTokens() throws -> Tokens? {
		guard let json = encryptedStorage[credentialsKey], let data = json.data(using: .utf8) else {
			return nil
		}
		return try JSONDecoder().decode(Tokens.self, from: data)
	}

	func saveTokens(tokens: Tokens) throws {
		let data = try JSONEncoder().encode(tokens)
		encryptedStorage[credentialsKey] = String(data: data, encoding: .utf8)
		latestTokens = tokens
		// TODO: emit credentails update:  `bus.emit(CredentialsUpdatedMessage)`
	}

	func eraseTokens() throws {
		latestTokens = nil
		try encryptedStorage.removeAll()
	}
}
