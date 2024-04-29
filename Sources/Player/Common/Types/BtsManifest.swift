import Foundation

struct BtsManifest: Decodable {
	let mimeType: String
	let codecs: String
	let encryptionType: String
	let keyId: String?
	let urls: [String]
}
