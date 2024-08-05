import Foundation

// MARK: - MediaProduct

public class MediaProduct: Codable {
	public let productType: ProductType
	public let productId: String
	public let progressSource: Source?
	public let playLogSource: Source?

	public init(
		productType: ProductType,
		productId: String,
		progressSource: Source?,
		playLogSource: Source?
	) {
		self.productType = productType
		self.productId = productId
		self.progressSource = progressSource
		self.playLogSource = playLogSource
	}

	public convenience init(productType: ProductType, productId: String) {
		self.init(
			productType: productType,
			productId: productId,
			progressSource: nil,
			playLogSource: nil
		)
	}
}

// MARK: SubType check

public extension MediaProduct {
	static func areSameSubtype(lhs: MediaProduct, rhs: MediaProduct) -> Bool {
		if type(of: lhs) == MediaProduct.self, type(of: rhs) == MediaProduct.self {
			return true
		}
		switch (lhs, rhs) {
		case (is StoredMediaProduct, is StoredMediaProduct):
			return true
		case (is Interruption, is Interruption):
			return true
		default:
			return false
		}
	}
}

// MARK: Equatable

extension MediaProduct: Equatable {
	public static func == (lhs: MediaProduct, rhs: MediaProduct) -> Bool {
		areSameSubtype(lhs: lhs, rhs: rhs) &&
			lhs.productId == rhs.productId &&
			lhs.productType == rhs.productType &&
			lhs.playLogSource == rhs.playLogSource &&
			lhs.progressSource == rhs.progressSource
	}
}

// MARK: CustomStringConvertible

extension MediaProduct: CustomStringConvertible {
	public var description: String {
		"MediaProduct(productType: \(productType), productId: \"\(productId)\", progressSource: \(String(describing: progressSource)), playLogSource: \(String(describing: playLogSource)))"
	}
}
