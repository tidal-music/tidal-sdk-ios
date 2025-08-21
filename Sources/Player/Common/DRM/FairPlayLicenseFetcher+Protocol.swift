import Foundation

/// Protocol for FairPlayLicenseFetcher to make it mockable in tests
protocol FairPlayLicenseFetcherProtocol {
    /// Get a license for a given key request and streaming session ID
    func getLicense(streamingSessionId: String, keyRequest: KeyRequest) async throws -> Data
    
    /// Update the configuration (no-op for FairPlayLicenseFetcher)
    func updateConfiguration(_ configuration: Configuration)
}

/// Extend the concrete class to implement the protocol
extension FairPlayLicenseFetcher: FairPlayLicenseFetcherProtocol {
    func updateConfiguration(_ configuration: Configuration) {
        // No-op as the FairPlayLicenseFetcher doesn't need configuration updates
    }
}