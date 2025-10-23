import Foundation

public final class OfflineEngineListenerMock: OfflineEngineListener {
	public var lastError: OfflineError?

	public func offliningStarted(for mediaProduct: MediaProduct) {}

	public func offliningProgressed(for mediaProduct: MediaProduct, is downloadPercentage: Double) {}

	public func offliningCompleted(for mediaProduct: MediaProduct) {}

	public func offliningFailed(for mediaProduct: MediaProduct, error: OfflineError) {
		lastError = error
	}

	public func offlinedDeleted(for mediaProduct: MediaProduct) {}

	public func allOfflinedMediaProductsDeleted() {}
}
