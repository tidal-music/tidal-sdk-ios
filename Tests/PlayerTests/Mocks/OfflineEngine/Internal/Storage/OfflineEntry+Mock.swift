import Foundation
@testable import Player

extension OfflineEntry {
    static func mock(
        productId: String = "mock-product-id",
        productType: ProductType = .TRACK,
        assetPresentation: AssetPresentation = .FULL,
        audioMode: AudioMode? = .STEREO,
        audioQuality: AudioQuality? = .HIGH,
        audioCodec: AudioCodec? = .AAC,
        mediaType: String? = "audio/mp4",
        size: Int = 100,
        mediaURL: URL? = URL(string: "file:///mock/path"),
        licenseURL: URL? = nil
    ) -> OfflineEntry {
        OfflineEntry(
            productId: productId,
            actualProductId: productId,
            productType: productType,
            assetPresentation: assetPresentation,
            audioMode: audioMode,
            audioQuality: audioQuality,
            audioCodec: audioCodec,
            audioSampleRate: nil,
            audioBitDepth: nil,
            videoQuality: nil,
            revalidateAt: nil,
            expiry: nil,
            mediaType: mediaType,
            albumReplayGain: nil,
            albumPeakAmplitude: nil,
            trackReplayGain: nil,
            trackPeakAmplitude: nil,
            licenseSecurityToken: licenseURL != nil ? "mock-token" : nil,
            size: size,
            mediaURL: mediaURL,
            licenseURL: licenseURL
        )
    }
    
    static func mock(
        from playbackInfo: PlaybackInfo,
        assetURL: URL? = URL(string: "file:///mock/path"),
        licenseURL: URL? = nil
    ) -> OfflineEntry {
        OfflineEntry(
            productId: playbackInfo.productId,
            actualProductId: playbackInfo.productId,
            productType: playbackInfo.productType,
            assetPresentation: playbackInfo.assetPresentation,
            audioMode: playbackInfo.audioMode,
            audioQuality: playbackInfo.audioQuality,
            audioCodec: playbackInfo.audioCodec,
            audioSampleRate: playbackInfo.audioSampleRate,
            audioBitDepth: playbackInfo.audioBitDepth,
            videoQuality: playbackInfo.videoQuality,
            revalidateAt: playbackInfo.offlineRevalidateAt,
            expiry: playbackInfo.offlineValidUntil,
            mediaType: playbackInfo.mediaType,
            albumReplayGain: playbackInfo.albumReplayGain,
            albumPeakAmplitude: playbackInfo.albumPeakAmplitude,
            trackReplayGain: playbackInfo.trackReplayGain,
            trackPeakAmplitude: playbackInfo.trackPeakAmplitude,
            licenseSecurityToken: playbackInfo.licenseSecurityToken,
            size: 100,
            mediaURL: assetURL,
            licenseURL: licenseURL ?? (playbackInfo.licenseSecurityToken != nil ? URL(string: "file:///mock/license") : nil)
        )
    }
}
