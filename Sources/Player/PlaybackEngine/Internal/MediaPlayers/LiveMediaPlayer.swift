import Foundation

protocol LiveMediaPlayer: AnyObject {
	func loadLive(
		_ url: URL,
		with licenseLoader: LicenseLoader?
	) async -> Asset
}
