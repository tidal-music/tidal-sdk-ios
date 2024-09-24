import Foundation
import KeychainAccess

final class DefaultTokensStore: TokensStore {
	private let PREFS_FILE_NAME = "tidal_auth_prefs"
	private let credentialsKey: String
	private let storageKey: String
	private let encryptedStorage: Keychain

	private var latestTokens: Tokens?

	private let credentialsQueue = DispatchQueue(label: "com.tidal.auth.credentialsQueue")

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
		try credentialsQueue.sync {
			if latestTokens == nil {
				latestTokens = try loadTokens()
			}
			return latestTokens
		}
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
					try saveTokensUnsafe(tokens: convertedLegacyTokens)
					return convertedLegacyTokens
				} else {
					throw error
				}
			}
		}()
	}

	func saveTokens(tokens: Tokens) throws {
		try credentialsQueue.sync {
			try saveTokensUnsafe(tokens: tokens)
		}
	}

	func eraseTokens() throws {
		try credentialsQueue.sync {
			latestTokens = nil
			try encryptedStorage.removeAll()
		}
	}

	private func saveTokensUnsafe(tokens: Tokens) throws {
		let data = try JSONEncoder().encode(tokens)
		encryptedStorage[credentialsKey] = String(decoding: data, as: UTF8.self)
		latestTokens = tokens
		// TODO: emit credentails update:  `bus.emit(CredentialsUpdatedMessage)`
	}
}
