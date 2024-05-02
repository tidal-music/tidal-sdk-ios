import Foundation

public protocol PlayerListener: AnyObject {
	func stateChanged(to state: State)

	func ended(_ mediaProduct: MediaProduct)

	func mediaTransitioned(to mediaProduct: MediaProduct, with playbackContext: PlaybackContext)

	func streamingPrivilegesLost(to device: String?)

	func failed(with error: PlayerError)

	func djSessionStarted(_ metadata: DJSessionMetadata)

	func djSessionEnded(with reason: DJSessionEndReason)

	func djSessionTransitioned(to transition: DJSessionTransition)
}

// Optional methods
public extension PlayerListener {
	func streamingPrivilegesLost(to device: String?) { }
	func djSessionStarted(_ metadata: DJSessionMetadata) { }
	func djSessionEnded(with reason: DJSessionEndReason) { }
	func djSessionTransitioned(to transition: DJSessionTransition) { }
}
