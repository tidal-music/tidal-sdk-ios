import Common

// MARK: - MediaProduct.Extras

public extension MediaProduct {
	typealias Extras = AnyCodableDictionary
}

extension MediaProduct.Extras {
	enum Constants {
		static let UploadsDictKey = "extras"
	}
}
	
public extension Encodable {
	func asMediaProductExtras() throws -> MediaProduct.Extras {
		try asAnyCodableDictionary()
	}
}
