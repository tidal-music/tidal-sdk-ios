import Foundation
@testable import Player

extension DownloadEntry {
    static func mock(
        id: String = "test-download-id",
        productId: String = "test-product-id",
        productType: ProductType = .TRACK,
        state: DownloadState = .PENDING,
        progress: Double = 0.0,
        attemptCount: Int = 0,
        lastError: String? = nil,
        createdAt: UInt64 = 1000,
        partialMediaPath: String? = nil,
        partialLicensePath: String? = nil
    ) -> DownloadEntry {
        var entry = DownloadEntry(
            id: id,
            productId: productId,
            productType: productType,
            createdAt: createdAt
        )
        
        if state != .PENDING {
            entry.updateState(state)
        }
        
        if progress > 0 {
            entry.updateProgress(progress)
        }
        
        if attemptCount > 0 {
            for _ in 0..<attemptCount {
                entry.incrementAttemptCount()
            }
        }
        
        if let error = lastError {
            entry.lastError = error
        }
        
        entry.partialMediaPath = partialMediaPath
        entry.partialLicensePath = partialLicensePath
        
        return entry
    }
}
