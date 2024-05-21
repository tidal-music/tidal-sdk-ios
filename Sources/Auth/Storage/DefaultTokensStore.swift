import Foundation
import KeychainAccess

final class DefaultTokensStore: TokensStore {
	private let PREFS_FILE_NAME = "tidal_auth_prefs"
	private let credentialsKey: String
	private let storageKey: String
	private let encryptedStorage: Keychain

	private var latestTokens: Tokens?

	init(credentialsKey: String, credentialsAccessGroup: String?) {
		storageKey = "\(credentialsKey)_\(PREFS_FILE_NAME)"
		self.credentialsKey = credentialsKey
		encryptedStorage = if let credentialsAccessGroup {
			Keychain(service: storageKey, accessGroup: credentialsAccessGroup)
		} else {
			Keychain(service: storageKey)
		}
	}

	func getLatestTokens() throws -> Tokens? {
		latestTokens = try latestTokens ?? loadTokens()
		return latestTokens
	}

	private func loadTokens() throws -> Tokens? {
		guard let json = encryptedStorage[credentialsKey], let data = json.data(using: .utf8) else {
			return nil
		}

		let decoder = JSONDecoder()

		return try {
			do {
				return try decoder.decode(Tokens.self, from: data)
			} catch {
				// try to decode legacy tokens, convert them to tokens and save tokens
				print("Failed to decode tokens. Attempting to decode legacy tokens")
				if let convertedLegacyTokens = try? decoder.decode(LegacyTokens.self, from: data).toTokens() {
					try saveTokens(tokens: convertedLegacyTokens)
					return convertedLegacyTokens
				} else {
					throw error
				}
			}
		}()
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
