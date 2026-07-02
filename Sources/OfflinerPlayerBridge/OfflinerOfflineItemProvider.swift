import Foundation
import Offliner
import Player

// MARK: - OfflinerOfflineItemProvider

/// Bridges ``Offliner`` into `Player`'s offline playback lookup.
///
/// This lives in a separate module so that `Offliner` itself has no Player dependency: Player does not support
/// watchOS, while Offliner does. Platforms that play through Player wire this adapter up as the player's
/// `OfflineItemProvider`; watchOS consumers use Offliner directly.
public final class OfflinerOfflineItemProvider: OfflineItemProvider {
	private let offliner: Offliner

	public init(offliner: Offliner) {
		self.offliner = offliner
	}

	public func get(productType: ProductType, productId: String) async -> OfflinePlaybackItem? {
		let mediaType: OfflineMediaItemType
		switch productType {
		case .TRACK: mediaType = .tracks
		case .VIDEO: mediaType = .videos
		case .UC: return nil
		}

		do {
			return try await offliner.getOfflineMediaItem(mediaType: mediaType, resourceId: .identifier(productId))
				.map { OfflinePlaybackItem($0, productType: productType) }
		} catch {
			Task { try? await offliner.download(mediaType: mediaType, resourceId: .identifier(productId)) }
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
