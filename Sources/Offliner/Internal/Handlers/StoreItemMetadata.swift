import Foundation
import TidalAPI

// MARK: - Metadata Conversion

extension OfflineMediaItem.Metadata {
	init(from task: StoreItemTask, duration: Int) {
		let artistNames = task.artists.compactMap(\.attributes?.name)
		switch task.itemMetadata {
		case .track(let track):
			self = .track(OfflineMediaItem.TrackMetadata(
				id: track.id,
				title: track.attributes?.title ?? "",
				artists: artistNames,
				duration: duration
			))
		case .video(let video):
			self = .video(OfflineMediaItem.VideoMetadata(
				id: video.id,
				title: video.attributes?.title ?? "",
				artists: artistNames,
				duration: duration
			))
		}
	}
}
