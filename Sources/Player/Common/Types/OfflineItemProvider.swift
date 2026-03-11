import Foundation

public struct OfflinePlaybackItem {
	public let mediaURL: URL
	public let licenseURL: URL?
	public let format: String?
	public let albumReplayGain: Float?
	public let albumPeakAmplitude: Float?
	public let productType: ProductType

	public init(
		mediaURL: URL,
		licenseURL: URL?,
		format: String?,
		albumReplayGain: Float?,
		albumPeakAmplitude: Float?,
		productType: ProductType
	) {
		self.mediaURL = mediaURL
		self.licenseURL = licenseURL
		self.format = format
		self.albumReplayGain = albumReplayGain
		self.albumPeakAmplitude = albumPeakAmplitude
		self.productType = productType
	}
}

public protocol OfflineItemProvider {
	func get(productType: ProductType, productId: String) async throws -> OfflinePlaybackItem?
}
