import Foundation

public protocol OfflineEngineListener: AnyObject {
	func offliningStarted(for mediaProduct: MediaProduct)
	func offliningProgressed(for mediaProduct: MediaProduct, is downloadPercentage: Double)
	func offliningCompleted(for mediaProduct: MediaProduct)
	func offliningFailed(for mediaProduct: MediaProduct)
	func offlinedDeleted(for mediaProduct: MediaProduct)
	func allOfflinedMediaProductsDeleted()
}
