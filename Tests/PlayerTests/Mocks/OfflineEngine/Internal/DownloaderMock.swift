import Foundation
@testable import Player

final class DownloaderMock {
    // Record calls for verification
    var downloadCalls: [(mediaProduct: MediaProduct, sessionType: SessionType, outputDevice: String?)] = []
    var cancelAllCalled = false
    var cancelDownloadCalls: [String] = []
    var cleanupStaleCalls: [Int] = []
    var observerSet: DownloadObserver?
    var configUpdated: Configuration?
    
    // Callbacks for testing
    var onDownload: ((MediaProduct, SessionType, String?) -> Void)?
    var onCancelAll: (() -> Void)?
    var onCancelDownload: ((String) -> Void)?
    var onCleanupStale: ((Int) -> Void)?
    
    // Provide test control
    var downloadStateManager: DownloadStateManagerMock
    
    init(downloadStateManager: DownloadStateManagerMock = DownloadStateManagerMock()) {
        self.downloadStateManager = downloadStateManager
    }
    
    func reset() {
        downloadCalls = []
        cancelAllCalled = false
        cancelDownloadCalls = []
        cleanupStaleCalls = []
        observerSet = nil
        configUpdated = nil
        
        onDownload = nil
        onCancelAll = nil
        onCancelDownload = nil
        onCleanupStale = nil
        
        downloadStateManager.reset()
    }
}

extension DownloaderMock: DownloadTaskMonitor {
    func emit(event: any StreamingMetricsEvent) {
        // Pass through to observer if set
        observerSet?.handle(streamingMetricsEvent: event)
    }
    
    func started(downloadTask: DownloadTask) {
        observerSet?.downloadStarted(for: downloadTask.mediaProduct)
    }
    
    func progress(downloadTask: DownloadTask, progress: Double) {
        observerSet?.downloadProgress(for: downloadTask.mediaProduct, is: progress)
    }
    
    func completed(downloadTask: DownloadTask, offlineEntry: OfflineEntry) {
        observerSet?.downloadCompleted(for: downloadTask.mediaProduct, offlineEntry: offlineEntry)
    }
    
    func failed(downloadTask: DownloadTask, with error: Error) {
        observerSet?.downloadFailed(for: downloadTask.mediaProduct, with: error)
    }
}

extension DownloaderMock: Downloader {
    func download(mediaProduct: MediaProduct, sessionType: SessionType, outputDevice: String? = nil) {
        downloadCalls.append((mediaProduct: mediaProduct, sessionType: sessionType, outputDevice: outputDevice))
        onDownload?(mediaProduct, sessionType, outputDevice)
    }
    
    func cancellAll() {
        cancelAllCalled = true
        onCancelAll?()
    }
    
    func cancelDownload(for productId: String) {
        cancelDownloadCalls.append(productId)
        onCancelDownload?(productId)
    }
    
    func cleanupStaleDownloads(olderThan days: Int = 7) {
        cleanupStaleCalls.append(days)
        onCleanupStale?(days)
    }
    
    func setObserver(observer: DownloadObserver) {
        observerSet = observer
    }
    
    func updateConfiguration(_ configuration: Configuration) {
        configUpdated = configuration
    }
}