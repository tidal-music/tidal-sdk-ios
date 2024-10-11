import Foundation

public extension MediaProduct {
	static func mock(
		productType: ProductType = .TRACK,
		productId: String = "productId",
		referenceId: String? = nil,
		progressSource: Source? = nil,
		playLogSource: Source? = nil,
		extras: Extras? = nil
	) -> MediaProduct {
		MediaProduct(
			productType: productType,
			productId: productId,
			referenceId: referenceId,
			progressSource: progressSource,
			playLogSource: playLogSource,
			extras: extras
		)
	}
}
