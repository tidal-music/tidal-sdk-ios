import Foundation

public extension DeviceAuthorizationResponse {
	static func mock(
		deviceCode: String = "6365c8ed-d096-45d4-9e21-b7ca9ba7d234",
		userCode: String = "FWXVX",
		verificationUri: String = "link.tidal.com",
		verificationUriComplete: String? = "link.tidal.com/FWXVX",
		expiresIn: Int = 300,
		interval: Int = 2
	) -> Self {
		.init(
			deviceCode: deviceCode,
			userCode: userCode,
			verificationUri: verificationUri,
			verificationUriComplete: verificationUriComplete,
			expiresIn: expiresIn,
			interval: interval
		)
	}
}
