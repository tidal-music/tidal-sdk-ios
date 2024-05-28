import Foundation

public protocol LicenseLoader {
	func getLicense() async throws -> Data
}
