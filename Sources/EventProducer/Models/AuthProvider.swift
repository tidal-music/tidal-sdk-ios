import Foundation

public protocol AuthProvider {
	func getToken() async -> String?
	var clientID: String? { get }
	func refreshAccessToken(status: Int?) throws
}
