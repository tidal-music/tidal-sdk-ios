struct EncodableEmuManifest: Encodable {
	let mimeType: String
	let urls: [String]

	init(mimeType: String = "application/json", urls: [String] = ["https://www.google.com"]) {
		self.mimeType = mimeType
		self.urls = urls
	}
}
