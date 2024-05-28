@testable import Auth
import Foundation

final class FakeTokensStore: TokensStore {
	var saves = 0
	var loads = 0
	var tokensList = [Tokens]()
	let credentialsKey: String

	init(credentialsKey: String) {
		self.credentialsKey = credentialsKey
	}

	func getLatestTokens() throws -> Tokens? {
		loads += 1
		return tokensList.last
	}

	func saveTokens(tokens: Tokens) throws {
		saves += 1
		tokensList.append(tokens)
	}

	func eraseTokens() throws {
		tokensList.removeAll()
	}

	var last: Tokens? {
		tokensList.last
	}
}
