import XCTest
@testable import Player

final class DefaultDownloadStateManagerTests: XCTestCase {
    var offlineStorage: OfflineStorageMock!
    var downloadStateManager: DefaultDownloadStateManager!
    
    override func setUp() {
        super.setUp()
        offlineStorage = OfflineStorageMock()
        downloadStateManager = DefaultDownloadStateManager(offlineStorage: offlineStorage)
    }
    
    override func tearDown() {
        offlineStorage = nil
        downloadStateManager = nil
        super.tearDown()
    }
    
    // MARK: - Create Download Tests
    
    func testCreateDownload_whenNoExistingDownload_shouldCreateNewOne() throws {
        // Act
        let download = try downloadStateManager.createDownload(
            productId: "track-123",
            productType: .TRACK
        )
        
        // Assert
        XCTAssertEqual(download.productId, "track-123")
        XCTAssertEqual(download.productType, .TRACK)
        XCTAssertEqual(download.state, .PENDING)
        XCTAssertEqual(download.progress, 0.0)
        
        // Verify it was saved to storage
        XCTAssertEqual(offlineStorage.savedDownloadEntries.count, 1)
        XCTAssertEqual(offlineStorage.savedDownloadEntries[0].productId, "track-123")
    }
    
    func testCreateDownload_whenExistingFailedDownload_shouldResetDownload() throws {
        // Arrange
        let existingDownload = DownloadEntry.mock(
            id: "existing-id",
            productId: "track-123",
            productType: .TRACK,
            state: .FAILED,
            progress: 0.5,
            attemptCount: 3
        )
        
        offlineStorage.mockDownloadEntriesByProductId = ["track-123": existingDownload]
        
        // Act
        let download = try downloadStateManager.createDownload(
            productId: "track-123",
            productType: .TRACK
        )
        
        // Assert
        XCTAssertEqual(download.id, "existing-id")
        XCTAssertEqual(download.productId, "track-123")
        XCTAssertEqual(download.state, .PENDING) // Should be reset to PENDING
        XCTAssertEqual(download.progress, 0.0) // Progress should be reset
        
        // Verify it was updated in storage
        XCTAssertEqual(offlineStorage.updatedDownloadEntries.count, 1)
        XCTAssertEqual(offlineStorage.updatedDownloadEntries[0].id, "existing-id")
        XCTAssertEqual(offlineStorage.updatedDownloadEntries[0].state, .PENDING)
    }
    
    func testCreateDownload_whenExistingActiveDownload_shouldReturnExistingDownload() throws {
        // Arrange
        let existingDownload = DownloadEntry.mock(
            id: "existing-id",
            productId: "track-123",
            productType: .TRACK,
            state: .IN_PROGRESS,
            progress: 0.5
        )
        
        offlineStorage.mockDownloadEntriesByProductId = ["track-123": existingDownload]
        
        // Act
        let download = try downloadStateManager.createDownload(
            productId: "track-123",
            productType: .TRACK
        )
        
        // Assert
        XCTAssertEqual(download.id, "existing-id")
        XCTAssertEqual(download.state, .IN_PROGRESS) // Should remain unchanged
        XCTAssertEqual(download.progress, 0.5) // Should remain unchanged
        
        // Verify no updates were made
        XCTAssertEqual(offlineStorage.updatedDownloadEntries.count, 0)
        XCTAssertEqual(offlineStorage.savedDownloadEntries.count, 0)
    }
    
    // MARK: - Update State Tests
    
    func testUpdateDownloadState_whenDownloadExists_shouldUpdateState() throws {
        // Arrange
        let existingDownload = DownloadEntry.mock(
            id: "download-123",
            productId: "track-123",
            state: .PENDING
        )
        
        offlineStorage.mockDownloadEntries = ["download-123": existingDownload]
        
        // Act
        let updatedDownload = try downloadStateManager.updateDownloadState(
            id: "download-123",
            state: .IN_PROGRESS
        )
        
        // Assert
        XCTAssertNotNil(updatedDownload)
        XCTAssertEqual(updatedDownload?.state, .IN_PROGRESS)
        
        // Verify it was updated in storage
        XCTAssertEqual(offlineStorage.updatedDownloadEntries.count, 1)
        XCTAssertEqual(offlineStorage.updatedDownloadEntries[0].id, "download-123")
        XCTAssertEqual(offlineStorage.updatedDownloadEntries[0].state, .IN_PROGRESS)
    }
    
    func testUpdateDownloadState_whenDownloadDoesNotExist_shouldReturnNil() throws {
        // Act
        let updatedDownload = try downloadStateManager.updateDownloadState(
            id: "non-existent-id",
            state: .IN_PROGRESS
        )
        
        // Assert
        XCTAssertNil(updatedDownload)
        XCTAssertEqual(offlineStorage.updatedDownloadEntries.count, 0)
    }
    
    // MARK: - Update Progress Tests
    
    func testUpdateDownloadProgress_whenDownloadExists_shouldUpdateProgress() throws {
        // Arrange
        let existingDownload = DownloadEntry.mock(
            id: "download-123",
            productId: "track-123",
            state: .IN_PROGRESS,
            progress: 0.3
        )
        
        offlineStorage.mockDownloadEntries = ["download-123": existingDownload]
        
        // Act
        let updatedDownload = try downloadStateManager.updateDownloadProgress(
            id: "download-123",
            progress: 0.5
        )
        
        // Assert
        XCTAssertNotNil(updatedDownload)
        XCTAssertEqual(updatedDownload?.progress, 0.5)
        
        // Verify it was updated in storage
        XCTAssertEqual(offlineStorage.updatedDownloadEntries.count, 1)
        XCTAssertEqual(offlineStorage.updatedDownloadEntries[0].id, "download-123")
        XCTAssertEqual(offlineStorage.updatedDownloadEntries[0].progress, 0.5)
    }
    
    // MARK: - Record Error Tests
    
    func testRecordDownloadError_whenDownloadExists_shouldUpdateErrorAndState() throws {
        // Arrange
        let existingDownload = DownloadEntry.mock(
            id: "download-123",
            productId: "track-123",
            state: .IN_PROGRESS
        )
        
        offlineStorage.mockDownloadEntries = ["download-123": existingDownload]
        
        let testError = NSError(domain: "test", code: 123, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        
        // Act
        let updatedDownload = try downloadStateManager.recordDownloadError(
            id: "download-123",
            error: testError
        )
        
        // Assert
        XCTAssertNotNil(updatedDownload)
        XCTAssertEqual(updatedDownload?.state, .FAILED)
        XCTAssertEqual(updatedDownload?.lastError, "Test error")
        
        // Verify it was updated in storage
        XCTAssertEqual(offlineStorage.updatedDownloadEntries.count, 1)
        XCTAssertEqual(offlineStorage.updatedDownloadEntries[0].id, "download-123")
        XCTAssertEqual(offlineStorage.updatedDownloadEntries[0].state, .FAILED)
        XCTAssertEqual(offlineStorage.updatedDownloadEntries[0].lastError, "Test error")
    }
    
    // MARK: - Delete Download Tests
    
    func testDeleteDownload_shouldCallStorageDelete() throws {
        // Act
        try downloadStateManager.deleteDownload(id: "download-123")
        
        // Assert
        XCTAssertEqual(offlineStorage.deletedDownloadIds.count, 1)
        XCTAssertEqual(offlineStorage.deletedDownloadIds[0], "download-123")
    }
    
    // MARK: - Get Downloads Tests
    
    func testGetAllDownloads_shouldReturnStorageValues() throws {
        // Arrange
        let download1 = DownloadEntry.mock(id: "1", state: .PENDING)
        let download2 = DownloadEntry.mock(id: "2", state: .IN_PROGRESS)
        
        offlineStorage.mockAllDownloadEntries = [download1, download2]
        
        // Act
        let downloads = try downloadStateManager.getAllDownloads()
        
        // Assert
        XCTAssertEqual(downloads.count, 2)
        XCTAssertEqual(downloads[0].id, "1")
        XCTAssertEqual(downloads[1].id, "2")
    }
    
    func testGetDownloadsByState_shouldReturnFilteredDownloads() throws {
        // Arrange
        let download1 = DownloadEntry.mock(id: "1", state: .PENDING)
        let download2 = DownloadEntry.mock(id: "2", state: .PENDING)
        
        offlineStorage.mockDownloadEntriesByState = [.PENDING: [download1, download2]]
        
        // Act
        let downloads = try downloadStateManager.getDownloadsByState(state: .PENDING)
        
        // Assert
        XCTAssertEqual(downloads.count, 2)
    }
    
    // MARK: - Cleanup Tests
    
    func testCleanupStaleDownloads_shouldCallStorageCleanup() throws {
        // Arrange
        offlineStorage.mockTotalSize = 5
        
        // Act
        let deletedCount = try downloadStateManager.cleanupStaleDownloads(threshold: 86400)
        
        // Assert
        XCTAssertEqual(deletedCount, 0)
        XCTAssertTrue(offlineStorage.clearedStaleDownloads)
    }
}