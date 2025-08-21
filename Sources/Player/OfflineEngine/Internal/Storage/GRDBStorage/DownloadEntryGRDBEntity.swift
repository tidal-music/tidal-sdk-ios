import Foundation
import GRDB

// MARK: - DownloadEntryGRDBEntity

struct DownloadEntryGRDBEntity: Codable, FetchableRecord, PersistableRecord {
    let id: String
    let productId: String
    let productType: String
    let state: String
    let progress: Double
    let attemptCount: Int
    let lastError: String?
    let createdAt: UInt64
    let updatedAt: UInt64
    let pausedAt: UInt64?
    let backgroundTaskIdentifier: String?
    let partialMediaPathBookmark: Data?
    let partialLicensePathBookmark: Data?
    
    static let databaseTableName = "downloadEntries"
    
    enum Columns {
        static let id = Column(CodingKeys.id)
        static let productId = Column(CodingKeys.productId)
        static let state = Column(CodingKeys.state)
        static let updatedAt = Column(CodingKeys.updatedAt)
    }
    
    var downloadEntry: DownloadEntry {
        var entry = DownloadEntry(
            id: id,
            productId: productId,
            productType: productTypeFromString(productType),
            createdAt: createdAt
        )
        
        // Set values that aren't part of the constructor
        entry.state = DownloadState(rawValue: state) ?? .PENDING
        entry.progress = progress
        entry.attemptCount = attemptCount
        entry.lastError = lastError
        entry.updatedAt = updatedAt
        entry.pausedAt = pausedAt
        entry.backgroundTaskIdentifier = backgroundTaskIdentifier
        entry.partialMediaPath = resolveBookmark(partialMediaPathBookmark)
        entry.partialLicensePath = resolveBookmark(partialLicensePathBookmark)
        
        return entry
    }
    
    init(from entry: DownloadEntry) {
        id = entry.id
        productId = entry.productId
        productType = entry.productType.rawValue
        state = entry.state.rawValue
        progress = entry.progress
        attemptCount = entry.attemptCount
        lastError = entry.lastError
        createdAt = entry.createdAt
        updatedAt = entry.updatedAt
        pausedAt = entry.pausedAt
        backgroundTaskIdentifier = entry.backgroundTaskIdentifier
        
        // Initialize these separately since they require method calls
        if let mediaPath = entry.partialMediaPath {
            partialMediaPathBookmark = URL(fileURLWithPath: mediaPath).bookmarkDataOrNil
        } else {
            partialMediaPathBookmark = nil
        }
        
        if let licensePath = entry.partialLicensePath {
            partialLicensePathBookmark = URL(fileURLWithPath: licensePath).bookmarkDataOrNil
        } else {
            partialLicensePathBookmark = nil
        }
    }
    
    private func resolveBookmark(_ bookmark: Data?) -> String? {
        guard let bookmark = bookmark else {
            return nil
        }
        
        var isStale = false
        guard
            let url = try? URL(resolvingBookmarkData: bookmark, bookmarkDataIsStale: &isStale),
            !isStale
        else {
            return nil
        }
        
        return url.path
    }
    
    private func createBookmark(from path: String?) -> Data? {
        guard let path = path else {
            return nil
        }
        
        let url = URL(fileURLWithPath: path)
        return try? url.bookmarkData()
    }
    
    private func productTypeFromString(_ typeString: String) -> ProductType {
        switch typeString {
        case "TRACK": return .TRACK
        case "VIDEO": return .VIDEO
        case "BROADCAST": return .BROADCAST
        default: return .TRACK // Default to TRACK for safety
        }
    }
}

// MARK: - URL Extension for Bookmark Safety

private extension URL {
    var bookmarkDataOrNil: Data? {
        try? bookmarkData()
    }
}