import Foundation
@testable import Player

// swiftformat:disable:next extensionAccessControl
extension StreamingLicenseLoader {
	override public func isEqual(_ object: Any?) -> Bool {
		guard let other = object as? StreamingLicenseLoader else {
			return false
		}
		return streamingSessionId == other.streamingSessionId
	}
}
