import Foundation

public struct OfflinePlaybackItem {
	public let mediaURL: URL
	public let licenseURL: URL?
	public let format: String?
	public let albumReplayGain: Float?
	public let albumPeakAmplitude: Float?

	public init(
		mediaURL: URL,
		licenseURL: URL?,
		format: String?,
		albumReplayGain: Float?,
		albumPeakAmplitude: Float?
	) {
		self.mediaURL = mediaURL
		self.licenseURL = licenseURL
		self.format = format
		self.albumReplayGain = albumReplayGain
		self.albumPeakAmplitude = albumPeakAmplitude
	}
}

public protocol OfflineItemProvider {
	func get(productType: ProductType, productId: String) throws -> OfflinePlaybackItem?
}
