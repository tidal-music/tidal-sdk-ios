struct EncodableEmuManifest: Encodable {
	let mimeType: String
	let urls: [String]

	init(mimeType: String = "application/json", urls: [String] = ["https://www.tidal.com"]) {
		self.mimeType = mimeType
		self.urls = urls
	}
}
