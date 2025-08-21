import XCTest
@testable import Player

final class SimpleDownloaderWithStateManagerTest: XCTestCase {
    func testDownloadStateManagement() async throws {
        // Create mocks
        let downloadStateManager = DownloadStateManagerMock()
        
        // Set up a mock download entry
        let mockEntry = DownloadEntry.mock(
            id: "test-123",
            productId: "product-123",
            productType: .TRACK
        )
        downloadStateManager.mockDownloadsByProductId["product-123"] = mockEntry
        
        // Verify state management works
        XCTAssertEqual(downloadStateManager.createdDownloads.count, 0)
        
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
        
        // Update state
        let updatedEntry = try downloadStateManager.updateDownloadState(id: entry.id, state: .IN_PROGRESS)
        
        // Verify state was updated
        XCTAssertNotNil(updatedEntry)
        XCTAssertEqual(updatedEntry?.state, .IN_PROGRESS)
        XCTAssertEqual(downloadStateManager.updatedDownloadStates.count, 1)
        XCTAssertEqual(downloadStateManager.updatedDownloadStates[0].id, "test-123")
        XCTAssertEqual(downloadStateManager.updatedDownloadStates[0].state, .IN_PROGRESS)
    }
}