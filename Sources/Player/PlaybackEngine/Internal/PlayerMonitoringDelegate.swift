import Foundation

// MARK: - PlayerMonitoringDelegate

public protocol PlayerMonitoringDelegate: AnyObject {
	func loaded(asset: Asset?, with duration: Double)
	func playing(asset: Asset?)
	func paused(asset: Asset?)
	func seeking(in asset: Asset?)
	func stall(in asset: Asset?)
	func waiting(for asset: Asset?)
	func downloaded(asset: Asset?)
	func completed(asset: Asset?)
	func failed(asset: Asset?, with error: Error)
	func playbackMetadataLoaded(asset: Asset?)
	func audioQualityChanged(asset: Asset?, to audioQuality: AudioQuality)
	func formatVariantChanged(asset: Asset?, variant: FormatVariantMetadata)
}

public extension PlayerMonitoringDelegate {
	func audioQualityChanged(asset: Asset?, to audioQuality: AudioQuality) {}
	func formatVariantChanged(asset: Asset?, variant: FormatVariantMetadata) {}
}

// MARK: - PlayerMonitoringDelegates

public final class PlayerMonitoringDelegates {
	private struct Observer {
		weak var delegate: PlayerMonitoringDelegate?
	}

	private var observers = [Observer]()
	private var delegates: [PlayerMonitoringDelegate] {
		observers.removeAll { $0.delegate == nil }
		return observers.compactMap { $0.delegate }
	}

	public init() {}

	public func removeAll() {
		observers.removeAll()
	}

	public func add(delegate: PlayerMonitoringDelegate?) {
		observers.append(Observer(delegate: delegate))
	}

	public func loaded(asset: Asset?, with duration: Double) {
		delegates.forEach {
			$0.loaded(asset: asset, with: duration)
		}
	}

	public func playing(asset: Asset?) {
		delegates.forEach {
			$0.playing(asset: asset)
		}
	}

	public func paused(asset: Asset?) {
		delegates.forEach { $0.paused(asset: asset) }
	}

	public func seeking(in asset: Asset?) {
		delegates.forEach { $0.seeking(in: asset) }
	}

	public func stall(in asset: Asset?) {
		delegates.forEach { $0.stall(in: asset) }
	}

	public func waiting(for asset: Asset?) {
		delegates.forEach { $0.waiting(for: asset) }
	}

	public func downloaded(asset: Asset?) {
		delegates.forEach { $0.downloaded(asset: asset) }
	}

	public func completed(asset: Asset?) {
		delegates.forEach { $0.completed(asset: asset) }
	}

	public func failed(asset: Asset?, with error: Error) {
		delegates.forEach { $0.failed(asset: asset, with: error) }
	}

	public func playbackMetadataLoaded(asset: Asset?) {
		delegates.forEach { $0.playbackMetadataLoaded(asset: asset) }
	}

	public func audioQualityChanged(asset: Asset?, to audioQuality: AudioQuality) {
		delegates.forEach { $0.audioQualityChanged(asset: asset, to: audioQuality) }
	}

	public func formatVariantChanged(asset: Asset?, variant: FormatVariantMetadata) {
		delegates.forEach { $0.formatVariantChanged(asset: asset, variant: variant) }
	}
}
