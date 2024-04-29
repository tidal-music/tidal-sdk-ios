import Foundation

// MARK: - UserConfiguration

public struct UserConfiguration: Equatable {
	/// The user's unique identifier
	public let userId: Int

	/// The user client id
	public let userClientId: Int

	public init(userId: Int, userClientId: Int) {
		self.userId = userId
		self.userClientId = userClientId
	}
}

// MARK: - Configuration

public struct Configuration {
	/// The client token that was used to create the access token
	public var clientToken: String

	/// The app's version
	public var clientVersion: String

	/// Tells TIDAL Player if client is in ONLINE of OFFLINE mode.
	///
	/// When in OFFLINE mode, TIDAL Player may not use any networking whatsoever
	///
	/// Must be called when bootstrapping TIDAL Player and each time the offline mode changes.
	public var offlineMode: Bool = false

	/// Loudness normalization mode.
	public var loudnessNormalizationMode: LoudnessNormalizationMode = .ALBUM

	// Pre amplification value to be used for loudness normalization.
	#if os(tvOS)
		public var loudnessNormalizationPreAmp: Float = 0.0
	#else
		public var loudnessNormalizationPreAmp: Float = 4.0
	#endif

	/// Pre amplification value to be used for loudness normalization with an Airplay output route.
	public var loudnessNormalizationPreAmpAirplay: Float = 0.0

	/// AudioQuality to use when streaming over WiFi.
	public var streamingWifiAudioQuality: AudioQuality = .LOSSLESS

	/// AudioQuality to use when streaming over cellular.
	public var streamingCellularAudioQuality: AudioQuality = .LOW

	public var offlineAudioQuality: AudioQuality = .HIGH

	public var offlineVideoQuality: VideoQuality = .MEDIUM

	public var allowOfflineOverCellular: Bool = false

	init(clientToken: String, clientVersion: String) {
		self.clientToken = clientToken
		self.clientVersion = clientVersion
	}
}

extension Configuration {
	/// Convenience value of preAmp considering if it's airplay or not. If it's airplay, then it uses
	/// ``loudnessNormalizationPreAmpAirplay``,  otherwise, ``loudnessNormalizationPreAmp``.
	var currentPreAmpValue: Float {
		PlayerWorld.audioInfoProvider.isAirPlayOutputRoute() ? loudnessNormalizationPreAmpAirplay : loudnessNormalizationPreAmp
	}
}
