import Foundation
import XCTest
@testable import Player

final class DownloadEntryTests: XCTestCase {
    private let mockTimestamp: UInt64 = 1000000

    override func setUp() {
        PlayerWorld = PlayerWorldClient.mock(
            timeProvider: TimeProviderMock(timestamp: mockTimestamp)
        )
    }

    override func tearDown() {
        PlayerWorld = PlayerWorldClient.live
    }

    func testInitialization() {
        // Test basic initialization
        let downloadEntry = DownloadEntry(
            id: "test-id",
            productId: "test-product-id",
            productType: .TRACK,
            createdAt: mockTimestamp
        )
        
        // Verify initial values
        XCTAssertEqual(downloadEntry.id, "test-id")
        XCTAssertEqual(downloadEntry.productId, "test-product-id")
        XCTAssertEqual(downloadEntry.productType, .TRACK)
        XCTAssertEqual(downloadEntry.state, .PENDING)
        XCTAssertEqual(downloadEntry.progress, 0.0)
        XCTAssertEqual(downloadEntry.attemptCount, 0)
        XCTAssertNil(downloadEntry.lastError)
        XCTAssertEqual(downloadEntry.createdAt, mockTimestamp)
        XCTAssertEqual(downloadEntry.updatedAt, mockTimestamp)
        XCTAssertNil(downloadEntry.pausedAt)
        XCTAssertNil(downloadEntry.backgroundTaskIdentifier)
        XCTAssertNil(downloadEntry.partialMediaPath)
        XCTAssertNil(downloadEntry.partialLicensePath)
    }

    func testUpdateState() {
        // Arrange
        let updatedTimestamp: UInt64 = 2000000
        (PlayerWorld.timeProvider as! TimeProviderMock).timestamp = updatedTimestamp
        
        var downloadEntry = DownloadEntry(
            id: "test-id",
            productId: "test-product-id",
            productType: .TRACK,
            createdAt: mockTimestamp
        )

        // Act
        downloadEntry.updateState(.IN_PROGRESS)

        // Assert
        XCTAssertEqual(downloadEntry.state, .IN_PROGRESS)
        XCTAssertEqual(downloadEntry.updatedAt, updatedTimestamp)
        XCTAssertNil(downloadEntry.pausedAt)
        
        // Act - test paused state
        downloadEntry.updateState(.PAUSED)
        
        // Assert
        XCTAssertEqual(downloadEntry.state, .PAUSED)
        XCTAssertEqual(downloadEntry.updatedAt, updatedTimestamp)
        XCTAssertEqual(downloadEntry.pausedAt, updatedTimestamp)
    }

    func testUpdateProgress() {
        // Arrange
        let updatedTimestamp: UInt64 = 2000000
        (PlayerWorld.timeProvider as! TimeProviderMock).timestamp = updatedTimestamp
        
        var downloadEntry = DownloadEntry(
            id: "test-id",
            productId: "test-product-id",
            productType: .TRACK,
            createdAt: mockTimestamp
        )

        // Act
        downloadEntry.updateProgress(0.5)

        // Assert
        XCTAssertEqual(downloadEntry.progress, 0.5)
        XCTAssertEqual(downloadEntry.updatedAt, updatedTimestamp)
    }

    func testIncrementAttemptCount() {
        // Arrange
        let updatedTimestamp: UInt64 = 2000000
        (PlayerWorld.timeProvider as! TimeProviderMock).timestamp = updatedTimestamp
        
        var downloadEntry = DownloadEntry(
            id: "test-id",
            productId: "test-product-id",
            productType: .TRACK,
            createdAt: mockTimestamp
        )

        // Act
        downloadEntry.incrementAttemptCount()

        // Assert
        XCTAssertEqual(downloadEntry.attemptCount, 1)
        XCTAssertEqual(downloadEntry.updatedAt, updatedTimestamp)
        
        // Act again
        downloadEntry.incrementAttemptCount()
        
        // Assert
        XCTAssertEqual(downloadEntry.attemptCount, 2)
    }

    func testRecordError() {
        // Arrange
        let updatedTimestamp: UInt64 = 2000000
        (PlayerWorld.timeProvider as! TimeProviderMock).timestamp = updatedTimestamp
        
        var downloadEntry = DownloadEntry(
            id: "test-id",
            productId: "test-product-id",
            productType: .TRACK,
            createdAt: mockTimestamp
        )
        
        let testError = NSError(domain: "test", code: 123, userInfo: [NSLocalizedDescriptionKey: "Test error"])

        // Act
        downloadEntry.recordError(testError)

        // Assert
        XCTAssertEqual(downloadEntry.lastError, "Test error")
        XCTAssertEqual(downloadEntry.updatedAt, updatedTimestamp)
    }

    func testIsStale() {
        // Arrange
        let currentTimestamp: UInt64 = 90_000_000 // 90 seconds in milliseconds
        (PlayerWorld.timeProvider as! TimeProviderMock).timestamp = currentTimestamp
        
        // Create a failed download from 1 day + 1 hour ago (should be stale)
        let staleEntry = DownloadEntry.mock(
            state: .FAILED,
            updatedAt: currentTimestamp - 91_000_000 // 25 hours + 1 second in milliseconds
        )
        
        // Create a failed download from 23 hours ago (should not be stale)
        let freshEntry = DownloadEntry.mock(
            state: .FAILED,
            updatedAt: currentTimestamp - 82_800_000 // 23 hours in milliseconds
        )
        
        // Create an in-progress download from 2 days ago (should not be stale because it's not failed)
        let activeEntry = DownloadEntry.mock(
            state: .IN_PROGRESS,
            updatedAt: currentTimestamp - 172_800_000 // 48 hours in milliseconds
        )

        // Act & Assert
        // Default threshold is 24 hours
        XCTAssertTrue(staleEntry.isStale(), "Entry older than 24 hours should be stale")
        XCTAssertFalse(freshEntry.isStale(), "Entry newer than 24 hours should not be stale")
        XCTAssertFalse(activeEntry.isStale(), "Active entry should not be stale regardless of age")
        
        // Custom threshold of 12 hours
        XCTAssertTrue(staleEntry.isStale(threshold: 12 * 60 * 60), "Entry older than 12 hours should be stale")
        XCTAssertTrue(freshEntry.isStale(threshold: 12 * 60 * 60), "Entry older than 12 hours should be stale")
    }
}