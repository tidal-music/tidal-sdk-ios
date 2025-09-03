import Foundation
@testable import TidalAPI

extension TrackManifestsSingleResourceDataDocument {
	static func mock(
		trackId: String = "12345",
		uri: String = "data:application/vnd.apple.mpegurl;base64,I0VYVE0zVQ==",
		formats: [TrackManifestsAttributes.Formats] = [.flac],
		trackPresentation: TrackManifestsAttributes.TrackPresentation = .full,
		hash: String = "abc123",
		drmData: DrmData? = nil,
		trackAudioNormalizationData: AudioNormalizationData? = AudioNormalizationData.mock(),
		albumAudioNormalizationData: AudioNormalizationData? = AudioNormalizationData.mock()
	) -> TrackManifestsSingleResourceDataDocument {
		let attributes = TrackManifestsAttributes(
			albumAudioNormalizationData: albumAudioNormalizationData,
			drmData: drmData,
			formats: formats,
			hash: hash,
			trackAudioNormalizationData: trackAudioNormalizationData,
			trackPresentation: trackPresentation,
			uri: uri
		)
		
		let data = TrackManifestsResourceObject(
			attributes: attributes,
			id: trackId,
			type: "trackManifests"
		)
		
		let links = Links(_self: "")
		
		return TrackManifestsSingleResourceDataDocument(
			data: data,
			included: nil,
			links: links
		)
	}
}

extension AudioNormalizationData {
	static func mock(
		peakAmplitude: Float? = 0.95,
		replayGain: Float? = -14.5
	) -> AudioNormalizationData {
		AudioNormalizationData(
			peakAmplitude: peakAmplitude,
			replayGain: replayGain
		)
	}
}

extension DrmData {
	static func mock(
		certificateUrl: String? = "https://fp.fa.tidal.com/certificate",
		drmSystem: DrmData.DrmSystem? = .fairplay,
		licenseUrl: String? = "https://fp.fa.tidal.com/license"
	) -> DrmData {
		DrmData(
			certificateUrl: certificateUrl,
			drmSystem: drmSystem,
			licenseUrl: licenseUrl
		)
	}
}