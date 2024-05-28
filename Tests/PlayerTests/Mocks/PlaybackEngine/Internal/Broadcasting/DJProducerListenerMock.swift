@testable import Player

final class DJProducerListenerMock: DJProducerListener {
	private(set) var djSessionStartedMetadatas = [DJSessionMetadata]()
	private(set) var djSessionEndReasons = [DJSessionEndReason]()

	func djSessionStarted(metadata: DJSessionMetadata) {
		djSessionStartedMetadatas.append(metadata)
	}

	func djSessionEnded(reason: DJSessionEndReason) {
		djSessionEndReasons.append(reason)
	}
}
