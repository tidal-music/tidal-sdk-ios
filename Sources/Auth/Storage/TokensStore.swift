import Foundation

protocol TokensStore {
	func getLatestTokens() throws -> Tokens?
	func saveTokens(tokens: Tokens) throws
	func eraseTokens() throws
}
