import Foundation

struct EmuManifest: Decodable {
	let mimeType: String
	let urls: [String]
}
