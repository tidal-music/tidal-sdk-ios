import Foundation

struct CredentialsSuccessDataParser {
	func clientIdFromToken(_ token: String) -> Int? {
		var clientId: Int?

		let credentialStrings = token.components(separatedBy: ".")
		if credentialStrings.count > 2 {
			let credentialsSuccessBase64EncodedString = credentialStrings[1].base64WithPadding()
			if let decodedCredentialsSuccessData = Data(base64Encoded: credentialsSuccessBase64EncodedString) {
				let jsonCredentialsSuccessString = String(decoding: decodedCredentialsSuccessData, as: UTF8.self)
				let jsonCredentialsSuccessData = Data(jsonCredentialsSuccessString.utf8)

				let decoder = JSONDecoder()
				do {
					let credentialsSuccessData = try decoder.decode(CredentialsSuccessData.self, from: jsonCredentialsSuccessData)
					clientId = credentialsSuccessData.clientId
				} catch {
					PlayerWorld.logger?.log(loggable: PlayerLoggable.credentialsSuccessParserParsingFailed(error: error))
					print("Error when trying to get client id from token from successData from credentials: \(error)")
				}
			}
		}
		return clientId
	}
}
