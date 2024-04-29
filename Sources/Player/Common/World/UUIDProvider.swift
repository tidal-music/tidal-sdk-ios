import Foundation

// MARK: - UUIDProvider

struct UUIDProvider {
	var uuidString: () -> String
}

extension UUIDProvider {
	public static let live = UUIDProvider(
		uuidString: { UUID().uuidString }
	)
}
