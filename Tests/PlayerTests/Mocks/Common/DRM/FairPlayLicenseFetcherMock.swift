import Foundation
@testable import Player

final class FairPlayLicenseFetcherMock: FairPlayLicenseFetcherProtocol {
    var getLicenseResult: Result<Data, Error> = .success(Data())
    var getLicenseCalls: [(streamingSessionId: String, keyRequest: KeyRequest)] = []
    var updateConfigurationCalls: [Configuration] = []
    
    func getLicense(streamingSessionId: String, keyRequest: KeyRequest) async throws -> Data {
        getLicenseCalls.append((streamingSessionId: streamingSessionId, keyRequest: keyRequest))
        return try getLicenseResult.get()
    }
    
    func updateConfiguration(_ configuration: Configuration) {
        updateConfigurationCalls.append(configuration)
    }
}
