import XCTest
@testable import Player

final class DownloadSummaryTests: XCTestCase {
    
    func testInitWithEmptyEntries() {
        // Given
        let entries: [DownloadEntry] = []
        
        // When
        let summary = DownloadSummary(entries: entries)
        
        // Then
        XCTAssertEqual(summary.totalDownloads, 0)
        XCTAssertEqual(summary.pendingDownloads, 0)
        XCTAssertEqual(summary.inProgressDownloads, 0)
        XCTAssertEqual(summary.pausedDownloads, 0)
        XCTAssertEqual(summary.failedDownloads, 0)
        XCTAssertEqual(summary.completedDownloads, 0)
        XCTAssertEqual(summary.cancelledDownloads, 0)
        XCTAssertEqual(summary.averageProgress, 0.0)
    }
    
    func testInitWithVariedEntries() {
        // Given
        let pendingDownload = DownloadEntry.mock(id: "pending", productId: "track1", state: .PENDING)
        let inProgressDownload1 = DownloadEntry.mock(id: "progress1", productId: "track2", state: .IN_PROGRESS, progress: 0.2)
        let inProgressDownload2 = DownloadEntry.mock(id: "progress2", productId: "track3", state: .IN_PROGRESS, progress: 0.8)
        let pausedDownload = DownloadEntry.mock(id: "paused", productId: "track4", state: .PAUSED)
        let failedDownload = DownloadEntry.mock(id: "failed", productId: "track5", state: .FAILED)
        let completedDownload = DownloadEntry.mock(id: "completed", productId: "track6", state: .COMPLETED)
        let cancelledDownload = DownloadEntry.mock(id: "cancelled", productId: "track7", state: .CANCELLED)
        
        let entries = [
            pendingDownload,
            inProgressDownload1,
            inProgressDownload2,
            pausedDownload,
            failedDownload,
            completedDownload,
            cancelledDownload
        ]
        
        // When
        let summary = DownloadSummary(entries: entries)
        
        // Then
        XCTAssertEqual(summary.totalDownloads, 7)
        XCTAssertEqual(summary.pendingDownloads, 1)
        XCTAssertEqual(summary.inProgressDownloads, 2)
        XCTAssertEqual(summary.pausedDownloads, 1)
        XCTAssertEqual(summary.failedDownloads, 1)
        XCTAssertEqual(summary.completedDownloads, 1)
        XCTAssertEqual(summary.cancelledDownloads, 1)
        XCTAssertEqual(summary.averageProgress, 0.5, accuracy: 0.01) // (0.2 + 0.8) / 2 = 0.5
    }
    
    func testDisplayableDownloadProgressWithNoActiveDownloads() {
        // Given
        let entries = [
            DownloadEntry.mock(id: "completed1", productId: "track1", state: .COMPLETED),
            DownloadEntry.mock(id: "failed1", productId: "track2", state: .FAILED)
        ]
        let summary = DownloadSummary(entries: entries)
        
        // When
        let displayText = summary.displayableDownloadProgress()
        
        // Then
        XCTAssertEqual(displayText, "No active downloads")
    }
    
    func testDisplayableDownloadProgressWithSingleDownload() {
        // Given
        let entries = [
            DownloadEntry.mock(id: "progress", productId: "track1", state: .IN_PROGRESS, progress: 0.75)
        ]
        let summary = DownloadSummary(entries: entries)
        
        // When
        let displayText = summary.displayableDownloadProgress()
        
        // Then
        XCTAssertEqual(displayText, "Downloading: 75%")
    }
    
    func testDisplayableDownloadProgressWithMultipleDownloads() {
        // Given
        let entries = [
            DownloadEntry.mock(id: "progress1", productId: "track1", state: .IN_PROGRESS, progress: 0.3),
            DownloadEntry.mock(id: "progress2", productId: "track2", state: .IN_PROGRESS, progress: 0.7),
            DownloadEntry.mock(id: "progress3", productId: "track3", state: .IN_PROGRESS, progress: 0.6)
        ]
        let summary = DownloadSummary(entries: entries)
        
        // When
        let displayText = summary.displayableDownloadProgress()
        
        // Then
        // Average progress = (0.3 + 0.7 + 0.6) / 3 = 0.53333... = 53%
        XCTAssertEqual(displayText, "Downloading 3 items: 53%")
    }
    
    func testDescriptionFormat() {
        // Given
        let entries = [
            DownloadEntry.mock(id: "pending", productId: "track1", state: .PENDING),
            DownloadEntry.mock(id: "progress", productId: "track2", state: .IN_PROGRESS, progress: 0.42)
        ]
        let summary = DownloadSummary(entries: entries)
        
        // When
        let description = summary.description
        
        // Then
        // Verify description contains all expected lines
        XCTAssertTrue(description.contains("Total: 2"))
        XCTAssertTrue(description.contains("Pending: 1"))
        XCTAssertTrue(description.contains("In Progress: 1 (Avg: 42%)"))
        XCTAssertTrue(description.contains("Paused: 0"))
        XCTAssertTrue(description.contains("Failed: 0"))
        XCTAssertTrue(description.contains("Completed: 0"))
        XCTAssertTrue(description.contains("Cancelled: 0"))
    }
}