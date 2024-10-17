import Foundation

public final class OfflineEngineListenerMock: OfflineEngineListener {
	public func offliningStarted(for mediaProduct: MediaProduct) {}

	public func offliningProgress(for mediaProduct: MediaProduct, is downloadPercentage: Double) {}

	public func offliningCompleted(for mediaProduct: MediaProduct) {}

	public func offliningFailed(for mediaProduct: MediaProduct) {}

	public func offlinedDeleted(for mediaProduct: MediaProduct) {}

	public func allOfflinedMediaProductsDeleted() {}
}
