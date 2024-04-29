struct EncodableEmuManifest: Encodable {
	let mimeType: String = "application/json"
	let urls: [String] = ["https://www.google.com"]
}
