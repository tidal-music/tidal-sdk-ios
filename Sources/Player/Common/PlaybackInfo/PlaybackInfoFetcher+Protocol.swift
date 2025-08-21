import Foundation

/// Protocol to allow mocking of PlaybackInfoFetcher
protocol PlaybackInfoFetcherProtocol {
    func getPlaybackInfo(
        streamingSessionId: String,
        mediaProduct: MediaProduct,
        playbackMode: PlaybackMode
    ) async throws -> PlaybackInfo
    
    func updateConfiguration(_ configuration: Configuration)
}

// Make the concrete class conform to the protocol
extension PlaybackInfoFetcher: PlaybackInfoFetcherProtocol {}