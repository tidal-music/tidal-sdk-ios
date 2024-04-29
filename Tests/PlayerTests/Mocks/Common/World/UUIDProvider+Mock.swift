@testable import Player

extension UUIDProvider {
	static let mock: Self = UUIDProvider(
		uuidString: { "uuid" }
	)
}
