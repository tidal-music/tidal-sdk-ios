import Foundation

protocol KeyRequest: AnyObject {
	func getKeyId() throws -> Data
	func createServerPlaybackContext(for keyId: Data, using certificate: Data) async throws -> Data
}
