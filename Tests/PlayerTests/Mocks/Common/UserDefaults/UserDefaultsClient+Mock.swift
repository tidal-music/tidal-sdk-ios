import Foundation
@testable import Player

extension UserDefaultsClient {
	static func mock() -> Self {
		Self(
			dataForKey: { _ in
				Data(count: 1)
			},
			setDataForKey: { _, _ in },
			removeObjectForKey: { _ in }
		)
	}
}
