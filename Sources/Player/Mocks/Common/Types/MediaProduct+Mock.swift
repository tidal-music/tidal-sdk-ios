import Foundation

public extension MediaProduct {
	static func mock(
		productType: ProductType = .TRACK,
		productId: String = "productId",
		progressSource: Source? = nil,
		playLogSource: Source? = nil,
		productURL: URL? = nil
	) -> MediaProduct {
		MediaProduct(
			productType: productType,
			productId: productId,
			progressSource: progressSource,
			playLogSource: playLogSource
		)
	}
}
