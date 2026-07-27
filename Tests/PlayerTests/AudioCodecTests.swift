@testable import Player
import Testing

struct AudioCodecTests {
	@Test
	func testFromQualityAndMode() throws {
		#expect(AudioCodec(from: nil, mode: nil) == nil)
		#expect(AudioCodec(from: nil, mode: AudioMode.STEREO) == nil)
		#expect(AudioCodec(from: AudioQuality.LOW, mode: nil) == nil)
		#expect(AudioCodec(from: AudioQuality.LOW, mode: AudioMode.DOLBY_ATMOS) == nil)
		#expect(AudioCodec(from: AudioQuality.LOW, mode: AudioMode.SONY_360RA) == nil)

		#expect(AudioCodec(from: AudioQuality.HIGH, mode: nil) == AudioCodec.AAC_LC)
		#expect(AudioCodec(from: AudioQuality.HIGH, mode: AudioMode.STEREO) == AudioCodec.AAC_LC)

		#expect(AudioCodec(from: AudioQuality.LOSSLESS, mode: nil) == AudioCodec.FLAC)
		#expect(AudioCodec(from: AudioQuality.LOSSLESS, mode: AudioMode.STEREO) == AudioCodec.FLAC)

		#expect(AudioCodec(from: AudioQuality.HI_RES, mode: nil) == AudioCodec.MQA)
		#expect(AudioCodec(from: AudioQuality.HI_RES, mode: AudioMode.STEREO) == AudioCodec.MQA)

		#expect(AudioCodec(from: AudioQuality.HI_RES_LOSSLESS, mode: nil) == AudioCodec.FLAC)
		#expect(AudioCodec(from: AudioQuality.HI_RES_LOSSLESS, mode: AudioMode.STEREO) == AudioCodec.FLAC)
	}

	@Test
	func testFromString() throws {
		let upperCasedAACCodec = "AAC"
		let newCodec = "new_codec"

		#expect(AudioCodec(rawValue: nil) == nil)

		#expect(AudioCodec(rawValue: AudioCodec.Constants.Manifest_Name_HE_AAC_V1) == AudioCodec.HE_AAC_V1)
		#expect(AudioCodec(rawValue: AudioCodec.Constants.Manifest_Name_HE_AAC_V1_Alt) == AudioCodec.HE_AAC_V1)
		#expect(AudioCodec(rawValue: AudioCodec.Constants.Manifest_Name_AAC_LC) == AudioCodec.AAC_LC)
		#expect(AudioCodec(rawValue: AudioCodec.Constants.Manifest_Name_AAC_LC_Alt) == AudioCodec.AAC_LC)
		#expect(AudioCodec(rawValue: AudioCodec.Constants.Manifest_Name_AAC) == AudioCodec.AAC)
		#expect(AudioCodec(rawValue: upperCasedAACCodec) == AudioCodec.AAC)
		#expect(AudioCodec(rawValue: AudioCodec.Constants.Manifest_Name_FLAC) == AudioCodec.FLAC)
		#expect(AudioCodec(rawValue: AudioCodec.Constants.Manifest_Name_FLAC_HIRES) == AudioCodec.FLAC)
		#expect(AudioCodec(rawValue: AudioCodec.Constants.Manifest_Name_ALAC) == AudioCodec.ALAC)
		#expect(AudioCodec(rawValue: AudioCodec.Constants.Manifest_Name_MQA) == AudioCodec.MQA)
		#expect(AudioCodec(rawValue: AudioCodec.Constants.Manifest_Name_AC4) == AudioCodec.AC4)
		#expect(AudioCodec(rawValue: AudioCodec.Constants.Manifest_Name_EAC3) == AudioCodec.EAC3)
		#expect(AudioCodec(rawValue: AudioCodec.Constants.Manifest_Name_MHA1) == AudioCodec.MHA1)
		#expect(AudioCodec(rawValue: AudioCodec.Constants.Manifest_Name_MHM1) == AudioCodec.MHM1)

		#expect(AudioCodec(rawValue: newCodec) == AudioCodec.UNKNOWN(value: newCodec))
	}

	@Test
	func testDisplayNames() throws {
		#expect(AudioCodec.AAC_LC.displayName == AudioCodec.Constants.Display_Name_AAC)
		#expect(AudioCodec.HE_AAC_V1.displayName == AudioCodec.Constants.Display_Name_AAC)
		#expect(AudioCodec.HE_AAC_V1.displayName == AudioCodec.Constants.Display_Name_AAC)
		#expect(AudioCodec.FLAC.displayName == AudioCodec.Constants.Display_Name_FLAC)
		#expect(AudioCodec.MQA.displayName == AudioCodec.Constants.Display_Name_MQA)

		#expect(AudioCodec.ALAC.displayName == nil)
		#expect(AudioCodec.AC4.displayName == nil)
		#expect(AudioCodec.EAC3.displayName == nil)
		#expect(AudioCodec.MHA1.displayName == nil)
		#expect(AudioCodec.MHM1.displayName == nil)
	}
}
