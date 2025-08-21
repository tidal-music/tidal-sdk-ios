import XCTest
@testable import Player

final class DownloaderWithStateManagerTests: XCTestCase {
    var playbackInfoFetcher: PlaybackInfoFetcherMock!
    var fairPlayLicenseFetcher: FairPlayLicenseFetcherMock!
    var networkMonitor: NetworkMonitorMock!
    var downloadStateManager: DownloadStateManagerMock!
    var downloader: Downloader!
    var observer: DownloadObserverMock!
    
    override func setUp() {
        super.setUp()
        playbackInfoFetcher = PlaybackInfoFetcherMock()
        fairPlayLicenseFetcher = FairPlayLicenseFetcherMock()
        networkMonitor = NetworkMonitorMock()
        downloadStateManager = DownloadStateManagerMock()
        
        downloader = Downloader(
            playbackInfoFetcher: playbackInfoFetcher,
            fairPlayLicenseFetcher: fairPlayLicenseFetcher,
            networkMonitor: networkMonitor,
            stateManager: downloadStateManager
        )
        
        observer = DownloadObserverMock()
        downloader.setObserver(observer: observer)
    }
    
    override func tearDown() {
        playbackInfoFetcher = nil
        fairPlayLicenseFetcher = nil
        networkMonitor = nil
        downloadStateManager = nil
        downloader = nil
        observer = nil
        super.tearDown()
    }
    
    // MARK: - Download Creation and State Tracking Tests
    
    func testDownload_CreatesDownloadEntry() async {
        // Arrange
        let mediaProduct = MediaProduct.mock(productType: .TRACK, productId: "track-123")
        let downloadEntry = DownloadEntry.mock(id: "entry-123", productId: "track-123", productType: .TRACK)
        downloadStateManager.mockDownloadsByProductId["track-123"] = downloadEntry
        
        // Set up playback info fetcher to succeed
        playbackInfoFetcher.getPlaybackInfoResult = .success(PlaybackInfo.mock(
            productType: .TRACK,
            productId: "track-123",
            url: URL(string: "https://example.com/track.mp3")!
        ))
        
        // Act
        downloader.download(mediaProduct: mediaProduct, sessionType: .DOWNLOAD)
        
        // Wait for async operations
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Assert
        XCTAssertEqual(downloadStateManager.createdDownloads.count, 1)
        XCTAssertEqual(downloadStateManager.createdDownloads[0].productId, "track-123")
        XCTAssertEqual(downloadStateManager.createdDownloads[0].productType, .TRACK)
    }
    
    func testDownload_UpdatesStateToInProgress() async {
        // Arrange
        let mediaProduct = MediaProduct.mock(productType: .TRACK, productId: "track-123")
        let downloadEntry = DownloadEntry.mock(id: "entry-123", productId: "track-123", productType: .TRACK)
        downloadStateManager.mockDownloadsByProductId["track-123"] = downloadEntry
        
        // Set up playback info fetcher to succeed
        playbackInfoFetcher.getPlaybackInfoResult = .success(PlaybackInfo.mock(
            productType: .TRACK,
            productId: "track-123",
            url: URL(string: "https://example.com/track.mp3")!
        ))
        
        // Act
        downloader.download(mediaProduct: mediaProduct, sessionType: .DOWNLOAD)
        
        // Wait for async operations
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Assert
        XCTAssertEqual(downloadStateManager.updatedDownloadStates.count, 1)
        XCTAssertEqual(downloadStateManager.updatedDownloadStates[0].id, "entry-123")
        XCTAssertEqual(downloadStateManager.updatedDownloadStates[0].state, .IN_PROGRESS)
    }
    
    func testProgressUpdate_UpdatesDownloadEntryProgress() async {
        // Arrange
        let mediaProduct = MediaProduct.mock(productType: .TRACK, productId: "track-123")
        let downloadEntry = DownloadEntry.mock(id: "entry-123", productId: "track-123", productType: .TRACK)
        downloadStateManager.mockDownloadsByProductId["track-123"] = downloadEntry
        downloadStateManager.mockDownloads["entry-123"] = downloadEntry
        
        // Create a task for testing progress updates
        let downloadTask = DownloadTask(
            mediaProduct: mediaProduct,
            downloadEntry: downloadEntry,
            networkType: .WIFI,
            outputDevice: nil,
            sessionType: .DOWNLOAD,
            monitor: downloader
        )
        
        // Act - simulate progress update
        downloadTask.reportProgress(0.5)
        
        // Wait for async operations
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Assert
        XCTAssertEqual(downloadStateManager.updatedDownloadProgresses.count, 1)
        XCTAssertEqual(downloadStateManager.updatedDownloadProgresses[0].id, "entry-123")
        XCTAssertEqual(downloadStateManager.updatedDownloadProgresses[0].progress, 0.5)
    }
    
    func testDownloadCompletion_UpdatesStateToCompleted() async {
        // Arrange
        let mediaProduct = MediaProduct.mock(productType: .TRACK, productId: "track-123")
        let downloadEntry = DownloadEntry.mock(id: "entry-123", productId: "track-123", productType: .TRACK)
        downloadStateManager.mockDownloadsByProductId["track-123"] = downloadEntry
        downloadStateManager.mockDownloads["entry-123"] = downloadEntry
        
        let offlineEntry = OfflineEntry.mock(productId: "track-123")
        
        // Create a task for testing completion
        let downloadTask = DownloadTask(
            mediaProduct: mediaProduct,
            downloadEntry: downloadEntry,
            networkType: .WIFI,
            outputDevice: nil,
            sessionType: .DOWNLOAD,
            monitor: downloader
        )
        
        // Act - simulate download completion
        (downloader as DownloadTaskMonitor).completed(downloadTask: downloadTask, offlineEntry: offlineEntry)
        
        // Wait for async operations
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Assert
        XCTAssertEqual(downloadStateManager.updatedDownloadStates.count, 1)
        XCTAssertEqual(downloadStateManager.updatedDownloadStates[0].id, "entry-123")
        XCTAssertEqual(downloadStateManager.updatedDownloadStates[0].state, .COMPLETED)
    }
    
    func testDownloadFailure_RecordsErrorInState() async {
        // Arrange
        let mediaProduct = MediaProduct.mock(productType: .TRACK, productId: "track-123")
        let downloadEntry = DownloadEntry.mock(id: "entry-123", productId: "track-123", productType: .TRACK)
        downloadStateManager.mockDownloadsByProductId["track-123"] = downloadEntry
        downloadStateManager.mockDownloads["entry-123"] = downloadEntry
        
        let error = NSError(domain: "test", code: 123, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        
        // Create a task for testing failure
        let downloadTask = DownloadTask(
            mediaProduct: mediaProduct,
            downloadEntry: downloadEntry,
            networkType: .WIFI,
            outputDevice: nil,
            sessionType: .DOWNLOAD,
            monitor: downloader
        )
        
        // Act - simulate download failure
        (downloader as DownloadTaskMonitor).failed(downloadTask: downloadTask, with: error)
        
        // Wait for async operations
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Assert
        XCTAssertEqual(downloadStateManager.recordedErrors.count, 1)
        XCTAssertEqual(downloadStateManager.recordedErrors[0].id, "entry-123")
        XCTAssertEqual(downloadStateManager.recordedErrors[0].error.localizedDescription, "Test error")
    }
    
    // MARK: - Cancellation and Cleanup Tests
    
    func testCancelDownload_UpdatesStateToCancel() {
        // Arrange
        let downloadEntry = DownloadEntry.mock(id: "entry-123", productId: "track-123", productType: .TRACK)
        downloadStateManager.mockDownloadsByProductId["track-123"] = downloadEntry
        
        // Act
        downloader.cancelDownload(for: "track-123")
        
        // Assert
        XCTAssertEqual(downloadStateManager.updatedDownloadStates.count, 1)
        XCTAssertEqual(downloadStateManager.updatedDownloadStates[0].id, "entry-123")
        XCTAssertEqual(downloadStateManager.updatedDownloadStates[0].state, .CANCELLED)
    }
    
    func testCleanupStaleDownloads_CallsStateManagerCleanup() {
        // Arrange
        downloadStateManager.mockDeletedCount = 5
        
        // Act
        downloader.cleanupStaleDownloads(olderThan: 3)
        
        // Assert
        XCTAssertEqual(downloadStateManager.clearedStaleDownloads, true)
        // Verify threshold was converted to seconds (3 days = 259200 seconds)
        XCTAssertEqual(downloadStateManager.cleanupStaleDownloadsCall?.threshold, 3 * 24 * 60 * 60)
    }
}

// Mock DownloadObserver for testing
final class DownloadObserverMock: DownloadObserver {
    var streamingEvents: [Any] = []
    var downloadStartedCalls: [MediaProduct] = []
    var downloadProgressCalls: [(mediaProduct: MediaProduct, progress: Double)] = []
    var downloadCompletedCalls: [(mediaProduct: MediaProduct, offlineEntry: OfflineEntry)] = []
    var downloadFailedCalls: [(mediaProduct: MediaProduct, error: Error)] = []
    
    func handle(streamingMetricsEvent: any StreamingMetricsEvent) {
        streamingEvents.append(streamingMetricsEvent)
    }
    
    func downloadStarted(for mediaProduct: MediaProduct) {
        downloadStartedCalls.append(mediaProduct)
    }
    
    func downloadProgress(for mediaProduct: MediaProduct, is percentage: Double) {
        downloadProgressCalls.append((mediaProduct: mediaProduct, progress: percentage))
    }
    
    func downloadCompleted(for mediaProduct: MediaProduct, offlineEntry: OfflineEntry) {
        downloadCompletedCalls.append((mediaProduct: mediaProduct, offlineEntry: offlineEntry))
    }
    
    func downloadFailed(for mediaProduct: MediaProduct, with error: Error) {
        downloadFailedCalls.append((mediaProduct: mediaProduct, error: error))
    }
}

// Mock MediaProduct for testing
extension MediaProduct {
    static func mock(
        productType: ProductType = .TRACK,
        productId: String = "mock-id"
    ) -> MediaProduct {
        MockMediaProduct(productType: productType, productId: productId)
    }
}

// Mock implementation of MediaProduct for testing
private class MockMediaProduct: MediaProduct {
    convenience init(productType: ProductType, productId: String) {
        self.init(productType: productType, productId: productId)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

// Mock implementation of PlaybackInfoFetcher for testing
final class PlaybackInfoFetcherMock: PlaybackInfoFetcherProtocol {
    var getPlaybackInfoResult: Result<PlaybackInfo, Error> = .failure(NSError(domain: "Test", code: 0, userInfo: nil))
    var getPlaybackInfoCalls: [(streamingSessionId: String, mediaProduct: MediaProduct, playbackMode: PlaybackMode)] = []
    var updateConfigurationCalls: [Configuration] = []
    
    func getPlaybackInfo(streamingSessionId: String, mediaProduct: MediaProduct, playbackMode: PlaybackMode) async throws -> PlaybackInfo {
        getPlaybackInfoCalls.append((streamingSessionId: streamingSessionId, mediaProduct: mediaProduct, playbackMode: playbackMode))
        return try getPlaybackInfoResult.get()
    }
    
    func updateConfiguration(_ configuration: Configuration) {
        updateConfigurationCalls.append(configuration)
    }
}

// Extend the existing NetworkMonitorMock for this test
extension NetworkMonitorMock {
    // Empty extension for clarity
}