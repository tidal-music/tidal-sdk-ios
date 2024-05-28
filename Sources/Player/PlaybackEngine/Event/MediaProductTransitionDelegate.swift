import Foundation

public protocol MediaProductTransitionDelegate: AnyObject {
	func mediaProductTransition(_ mediaProduct: MediaProduct, playbackContext: PlaybackContext)
}
