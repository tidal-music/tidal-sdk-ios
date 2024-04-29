import Foundation

public struct DeviceAuthorizationResponse: Codable {
	public let deviceCode: String
	public let userCode: String
	public let verificationUri: String
	public let verificationUriComplete: String?
	public let expiresIn: Int
	public let interval: Int
}
