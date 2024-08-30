import Foundation

/// This class only exists to avoid that interruptions that Player plays are not logged.
/// Interruptions must be considered a hack, and this is how hacks behave, they spread
/// and grow. Ideally this class should not exist.
public final class Interruption: MediaProduct {
	public init(productType: ProductType, productId: String) {
		super.init(
			productType: productType,
			productId: productId,
			referenceId: nil,
			progressSource: nil,
			playLogSource: nil,
			extras: nil
		)
	}

	required init(from decoder: Decoder) throws {
		try super.init(from: decoder)
	}
}
