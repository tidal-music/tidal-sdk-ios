import Foundation

// MARK: - MediaProduct

public class MediaProduct: Codable {
	public let productType: ProductType
	public let productId: String
	public let referenceId: String?
	public let progressSource: Source?
	public let playLogSource: Source?
	public let extras: Extras?
	/// Grants playback of an upload shared by link to a recipient who has not saved the share.
	public let shareCode: String?

	public init(
		productType: ProductType,
		productId: String,
		referenceId: String?,
		progressSource: Source?,
		playLogSource: Source?,
		extras: Extras?,
		shareCode: String? = nil
	) {
		self.productType = productType
		self.productId = productId
		self.referenceId = referenceId
		self.progressSource = progressSource
		self.playLogSource = playLogSource
		self.extras = extras
		self.shareCode = shareCode
	}

	public convenience init(productType: ProductType, productId: String) {
		self.init(
			productType: productType,
			productId: productId,
			referenceId: nil,
			progressSource: nil,
			playLogSource: nil,
			extras: nil
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
			lhs.referenceId == rhs.referenceId &&
			lhs.playLogSource == rhs.playLogSource &&
			lhs.progressSource == rhs.progressSource &&
			lhs.extras == rhs.extras &&
			lhs.shareCode == rhs.shareCode
	}
}

// MARK: CustomStringConvertible

extension MediaProduct: CustomStringConvertible {
	public var description: String {
		"MediaProduct(productType: \(productType), productId: \"\(productId)\", referenceId: \"\(String(describing: referenceId))\", progressSource: \(String(describing: progressSource)), playLogSource: \(String(describing: playLogSource)), extras: \(String(describing: extras)))"
	}
}
