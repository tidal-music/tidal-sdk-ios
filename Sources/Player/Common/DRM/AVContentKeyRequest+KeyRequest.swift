import AVFoundation

extension AVContentKeyRequest: KeyRequest {
	func getKeyId() throws -> Data {
		guard let identifier = identifier as? String,
		      let host = URL(string: identifier)?.host,
		      let keyId = host.data(using: .utf8)
		else {
			throw PlayerInternalError(
				errorId: .EUnexpected,
				errorType: .drmLicenseError,
				code: 0,
				description: "Unable to extract keyId from AVContentKeyRequest [\(identifier.debugDescription)]"
			)
		}

		return keyId
	}

	func createServerPlaybackContext(for keyId: Data, using certificate: Data) async throws -> Data {
		try await withCheckedThrowingContinuation { continuation in
			let completionHandler: (Data?, Error?) -> Void = { spc, error in
				if let spc {
					PlayerWorld.logger?.log(loggable: PlayerLoggable.avcontentKeyRequestNoData)
					continuation.resume(returning: spc)
					return
				}

				guard let error else {
					let unknownError = PlayerInternalError(
						errorId: .PERetryable,
						errorType: .drmLicenseError,
						code: 1,
						description: "An unknown error caused SPC creation to fail"
					)

					continuation.resume(throwing: unknownError)
					return
				}

				continuation.resume(throwing: PlayerInternalError(
					errorId: .PERetryable,
					errorType: .drmLicenseError,
					code: (error as NSError).code,
					description: String(describing: error)
				))
			}

			makeStreamingContentKeyRequestData(
				forApp: certificate,
				contentIdentifier: keyId,
				options: nil,
				completionHandler: completionHandler
			)
		}
	}
}
