import Foundation
import GRDB
import XCTest
@testable import Player

final class DownloadEntryGRDBStorageTests: XCTestCase {
    private var dbQueue: DatabaseQueue!
    private var offlineStorage: GRDBOfflineStorage!

    override func setUpWithError() throws {
        // Create an in-memory database for testing
        dbQueue = try DatabaseQueue()
        try GRDBOfflineStorage.initializeDatabase(dbQueue: dbQueue)
        offlineStorage = GRDBOfflineStorage(dbQueue: dbQueue)
    }

    override func tearDownWithError() throws {
        dbQueue = nil
        offlineStorage = nil
    }
    
    // MARK: - Save and Retrieve Tests

    func testSaveDownloadEntry() throws {
        // Arrange
        let entry = DownloadEntry.mock(
            id: "test-id",
            productId: "test-product-id",
            state: .PENDING,
            progress: 0.5
        )
        
        // Act
        try offlineStorage.saveDownloadEntry(entry)
        
        // Assert
        let savedEntry = try offlineStorage.getDownloadEntry(id: "test-id")
        XCTAssertNotNil(savedEntry, "Saved entry should be retrievable")
        XCTAssertEqual(savedEntry?.id, "test-id")
        XCTAssertEqual(savedEntry?.productId, "test-product-id")
        XCTAssertEqual(savedEntry?.state, .PENDING)
        XCTAssertEqual(savedEntry?.progress, 0.5)
    }
    
    func testUpdateDownloadEntry() throws {
        // Arrange
        var entry = DownloadEntry.mock(
            id: "test-id",
            productId: "test-product-id",
            state: .PENDING,
            progress: 0.0
        )
        try offlineStorage.saveDownloadEntry(entry)
        
        // Act - update the entry
        entry.updateState(.IN_PROGRESS)
        entry.updateProgress(0.75)
        try offlineStorage.updateDownloadEntry(entry)
        
        // Assert
        let updatedEntry = try offlineStorage.getDownloadEntry(id: "test-id")
        XCTAssertEqual(updatedEntry?.state, .IN_PROGRESS)
        XCTAssertEqual(updatedEntry?.progress, 0.75)
    }

    func testGetDownloadEntryByProductId() throws {
        // Arrange
        let entry = DownloadEntry.mock(
            id: "test-id",
            productId: "test-product-id",
            state: .IN_PROGRESS
        )
        try offlineStorage.saveDownloadEntry(entry)
        
        // Act
        let retrievedEntry = try offlineStorage.getDownloadEntryByProductId(productId: "test-product-id")
        
        // Assert
        XCTAssertNotNil(retrievedEntry)
        XCTAssertEqual(retrievedEntry?.id, "test-id")
    }
    
    func testDeleteDownloadEntry() throws {
        // Arrange
        let entry = DownloadEntry.mock(id: "test-id")
        try offlineStorage.saveDownloadEntry(entry)
        
        // Act
        try offlineStorage.deleteDownloadEntry(id: "test-id")
        
        // Assert
        let deletedEntry = try offlineStorage.getDownloadEntry(id: "test-id")
        XCTAssertNil(deletedEntry, "Entry should be deleted")
    }
    
    // MARK: - Collection Tests
    
    func testGetAllDownloadEntries() throws {
        // Arrange
        let entry1 = DownloadEntry.mock(
            id: "test-id-1",
            productId: "product-1",
            state: .PENDING,
            updatedAt: 1000
        )
        
        let entry2 = DownloadEntry.mock(
            id: "test-id-2",
            productId: "product-2",
            state: .IN_PROGRESS,
            updatedAt: 2000
        )
        
        try offlineStorage.saveDownloadEntry(entry1)
        try offlineStorage.saveDownloadEntry(entry2)
        
        // Act
        let allEntries = try offlineStorage.getAllDownloadEntries()
        
        // Assert
        XCTAssertEqual(allEntries.count, 2)
        
        // Should be sorted by updatedAt desc
        XCTAssertEqual(allEntries[0].id, "test-id-2")
        XCTAssertEqual(allEntries[1].id, "test-id-1")
    }
    
    func testGetDownloadEntriesByState() throws {
        // Arrange
        let pendingEntry1 = DownloadEntry.mock(id: "pending-1", state: .PENDING)
        let pendingEntry2 = DownloadEntry.mock(id: "pending-2", state: .PENDING)
        let inProgressEntry = DownloadEntry.mock(id: "progress-1", state: .IN_PROGRESS)
        let failedEntry = DownloadEntry.mock(id: "failed-1", state: .FAILED)
        
        try offlineStorage.saveDownloadEntry(pendingEntry1)
        try offlineStorage.saveDownloadEntry(pendingEntry2)
        try offlineStorage.saveDownloadEntry(inProgressEntry)
        try offlineStorage.saveDownloadEntry(failedEntry)
        
        // Act
        let pendingEntries = try offlineStorage.getDownloadEntriesByState(state: .PENDING)
        let inProgressEntries = try offlineStorage.getDownloadEntriesByState(state: .IN_PROGRESS)
        let completedEntries = try offlineStorage.getDownloadEntriesByState(state: .COMPLETED)
        
        // Assert
        XCTAssertEqual(pendingEntries.count, 2)
        XCTAssertEqual(inProgressEntries.count, 1)
        XCTAssertEqual(completedEntries.count, 0)
    }
    
    // MARK: - Cleanup Test
    
    func testCleanupStaleDownloadEntries() throws {
        // Arrange - create entries with different states
        let currentTimestamp: UInt64 = 100000
        PlayerWorld = PlayerWorldClient.mock(
            timeProvider: TimeProviderMock(timestamp: currentTimestamp)
        )
        
        // This one should be cleaned up (failed + old)
        let staleEntry = DownloadEntry.mock(
            id: "stale-id",
            state: .FAILED,
            updatedAt: currentTimestamp - 100000 // Old timestamp
        )
        
        // This should remain (failed but recent)
        let recentFailedEntry = DownloadEntry.mock(
            id: "recent-failed-id", 
            state: .FAILED,
            updatedAt: currentTimestamp - 1000 // Recent timestamp
        )
        
        // This should remain (old but not failed)
        let oldActiveEntry = DownloadEntry.mock(
            id: "old-active-id",
            state: .IN_PROGRESS,
            updatedAt: currentTimestamp - 100000 // Old timestamp
        )
        
        try offlineStorage.saveDownloadEntry(staleEntry)
        try offlineStorage.saveDownloadEntry(recentFailedEntry)
        try offlineStorage.saveDownloadEntry(oldActiveEntry)
        
        // Act
        try offlineStorage.cleanupStaleDownloadEntries(threshold: 50.0) // 50 seconds threshold
        
        // Assert
        let remainingEntries = try offlineStorage.getAllDownloadEntries()
        
        XCTAssertEqual(remainingEntries.count, 2)
        
        // The stale entry should be gone
        let staleEntryResult = try offlineStorage.getDownloadEntry(id: "stale-id")
        XCTAssertNil(staleEntryResult)
        
        // The others should still be there
        let recentFailedResult = try offlineStorage.getDownloadEntry(id: "recent-failed-id")
        let oldActiveResult = try offlineStorage.getDownloadEntry(id: "old-active-id")
        
        XCTAssertNotNil(recentFailedResult)
        XCTAssertNotNil(oldActiveResult)
        
        // Reset PlayerWorld
        PlayerWorld = PlayerWorldClient.live
    }
}