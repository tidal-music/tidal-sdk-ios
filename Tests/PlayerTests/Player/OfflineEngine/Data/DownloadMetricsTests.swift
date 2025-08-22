import XCTest
@testable import Player

final class DownloadMetricsTests: XCTestCase {
    
    func testSuccessRate() {
        // Given
        let metrics = DownloadMetrics(
            periodDays: 7,
            totalDownloads: 100,
            successfulDownloads: 75,
            failedDownloads: 15,
            cancelledDownloads: 10,
            averageCompletionTimeSeconds: 120
        )
        
        // When & Then
        XCTAssertEqual(metrics.successRate, 75.0)
        XCTAssertEqual(metrics.failureRate, 15.0)
        XCTAssertEqual(metrics.cancellationRate, 10.0)
    }
    
    func testRatesWithZeroDownloads() {
        // Given
        let metrics = DownloadMetrics(
            periodDays: 7,
            totalDownloads: 0,
            successfulDownloads: 0,
            failedDownloads: 0,
            cancelledDownloads: 0,
            averageCompletionTimeSeconds: 0
        )
        
        // When & Then
        XCTAssertEqual(metrics.successRate, 0.0)
        XCTAssertEqual(metrics.failureRate, 0.0)
        XCTAssertEqual(metrics.cancellationRate, 0.0)
    }
    
    func testDescription() {
        // Given
        let metrics = DownloadMetrics(
            periodDays: 7,
            totalDownloads: 100,
            successfulDownloads: 80,
            failedDownloads: 15,
            cancelledDownloads: 5,
            averageCompletionTimeSeconds: 45
        )
        
        // When
        let description = metrics.description
        
        // Then
        XCTAssertTrue(description.contains("Last 7 days"))
        XCTAssertTrue(description.contains("Total Downloads: 100"))
        XCTAssertTrue(description.contains("Success Rate: 80.0%"))
        XCTAssertTrue(description.contains("Failure Rate: 15.0%"))
        XCTAssertTrue(description.contains("Cancellation Rate: 5.0%"))
        XCTAssertTrue(description.contains("Average Completion Time: 45s"))
    }
    
    func testTimeFormattingSeconds() {
        // Given
        let metrics = DownloadMetrics(
            periodDays: 7,
            totalDownloads: 10,
            successfulDownloads: 10,
            failedDownloads: 0,
            cancelledDownloads: 0,
            averageCompletionTimeSeconds: 45
        )
        
        // When
        let description = metrics.description
        
        // Then
        XCTAssertTrue(description.contains("Average Completion Time: 45s"))
    }
    
    func testTimeFormattingMinutes() {
        // Given
        let metrics = DownloadMetrics(
            periodDays: 7,
            totalDownloads: 10,
            successfulDownloads: 10,
            failedDownloads: 0,
            cancelledDownloads: 0,
            averageCompletionTimeSeconds: 125 // 2m 5s
        )
        
        // When
        let description = metrics.description
        
        // Then
        XCTAssertTrue(description.contains("Average Completion Time: 2m 5s"))
    }
    
    func testTimeFormattingHours() {
        // Given
        let metrics = DownloadMetrics(
            periodDays: 7,
            totalDownloads: 10,
            successfulDownloads: 10,
            failedDownloads: 0,
            cancelledDownloads: 0,
            averageCompletionTimeSeconds: 3665 // 1h 1m
        )
        
        // When
        let description = metrics.description
        
        // Then
        XCTAssertTrue(description.contains("Average Completion Time: 1h 1m"))
    }
}