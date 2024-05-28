import Foundation

public protocol PlaybackStateChangeDelegate: AnyObject {
	func playbackStateChange(state: State)
}
