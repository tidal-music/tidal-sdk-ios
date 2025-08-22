import XCTest
@testable import Player

final class DefaultDownloadStateManagerMetricsTests: XCTestCase {
    var offlineStorage: OfflineStorageMock!
    var stateManager: DefaultDownloadStateManager!
    var mockTimeProvider: TimeProviderMock = TimeProviderMock()
    
    override func setUp() {
        super.setUp()
        PlayerWorld.timeProvider = TimeProvider(
            timestamp: { self.mockTimeProvider.mockTimestamp },
            date: { self.mockTimeProvider.mockDate }
        )
        
        offlineStorage = OfflineStorageMock()
        stateManager = DefaultDownloadStateManager(offlineStorage: offlineStorage)
    }
    
    override func tearDown() {
        offlineStorage = nil
        stateManager = nil
        PlayerWorld.timeProvider = TimeProvider.live
        super.tearDown()
    }
    
    func testGetDownloadSummary() throws {
        // Given
        let pendingDownload = DownloadEntry.mock(id: "pending", productId: "track1", state: .PENDING)
        let inProgressDownload = DownloadEntry.mock(id: "progress", productId: "track2", state: .IN_PROGRESS, progress: 0.5)
        let completedDownload = DownloadEntry.mock(id: "completed", productId: "track3", state: .COMPLETED)
        
        offlineStorage.mockAllDownloadEntries = [pendingDownload, inProgressDownload, completedDownload]
        
        // When
        let summary = try stateManager.getDownloadSummary()
        
        // Then
        XCTAssertEqual(summary.totalDownloads, 3)
        XCTAssertEqual(summary.pendingDownloads, 1)
        XCTAssertEqual(summary.inProgressDownloads, 1)
        XCTAssertEqual(summary.completedDownloads, 1)
        XCTAssertEqual(summary.averageProgress, 0.5)
    }
    
    func testGetDownloadMetrics() throws {
        // Given
        // Current time as timestamp in milliseconds
        let now = 1000000000000
        mockTimeProvider.mockTimestamp = UInt64(now)
        
        // One day in milliseconds
        let dayInMs: UInt64 = 24 * 60 * 60 * 1000
        
        // Create entries with different timestamps and states
        // Within the 7-day window
        var completedEntry1 = DownloadEntry.mock(
            id: "completed1", 
            productId: "track1", 
            createdAt: UInt64(now) - (3 * dayInMs)  // 3 days ago
        )
        completedEntry1.updateState(.COMPLETED)
        // Manually set updatedAt for test
        completedEntry1.updatedAt = UInt64(now) - (2 * dayInMs)  // 2 days ago (completed after 1 day)
        
        var completedEntry2 = DownloadEntry.mock(
            id: "completed2", 
            productId: "track2", 
            createdAt: UInt64(now) - (6 * dayInMs)  // 6 days ago
        )
        completedEntry2.updateState(.COMPLETED)
        // Manually set updatedAt for test
        completedEntry2.updatedAt = UInt64(now) - (5 * dayInMs)  // 5 days ago (completed after 1 day)
        
        let failedEntry = DownloadEntry.mock(
            id: "failed1", 
            productId: "track3", 
            state: .FAILED, 
            createdAt: UInt64(now) - (2 * dayInMs)  // 2 days ago
        )
        
        let cancelledEntry = DownloadEntry.mock(
            id: "cancelled1", 
            productId: "track4", 
            state: .CANCELLED, 
            createdAt: UInt64(now) - dayInMs  // 1 day ago
        )
        
        // Outside the 7-day window (10 days ago)
        let oldEntry = DownloadEntry.mock(
            id: "old1", 
            productId: "track5", 
            state: .COMPLETED, 
            createdAt: UInt64(now) - (10 * dayInMs)  // 10 days ago
        )
        
        offlineStorage.mockAllDownloadEntries = [
            completedEntry1, completedEntry2, failedEntry, cancelledEntry, oldEntry
        ]
        
        // When
        let metrics = try stateManager.getDownloadMetrics(days: 7)
        
        // Then
        XCTAssertEqual(metrics.periodDays, 7)
        XCTAssertEqual(metrics.totalDownloads, 4) // excludes oldEntry
        XCTAssertEqual(metrics.successfulDownloads, 2)
        XCTAssertEqual(metrics.failedDownloads, 1)
        XCTAssertEqual(metrics.cancelledDownloads, 1)
        
        // Average completion time = (1 day + 1 day) / 2 = 1 day = 86400 seconds
        XCTAssertEqual(metrics.averageCompletionTimeSeconds, 86400.0, accuracy: 0.1)
    }
    
    func testGetDownloadMetricsWithNoDownloads() throws {
        // Given
        offlineStorage.mockAllDownloadEntries = []
        
        // When
        let metrics = try stateManager.getDownloadMetrics(days: 30)
        
        // Then
        XCTAssertEqual(metrics.periodDays, 30)
        XCTAssertEqual(metrics.totalDownloads, 0)
        XCTAssertEqual(metrics.successfulDownloads, 0)
        XCTAssertEqual(metrics.failedDownloads, 0)
        XCTAssertEqual(metrics.cancelledDownloads, 0)
        XCTAssertEqual(metrics.averageCompletionTimeSeconds, 0)
        XCTAssertEqual(metrics.successRate, 0)
    }
    
    func testGetDownloadMetricsWithNoCompletedDownloads() throws {
        // Given
        let now = 1000000000000
        mockTimeProvider.mockTimestamp = UInt64(now)
        
        let dayInMs: UInt64 = 24 * 60 * 60 * 1000
        
        let pendingEntry = DownloadEntry.mock(
            id: "pending1", 
            productId: "track1", 
            state: .PENDING, 
            createdAt: UInt64(now) - dayInMs
        )
        
        let failedEntry = DownloadEntry.mock(
            id: "failed1", 
            productId: "track2", 
            state: .FAILED, 
            createdAt: UInt64(now) - (2 * dayInMs)
        )
        
        offlineStorage.mockAllDownloadEntries = [pendingEntry, failedEntry]
        
        // When
        let metrics = try stateManager.getDownloadMetrics(days: 7)
        
        // Then
        XCTAssertEqual(metrics.periodDays, 7)
        XCTAssertEqual(metrics.totalDownloads, 2)
        XCTAssertEqual(metrics.successfulDownloads, 0)
        XCTAssertEqual(metrics.failedDownloads, 1)
        XCTAssertEqual(metrics.averageCompletionTimeSeconds, 0)
    }
    
    func testGetDownloadMetricsThrowsErrorFromStorage() {
        // Given
        let expectedError = NSError(domain: "test", code: 123)
        offlineStorage.errorToThrow = expectedError
        
        // When & Then
        XCTAssertThrowsError(try stateManager.getDownloadMetrics(days: 7)) { error in
            XCTAssertEqual((error as NSError).domain, expectedError.domain)
            XCTAssertEqual((error as NSError).code, expectedError.code)
        }
    }
    
    func testGetDownloadSummaryThrowsErrorFromStorage() {
        // Given
        let expectedError = NSError(domain: "test", code: 123)
        offlineStorage.errorToThrow = expectedError
        
        // When & Then
        XCTAssertThrowsError(try stateManager.getDownloadSummary()) { error in
            XCTAssertEqual((error as NSError).domain, expectedError.domain)
            XCTAssertEqual((error as NSError).code, expectedError.code)
        }
    }
}