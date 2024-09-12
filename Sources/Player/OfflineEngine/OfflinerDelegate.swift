import Foundation

public protocol OfflinerDelegate: AnyObject {
	func offliningStarted(for mediaProduct: MediaProduct)
	func offliningProgress(for mediaProduct: MediaProduct, is downloadPercentage: Double)
	func offliningCompleted(for mediaProduct: MediaProduct)
	func offliningFailed(for mediaProduct: MediaProduct)
	func offlinedDeleted(for mediaProduct: MediaProduct)
	func allOfflinedMediaProductsDeleted()
}
