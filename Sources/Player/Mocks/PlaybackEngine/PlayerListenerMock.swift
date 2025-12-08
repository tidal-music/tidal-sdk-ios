import Foundation

public final class PlayerListenerMock: PlayerListener {
	var state: State?
	var numEnds: Int = 0
	var numTransitions: Int = 0
	var numQualityChanges: Int = 0
	var numPrivilegesLost: Int = 0
	var numErrors: Int = 0

	public func stateChanged(to state: State) {
		self.state = state
	}

	public func ended(_ mediaProduct: MediaProduct) {
		numEnds += 1
	}

	public func mediaTransitioned(to mediaProduct: MediaProduct, with playbackContext: PlaybackContext) {
		numTransitions += 1
	}

	public func playbackQualityChanged(to playbackContext: PlaybackContext) {
		numQualityChanges += 1
	}

	public func streamingPrivilegesLost(to device: String?) {
		numPrivilegesLost += 1
	}

	public func failed(with error: PlayerError) {
		numErrors += 1
	}

	public func mediaServicesWereReset() {}
}
