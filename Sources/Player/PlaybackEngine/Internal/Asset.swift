import Foundation

// MARK: - Asset

/// Asset class meant to be subclassed by each player implementing GenericMediaPlayer,
/// so they can customize the behaviour.
open class Asset {
	let player: GenericMediaPlayer
	private var loudnessNormalizationConfiguration: LoudnessNormalizationConfiguration

	@Atomic var assetPosition: Double
	@Atomic var playbackMetadata: AssetPlaybackMetadata?

	/// Convenience initializer.
	/// - Parameters:
	///   - player: An implementation of a GenericMediaPlayer, that manages the asset playback.
	///   - loudnessNormalizationConfiguration: The loudness normalization configuration controlling the output volume.
	/// - Returns: Instance of Asset.
	public init(
		with player: GenericMediaPlayer,
		loudnessNormalizationConfiguration: LoudnessNormalizationConfiguration
	) {
		self.player = player
		self.loudnessNormalizationConfiguration = loudnessNormalizationConfiguration
		assetPosition = 0
	}

	/// Method to obtain the current asset position
	/// - Returns: The asset position
	public func getAssetPosition() -> Double {
		assetPosition
	}

	/// Method to set the current asset position
	/// - Parameter assetPosition: The asset position
	public func setAssetPosition(_ assetPosition: Double) {
		self.assetPosition = assetPosition
	}

	/// Method to obtain the current asset Playback Metadata
	/// - Returns: The asset playback metadata
	public func getAssetMetadata() -> AssetPlaybackMetadata? {
		playbackMetadata
	}

	/// Method to set the asset playback metadata.
	/// - Parameter playbackMetadata: Playback metadata of the asset.
	public func setPlaybackMetadata(_ playbackMetadata: AssetPlaybackMetadata?) {
		self.playbackMetadata = playbackMetadata
	}

	/// Method to unload the asset in the player instance.
	public func unload() {
		player.unload(asset: self)
	}

	// MARK: - Loudness normalization

	func setLoudnessNormalizationMode(_ loudnessNormalizationMode: LoudnessNormalizationMode) {
		loudnessNormalizationConfiguration.setLoudnessNormalizationMode(loudnessNormalizationMode)
	}

	public func getLoudnessNormalizationConfiguration() -> LoudnessNormalizationConfiguration {
		loudnessNormalizationConfiguration
	}

	/// Updates the volume of the asset in its player based on the loudness normalization mode.
	func updateVolume() {
		player.updateVolume(loudnessNormalizer: loudnessNormalizationConfiguration.getLoudnessNormalizer())
	}

	/// Updates the preAmp of the loudness normalizer.
	func updatePreAmp(_ preAmpValue: Float) {
		loudnessNormalizationConfiguration.getLoudnessNormalizer()?.updatePreAmp(preAmpValue)
	}
}

// MARK: Equatable

extension Asset: Equatable {
	public static func == (lhs: Asset, rhs: Asset) -> Bool {
		lhs.assetPosition == rhs.assetPosition &&
			lhs.loudnessNormalizationConfiguration == rhs.loudnessNormalizationConfiguration &&
			lhs.playbackMetadata == rhs.playbackMetadata
	}
}

// MARK: CustomStringConvertible

extension Asset: CustomStringConvertible {
	public var description: String {
		"Asset(assetPosition: \(assetPosition), loudnessNormalizationConfiguration: \(String(describing: loudnessNormalizationConfiguration)), playbackMetadata: \(String(describing: playbackMetadata)), player: \(player))"
	}
}
