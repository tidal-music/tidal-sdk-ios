import Foundation
@testable import Player

final class KeyRequestMock: KeyRequest {
	var dataToReturn = Data()
	var shouldGetKeyIdSucceed = true
	var shouldCreateServerPlaybackContextSucceed = true
	let error = PlayerInternalError(
		errorId: .EUnexpected,
		errorType: PlayerInternalError.ErrorType.drmLicenseError,
		code: 0,
		description: nil
	)

	func getKeyId() throws -> Data {
		if shouldGetKeyIdSucceed {
			return dataToReturn
		} else {
			throw error
		}
	}

	func createServerPlaybackContext(for keyId: Data, using certificate: Data) async throws -> Data {
		if shouldCreateServerPlaybackContextSucceed {
			return dataToReturn
		} else {
			throw error
		}
	}
}
