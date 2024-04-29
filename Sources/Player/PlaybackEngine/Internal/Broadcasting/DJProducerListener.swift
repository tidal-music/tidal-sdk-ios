import Foundation

protocol DJProducerListener: AnyObject {
	func djSessionStarted(metadata: DJSessionMetadata)
	func djSessionEnded(reason: DJSessionEndReason)
}
