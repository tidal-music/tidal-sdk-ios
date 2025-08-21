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
        updatedAt: UInt64 = 1000,
        pausedAt: UInt64? = nil,
        backgroundTaskIdentifier: String? = nil,
        partialMediaPath: String? = nil,
        partialLicensePath: String? = nil
    ) -> DownloadEntry {
        var entry = DownloadEntry(
            id: id,
            productId: productId,
            productType: productType,
            createdAt: createdAt
        )
        
        entry.state = state
        entry.progress = progress
        entry.attemptCount = attemptCount
        entry.lastError = lastError
        entry.updatedAt = updatedAt
        entry.pausedAt = pausedAt
        entry.backgroundTaskIdentifier = backgroundTaskIdentifier
        entry.partialMediaPath = partialMediaPath
        entry.partialLicensePath = partialLicensePath
        
        return entry
    }
}