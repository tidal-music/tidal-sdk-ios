import XCTest
@testable import Player

final class DownloadStateManagerTests: XCTestCase {
    var downloadStateManager: DownloadStateManagerMock!
    
    override func setUp() {
        super.setUp()
        downloadStateManager = DownloadStateManagerMock()
    }
    
    override func tearDown() {
        downloadStateManager = nil
        super.tearDown()
    }
    
    func testCreateDownload() throws {
        // Set up a mock download entry
        let mockEntry = DownloadEntry.mock(
            id: "test-123",
            productId: "product-123",
            productType: .TRACK
        )
        downloadStateManager.mockDownloadsByProductId["product-123"] = mockEntry
        
        // Create a download
        let entry = try downloadStateManager.createDownload(
            productId: "product-123",
            productType: .TRACK
        )
        
        // Verify download was created
        XCTAssertEqual(downloadStateManager.createdDownloads.count, 1)
        XCTAssertEqual(entry.id, "test-123")
        XCTAssertEqual(entry.productId, "product-123")
        XCTAssertEqual(entry.productType, .TRACK)
        XCTAssertEqual(entry.state, .PENDING)
    }
    
    func testUpdateDownloadState() throws {
        // Set up a mock download entry
        let mockEntry = DownloadEntry.mock(
            id: "test-123",
            productId: "product-123",
            productType: .TRACK
        )
        downloadStateManager.mockDownloads["test-123"] = mockEntry
        
        // Update state
        let updatedEntry = try downloadStateManager.updateDownloadState(
            id: "test-123", 
            state: .IN_PROGRESS
        )
        
        // Verify state was updated
        XCTAssertNotNil(updatedEntry)
        XCTAssertEqual(updatedEntry?.state, .IN_PROGRESS)
        XCTAssertEqual(downloadStateManager.updatedDownloadStates.count, 1)
        XCTAssertEqual(downloadStateManager.updatedDownloadStates[0].id, "test-123")
        XCTAssertEqual(downloadStateManager.updatedDownloadStates[0].state, .IN_PROGRESS)
    }
    
    func testUpdateDownloadProgress() throws {
        // Set up a mock download entry
        let mockEntry = DownloadEntry.mock(
            id: "test-123",
            productId: "product-123",
            productType: .TRACK
        )
        downloadStateManager.mockDownloads["test-123"] = mockEntry
        
        // Update progress
        let updatedEntry = try downloadStateManager.updateDownloadProgress(
            id: "test-123", 
            progress: 0.5
        )
        
        // Verify progress was updated
        XCTAssertNotNil(updatedEntry)
        XCTAssertEqual(updatedEntry?.progress, 0.5)
        XCTAssertEqual(downloadStateManager.updatedDownloadProgresses.count, 1)
        XCTAssertEqual(downloadStateManager.updatedDownloadProgresses[0].id, "test-123")
        XCTAssertEqual(downloadStateManager.updatedDownloadProgresses[0].progress, 0.5)
    }
    
    func testRecordDownloadError() throws {
        // Set up a mock download entry
        let mockEntry = DownloadEntry.mock(
            id: "test-123",
            productId: "product-123",
            productType: .TRACK
        )
        downloadStateManager.mockDownloads["test-123"] = mockEntry
        
        // Record error
        let error = NSError(domain: "test", code: 123, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        let updatedEntry = try downloadStateManager.recordDownloadError(
            id: "test-123", 
            error: error
        )
        
        // Verify error was recorded
        XCTAssertNotNil(updatedEntry)
        XCTAssertEqual(updatedEntry?.state, .FAILED)
        XCTAssertEqual(downloadStateManager.recordedErrors.count, 1)
        XCTAssertEqual(downloadStateManager.recordedErrors[0].id, "test-123")
        XCTAssertEqual(downloadStateManager.recordedErrors[0].error.localizedDescription, "Test error")
    }
    
    func testCleanupStaleDownloads() throws {
        // Set up expected deleted count
        downloadStateManager.mockDeletedCount = 5
        
        // Call cleanup
        let deletedCount = try downloadStateManager.cleanupStaleDownloads(threshold: 3 * 24 * 60 * 60)
        
        // Verify cleanup was called
        XCTAssertEqual(downloadStateManager.clearedStaleDownloads, true)
        XCTAssertEqual(deletedCount, 5)
        XCTAssertEqual(downloadStateManager.cleanupStaleDownloadsCall?.threshold, 3 * 24 * 60 * 60)
    }
}