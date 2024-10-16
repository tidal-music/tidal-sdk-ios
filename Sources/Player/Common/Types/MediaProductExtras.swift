import Common

// MARK: - MediaProduct.Extras

public extension MediaProduct {
	typealias Extras = AnyCodableDictionary
}

public extension Encodable {
	func asMediaProductExtras() throws -> MediaProduct.Extras {
		try asAnyCodableDictionary()
	}
}
