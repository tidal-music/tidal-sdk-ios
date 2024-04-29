import Foundation

public protocol OfflinerDelegate: AnyObject {
	func offlineStarted(for mediaProduct: MediaProduct)
	func offlineProgress(for mediaProduct: MediaProduct, is downloadPercentage: Double)
	func offlineDone(for mediaProduct: MediaProduct)
	func offlineFailed(for mediaProduct: MediaProduct)
	func offlineDeleted(for mediaProduct: MediaProduct)
	func allOfflinesDeleted()
}
