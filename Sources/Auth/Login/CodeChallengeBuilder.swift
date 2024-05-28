import Common
import CommonCrypto
import CryptoKit
import Foundation

class CodeChallengeBuilder {
	private let DIGEST_ALGORITHM = "SHA-256"
	private let CODE_VERIFIER_BYTE_ARRAY_SIZE = 32

	static let shared = CodeChallengeBuilder()

	func createCodeVerifier() -> String {
		var buffer = [UInt8](repeating: 0, count: CODE_VERIFIER_BYTE_ARRAY_SIZE)
		_ = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)
		return Data(buffer).base64EncodedString()
			.replacingOccurrences(of: "+", with: "-")
			.replacingOccurrences(of: "/", with: "_")
			.replacingOccurrences(of: "=", with: "")
	}

	func createCodeChallenge(codeVerifier: String) -> String {
		let data = codeVerifier.data(using: .utf8)!
		var buffer = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
		_ = data.withUnsafeBytes {
			CC_SHA256($0.baseAddress, CC_LONG(data.count), &buffer)
		}

		return Data(buffer).base64EncodedString()
			.replacingOccurrences(of: "+", with: "-")
			.replacingOccurrences(of: "/", with: "_")
			.replacingOccurrences(of: "=", with: "")
	}
}
