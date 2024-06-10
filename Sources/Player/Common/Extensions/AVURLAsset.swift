import Foundation
import MediaPlayer

extension AVURLAsset {
	var isPlayableOffline: Bool {
		assetCache?.isPlayableOffline ?? false
	}
}
