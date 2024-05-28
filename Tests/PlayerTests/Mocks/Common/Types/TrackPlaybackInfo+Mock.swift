import Foundation
@testable import Player

extension TrackPlaybackInfo {
	// swiftlint:disable force_try
	static func mock(
		trackId: Int = 1,
		assetPresentation: AssetPresentation = .FULL,
		audioMode: AudioMode = .STEREO,
		audioQuality: AudioQuality = .LOSSLESS,
		streamingSessionId: String? = nil,
		licenseSecurityToken: String? = nil,
		manifestMimeType: String = MediaTypes.EMU,
		manifestHash: String = "manifestHash",
		manifest: String = Data(try! JSONEncoder().encode(EncodableEmuManifest())).base64EncodedString(),
		albumReplayGain: Float? = nil,
		albumPeakAmplitude: Float? = nil,
		trackReplayGain: Float? = nil,
		trackPeakAmplitude: Float? = nil,
		offlineRevalidateAt: UInt64? = nil,
		offlineValidUntil: UInt64? = nil,
		sampleRate: Int? = 44100,
		bitDepth: Int? = 15
	) -> Self {
		TrackPlaybackInfo(
			trackId: trackId,
			assetPresentation: assetPresentation,
			audioMode: audioMode,
			audioQuality: audioQuality,
			streamingSessionId: streamingSessionId,
			licenseSecurityToken: licenseSecurityToken,
			manifestMimeType: manifestMimeType,
			manifestHash: manifestHash,
			manifest: manifest,
			albumReplayGain: albumReplayGain,
			albumPeakAmplitude: albumPeakAmplitude,
			trackReplayGain: trackReplayGain,
			trackPeakAmplitude: trackPeakAmplitude,
			offlineRevalidateAt: offlineRevalidateAt,
			offlineValidUntil: offlineValidUntil,
			sampleRate: sampleRate,
			bitDepth: bitDepth
		)
	}
	// swiftlint:enable force_try
}
