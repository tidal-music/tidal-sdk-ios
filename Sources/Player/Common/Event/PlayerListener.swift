import Foundation

// MARK: - PlayerListener

public protocol PlayerListener: AnyObject {
	func stateChanged(to state: State)

	func ended(_ mediaProduct: MediaProduct)

	func mediaTransitioned(to mediaProduct: MediaProduct, with playbackContext: PlaybackContext)

	func streamingPrivilegesLost(to device: String?)

	func failed(with error: PlayerError)

	/// Called when the media services were reset. A chance for the client of the player to respond appropriately to
	/// mediaServicesWereResetNotification. More info about this issue:
	/// https://developer.apple.com/documentation/avfaudio/avaudiosession/1616540-mediaserviceswereresetnotificati
	/// - Important: This is a good time to set up the audio session again.
	func mediaServicesWereReset()
}

// MARK: - Optional methods

public extension PlayerListener {
	func streamingPrivilegesLost(to device: String?) {}
}
