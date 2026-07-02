import Foundation
import Offliner
import Player

// MARK: - OfflineItemProvider

/// Bridges ``Offliner`` into `Player`'s offline playback lookup.
///
/// The conformance lives in a separate module so that `Offliner` itself has no Player dependency: Player does not
/// support watchOS, while Offliner does. Platforms that play through Player import this module and wire the offliner
/// up as the player's `OfflineItemProvider` directly; watchOS consumers use Offliner without it.
///
/// Declaring the conformance here is safe even though both types are imported: Offliner and Player belong to this
/// package, and this module is the only place the conformance is declared.
extension Offliner: @retroactive OfflineItemProvider {
	public func get(productType: ProductType, productId: String) async -> OfflinePlaybackItem? {
		let mediaType: OfflineMediaItemType
		switch productType {
		case .TRACK: mediaType = .tracks
		case .VIDEO: mediaType = .videos
		case .UC: return nil
		}

		do {
			return try await getOfflineMediaItem(mediaType: mediaType, resourceId: .identifier(productId))
				.map { OfflinePlaybackItem($0, productType: productType) }
		} catch {
			Task { try? await download(mediaType: mediaType, resourceId: .identifier(productId)) }
		}

		return nil
	}
}

// MARK: - OfflinePlaybackItem from OfflineMediaItem

private extension OfflinePlaybackItem {
	init(_ item: OfflineMediaItem, productType: ProductType) {
		self.init(
			mediaURL: item.mediaURL,
			licenseURL: item.licenseURL,
			format: item.playbackMetadata?.format.rawValue,
			albumReplayGain: item.playbackMetadata?.albumNormalizationData?.replayGain,
			albumPeakAmplitude: item.playbackMetadata?.albumNormalizationData?.peakAmplitude,
			productType: productType
		)
	}
}
